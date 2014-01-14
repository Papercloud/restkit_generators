//
//  PCDObjectProtocol.h
//  FilterKit
//
//  Created by Mark Turner on 17/12/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;
@protocol PCDObjectProtocol <NSObject>
@required
+ (NSString *)entityName;
+ (RKObjectMapping *)mapping;
+ (NSString *)keypath;
@optional
+ (NSArray *)sortDescriptors;
@end
