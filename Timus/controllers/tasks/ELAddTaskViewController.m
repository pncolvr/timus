//
//  ELAddTaskViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 10/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELAddTaskViewController.h"
#import "ELTask+Common.h"
#import "ELProject+Common.h"
#import "ELTextView.h"
#import "NSSet+Utils.h"

#pragma mark - Constants

#define kDidCreateTaskIdentifier @"kDidCreateTaskIdentifier"
#define kDidSelectCancelSegueIdentifier @"kDidSelectCancelSegueIdentifier"

@interface ELAddTaskViewController ()

- (void) p_createTaskWithStartDate:(NSDate*)startDate
                           endDate:(NSDate*)endDate
                         andDetail:(NSString*)detail;

@end

@implementation ELAddTaskViewController

#pragma mark - Actions

- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender
{
    NSDate *startDate = self.temporaryStartDate;
    NSDate *endDate   = self.temporaryEndDate;
    NSString *detail  = self.taskDetailTextView.text;
    
    NSMutableSet *filteredTasks = [self.parentProject.tasks tasksWithStartDate:startDate
                                                                    andEndDate:endDate];
    if ([filteredTasks count]) {
        __block ELAddTaskViewController *weakSelf = self;
        [super showMergeTasksDialogWithMergeBlock:^{
            ELTask *taskToKeep = [filteredTasks anyObject];
            [taskToKeep mergeWithStartDate:startDate
                                   endDate:endDate
                                    detail:detail
                                   isAfter:NO];
            [taskToKeep mergeWithTasks:filteredTasks];
            [weakSelf performSegueWithIdentifier:kDidCreateTaskIdentifier
                                          sender:weakSelf];
        } createTaskBlock:^{
            [weakSelf p_createTaskWithStartDate:startDate
                                        endDate:endDate
                                      andDetail:detail];
        } andGoBackBlock:NULL];
    } else {
        [self p_createTaskWithStartDate:startDate
                                endDate:endDate
                              andDetail:detail];
    }
}

#pragma mark - Private Methods

- (void) p_createTaskWithStartDate:(NSDate*) startDate endDate:(NSDate*) endDate andDetail:(NSString*)detail
{
    ELTask *task = [ELTask createWithTitle:nil
                                    detail:detail
                                     image:nil
                              creationDate:startDate
                                   project:self.parentProject
                              failureBlock:NULL];
    task.endDate = endDate;
    [self performSegueWithIdentifier:kDidCreateTaskIdentifier
                              sender:self];
}

@end
