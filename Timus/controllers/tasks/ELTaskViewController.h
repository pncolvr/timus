//
//  ELTaskViewController.h
//  Timus
//
//  Created by Pedro Oliveira on 7/16/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import UIKit;

#import "PieChartView.h"

@class ELTask;
@class ELTextView;
@interface ELTaskViewController : UIViewController <PieChartViewDataSource,PieChartViewDelegate>

#pragma mark - Properties

@property (nonatomic, strong) ELTask *task;
@property (strong, nonatomic) IBOutlet UILabel *taskDurationLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskProductiveTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskNonProductiveTimeLabel;
@property (weak, nonatomic) IBOutlet ELTextView *taskDetailTextView;
@property (weak, nonatomic) IBOutlet PieChartView *pieChartView;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

#pragma mark - Segues

- (IBAction)unwindFromListBreaksViewController:(UIStoryboardSegue*)segue;
- (IBAction)unwindFromNewTaskViewControllerCancelledCreateTask:(UIStoryboardSegue*)segue;
- (IBAction)unwindFromNewTaskViewControllerFinishedCreateTask:(UIStoryboardSegue*)segue;

@end
