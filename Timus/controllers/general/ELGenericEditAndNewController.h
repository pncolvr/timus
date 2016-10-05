//
//  ELGenericEditAndNewController.h
//  Timus
//
//  Created by Pedro Oliveira on 10/08/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;
#import "ELDatePickerView.h"
#import "ELTextView.h"

#pragma mark - Constants

#define kDatePickerInternalSegue @"kDatePickerInternalSegue"
#define kDatePickerSegue @"kDatePickerSegue"

@class ELProject;
@class ELTask;
@protocol ELIntervalRepresentationObject;

@interface ELGenericEditAndNewController : UIViewController <ELDatePickerDelegate>

#pragma mark - Properties

@property (strong, nonatomic) NSObject<ELIntervalRepresentationObject> *timeObject;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveTaskButton;
@property (strong, nonatomic) IBOutlet UIButton *startDateButton;
@property (strong, nonatomic) IBOutlet UIButton *endDateButton;
@property (strong, nonatomic) IBOutlet ELTextView *taskDetailTextView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) ELProject *project;

/*
 declared here so that subclasses can legally access these properties
 used copy, to create a new object on attribution
 */
@property (nonatomic, copy) NSDate *temporaryStartDate;
@property (nonatomic, copy) NSDate *temporaryEndDate;
@property (nonatomic, copy) NSString *temporaryDetail;

#pragma mark - Actions

- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender;
- (IBAction)didSelectStartDateButton:(UIButton*)sender;
- (IBAction)didSelectEndDateButton:(id)sender;
- (IBAction)tapGestureRecognizerRecognized:(UITapGestureRecognizer *)sender;
- (void) showMergeTasksDialogWithMergeBlock:(void (^)(void)) mergeBlock
                            createTaskBlock:(void (^)(void)) createTaskBlock
                             andGoBackBlock:(void (^)(void)) goBackBlock;
- (void) showMergeBreaksDialogWithMergeBlock:(void (^)(void)) mergeBlock
                            createBreakBlock:(void (^)(void)) createBreakBlock
                              andGoBackBlock:(void (^)(void)) goBackBlock;

@end