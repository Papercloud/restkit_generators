//
//  PCDCollectionFilter.h
//  FilterKit
//
//  Created by Tomas Spacek on 2/12/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCDCollectionFilter : NSObject

// Predicate used to filter an NSFetchRequest locally.
@property (nonatomic, strong) NSPredicate *predicate;

// Parameters sent to the remote server for filtering server-side.
@property (nonatomic, strong) NSDictionary *parameters;

// Case-insensitive filter on beginning of a string property's value.
// Returns nil if query is empty.
+ (id)filterWithProperty:(NSString *)property beginsWith:(NSString *)query;

@end
