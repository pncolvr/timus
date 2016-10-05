//
//  ELTaskCell.m
//  Timus
//
//  Created by Emanuel Coelho on 21/04/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELTaskCell.h"
#import "UIColor+Utils.h"
#import "UIView+Utils.h"

#define kSeparatorMargin 20

@implementation ELTaskCell
{
    UIView *_backgroundView;
}

#pragma mark - View Lifecycle

-(void)awakeFromNib
{
    [super awakeFromNib];
    CGRect visibleRect = self.frame;
    
    _backgroundView = [UIView viewWithFrame:visibleRect
                         andBackgroundColor:kClearColor];
    [self addSubview:_backgroundView];
    [self sendSubviewToBack:_backgroundView];
    [self setSelectedBackgroundView:[UIView viewWithFrame:visibleRect
                                       andBackgroundColor:kClearColor]];
    
    /* Add a custom border start where the Task description starts start */
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(kSeparatorMargin, CGRectGetHeight(self.frame)-kBottomBorderSize, CGRectGetWidth(self.frame), kBottomBorderSize);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    
    [self.layer addSublayer:bottomBorder];
}

#pragma mark - Methods

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted
                 animated:animated];
    if (highlighted) {
        [_backgroundView setBackgroundColor:kSelectedColor];
    } else {
        [_backgroundView setBackgroundColor:kClearColor];
    }
    [self setNeedsDisplay];
}

@end
