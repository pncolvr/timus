//
//  UIColor+Utils.m
//  Timus
//
//  Created by Pedro Oliveira on 7/14/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

#pragma mark - Methods

+ (UIColor *)colorWithRedValue:(CGFloat)red greenValue:(CGFloat)green blueValue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255
                           green:green/255
                            blue:blue/255
                           alpha:alpha];
}

@end
