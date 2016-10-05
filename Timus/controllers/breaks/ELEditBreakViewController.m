//
//  ELEditBreakViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 10/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELEditBreakViewController.h"
#import "ELIntervalRepresentationObject.h"
#import "ELProjectManager.h"
#import "ELTextView.h"
#import "ELBreak+Common.h"
#import "ELTask+Common.h"
#import "NSSet+Utils.h"

#define kDidCreateTaskIdentifier @"kDidCreateTaskIdentifier"
#define kDidSelectCancelSegueIdentifier @"kDidSelectCancelSegueIdentifier"

@interface ELEditBreakViewController ()

- (void) p_finishEditing;

@end

@implementation ELEditBreakViewController

#pragma mark - Actions

- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender
{
    ELBreak *interval = (ELBreak*)self.timeObject;
    ELTask *parentTask = interval.task;
    NSSet *intervals = parentTask.intervals;
    NSMutableSet *filteredIntervals = [intervals breaksWithStartDate:
                                       self.temporaryStartDate
                                                          andEndDate:self.temporaryEndDate];
    __block ELEditBreakViewController *weakSelf = self;
    //if filteredIntervals is 1 we are editing the only break
    if ([filteredIntervals count] > 1) {
        [super showMergeTasksDialogWithMergeBlock:^{
            ELBreak *breakToKeep = [filteredIntervals anyObject];
            [breakToKeep mergeWithStartDate:[weakSelf temporaryStartDate]
                                    endDate:[weakSelf temporaryEndDate]
                                     detail:[weakSelf temporaryDetail]
                                    isAfter:NO];
            [breakToKeep mergeWithBreaks:filteredIntervals];
            [breakToKeep adjustToParentTask];
            [weakSelf performSegueWithIdentifier:kDidCreateTaskIdentifier
                                          sender:weakSelf];
        } createTaskBlock:^{
            [weakSelf p_finishEditing];
        } andGoBackBlock:NULL];
    } else {
        [self p_finishEditing];
    }
}

#pragma mark - Private Methods

- (void) p_finishEditing
{
    ELProjectManager *projectManager = [ELProjectManager sharedProjectManager];
    [self.timeObject setCreationDate:self.temporaryStartDate];
    [self.timeObject setEndDate:self.temporaryEndDate];
    if ([[projectManager currentBreak] isEqual:self.timeObject]) {
        [projectManager endCurrentBreakWithDetail:self.taskDetailTextView.text];
    } else {
        self.timeObject.detail = self.taskDetailTextView.text;
    }
    [(ELBreak*)self.timeObject adjustToParentTask];
    
    [self performSegueWithIdentifier:kDidCreateTaskIdentifier
                              sender:self];
}

@end
