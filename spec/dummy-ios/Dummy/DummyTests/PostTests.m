//
//  DummyTests.m
//  DummyTests
//
//  Created by Tomas Spacek on 9/01/2014.
//  Copyright (c) 2014 Papercloud. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/CoreData.h>
#import <RestKit/Testing.h>
#import <Generated/Generated.h>
#import <Generated/_Post+Mapping.h>

@interface PostTests : XCTestCase
@property (nonatomic, strong) RKMappingTest *test;
@property (nonatomic, strong) Comment *comment;
@property (nonatomic, strong) User *user;
- (void)mapAndWaitForConnections;
@end

@implementation PostTests

- (void)setUp
{
    [super setUp];
    
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelDebug);
    
    [RKTestFactory setUp];
    NSBundle *testTargetBundle = [NSBundle bundleForClass:[self class]];
    [RKTestFixture setFixtureBundle:testTargetBundle];
    [RKManagedObjectStore setDefaultStore:[RKTestFactory managedObjectStore]];
    
    NSManagedObjectContext *context = [RKTestFactory managedObjectStore].persistentStoreManagedObjectContext;
    
    self.comment = [RKTestFactory insertManagedObjectForEntityForName:@"Comment"
                                               inManagedObjectContext:context
                                                       withProperties:@{ @"primaryKey" : @1, @"title" : @"Test Comment" }];
    
    self.user = [RKTestFactory insertManagedObjectForEntityForName:@"User"
                                            inManagedObjectContext:context
                                                    withProperties:@{ @"primaryKey" : @1, @"name" : @"Joe" }];
    
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"post.json"];
    self.test = [RKMappingTest testForMapping:[Post mapping] sourceObject:parsedJSON destinationObject:nil];

    self.test.mappingOperationDataSource = [[RKManagedObjectMappingOperationDataSource alloc]
                                            initWithManagedObjectContext:context
                                            cache:[RKFetchRequestManagedObjectCache new]];
    [(RKManagedObjectMappingOperationDataSource *)self.test.mappingOperationDataSource setOperationQueue:[NSOperationQueue new]];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
    [super tearDown];
}

- (void)mapAndWaitForConnections
{
    [self.test performMapping];
    
    // RestKit/Testing doesn't correctly wait for connections to complete, so we have to wait here.
    NSOperationQueue *operationQueue = [(RKManagedObjectMappingOperationDataSource *)self.test.mappingOperationDataSource operationQueue];
    [operationQueue waitUntilAllOperationsAreFinished];
}

- (void)testNameMapping
{
    [self.test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"name"
                                                                          destinationKeyPath:@"name"
                                                                                       value:@"My First Post"]];
    
    XCTAssertNoThrow([self.test verify], @"The post's name could not be mapped from JSON.");
}

- (void)testCommentsMapping
{
    [self.test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"comment_ids"
                                                                          destinationKeyPath:@"commentIds"
                                                                                       value:@[@1]]];
    
    [self.test addExpectation:[RKConnectionTestExpectation expectationWithRelationshipName:@"comments"
                                                                                attributes:@{ @"commentIds" : @"primaryKey" }
                                                                                     value:[NSSet setWithObjects:self.comment, nil]]];
    
    [self mapAndWaitForConnections];
    XCTAssertNoThrow([self.test verify], @"Could not connect comments.");
}

- (void)testUserMapping
{
    [self.test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"user_id"
                                                                          destinationKeyPath:@"userId"
                                                                                       value:@1]];
    
    [self.test addExpectation:[RKConnectionTestExpectation expectationWithRelationshipName:@"user"
                                                                                attributes:@{ @"userId" : @"primaryKey" }
                                                                                     value:self.user]];
    
    [self mapAndWaitForConnections];
    XCTAssertNoThrow([self.test verify], @"Could not connect user.");
}


@end
