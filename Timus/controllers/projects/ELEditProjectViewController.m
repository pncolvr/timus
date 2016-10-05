//
//  ELEditProjectViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 9/15/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELCircleButton.h"
#import "ELEditProjectViewController.h"
#import "ELProject+Common.h"
#import "RPFloatingPlaceholderTextField.h"
#import "RPFloatingPlaceholderTextView.h"

#pragma mark - Constants

#define kProjectEdited @"kProjectEdited"

@interface ELEditProjectViewController ()

- (void) p_saveTemporaryVariables;
- (void) p_readTemporaryVariables;
@property (nonatomic, strong) NSString *internalProjectTitle;
@property (nonatomic, strong) NSString *internalProjectDetail;
@end

@implementation ELEditProjectViewController{
    ELProject *_project; //strong reference
}
@dynamic project;

#pragma mark - Dynamic Properties

-(ELProject *)project
{
    return _project;
}

-(void)setProject:(ELProject *)project
{
    _project = project;
    self.internalProjectTitle = _project.name;
    self.internalProjectDetail = _project.detail;
}

#pragma mark - View Lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUserInterface];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupUserInterface];
    [self p_readTemporaryVariables];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self p_saveTemporaryVariables];
}

#pragma mark - Actions

- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender
{
    self.project.name = self.projectNameTextField.text;
    self.project.detail = self.projectDetailsTextView.text;
    UIImage *selectedImage = [self.projectImageButton imageForState:UIControlStateNormal];
    self.project.image = selectedImage;
    [self performSegueWithIdentifier:kProjectEdited
                              sender:sender];
}

#pragma mark - Overrides

- (void) setupUserInterface
{
    [super setupUserInterface];
    if (self.project.image) {
        [self.projectImageButton setImage:self.project.image
                                 forState:UIControlStateNormal];
    }
}

#pragma mark - Private Methods

- (void) p_saveTemporaryVariables
{
    self.internalProjectTitle = self.projectNameTextField.text;
    self.internalProjectDetail = self.projectDetailsTextView.text;
}

- (void) p_readTemporaryVariables
{
    self.projectNameTextField.text = self.internalProjectTitle;
    self.projectDetailsTextView.text = self.internalProjectDetail;
}

@end
