//
//  ELNavigationBar.m
//  Timus
//
//  Created by Pedro Oliveira on 9/27/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELNavigationBar.h"

@implementation ELNavigationBar

#pragma mark - Methods

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UISegmentedControl class]]) {
            CGRect frame = view.frame;
            frame.origin.y = 5;
            view.frame = frame;
        }
    }
}

@end
