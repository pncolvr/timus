//
//  ELProjectViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 03/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELProjectViewController.h"
#import "ELImagePicker.h"
#import "UIViewController+Utils.h"
#import "ELCircleButton.h"
#import "RPFloatingPlaceholderTextField.h"
#import "RPFloatingPlaceholderTextView.h"

@interface ELProjectViewController ()

@property (nonatomic, strong) ELImagePicker *imagePicker;

@end

@implementation ELProjectViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUserInterface];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - Actions

- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender
{
    ELLogCritical(@"didSelectDoneButton: must be implemented in a subclass");
}

- (IBAction)tapGestureRecognizerRecognized:(UITapGestureRecognizer *)sender
{
    [self dismissKeyboard];
}

- (IBAction)didSelectProjectImageButton:(UIButton *)sender
{
    if (!self.imagePicker) {
        self.imagePicker = [[ELImagePicker alloc] init];
    }
    [self.imagePicker presentInViewController:self.navigationController
                                 targetButton:self.projectImageButton
                              andDefaultImage:nil];
}

#pragma mark - Private Methods

- (void) setupUserInterface
{
    [self.projectImageButton setTitle:NSLocalizedString(@"add\nphoto", @"")
                             forState:UIControlStateNormal];
    self.projectImageButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.projectImageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.projectImageButton.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
    self.projectImageButton.layer.borderWidth  = 0.7f;
    
    self.projectNameTextField.floatingLabelActiveTextColor = [UIColor blackColor];
    self.projectDetailsTextView.floatingLabelActiveTextColor = [UIColor blackColor];
}

@end
