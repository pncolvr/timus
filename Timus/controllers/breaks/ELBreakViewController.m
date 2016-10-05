//
//  ELBreakViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 9/19/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//


#import "ELBreak+Common.h"
#import "ELBreakViewController.h"
#import "ELTextView.h"
#import "NSDate+Localization.h"
#import "ELProjectManager.h"
#import "ELGenericEditAndNewController.h"

#define kEditBreakSegue @"kEditBreakSegue"

@interface ELBreakViewController ()

-(void) p_setupUserInterface;

@property (nonatomic, strong) UIBarButtonItem *tempEditButton;

@end

@implementation ELBreakViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tempEditButton = self.navigationItem.rightBarButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_setupUserInterface];
}

#pragma mark - Private Methods

-(void) p_setupUserInterface
{
    self.navigationItem.title = [self.interval displayDetail];
    self.startDateLabel.text = [self.interval.creationDate localizedShortDateString];
    NSDate *endDate = self.interval.endDate;
    NSString *endDateString = [endDate localizedShortDateString];
    if (!endDate) {
        endDateString = @"---";
    }
    self.endDateLabel.text = endDateString;
    
    self.breakDetailTextView.text = [self.interval displayDetail];
    
    ELProjectManager *projectManager = [ELProjectManager sharedProjectManager];
    BOOL isCurrentBreak = [self.interval isEqual:[projectManager currentBreak]];
    
    if (isCurrentBreak) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = self.tempEditButton;
    }
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kEditBreakSegue]) {
        ELGenericEditAndNewController *editViewController = [segue.destinationViewController viewControllers][0];
        editViewController.timeObject = self.interval;
    }
}

- (IBAction)unwindFromNewTaskViewControllerCancelledCreateTask:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}

- (IBAction)unwindFromNewTaskViewControllerFinishedCreateTask:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}

@end
