//
//  ELNewTaskViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 4/16/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELDatePickerView.h"
#import "ELNewTaskViewController.h"
#import "ELIntervalRepresentationObject.h"
#import "ELProjectManager.h"
#import "ELTextView.h"
#import "ELTask+Common.h"
#import "ELProject+Common.h"
#import "NSSet+Utils.h"

#define kDidCreateTaskIdentifier @"kDidCreateTaskIdentifier"
#define kDidSelectCancelSegueIdentifier @"kDidSelectCancelSegueIdentifier"

@interface ELNewTaskViewController ()

- (void) p_endCurrentTask;

@end

@implementation ELNewTaskViewController

#pragma mark - Actions

- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender
{
    ELProjectManager *projectManager = [ELProjectManager sharedProjectManager];
    ELTask *taskToKeep = (ELTask*)[self timeObject];
    NSMutableSet *filteredTasks = [taskToKeep.project.tasks tasksWithStartDate:self.temporaryStartDate
                                                                    andEndDate:self.temporaryEndDate];
    if ([filteredTasks count] > 1) {
        __block ELNewTaskViewController *weakSelf = self;
        [super showMergeTasksDialogWithMergeBlock:^{
            [taskToKeep mergeWithStartDate:self.temporaryStartDate
                                   endDate:self.temporaryEndDate
                                    detail:self.taskDetailTextView.text
                                   isAfter:NO];
            [taskToKeep mergeWithTasks:filteredTasks];
            [projectManager endCurrentTask];
            [weakSelf performSegueWithIdentifier:kDidCreateTaskIdentifier
                                          sender:weakSelf];
        } createTaskBlock:^{
            [weakSelf p_endCurrentTask];
        } andGoBackBlock:NULL];
    } else {
        [self p_endCurrentTask];
    }
}

#pragma mark - Private Methods

- (void) p_endCurrentTask
{
    ELProjectManager *projectManager = [ELProjectManager sharedProjectManager];
    [self.timeObject setCreationDate:self.temporaryStartDate];
    [self.timeObject setEndDate:self.temporaryEndDate];
    [projectManager endCurrentTaskWithDetail:self.taskDetailTextView.text];
    [self performSegueWithIdentifier:kDidCreateTaskIdentifier
                              sender:self];
}

@end
