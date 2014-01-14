//
//  PCDAbstractDecorator.h
//  FilterKit
//
//  Created by Tomas Spacek on 30/11/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//  Based on https://github.com/valentinradu/UITableView-Decorator-Example
//

#import <Foundation/Foundation.h>
#import <objc/message.h>

// Support for the macros below.
#define _checkDecoratedResponds if ([self.decoratedObject respondsToSelector:_cmd])
#define _callDecoratedWithArgs(...) objc_msgSend(self.decoratedObject, _cmd, __VA_ARGS__)

// Calls and returns decoratedObject's method instead.
#define _returnDecorated(...) _checkDecoratedResponds return _callDecoratedWithArgs(__VA_ARGS__);

// Same as above, but calls then returns. For methods that return null.
#define _callDecoratedThenReturn(...) _checkDecoratedResponds { _callDecoratedWithArgs(__VA_ARGS__); return; }

/**
 Forwards on methods it doesn't implement on to decoratedObject.
 Optionally defers to decoratedObject on methods it does implement.
 */

@interface PCDAbstractDecorator : NSObject

@property (nonatomic, weak) id decoratedObject;

- (id)initWithDecoratedObject:(id)object;

@end
