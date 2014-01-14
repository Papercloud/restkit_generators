//
//  PCDHelpers.m
//  FilterKit
//
//  Created by Mark Turner on 03/12/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import "PCDHelpers.h"
/**
 Helpers
 */
#import "NSString+Inflections.h"

NSString *PCDPluralNameForClass(Class klass)
{
    // TODO: Could add in a check to see if the class responds to an override method.
    return [[NSStringFromClass(klass) pluralize] underscore];
}

NSString *PCDSingularNameForClass(Class klass)
{
    // TODO: Could add in a check to see if the class responds to an override method.
    return [NSStringFromClass(klass) underscore];
}

