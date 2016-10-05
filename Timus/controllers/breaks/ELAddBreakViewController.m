//
//  ELAddBreakViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 10/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELAddBreakViewController.h"
#import "ELTask+Common.h"
#import "ELBreak+Common.h"
#import "ELTextView.h"
#import "NSSet+Utils.h"

#define kDidCreateTaskIdentifier @"kDidCreateTaskIdentifier"
#define kDidSelectCancelSegueIdentifier @"kDidSelectCancelSegueIdentifier"

@interface ELAddBreakViewController ()

- (void) p_createBreak;

@end

@implementation ELAddBreakViewController

#pragma mark - Actions

- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender
{
    NSSet *intervals = self.parentTask.intervals;
    NSMutableSet *filteredIntervals = [intervals breaksWithStartDate:self.temporaryStartDate
                                                          andEndDate:self.temporaryEndDate];
    __block ELAddBreakViewController *weakSelf = self;
    if ([filteredIntervals count]) {
        
        [super showMergeBreaksDialogWithMergeBlock:^{
            ELBreak *breakToKeep = [filteredIntervals anyObject];
            [breakToKeep mergeWithStartDate:[weakSelf temporaryStartDate]
                                    endDate:[weakSelf temporaryEndDate]
                                     detail:[weakSelf temporaryDetail]
                                    isAfter:NO];
            [breakToKeep mergeWithBreaks:filteredIntervals];
            [breakToKeep adjustToParentTask];
            [weakSelf performSegueWithIdentifier:kDidCreateTaskIdentifier
                                          sender:weakSelf];
        } createBreakBlock:^{
            [weakSelf p_createBreak];
        } andGoBackBlock:NULL];
    } else {
        [self p_createBreak];
    }
}

#pragma mark - Private Methods

- (void) p_createBreak
{
    [[ELBreak createWithTitle:nil
                       detail:self.taskDetailTextView.text
                 creationDate:self.temporaryStartDate
                      endDate:self.temporaryEndDate
                         task:self.parentTask
                 failureBlock:NULL] adjustToParentTask];
    [self performSegueWithIdentifier:kDidCreateTaskIdentifier
                              sender:self];
}

@end
