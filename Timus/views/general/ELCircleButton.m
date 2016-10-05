//
//  ELCircleButton.m
//  Timus
//
//  Created by Pedro Oliveira on 7/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELCircleButton.h"

@interface ELCircleButton ()

-(void) p_setupButton;

@end

@implementation ELCircleButton

#pragma mark - View Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupButton];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self p_setupButton];
}

#pragma mark - Private Methods

-(void)p_setupButton
{
    self.layer.cornerRadius = floor(CGRectGetWidth(self.frame)/2);
    self.layer.borderColor  = [self.titleLabel.textColor CGColor];
    self.layer.borderWidth  = 0.7f;
    self.layer.masksToBounds = YES;
}

@end
