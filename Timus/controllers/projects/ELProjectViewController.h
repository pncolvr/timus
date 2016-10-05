//
//  ELProjectViewController.h
//  Timus
//
//  Created by Pedro Oliveira on 03/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import UIKit;

@class ELCircleButton;
@class RPFloatingPlaceholderTextField;
@class RPFloatingPlaceholderTextView;
@interface ELProjectViewController : UIViewController

#pragma mark - Actions

- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender;
- (IBAction)tapGestureRecognizerRecognized:(UITapGestureRecognizer *)sender;
- (IBAction)didSelectProjectImageButton:(UIButton *)sender;

#pragma mark - Methods

- (void) setupUserInterface;

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet RPFloatingPlaceholderTextField *projectNameTextField;
@property (strong, nonatomic) IBOutlet RPFloatingPlaceholderTextView *projectDetailsTextView;
@property (strong, nonatomic) IBOutlet ELCircleButton *projectImageButton;

@end
