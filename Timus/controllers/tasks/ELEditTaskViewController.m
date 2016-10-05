//
//  ELEditTaskViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 10/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELEditTaskViewController.h"
#import "ELIntervalRepresentationObject.h"
#import "RPFloatingPlaceholderTextView.h"
#import "ELProject+Common.h"
#import "ELTask+Common.h"
#import "NSSet+Utils.h"

#pragma mark - Constants

#define kDidCreateTaskIdentifier @"kDidCreateTaskIdentifier"
#define kDidSelectCancelSegueIdentifier @"kDidSelectCancelSegueIdentifier"

@interface ELEditTaskViewController ()

- (void) p_editTask;

@end

@implementation ELEditTaskViewController

#pragma mark - Actions

- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender
{
    ELTask *taskToKeep = (ELTask*)[self timeObject];
    NSMutableSet *filteredTasks = [taskToKeep.project.tasks tasksWithStartDate:self.temporaryStartDate
                                                                    andEndDate:self.temporaryEndDate];
    [filteredTasks removeObject:taskToKeep];
    //if filteredIntervals is 1 we are editing the only task
    if ([filteredTasks count] > 1) {
        __block ELEditTaskViewController *weakSelf = self;
        [super showMergeTasksDialogWithMergeBlock:^{
            [taskToKeep mergeWithStartDate:self.temporaryStartDate
                                   endDate:self.temporaryEndDate
                                    detail:self.taskDetailTextView.text
                                   isAfter:NO];
            [taskToKeep mergeWithTasks:filteredTasks];
            [weakSelf performSegueWithIdentifier:kDidCreateTaskIdentifier
                                          sender:weakSelf];
        } createTaskBlock:^{
            [weakSelf p_editTask];
        } andGoBackBlock:NULL];
    } else {
        [self p_editTask];
    }
}

#pragma mark - Private Methods

- (void) p_editTask
{
    [self.timeObject setCreationDate:self.temporaryStartDate];
    [self.timeObject setEndDate:self.temporaryEndDate];
    [self.timeObject setDetail:self.taskDetailTextView.text];
    [self performSegueWithIdentifier:kDidCreateTaskIdentifier
                              sender:self];
}

@end
