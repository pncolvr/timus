//
//  ELDatePickerView.h
//  Timus
//
//  Created by Emanuel Coelho on 06/07/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import UIKit;

@protocol ELDatePickerDelegate;
@interface ELDatePickerView : UIView

#pragma mark - Properties

@property (nonatomic, strong) NSDate* initialDate;
@property (nonatomic, weak) NSObject<ELDatePickerDelegate> *delegate;
@property (nonatomic, strong) id userInfo;

#pragma mark - Methods

- (IBAction)didSelectCancelButton;
- (IBAction)didSelectDoneButton;
- (void)show;
- (void)hide;

@end


#pragma mark - ELDatePickerDelegateProtocol

@protocol ELDatePickerDelegate <NSObject>

-(void)datePicker:(ELDatePickerView*)datePicker didSelectDate:(NSDate*)selectedDate andUserInfo:(id)userInfo;
-(void)datePicker:(ELDatePickerView *)datePicker didCancelDateSelectionWithInitialDate:(NSDate*) date andUserInfo:(id)userInfo;
-(void)datePicker:(ELDatePickerView*)datePicker didUpdateDate:(NSDate*)selectedDate andUserInfo:(id)userInfo;
-(CGFloat)datePickerPresenterViewHeight:(ELDatePickerView*) datePicker;

@end