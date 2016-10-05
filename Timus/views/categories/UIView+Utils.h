//
//  UIView+Utils.h
//  Timus
//
//  Created by Emanuel Coelho on 06/07/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import UIKit;

@interface UIView (Utils)

#pragma mark - Methods

- (UIImage *)takeViewScreenShot;
- (void) dismissKeyboard;
+ (UIView*) viewWithFrame:(CGRect)frame andBackgroundColor:(UIColor*)color;
- (void) animateWithOptions:(UIViewAnimationOptions) options andDuration:(NSTimeInterval) duration;

@end
