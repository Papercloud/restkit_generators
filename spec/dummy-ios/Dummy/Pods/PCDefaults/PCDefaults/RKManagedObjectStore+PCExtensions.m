//
//  RKManagedObjectStore+PCExtensions.m
//  FilterKit
//
//  Created by Tomas Spacek on 29/11/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import "RKManagedObjectStore+PCExtensions.h"
#import <RestKit/RestKit.h>

@implementation RKManagedObjectStore (PCExtensions)

+ (RKManagedObjectStore *)setupDefaultStore
{
    NSError *error = nil;
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:kPCRKExtensionsStoreName ofType:@"momd"]];
    
    // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Initialize the Core Data stack
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:kPCRKExtensionsStoreName];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:kPCRKExtensionsStoreName ofType:@"sqlite"];
    NSPersistentStore __unused *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                                                              fromSeedDatabaseAtPath:seedPath
                                                                                   withConfiguration:nil
                                                                                             options:nil
                                                                                               error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
    
    [managedObjectStore createManagedObjectContexts];
    
    // Set the default store shared instance
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    return managedObjectStore;
}

@end
