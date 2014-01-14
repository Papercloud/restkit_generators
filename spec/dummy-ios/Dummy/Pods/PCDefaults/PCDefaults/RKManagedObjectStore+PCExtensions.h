//
//  RKManagedObjectStore+PCExtensions.h
//  FilterKit
//
//  Created by Tomas Spacek on 29/11/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import "RKManagedObjectStore.h"

#define kPCRKExtensionsStoreName @"DataModel"

@interface RKManagedObjectStore (PCExtensions)

+ (RKManagedObjectStore *)setupDefaultStore;

@end
