//
//  ELFilledCircleButton.m
//  Timus
//
//  Created by Pedro Oliveira on 19/02/14.
//  Copyright (c) 2014 Timus. All rights reserved.
//

#import "ELFilledCircleButton.h"

@implementation ELFilledCircleButton
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
    CGColorRef color = [self.tintColor CGColor];
    self.layer.cornerRadius = floor(CGRectGetWidth(self.frame)/2);
    self.layer.borderColor = color;
    self.layer.backgroundColor = color;
    self.layer.borderWidth  = 0.7f;
    self.layer.masksToBounds = YES;
}
@end
