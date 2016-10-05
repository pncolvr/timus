//
//  ELCircleImageView.m
//  Timus
//
//  Created by Pedro Oliveira on 7/14/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELCircleImageView.h"

@interface ELCircleImageView ()

- (void) p_setupImageView;

@end

@implementation ELCircleImageView

#pragma mark - View Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupImageView];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self p_setupImageView];
}

#pragma mark - Private Methods

- (void) p_setupImageView
{
    
    self.layer.cornerRadius = floor(CGRectGetWidth(self.frame)/2);
    self.layer.borderWidth  = 0.0f;
    self.layer.masksToBounds = YES;
}

@end
