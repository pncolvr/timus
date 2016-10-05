//
//  ELAnimatedLabel.m
//  Timus
//
//  Created by Pedro Oliveira on 7/16/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELAnimatedLabel.h"

@import CoreText;

#define kAnimationDuration      2.25f
#define kGradientSize           0.45f
#define kGradientTint           [UIColor whiteColor]

#define kAnimationKey           @"gradientAnimation"
#define kGradientEndPointKey    @"endPoint"
#define kGradientStartPointKey  @"startPoint"

@interface ELAnimatedLabel ()

@property (nonatomic, strong) CATextLayer *textLayer;

@end

@implementation ELAnimatedLabel

#pragma mark - View Lifecycle

- (void)initializeLayers
{
    /* set Defaults */
    self.tint               = kGradientTint;
    self.animationDuration  = kAnimationDuration;
    self.gradientWidth      = kGradientSize;
    
    CAGradientLayer *gradientLayer  = (CAGradientLayer *)self.layer;
    gradientLayer.backgroundColor   = [super.textColor CGColor];
    gradientLayer.startPoint        = CGPointMake(-self.gradientWidth, 0.);
    gradientLayer.endPoint          = CGPointMake(0., 0.);
    gradientLayer.colors            = @[(id)[self.textColor CGColor],(id)[self.tint CGColor], (id)[self.textColor CGColor]];
    
    self.textLayer                      = [CATextLayer layer];
    self.textLayer.backgroundColor      = [[UIColor clearColor] CGColor];
    self.textLayer.contentsScale        = [[UIScreen mainScreen] scale];
    self.textLayer.rasterizationScale   = [[UIScreen mainScreen] scale];
    self.textLayer.bounds               = self.bounds;
    self.textLayer.anchorPoint          = CGPointZero;
    
    /* set initial values for the textLayer because they may have been loaded from a nib */
    [self setFont:          super.font];
    [self setTextAlignment: super.textAlignment];
    [self setText:          super.text];
    [self setTextColor:     super.textColor];
    
    /*
     finally set the textLayer as the mask of the gradientLayer, this requires offscreen rendering
     and therefore this label subclass should ONLY BE USED if animation is required
     */
    gradientLayer.mask = self.textLayer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeLayers];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeLayers];
    }
    return self;
}

#pragma mark - UILabel Accessor overrides

- (UIColor *)textColor
{
    UIColor *textColor = [UIColor colorWithCGColor:self.layer.backgroundColor];
    if (!textColor) {
        textColor = [super textColor];
    }
    return textColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    CAGradientLayer *gradientLayer  = (CAGradientLayer *)self.layer;
    gradientLayer.backgroundColor   = [textColor CGColor];
    gradientLayer.colors            = @[(id)[textColor CGColor],(id)[self.tint CGColor], (id)[textColor CGColor]];
    
    [self setNeedsDisplay];
}

- (NSString *)text
{
    return self.textLayer.string;
}

- (void)setText:(NSString *)text
{
    self.textLayer.string = text;
    [self setNeedsDisplay];
}

- (UIFont *)font
{
    CTFontRef ctFont    = self.textLayer.font;
    NSString *fontName  = (__bridge_transfer NSString *)CTFontCopyName(ctFont, kCTFontPostScriptNameKey);
    CGFloat fontSize    = CTFontGetSize(ctFont);
    return [UIFont fontWithName:fontName size:fontSize];
}

- (void)setFont:(UIFont *)font
{
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)(font.fontName), font.pointSize, &CGAffineTransformIdentity);
    self.textLayer.font = fontRef;
    self.textLayer.fontSize = font.pointSize;
    CFRelease(fontRef);
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (NSTextAlignment)textAlignment
{
    return [ELAnimatedLabel UITextAlignmentFromCAAlignment:self.textLayer.alignmentMode];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.textLayer.alignmentMode = [ELAnimatedLabel CAAlignmentFromUITextAlignment:textAlignment];
}

#pragma mark - UILabel Layer override

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

/* Stop UILabel from drawing because we are using a CATextLayer for that! */
- (void)drawRect:(CGRect)rect {}

#pragma mark - Utility Methods

+ (NSString *)CAAlignmentFromUITextAlignment:(NSTextAlignment)textAlignment
{
    switch (textAlignment) {
        case NSTextAlignmentLeft:   return kCAAlignmentLeft;
        case NSTextAlignmentCenter: return kCAAlignmentCenter;
        case NSTextAlignmentRight:  return kCAAlignmentRight;
        default:                    return kCAAlignmentNatural;
    }
}

+ (NSTextAlignment)UITextAlignmentFromCAAlignment:(NSString *)alignment
{
    if ([alignment isEqualToString:kCAAlignmentLeft])       return NSTextAlignmentLeft;
    if ([alignment isEqualToString:kCAAlignmentCenter])     return NSTextAlignmentCenter;
    if ([alignment isEqualToString:kCAAlignmentRight])      return NSTextAlignmentRight;
    if ([alignment isEqualToString:kCAAlignmentNatural])    return NSTextAlignmentLeft;
    return NSTextAlignmentLeft;
}

#pragma mark - LayoutSublayers

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    self.textLayer.frame = self.layer.bounds;
}

#pragma mark - MTAnimated Label Public Methods

- (void)setTint:(UIColor *)tint
{
    _tint = tint;
    
    CAGradientLayer *gradientLayer  = (CAGradientLayer *)self.layer;
    gradientLayer.colors            = @[(id)[self.textColor CGColor],(id)[_tint CGColor], (id)[self.textColor CGColor]];
    [self setNeedsDisplay];
}

- (void)startAnimating
{
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    if([gradientLayer animationForKey:kAnimationKey] == nil)
    {
        CABasicAnimation *startPointAnimation = [CABasicAnimation animationWithKeyPath:kGradientStartPointKey];
        startPointAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 0)];
        startPointAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *endPointAnimation = [CABasicAnimation animationWithKeyPath:kGradientEndPointKey];
        endPointAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1+self.gradientWidth, 0)];
        endPointAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[startPointAnimation, endPointAnimation];
        group.duration = self.animationDuration;
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        group.repeatCount = FLT_MAX;
        
        [gradientLayer addAnimation:group forKey:kAnimationKey];
    }
}

- (void)stopAnimating
{
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    if([gradientLayer animationForKey:kAnimationKey])
        [gradientLayer removeAnimationForKey:kAnimationKey];
}
@end
