//
//  PCDCollectionManager.m
//  FilterKit
//
//  Created by Tomas Spacek on 30/11/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import "PCDCollectionManager.h"
#import "RKObjectManager+PCDefaults.h"

/**
 Monkey-patch RKPaginator to allow filter params.
 */

@interface RKPaginator()
@property (nonatomic, copy) NSURLRequest *request;
@end

@interface PCDCollectionManager() <NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController * _fetchedResultsController;
}
- (id)initWithObjectClass:(Class <PCDObjectProtocol>)klass;
- (RKResponseDescriptor *)registerResponseDescriptorsForCollection:(NSString *)keyPath mapping:(RKObjectMapping *)mapping;

@property (nonatomic, assign) Class <PCDObjectProtocol> objectClass;
@property (nonatomic, strong) NSPredicate                *filterPredicate;
@property (nonatomic, strong) NSMutableDictionary        *filterParameters;

@property (nonatomic, copy) void (^updateBlock ) (NSArray *objects);
@property (nonatomic, copy) void (^failureBlock) (NSError *error  );
@end

@implementation PCDCollectionManager

+ (PCDCollectionManager *)collectionManagerWithClass:(Class <PCDObjectProtocol>)klass
{
    PCDCollectionManager *collectionManager = [[self alloc] initWithObjectClass:klass];
    return collectionManager;
}

- (id)initWithObjectClass:(Class <PCDObjectProtocol>)klass
{
    self = [super init];
    if (self) {
        
        self.objectClass = klass;
        
        self.filterParameters = [NSMutableDictionary dictionary];
        
        // Make sure response descriptors are registered
        [self registerResponseDescriptorsForCollection:[self keypath] mapping:[self objectMapping]];
        
        // Make sure there's a pagination mapping registered
        [self.objectManager setPaginationMapping:[RKObjectManager PCD_paginationMapping]];
    }
    return self;
}

- (RKResponseDescriptor *)registerResponseDescriptorsForCollection:(NSString *)keyPath
                                                           mapping:(RKObjectMapping *)mapping
{
    RKResponseDescriptor *responseDescriptor;
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                      method:RKRequestMethodGET
                                                                 pathPattern:[self path]
                                                                     keyPath:keyPath
                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    return responseDescriptor;
}

- (void)setUpdateBlock:(void (^)(NSArray *objects))update
               failure:(void (^)(NSError *error))failure
{
    self.updateBlock = update;
    self.failureBlock = failure;
}

- (void)reloadWithFilter:(PCDCollectionFilter *)filter
{
    [self reloadWithFilters:@[ filter ]];
}

- (void)reloadWithFilters:(NSArray *)filters
{
    [self clearFilters];
    
    // TODO: We'll probably need some sort of class for handling combining filters. We will if we ever need to do
    // combinations of AND and OR conditions.
    // Or it's possible we could use RestKit's own routing support and just map URLs (and therefore params) to
    // NSPredicates that way.
    
    for (PCDCollectionFilter *filter in filters) {
        if (filter.parameters) {
            [self.filterParameters addEntriesFromDictionary:filter.parameters];
        }
        
        if (filter.predicate) {
            [self addANDPredicate:filter.predicate];
        }
    }
    
    [self reload];
}

- (void)reload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hudClass show];
    });
    
    [self.fetchedResultsController.fetchRequest setSortDescriptors:[self sortDescriptors]];
    [self.fetchedResultsController.fetchRequest setPredicate:[self filterPredicate]];

    NSError * fetchError = nil;
    BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&fetchError]; // TODO: Error handling.
    if (fetchSuccessful == NO) {
        NSLog(@"Fetch error - %@",fetchError);
    }
    
    if (self.updateBlock) {
        self.updateBlock(self.objects);
    }
    
    // Create a new RKPaginator, so we can reset its paging.
    
    [self setPaginator:[self createPaginator]];
    [self.paginator loadPage:1];
}

- (void)clearFilters
{
    self.filterParameters = [NSMutableDictionary dictionary];
    self.filterPredicate = nil;
}

- (void)addANDPredicate:(NSPredicate *)predicate
{
    if (self.filterPredicate) {
        self.filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ self.filterPredicate, predicate]];
    } else {
        self.filterPredicate = predicate;
    }
}

- (NSArray *)objects
{
    return self.fetchedResultsController.fetchedObjects;
}

- (NSString *)baseRequestPath
{
    NSString *requestString = [NSString stringWithFormat:@"%@?page=:currentPage&per_page=:perPage",[self path]];
    return requestString;
}

// TODO: Formalise this into a protocol.
- (NSArray *)sortDescriptors
{
    if (!_sortDescriptors) {
        if ([self.objectClass respondsToSelector:@selector(sortDescriptors)]) {
            self.sortDescriptors = [self.objectClass sortDescriptors];
        } else {
            self.sortDescriptors = @[];
        }
    }

    return _sortDescriptors;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    // Setup fetched results
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self.objectClass entityName]];
        [fetchRequest setSortDescriptors:[self sortDescriptors]];
        [fetchRequest setPredicate:[self filterPredicate]];
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                   managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                                                                                                     sectionNameKeyPath:nil
                                                                                                              cacheName:nil];
        [fetchedResultsController setDelegate:self];
        _fetchedResultsController = fetchedResultsController;
    }
    return _fetchedResultsController;
}

- (RKPaginator *)createPaginator
{
    NSString *requestString = [self baseRequestPath];
    
    RKPaginator *paginator = [self.objectManager paginatorWithPathPattern:requestString];
    paginator.request = [self.objectManager.HTTPClient requestWithMethod:@"GET" path:[self baseRequestPath]
                                                              parameters:self.filterParameters];
    paginator.perPage = 20;
    
    [paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hudClass dismiss];
        });
    } failure:^(RKPaginator *paginator, NSError *error) {
        if (!([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hudClass showError:error];
            });
        }
        if (self.failureBlock) {
            self.failureBlock(error);
        }
    }];
    
    return paginator;
}

#pragma mark Defaults

- (RKObjectManager *)objectManager
{
    if (!_objectManager) {
        return [RKObjectManager sharedManager];
    }
    return _objectManager;
}

- (RKObjectMapping *)objectMapping
{
    if (!_objectMapping) {
        return [self.objectClass mapping];
    }
    return _objectMapping;
}

- (NSString *)keypath
{
    return [self.objectClass keypath];
}

- (NSString *)path
{
    return [NSString stringWithFormat:@"/api/%@.json", [self keypath]];
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.updateBlock) {
        self.updateBlock(self.objects);
    }
}


@end
