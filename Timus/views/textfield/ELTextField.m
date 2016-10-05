//
//  ELTextField.m
//  Timus
//
//  Created by Emanuel Coelho on 07/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELTextField.h"

@implementation ELTextField

#pragma mark - View Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTextColor:kTextBlackColor];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setTextColor:kTextBlackColor];
}

@end
