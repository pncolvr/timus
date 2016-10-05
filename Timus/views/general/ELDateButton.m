//
//  ELDateButton.m
//  Timus
//
//  Created by Emanuel Coelho on 07/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELDateButton.h"

@interface ELDateButton ()
- (void) p_updateButtonColors;
@end

@implementation ELDateButton

#pragma mark - View Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_updateButtonColors];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self p_updateButtonColors];
}

#pragma mark - Private Methods

-(void)p_updateButtonColors
{
    [self setTitleColor:kTextBlackColor forState:UIControlStateNormal];
    [self setTitleColor:kTextBlackColor forState:UIControlStateHighlighted];
    [self setTitleColor:kTextBlackColor forState:UIControlStateSelected];
}

@end
