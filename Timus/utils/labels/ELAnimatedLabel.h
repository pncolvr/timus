//
//  ELAnimatedLabel.h
//  Timus
//
//  Created by Pedro Oliveira on 7/16/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//
/*
 Adapted from MTAnimatedLabel https://github.com/mturner1721/MTAnimatedLabel
*/

@import UIKit;

@interface ELAnimatedLabel : UILabel

#pragma mark - Properties

@property (nonatomic)           CGFloat animationDuration;
@property (nonatomic)           CGFloat gradientWidth;
@property (nonatomic, strong)   UIColor *tint;

#pragma mark - Methods

- (void)startAnimating;
- (void)stopAnimating;

@end
