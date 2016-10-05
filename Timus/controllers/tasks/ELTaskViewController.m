//
//  ELTaskViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 7/16/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELBreaksTableViewController.h"
#import "ELProject+Common.h"
#import "ELTask+Common.h"
#import "ELTaskViewController.h"
#import "NSDate+Localization.h"
#import "NSString+TimeFormatting.h"
#import "UIColor+Utils.h"
#import "ELGenericEditAndNewController.h"
#import "ELProjectManager.h"

#pragma mark - Constants

#define kDidSelectListBreaks @"kDidSelectListBreaks"
#define kNonProductiveTimeIndex 0
#define kProductiveTimeIndex 1
#define kEditTaskSegue @"kEditTaskSegue"

@interface ELTaskViewController ()

- (void) p_setupChartView;
- (void) p_updateUserInterface;
- (void) p_updateUserInterfaceFromNotification:(NSNotification*)note;
- (void) p_updateTaskDurationLabel;
- (void) p_updateTaskProductiveTimeLabel;
- (void) p_updateTaskNonProductiveTimeLabel;
- (void) p_registerNotifications;

@property (nonatomic, strong) UIBarButtonItem *tempEditButton;

@end

@implementation ELTaskViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tempEditButton = self.navigationItem.rightBarButtonItem;
    [self p_registerNotifications];
    [self p_setupChartView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_updateUserInterface];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kDidSelectListBreaks]) {
        ELBreaksTableViewController *breaksTableViewController = [segue.destinationViewController viewControllers][0];
        breaksTableViewController.task = self.task;
    }
    
    if ([segue.identifier isEqualToString:kEditTaskSegue]) {
        ELGenericEditAndNewController *editViewController = [segue.destinationViewController viewControllers][0];
        editViewController.timeObject = self.task;
    }
}

- (IBAction)unwindFromListBreaksViewController:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}


- (IBAction)unwindFromNewTaskViewControllerCancelledCreateTask:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}

- (IBAction)unwindFromNewTaskViewControllerFinishedCreateTask:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}

#pragma mark - Private Methods

- (void) p_setupChartView
{
    self.pieChartView.delegate = self;
    self.pieChartView.datasource = self;
    self.pieChartView.backgroundColor = [UIColor clearColor];
}

- (void) p_updateUserInterface
{
    NSString *taskDetail = [self.task displayDetail];
    self.navigationItem.title = taskDetail;
    self.taskDetailTextView.text = taskDetail;
    
    self.startDateLabel.text = [self.task.creationDate localizedShortDateString];
    NSDate *endDate = self.task.endDate;
    NSString* localizedDate = @"---";
    if (endDate) {
        localizedDate = [endDate localizedShortDateString];
    }
    self.endDateLabel.text = localizedDate;
    
    ELProjectManager *projectManager = [ELProjectManager sharedProjectManager];
    BOOL isCurrentTask = [self.task isEqual:[projectManager currentTask]];
    
    if (isCurrentTask) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = self.tempEditButton;
    }
    
    [self.pieChartView reloadData];
    [self p_updateTaskDurationLabel];
    [self p_updateTaskProductiveTimeLabel];
    [self p_updateTaskNonProductiveTimeLabel];
}

- (void) p_updateUserInterfaceFromNotification:(NSNotification*)note
{
    if ([self.task.project isEqualToProject:[note object]]) {
        [self p_updateUserInterface];
    }
}

- (void) p_updateTaskDurationLabel
{
    NSInteger elapsedSeconds = [self.task totalWorkTimeInSeconds];
    self.taskDurationLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:elapsedSeconds];
}
- (void) p_updateTaskProductiveTimeLabel
{
    NSInteger elapsedSeconds = [self.task totalProductiveTimeInSeconds];
    self.taskProductiveTimeLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:elapsedSeconds];
}

- (void) p_updateTaskNonProductiveTimeLabel
{
    NSInteger elapsedSeconds = [self.task totalBreakTimeInSeconds];
    self.taskNonProductiveTimeLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:elapsedSeconds];
}

-(void)p_registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_updateUserInterfaceFromNotification:)
                                                 name:kCurrentProjectDidUpdateNotification
                                               object:nil];
}

#pragma mark - PieChartViewDataSource

- (int)numberOfSlicesInPieChartView:(PieChartView *)pieChartView
{
    return 2;
}

- (double)pieChartView:(PieChartView *)pieChartView valueForSliceAtIndex:(NSUInteger)index
{
    switch (index) {
        case kProductiveTimeIndex:    return [self.task totalProductiveTimeInSeconds];
        case kNonProductiveTimeIndex: return [self.task totalBreakTimeInSeconds];
        default: return 0.0;
    }
}

- (UIColor *)pieChartView:(PieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index
{
    switch (index) {
        case kProductiveTimeIndex:    return kProductiveTimeColor;
        case kNonProductiveTimeIndex: return kNonProductiveTimeColor;
        default: return [UIColor blackColor];
    }
}

- (NSString*)pieChartView:(PieChartView *)pieChartView titleForSliceAtIndex:(NSUInteger)index
{
    switch (index) {
        case kProductiveTimeIndex:    return NSLocalizedString(@"Productive time", @"");
        case kNonProductiveTimeIndex: return NSLocalizedString(@"Break time", @"");;
        default: return @"";
    }
}

#pragma mark - PieChartViewDelegate

-(CGFloat)centerCircleRadius
{
    return 0.0f;
}

@end
