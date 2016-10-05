//
//  ELTextView.m
//  Timus
//
//  Created by Emanuel Coelho on 07/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELTextView.h"

@implementation ELTextView

#pragma mark - View Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTextColor:kTextBlackColor];
        [self setTintColor:kTextBlackColor];
        self.floatingLabelActiveTextColor = kTextBlackColor;
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setTextColor:kTextBlackColor];
    [self setTintColor:kTextBlackColor];
    self.floatingLabelActiveTextColor = kTextBlackColor;
}

@end
