//
//  RKObjectManager+PCDefaults.m
//  FilterKit
//
//  Created by Tomas Spacek on 30/11/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import "RKObjectManager+PCDefaults.h"

@implementation RKObjectManager (PCDefaults)

+ (RKObjectMapping *)PCD_paginationMapping
{
    RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
    [paginationMapping addAttributeMappingsFromDictionary:@{
                                                            @"meta.pagination.per_page": @"perPage",
                                                            @"meta.pagination.total_pages": @"pageCount",
                                                            @"meta.pagination.total_objects": @"objectCount",
                                                            }];
    
    return paginationMapping;
}

@end
