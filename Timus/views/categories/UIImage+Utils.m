//
//  UIImage+Utils.m
//  Timus
//
//  Created by Emanuel Coelho on 06/07/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "UIImage+Utils.h"

#define kAlphaDefault 0.7f 

@implementation UIImage (Utils)

#pragma mark - Methods

-(UIImage*)applyOpacity
{
   return [self applyOpacityWithAlpha:kAlphaDefault];
}

-(UIImage *)applyOpacityWithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
