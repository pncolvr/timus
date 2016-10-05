//
//  ELDashboardViewController.m
//  Timus
//
//  Created by Emanuel Coelho on 03/06/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELBreak.h"
#import "ELDashboardViewController.h"
#import "ELEditProjectViewController.h"
#import "ELNewTaskViewController.h"
#import "ELProject+Common.h"
#import "ELProjectManager.h"
#import "ELTask+Common.h"
#import "ELTasksTableViewController.h"
#import "NSString+TimeFormatting.h"
#import "POAlertView.h"
#import "POPromptAlertView.h"
#import "UIColor+Utils.h"
#import "UIView+Utils.h"
#import "ELExportTasksViewController.h"

#pragma mark - Constants

#define kCreateTaskIdentifier @"kCreateTaskIdentifier"
#define kDidSelectEditButton @"kDidSelectEditButton"
#define kExportViewSegue @"kExportViewSegue"
#define kShowTasksSegueIdentifier @"kShowTasksSegueIdentifier"

#define kNonProductiveTimeIndex 0
#define kProductiveTimeIndex 1

@interface ELDashboardViewController ()
- (void) p_updateFromProjectSelection;
- (void) p_updateTimer:(NSNotification*)note;
- (void) p_showPauseButton;
- (void) p_showStartButton;
- (void) p_showResumeButton;
- (void) p_registerNotifications;
- (void) p_setupChartView;
- (void) p_showChartViews;
- (void) p_hideChartViews;
@end

@implementation ELDashboardViewController
{
    POAlertView *_alertView;
    POPromptAlertView *_promptAlertView;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_registerNotifications];
    [self p_setupChartView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_updateFromProjectSelection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (IBAction)didPressStartButton:(id)sender
{
    ELProjectManager *projectManager = [ELProjectManager sharedProjectManager];
    ELProject *selectedProject = [[ELUserDefaults sharedUserDefaults] selectedProject];
    __block ELDashboardViewController *weakSelf = self;
    __block POPromptAlertView *weakPrompt = _promptAlertView;
    if([projectManager canCreateTaskWithProject:selectedProject]){
        [projectManager createTaskWithProject:selectedProject];
        [self p_showPauseButton];
    } else {
        _alertView = [[POAlertView alloc]initWithTitle:nil
                                            andMessage:[NSString stringWithFormat:NSLocalizedString(@"You have a task running on %@ project. Would you like to stop it?", @""), [[projectManager currentProject] name]]];
        [_alertView addButtonWithTitle:NSLocalizedString(@"Yes", @"") andAction:^{
            weakPrompt = [[POPromptAlertView alloc] initWithTitle:NSLocalizedString(@"So, what have you been doing?", @"")];
            
            [weakPrompt addButtonWithTitle:NSLocalizedString(@"OK", @"") andAction:^(NSString *text) {
                [projectManager endCurrentTaskWithDetail:text];
                [projectManager createTaskWithProject:selectedProject];
                [weakSelf p_showPauseButton];
            }];
            [weakPrompt show];
            
        }];
        [_alertView addButtonWithTitle:NSLocalizedString(@"No", @"") andAction:nil];
        [_alertView show];
    }
    
}

- (IBAction)didPressStopButton:(id)sender
{
    [self performSegueWithIdentifier:kCreateTaskIdentifier sender:sender];
}

- (IBAction)didPressPauseButton:(id)sender
{
    ELProjectManager *projectManager = [ELProjectManager sharedProjectManager];
    ELProject *currentProject = [[ELUserDefaults sharedUserDefaults] selectedProject];
    ELTask *currentTask = [currentProject currentTask];
    
    if ([projectManager canCreateBreakWithProject:currentProject]) {
        [projectManager createBreakWithTask:currentTask];
        [self p_showResumeButton];
    }
}

- (IBAction)didPressResumeButton:(id)sender
{
    _promptAlertView = [[POPromptAlertView alloc] initWithTitle:NSLocalizedString(@"Was it a good break?", @"")];
    
    [_promptAlertView addButtonWithTitle:NSLocalizedString(@"OK", @"") andAction:^(NSString *text) {
        ELProjectManager *projectManager = [ELProjectManager sharedProjectManager];
        [projectManager endCurrentBreakWithDetail:text];
    }];
    [_promptAlertView show];
    [self p_showPauseButton];
    
}

- (IBAction)didPressExportButton:(id)sender
{
    [self performSegueWithIdentifier:kExportViewSegue
                              sender:self];
}

#pragma mark - Segues

- (IBAction)unwindFromNewTaskViewControllerCancelledCreateTask:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}

- (IBAction)unwindFromNewTaskViewControllerFinishedCreateTask:(UIStoryboardSegue*)segue
{
    self.timerLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:0];
}

- (IBAction)unwindFromTasksTableViewController:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}

- (IBAction)unwindFromEditProjectViewController:(UIStoryboardSegue*)segue;
{
    LOG_METHOD_NAME
}

- (IBAction)unwindFromEditProjectViewControllerProjectEdited:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}

- (IBAction) unwindFromExportTasksViewControllerWithBack:(UIStoryboardSegue*) segue
{
    LOG_METHOD_NAME
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kCreateTaskIdentifier]) {
        ELGenericEditAndNewController *editViewController = [segue.destinationViewController viewControllers][0];
        editViewController.timeObject = [[ELProjectManager sharedProjectManager] currentTask];
    }
    
    if ([segue.identifier isEqualToString:kShowTasksSegueIdentifier]) {
        ELTasksTableViewController *tasksTableViewController = [segue.destinationViewController viewControllers][0];
        tasksTableViewController.project = [[ELUserDefaults sharedUserDefaults] selectedProject];
    }
    
    if ([segue.identifier isEqualToString:kDidSelectEditButton]) {
        ELEditProjectViewController *editProjectViewController = [segue.destinationViewController viewControllers][0];
        editProjectViewController.project = [[ELUserDefaults sharedUserDefaults] selectedProject];
    }
    if ([segue.identifier isEqualToString:kExportViewSegue]) {
        ELExportTasksViewController *exportViewController = [segue.destinationViewController viewControllers][0];
        exportViewController.project = [[ELUserDefaults sharedUserDefaults] selectedProject];
    }
}

#pragma mark - Private Methods

- (void) p_updateFromProjectSelection
{
    ELProject *project = [[ELUserDefaults sharedUserDefaults] selectedProject];
    if(project){
        self.navigationItem.title = project.name;
    } else {
        [self.startButton setHidden:YES];
        [self.stopButton setHidden:YES];
    }
    ELProjectManager *projectManager = [ELProjectManager sharedProjectManager];
    ELTask *currentTask = [projectManager currentTask];
    if ([currentTask.project isEqual:project]) {
        if ([projectManager currentBreak]) {
            [self p_showResumeButton];
        } else {
            [self p_showPauseButton];
        }
        
    } else {
        [self p_showStartButton];
    }
    
    [self p_updateTimerWithCurrentProject:[projectManager currentProject]];
}

- (void) p_updateTimer:(NSNotification*)note
{
    [self p_updateTimerWithCurrentProject:[note object]];
}

- (void) p_updateTimerWithCurrentProject:(ELProject*) project
{
    ELProject *selectedProject = [[ELUserDefaults sharedUserDefaults] selectedProject];
    if ([selectedProject isEqualToProject:project]) {
        NSDate *initialDate = [[[ELProjectManager sharedProjectManager] currentTask] creationDate];
        NSDate *currentDate = [NSDate date];
        NSInteger elapsedTaskSeconds = [currentDate timeIntervalSinceDate:initialDate];
        NSInteger elapsedBreakSeconds = 0;
        ELBreak *currentBreak = [[ELProjectManager sharedProjectManager] currentBreak];
        if (currentBreak) {
            elapsedBreakSeconds = [currentDate timeIntervalSinceDate:currentBreak.creationDate];
        }
        self.timerLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:elapsedTaskSeconds];
        self.breakTimerLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:elapsedBreakSeconds];
    } else {
        self.timerLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:0];
        self.breakTimerLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:0];
    }
    NSTimeInterval productiveTime = [selectedProject totalProductiveTimeInSeconds];
    NSTimeInterval breakTime = [selectedProject totalBreakTimeInSeconds];
    
    if (productiveTime > 0 || breakTime > 0) {
        [self p_showChartViews];
        [self.pieCharView reloadData];
        self.productiveTimeLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:productiveTime];
        self.breakTimeLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:breakTime];
    } else {
        [self p_hideChartViews];
    }
    
}

-(void)p_showPauseButton
{
    self.resumeButton.hidden = YES;
    self.startButton.hidden  = YES;
    self.pauseButton.hidden  = NO;
    
    self.stopButton.enabled = YES;
    
    self.breakTimerLabel.hidden = YES;
}

-(void)p_showResumeButton
{
    self.startButton.hidden  = YES;
    self.pauseButton.hidden  = YES;
    self.resumeButton.hidden = NO;
    
    self.stopButton.enabled = YES;
    
    self.breakTimerLabel.hidden = NO;
    self.breakTimerLabel.alpha = 0.0f;
    [UIView animateWithDuration:0.3 animations:^{
        self.breakTimerLabel.alpha = 1.0f;
    }];
}

-(void)p_showStartButton
{
    self.resumeButton.hidden = YES;
    self.pauseButton.hidden  = YES;
    self.startButton.hidden  = NO;
    
    self.stopButton.enabled = NO;
    self.breakTimerLabel.hidden = YES;
}

- (void) p_registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_updateFromProjectSelection)
                                                 name:kDefaultProjectDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_updateTimer:)
                                                 name:kCurrentProjectDidUpdateNotification
                                               object:nil];
    
}
- (void) p_setupChartView
{
    self.pieCharView.delegate = self;
    self.pieCharView.datasource = self;
    self.pieCharView.backgroundColor = [UIColor clearColor];
}

- (void) p_showChartViews
{
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCrossDissolve;
    NSTimeInterval duration = 0.25;
    [self.pieCharView animateWithOptions:options andDuration:duration];
    [self.breakTimeLabel animateWithOptions:options andDuration:duration];
    [self.productiveTimeLabel animateWithOptions:options andDuration:duration];
    [self.projectOverviewLabel animateWithOptions:options andDuration:duration];
    
    [self.pieCharView setHidden:NO];
    [self.breakTimeLabel setHidden:NO];
    [self.productiveTimeLabel setHidden:NO];
    [self.projectOverviewLabel setHidden:NO];
    
    [self.exportButton setStyle:UIBarButtonItemStyleBordered];
    [self.exportButton setTitle:NSLocalizedString(@"Export", @"")];
    [self.exportButton setTitle:@""];
    [self.exportButton setEnabled:YES];
    
    [self.exportButton setEnabled:NO];
}

- (void) p_hideChartViews
{
    [self.pieCharView setHidden:YES];
    [self.breakTimeLabel setHidden:YES];
    [self.productiveTimeLabel setHidden:YES];
    [self.projectOverviewLabel setHidden:YES];
    
    [self.exportButton setStyle:UIBarButtonItemStylePlain];
    [self.exportButton setTitle:@""];
    [self.exportButton setEnabled:NO];
}

#pragma mark - PieChartViewDataSource

- (int)numberOfSlicesInPieChartView:(PieChartView *)pieChartView
{
    return 2;
}
- (double)pieChartView:(PieChartView *)pieChartView valueForSliceAtIndex:(NSUInteger)index
{
    ELProject *selectedProject = [[ELUserDefaults sharedUserDefaults] selectedProject];
    switch (index) {
        case kProductiveTimeIndex:    return [selectedProject totalProductiveTimeInSeconds];
        case kNonProductiveTimeIndex: return [selectedProject totalBreakTimeInSeconds];
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
