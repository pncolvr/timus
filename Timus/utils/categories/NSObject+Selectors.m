//
//  NSObject+Selectors.m
//  Timus
//
//  Created by Pedro Oliveira on 4/24/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import ObjectiveC.message;

#import "NSObject+Selectors.h"

@implementation NSObject (Selectors)

#pragma mark - Methods

- (void) checkAndPerformSelector:(SEL) selector withObject:(id)arg
{
    if ([self respondsToSelector:selector]) {
        objc_msgSend(self, selector, arg);
    } else {
        ELLogDebug(@"Object %@ does not recognize selector %@", self, NSStringFromSelector(selector));
    }
}

@end
