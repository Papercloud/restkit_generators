//
//  Post.m
//  Dummy
//
//  Created by Tomas Spacek on 14/01/2014.
//  Copyright (c) 2014 Papercloud. All rights reserved.
//

#import "Post.h"

@implementation Post

- (NSString *)description
{
    NSUInteger commentsCount = self.comments.count;
    return [NSString stringWithFormat:@"Post with %d comments", commentsCount];
}

@end
