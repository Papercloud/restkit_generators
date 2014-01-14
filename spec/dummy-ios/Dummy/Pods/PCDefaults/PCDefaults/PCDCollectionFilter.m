//
//  PCDCollectionFilter.m
//  FilterKit
//
//  Created by Tomas Spacek on 2/12/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import "PCDCollectionFilter.h"

@implementation PCDCollectionFilter

+ (id)filterWithProperty:(NSString *)property beginsWith:(NSString *)query
{
    PCDCollectionFilter *filter = [[self alloc] init];
    if (query.length) {
        filter.predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[c] %@", property, query];
        filter.parameters = [NSDictionary dictionaryWithObject:query forKey:property];
    }
    return filter;
}

@end
