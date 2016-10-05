//
//  UIView+Utils.m
//  Timus
//
//  Created by Emanuel Coelho on 06/07/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

#pragma mark - Methods

-(UIImage *)takeViewScreenShot
{
    UIGraphicsBeginImageContext(self.bounds.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return screenshot;
}
- (void) dismissKeyboard
{
    [self endEditing:YES];
}

+ (UIView*) viewWithFrame:(CGRect)frame andBackgroundColor:(UIColor*)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

- (void) animateWithOptions:(UIViewAnimationOptions) options andDuration:(NSTimeInterval) duration
{
    [UIView transitionWithView:self
                      duration:duration
                       options:options
                    animations:NULL
                    completion:NULL];
}

@end
