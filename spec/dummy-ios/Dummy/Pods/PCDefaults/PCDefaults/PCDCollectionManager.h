//
//  PCDCollectionManager.h
//  FilterKit
//
//  Created by Tomas Spacek on 30/11/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCDCollectionFilter.h"
#import "PCDObjectProtocol.h"

@protocol PCDLoadingHUDViewProtocol;

@interface PCDCollectionManager : NSObject

+ (PCDCollectionManager *)collectionManagerWithClass:(Class <PCDObjectProtocol>)klass;

@property (nonatomic, readonly) NSArray *objects;
@property (nonatomic) Class <PCDLoadingHUDViewProtocol> hudClass;

// Clears filters, sets new filters, then reloads.
- (void)reloadWithFilter:(PCDCollectionFilter *)filter;
- (void)reloadWithFilters:(NSArray *)filters;

- (void)clearFilters;
- (void)reload;

- (void)setUpdateBlock:(void (^)(NSArray *objects))update
               failure:(void (^)(NSError *error))failure;

// Defaults overrides
@property (nonatomic, strong) NSArray         *sortDescriptors;
@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) RKObjectMapping *objectMapping;
@property (nonatomic, strong) RKPaginator     *paginator;

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@end

@protocol PCDLoadingHUDViewProtocol <NSObject>
+ (void)show;
+ (void)showError:(NSError *)error;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)dismiss;
@end
