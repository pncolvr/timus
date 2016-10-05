//
//  ELDashboardViewController.h
//  Timus
//
//  Created by Emanuel Coelho on 03/06/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import UIKit;

#import "PieChartView.h"

@interface ELDashboardViewController : UIViewController <PieChartViewDataSource, PieChartViewDelegate>

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UILabel *breakTimerLabel;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *actionButtons;
@property (weak, nonatomic) IBOutlet PieChartView *pieCharView;
@property (weak, nonatomic) IBOutlet UILabel *breakTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *productiveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectOverviewLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exportButton;

#pragma mark - Actions

- (IBAction)didPressStartButton:(id)sender;
- (IBAction)didPressStopButton:(id)sender;
- (IBAction)didPressPauseButton:(id)sender;
- (IBAction)didPressResumeButton:(id)sender;
- (IBAction)didPressExportButton:(id)sender;

#pragma mark - Segues

- (IBAction)unwindFromNewTaskViewControllerCancelledCreateTask:(UIStoryboardSegue*)segue;
- (IBAction)unwindFromEditProjectViewController:(UIStoryboardSegue*)segue;
- (IBAction)unwindFromEditProjectViewControllerProjectEdited:(UIStoryboardSegue*)segue;
- (IBAction)unwindFromNewTaskViewControllerFinishedCreateTask:(UIStoryboardSegue*)segue;
- (IBAction)unwindFromTasksTableViewController:(UIStoryboardSegue*)segue;
- (IBAction) unwindFromExportTasksViewControllerWithBack:(UIStoryboardSegue*) segue;

@end
