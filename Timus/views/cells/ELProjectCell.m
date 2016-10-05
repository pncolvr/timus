//
//  ELProjectCell.m
//  Timus
//
//  Created by Pedro Oliveira on 4/18/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELProjectCell.h"
#import "UIColor+Utils.h"
#import "UIView+Utils.h"

@implementation ELProjectCell
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
    
    /* Add a custom border start where the project image start */
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(self.projectImageView.frame.origin.x, CGRectGetHeight(self.frame)-kBottomBorderSize, CGRectGetWidth(self.frame), kBottomBorderSize);
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
