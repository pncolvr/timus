//
//  ELEmptyView.m
//  Timus
//
//  Created by Pedro Oliveira on 7/24/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELInformationView.h"

@interface ELInformationView ()

@property (nonatomic, strong) UILabel *informationLabel;

- (void) p_setupInformationLabelAutoLayout;
- (void) p_setupInformationLabel;
- (void) p_setupView;

@end

@implementation ELInformationView

#pragma mark - View Lifecycle

- (instancetype) initWithFrame:(CGRect)frame andInformationText:(NSString*) informationText
{
    self = [super initWithFrame:frame];
    if (self) {
        self.informationText = informationText;
        [self p_setupView];
    }
    return self;
}

#pragma mark - Private Methods

- (void) p_setupInformationLabelAutoLayout
{
    [self.informationLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.informationLabel
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:CGRectGetWidth(self.informationLabel.frame)]];
    [self.informationLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.informationLabel
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeHeight
                                                                     multiplier:1.0f
                                                                       constant:CGRectGetHeight(self.informationLabel.frame)]];
}

- (void) p_setupInformationLabel
{
    self.informationLabel.text = self.informationText;
    self.informationLabel.numberOfLines = 0;
    self.informationLabel.textAlignment = NSTextAlignmentCenter;
    [self p_setupInformationLabelAutoLayout];
}

- (void) p_setupView
{
    self.backgroundColor = [UIColor whiteColor];
    self.informationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:self.informationLabel];
    [self p_setupInformationLabel];
}

@end
