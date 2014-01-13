//
//  DummyTests.m
//  DummyTests
//
//  Created by Tomas Spacek on 9/01/2014.
//  Copyright (c) 2014 Papercloud. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "Generated.h"
#import "Generated/_Post+Mapping.h"

@interface PostTests : XCTestCase
@property (nonatomic, strong) RKMappingTest *test;
@end

@implementation PostTests

- (void)setUp
{
    [super setUp];
    [RKTestFactory setUp];
    NSBundle *testTargetBundle = [NSBundle bundleForClass:[self class]];
    [RKTestFixture setFixtureBundle:testTargetBundle];
    
    [RKManagedObjectStore setDefaultStore:[RKTestFactory managedObjectStore]];
    
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"post.json"];
    self.test = [RKMappingTest testForMapping:[Post mapping] sourceObject:parsedJSON destinationObject:nil];
    self.test.managedObjectContext = [RKTestFactory managedObjectStore].persistentStoreManagedObjectContext;
}

- (void)tearDown
{
    [RKTestFactory tearDown];
    [super tearDown];
}

- (void)testExample
{
    [self.test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"name"
                                                                     destinationKeyPath:@"name"
                                                                                  value:@"My First Post"]];
}

@end
