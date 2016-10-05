//
//  ELBreakViewController.h
//  Timus
//
//  Created by Pedro Oliveira on 9/19/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import UIKit;

@class ELBreak;
@class ELTextView;
@interface ELBreakViewController : UIViewController

@property (nonatomic, strong) ELBreak *interval;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet ELTextView *breakDetailTextView;

//Segue actions
- (IBAction)unwindFromNewTaskViewControllerCancelledCreateTask:(UIStoryboardSegue*)segue;
- (IBAction)unwindFromNewTaskViewControllerFinishedCreateTask:(UIStoryboardSegue*)segue;

@end
