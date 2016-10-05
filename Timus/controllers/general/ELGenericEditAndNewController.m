//
//  ELGenericEditAndNewController.m
//  Timus
//
//  Created by Pedro Oliveira on 10/08/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//


#import "UIViewController+Utils.h"
#import "NSDate+Localization.h"
#import "ELNewTaskViewController.h"
#import "ELIntervalRepresentationObject.h"
#import "ELTextView.h"
#import "POActionSheet.h"

@interface ELGenericEditAndNewController ()
@property (nonatomic, strong) ELDatePickerView *datePickerView;

-(void)p_showDatePickerContainer;
-(void)p_hideDatePickerContainer;
-(void)p_refreshView;
-(void)p_invokeDatePickerWithDate:(NSDate*)date andUserInfo:(id) userInfo;
-(void)p_showMergeDialogWithTitleString:(NSString*)title
                       mergeButtonTitle:(NSString*)mergeButtonTitle
                      goBackButtonTitle:(NSString*)goBackButtonTitle
                    continueButtonTitle:(NSString*)continueButtonTitle
                             MergeBlock:(void (^)(void)) mergeBlock
                            createBlock:(void (^)(void)) createBlock
                         andGoBackBlock:(void (^)(void)) goBackBlock;

@end

@implementation ELGenericEditAndNewController{
    NSObject<ELIntervalRepresentationObject> * _timeObject;
    POActionSheet *_actionSheet;
}
@dynamic timeObject;

#pragma mark - Dynamic Properties

-(NSObject<ELIntervalRepresentationObject> *)timeObject
{
    return _timeObject;
}

-(void)setTimeObject:(NSObject<ELIntervalRepresentationObject> *)timeObject
{
    _timeObject = timeObject;
    self.temporaryDetail = [timeObject detail];
    self.temporaryStartDate = [timeObject creationDate];
    self.temporaryEndDate = [timeObject presentingEndDate];
}

#pragma mark - View Lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.taskDetailTextView.text = self.temporaryDetail;
    
    if (!self.temporaryStartDate) { self.temporaryStartDate = [NSDate date]; }
    if (!self.temporaryEndDate)   { self.temporaryEndDate = [NSDate date]; }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_refreshView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.datePickerView = [[ELDatePickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(APP_WINDOW.frame), 320, 304)];
    self.datePickerView.delegate = self;
    [APP_WINDOW addSubview:self.datePickerView];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.datePickerView removeFromSuperview];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Actions

- (IBAction)didSelectStartDateButton:(UIButton*)sender
{
    [self p_invokeDatePickerWithDate:self.temporaryStartDate
                         andUserInfo:@"temporaryStartDate"];
}

- (IBAction)didSelectEndDateButton:(id)sender
{
    [self p_invokeDatePickerWithDate:self.temporaryEndDate
                         andUserInfo:@"temporaryEndDate"];
}

-(IBAction)didSelectDoneButton:(UIBarButtonItem *)sender
{
    ELLogCritical(@"Method not implemented, please subclass");
}

- (IBAction)tapGestureRecognizerRecognized:(UITapGestureRecognizer *)sender
{
    [self dismissKeyboard];
}

#pragma mark - ELDatePickerDelegate

-(void)datePicker:(ELDatePickerView *)datePicker didSelectDate:(NSDate *)selectedDate andUserInfo:(id)userInfo
{
    [self p_hideDatePickerContainer];
    [self setValue:selectedDate
            forKey:userInfo];
    [self p_refreshView];
}

-(void)datePicker:(ELDatePickerView *)datePicker didCancelDateSelectionWithInitialDate:(NSDate *)date andUserInfo:(id)userInfo
{
    [self setValue:date
            forKey:userInfo];
    [self p_refreshView];
    [self p_hideDatePickerContainer];
}

-(void)datePicker:(ELDatePickerView *)datePicker didUpdateDate:(NSDate *)selectedDate andUserInfo:(id)userInfo
{
    [self setValue:selectedDate
            forKey:userInfo];
    [self p_refreshView];
}

-(CGFloat)datePickerPresenterViewHeight:(ELDatePickerView *)datePicker
{
    return CGRectGetHeight(APP_WINDOW.frame);
}

#pragma mark - Private Methods

-(void)p_showDatePickerContainer
{
    [self.datePickerView show];
    self.tapGestureRecognizer.enabled = NO;
    [self dismissKeyboard];
}

-(void)p_hideDatePickerContainer
{
    [self.datePickerView hide];
    self.tapGestureRecognizer.enabled = YES;
}

-(void)p_refreshView
{
    NSDate *startDate = self.temporaryStartDate;
    NSDate *endDate = self.temporaryEndDate;
    
    [self.startDateButton setTitle: [startDate localizedShortDateString]
                          forState:UIControlStateNormal];
    
    [self.endDateButton setTitle: [endDate localizedShortDateString]
                        forState:UIControlStateNormal];
    
    if ([startDate timeIntervalSinceDate:endDate] > 0) {
        [self.endDateButton setTitleColor:kInvalidDateColor
                                 forState:UIControlStateNormal];
        [self.startDateButton setTitleColor:kInvalidDateColor
                                   forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        [self.endDateButton setTitleColor:kTextBlackColor
                                 forState:UIControlStateNormal];
        [self.startDateButton setTitleColor:kTextBlackColor
                                   forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}

-(void)p_invokeDatePickerWithDate:(NSDate*)date andUserInfo:(id) userInfo
{
    self.datePickerView.initialDate = date;
    self.datePickerView.userInfo = userInfo;
    [self p_showDatePickerContainer];
}

-(void)p_showMergeDialogWithTitleString:(NSString*) title
                       mergeButtonTitle:(NSString*) mergeButtonTitle
                      goBackButtonTitle:(NSString*)goBackButtonTitle
                    continueButtonTitle:(NSString*)continueButtonTitle
                             MergeBlock:(void (^)(void)) mergeBlock
                            createBlock:(void (^)(void)) createBlock
                         andGoBackBlock:(void (^)(void)) goBackBlock
{
    _actionSheet = [[POActionSheet alloc] initWithTitle:title];
    _actionSheet.presentingView = self.navigationController;
    [_actionSheet addButtonWithTitle:continueButtonTitle
                           andAction:createBlock];
    [_actionSheet addDestructiveButtonWithTitle:mergeButtonTitle
                                      andAction:mergeBlock];
    [_actionSheet addCancelButtonWithTitle:goBackButtonTitle
                                 andAction:goBackBlock];
    [_actionSheet show];
    
}

- (void) showMergeTasksDialogWithMergeBlock:(void (^)(void)) mergeBlock
                            createTaskBlock:(void (^)(void)) createTaskBlock
                             andGoBackBlock:(void (^)(void)) goBackBlock
{
    [self p_showMergeDialogWithTitleString:NSLocalizedString(@"There are other tasks on the selected time range. What would you like to do?", @"")
                          mergeButtonTitle:NSLocalizedString(@"Merge the tasks", @"")
                         goBackButtonTitle:NSLocalizedString(@"Edit this task's details", @"")
                       continueButtonTitle:NSLocalizedString(@"Continue", @"")
                                MergeBlock:mergeBlock
                               createBlock:createTaskBlock
                            andGoBackBlock:goBackBlock];
}

- (void) showMergeBreaksDialogWithMergeBlock:(void (^)(void)) mergeBlock
                            createBreakBlock:(void (^)(void)) createBreakBlock
                              andGoBackBlock:(void (^)(void)) goBackBlock
{
    [self p_showMergeDialogWithTitleString:NSLocalizedString(@"There are other breaks on the selected time range. What would you like to do?", @"")
                          mergeButtonTitle:NSLocalizedString(@"Merge the breaks", @"")
                         goBackButtonTitle:NSLocalizedString(@"Edit this break's details", @"")
                       continueButtonTitle:NSLocalizedString(@"Continue", @"")
                                MergeBlock:mergeBlock
                               createBlock:createBreakBlock
                            andGoBackBlock:goBackBlock];
}

@end