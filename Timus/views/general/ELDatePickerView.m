//
//  ELDatePickerView.m
//  Timus
//
//  Created by Emanuel Coelho on 06/07/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELDatePickerView.h"
#import "NSDate+Localization.h"

@interface ELDatePickerView ()

-(void)p_updateDatePickerModeToMode:(UIDatePickerMode)mode;
-(void)p_showDatePickerView:(BOOL)show;
-(void)p_datePickerDateUpdated;
-(void)p_moveDatePickerContainerFromRect:(CGRect)origin toRect:(CGRect)destination willBeVisible:(BOOL)visible;
-(void)p_updateSelectedTimeLabelWithDate:(NSDate*)date;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIToolbar *bottomToolbar;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *flexible;
@property (nonatomic, strong) UIBarButtonItem *divider;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *selectedTimeButton;

@property (nonatomic, strong) UIButton *background;
@property (nonatomic) CGRect originalFrame;
@end

@implementation ELDatePickerView

#pragma mark - View Lifecycle

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.originalFrame = frame;
        self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 44)];
        self.bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 260, CGRectGetWidth(frame), 44)];
        self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(didSelectCancelButton)];
        self.doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"")
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(didSelectDoneButton)];
        
        self.flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.selectedTimeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"", @"")
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 44)];
        label.backgroundColor = [UIColor darkGrayColor];
        
        self.divider = [[UIBarButtonItem alloc] initWithCustomView:label];
        
        NSArray *buttons = @[self.flexible,self.cancelButton, self.flexible, self.divider,self.flexible,self.doneButton,self.flexible];
        NSArray *views = @[self.flexible, self.selectedTimeButton, self.flexible];
        [self.toolbar setItems:views
                      animated:NO];
        [self.bottomToolbar setItems:buttons
                            animated:NO];
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(frame), 216)];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.backgroundColor = [UIColor whiteColor];
        [self.datePicker addTarget:self
                            action:@selector(p_datePickerDateUpdated)
                  forControlEvents:UIControlEventValueChanged];
        
        self.background = [UIButton buttonWithType:UIButtonTypeCustom];
        self.background.frame = APP_WINDOW.frame;
        
        [self.background addTarget:self
                            action:@selector(didSelectCancelButton)
                  forControlEvents:UIControlEventTouchUpInside];
        UIImage *backgroundImage =[UIImage imageNamed:@"datePickerBackgound"];
        
        self.background.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        [self addSubview:self.datePicker];
        [self addSubview:self.toolbar];
        [self addSubview:self.bottomToolbar];
        
    }
    return self;
}
#pragma mark - Object Lifecycle

- (void)show
{
    [self p_showDatePickerView:YES];
    NSDate *currentSelectedDate = self.datePicker.date;
    [self p_updateSelectedTimeLabelWithDate:currentSelectedDate];
}
- (void)hide
{
    [self p_showDatePickerView:NO];
}

#pragma mark - IBAction
- (IBAction)didSelectCancelButton
{
    if ([self.delegate respondsToSelector:@selector(datePicker:didCancelDateSelectionWithInitialDate:andUserInfo:)]) {
        [self.delegate datePicker:self
didCancelDateSelectionWithInitialDate:self.initialDate
                      andUserInfo:self.userInfo];
    }
}

- (IBAction)didSelectDoneButton
{
    if ([self.delegate respondsToSelector:@selector(datePicker:didSelectDate:andUserInfo:)]) {
        [self.delegate datePicker:self
                    didSelectDate:self.datePicker.date
                      andUserInfo:self.userInfo];
    }
}

#pragma mark - Private Methods

-(void)p_updateDatePickerModeToMode:(UIDatePickerMode)mode
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.datePicker.datePickerMode = mode;
                     }];
}

-(void)p_showDatePickerView:(BOOL)show{
    CGFloat viewHeight = [self.delegate datePickerPresenterViewHeight:self];
    
    CGFloat height = viewHeight;
    CGFloat datePickerHeight = CGRectGetHeight(self.datePicker.frame)+CGRectGetHeight(self.toolbar.frame)+CGRectGetHeight(self.bottomToolbar.frame);
    
    CGFloat datePickerWidth = CGRectGetWidth(self.datePicker.frame);
    
    CGRect origin;
    CGRect destination;
    
    if(show){
        origin = CGRectMake(0, height, datePickerWidth, datePickerHeight);
        destination = CGRectMake(0, height-datePickerHeight, datePickerWidth, datePickerHeight);
    }else{
        destination  = CGRectMake(0, height, datePickerWidth, datePickerHeight);
        origin = CGRectMake(0, height-datePickerHeight, datePickerWidth, datePickerHeight);
    }
    
    [self p_moveDatePickerContainerFromRect:origin toRect:destination willBeVisible:show];
}

-(void)p_moveDatePickerContainerFromRect:(CGRect)origin toRect:(CGRect)destination willBeVisible:(BOOL)visible
{
    self.frame = origin;
    if (visible) {
        [APP_WINDOW insertSubview:self.background
                     belowSubview:self];
    }
    
    self.background.frame = APP_WINDOW.frame;
    CGRect finalBackgroundFrame =  CGRectMake(CGRectGetMinX(APP_WINDOW.frame), CGRectGetMinY(APP_WINDOW.frame), CGRectGetWidth(APP_WINDOW.frame), CGRectGetHeight(APP_WINDOW.frame) - CGRectGetHeight(self.frame));
    self.background.alpha = visible ? 0.0f: 1.0f;
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = destination;
                         self.datePicker.date = self.initialDate;
                         self.background.alpha = visible ? 1.0f: 0.0f;
                         if (visible) {
                             self.background.frame = finalBackgroundFrame;
                         }
                     } completion:^(BOOL finished) {
                         if (finished) {
                             if (!visible) {
                                 [self.background removeFromSuperview];
                             }
                             
                         }
                     }];
}

-(void)p_datePickerDateUpdated
{
    NSDate *currentSelectedDate = self.datePicker.date;
    [self p_updateSelectedTimeLabelWithDate:currentSelectedDate];
    if ([self.delegate respondsToSelector:@selector(datePicker:didUpdateDate:andUserInfo:)]) {
        [self.delegate datePicker:self
                    didUpdateDate:currentSelectedDate
                      andUserInfo:self.userInfo];
    }
}

-(void)p_updateSelectedTimeLabelWithDate:(NSDate*)date
{
    [self.selectedTimeButton setTitle:[date localizedShortDateString]];
}

@end
