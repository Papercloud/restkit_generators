//
//  PCDAbstractDecorator.m
//  FilterKit
//
//  Created by Tomas Spacek on 30/11/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import "PCDAbstractDecorator.h"

@implementation PCDAbstractDecorator

- (id)initWithDecoratedObject:(id)object
{
    self = [super init];
    if (self) {
        self.decoratedObject = object;
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([_decoratedObject respondsToSelector:aSelector]) {
        return _decoratedObject;
    }
    
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector])
        return YES;
    else if ([_decoratedObject respondsToSelector:aSelector]) {
        return YES;
    }
    return NO;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    if ([super isKindOfClass:aClass]) {
        return YES;
    }
    else if ([_decoratedObject isKindOfClass:aClass]) {
        return YES;
    }
    
    return NO;
}

@end
