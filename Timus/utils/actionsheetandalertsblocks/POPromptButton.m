//
//  POPromptButton.m
//  Timus
//
//  Created by Pedro Oliveira on 7/31/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "POPromptButton.h"

@implementation POPromptButton

#pragma mark - View Lifecycle

- (instancetype) initWithTitle:(NSString*) aTitle
           andAction:(void (^)(NSString*)) aAction
{
    self  = [super init];
    if (self) {
        _title = aTitle;
        _action = aAction;
    }
    return self;
}

@end
