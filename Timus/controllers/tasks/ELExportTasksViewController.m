//
//  ELExportTasksViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 9/27/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELCoreDataStack.h"
#import "ELDatePickerView.h"
#import "ELExportTasksViewController.h"
#import "ELProject.h"
#import "ELTask+Common.h"
#import "NSDate+Common.h"
#import "NSDate+Localization.h"
#import "NSDictionary+Tasks.h"
#import "UITableViewController+ELTable.h"
#import "UIViewController+Common.h"
#import "ELTaskCell.h"
#import "POAlertView.h"
#import "POActionSheet.h"
#import "NSString+TimeFormatting.h"
#import "UIColor+Utils.h"
#import "ELTaskViewController.h"

#pragma mark - Constants

#define kAnimationDelay 0.0
#define kAnimationDuration 0.25
#define kExportCell @"kExportCell"
#define kNavigationBarTallerHeight 88
#define kMinimumSectionsToShow 7
#define kSelectTaskSegueIdentifier @"kSelectTaskSegueIdentifier"
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#pragma mark - Enums

typedef NS_ENUM(NSInteger, ELExportFilter)
{
    ELExportFilterAll      = 0,
    ELExportFilterLastWeek = 1,
    ELExportFilterCustom   = 2
};

@interface ELExportTasksViewController ()

- (void) p_setupFetchedResultsControllerWithStartDate:(NSDate*) startDate
                                           andEndDate:(NSDate*)endDate;
- (void) p_filterAllTasks;
- (void) p_filterLastWeekTasks;
- (void) p_filterCustomTasks;
- (void) p_animateNavigationBarFrameToFrame:(CGRect) frame andShowTimeButtons:(BOOL) showTimeButtons;

- (void) p_didSelectStartDateButton;
- (void) p_didSelectEndDateButton;

- (void) p_invokeDatePickerWithDate:(NSDate*)date andUserInfo:(id) userInfo;
- (void) p_showDatePickerContainer;

- (void) p_addTimeButtons;
- (void) p_removeTimeButtons;
- (void) p_setupView;
- (void) p_resizeTableViewToUpperFrame:(CGRect) upperFrame;

@property (nonatomic, strong) POAlertView *mailAlertView;

@property (nonatomic, assign) CGRect originalNavBarFrame;
@property (nonatomic, assign) CGRect tallerNavBarFrame;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *endButton;
@property (nonatomic, strong) NSDate *customStartDate;
@property (nonatomic, strong) NSDate *customEndDate;

@property (nonatomic, strong) ELDatePickerView *datePickerView;
@property (nonatomic, strong) POActionSheet *exportMethodActionSheet;
@property (nonatomic, strong) NSMutableArray *unselectedTasks;

@property (nonatomic, getter = isDisappearing) BOOL disappearing;

@end

@implementation ELExportTasksViewController
@synthesize datePickerView;

#pragma mark - View Lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self p_setupView];
    [self p_filterLastWeekTasks];
    [self applyTableUserInterfaceChanges];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.disappearing = NO;
    if ([self.exportFilterSegmentedControl selectedSegmentIndex] == ELExportFilterCustom) {
        [self p_filterCustomTasks];
    }
    self.datePickerView = [[ELDatePickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(APP_WINDOW.frame), 320, 304)];
    self.datePickerView.delegate = self;
    [APP_WINDOW addSubview:self.datePickerView];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if ([self.exportFilterSegmentedControl selectedSegmentIndex] == ELExportFilterCustom && !self.isDisappearing) {
        self.navigationController.navigationBar.frame = self.tallerNavBarFrame;
        [self p_resizeTableViewToUpperFrame:self.tallerNavBarFrame];
    } else {
        self.navigationController.navigationBar.frame = self.originalNavBarFrame;
        [self p_resizeTableViewToUpperFrame:self.originalNavBarFrame];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.disappearing = YES;
    [self p_removeTimeButtons];
}
#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELTaskCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kExportCell];
    ELTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSTimeInterval seconds = [task totalWorkTimeInSeconds];
    
    cell.tasksDescription.text = [task displayDetail];
    cell.taskTotalWorkTimer.text = [NSString timeIndicatorStringWithElapsedSeconds:seconds];
    
    NSUInteger numberOfBreaks = [[task intervals] count];
    
    if(!numberOfBreaks){
        cell.numberOfBreaksLabel.text = NSLocalizedString(@"0 breaks",@"");
        cell.numberOfBreaksLabel.textColor = kZeroTasksColor;
    }else if(numberOfBreaks==1){
        cell.numberOfBreaksLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"%lu break",@""), (unsigned long)numberOfBreaks];
    }else{
        cell.numberOfBreaksLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"%lu breaks",@""), (unsigned long)numberOfBreaks];
    }
    UIImage *image = [self.unselectedTasks containsObject:task] == NO ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //START Apple suggested hack for custom accessory views
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image
                      forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(p_checkButtonTapped:event:)
     forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    button.opaque = YES;
    //END Apple suggested hack for custom accessory views
    cell.accessoryView = button;
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ELTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([self.unselectedTasks containsObject:task]) { //task to be selected
        [self.unselectedTasks removeObject:task];
    } else { //task to be selected
        [self.unselectedTasks addObject:task];
    }
    //reload only the affected cell
    [tableView reloadRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *sections = [super sectionIndexTitlesForTableView:tableView];
    if ([sections count] >= kMinimumSectionsToShow) {
        return sections;
    }
    return nil;
}

#pragma mark - Private Methods

- (void) p_setupFetchedResultsControllerWithStartDate:(NSDate*) startDate
                                           andEndDate:(NSDate*) endDate
{
    BOOL filterByProject = self.project != nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ELTask class])];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"project.name"
                                                              ascending:NO
                                                               selector:@selector(compare:)],
                                [NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                              ascending:NO
                                                               selector:@selector(compare:)]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creationDate >= %@ && (endDate == NULL || endDate <= %@)", startDate, endDate];
    if (filterByProject) {
        NSPredicate *projectPredicate =[NSPredicate predicateWithFormat:@"project = %@", self.project];
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, projectPredicate]];
        
    }
    request.predicate = predicate;
    NSManagedObjectContext *context = [[ELCoreDataStack sharedCoreDataStack] managedObjectContext];
    self.fetchedResultsController   = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:context
                                                                            sectionNameKeyPath:filterByProject ? nil : @"project.name"
                                                                                     cacheName:nil];
    
}

- (void) p_filterAllTasks
{
    [self p_animateNavigationBarFrameToFrame:self.originalNavBarFrame andShowTimeButtons:NO];
    [self p_setupFetchedResultsControllerWithStartDate:[NSDate distantPast]
                                            andEndDate:[NSDate distantFuture]];
    [self.exportFilterSegmentedControl setSelectedSegmentIndex:ELExportFilterAll];
}

- (void) p_filterLastWeekTasks
{
    [self p_animateNavigationBarFrameToFrame:self.originalNavBarFrame andShowTimeButtons:NO];
    [self p_setupFetchedResultsControllerWithStartDate:[NSDate lastWeekStartDate]
                                            andEndDate:[NSDate currentWeekStartDate]];
    [self.exportFilterSegmentedControl setSelectedSegmentIndex:ELExportFilterLastWeek];
}

- (void) p_filterCustomTasks
{
    [self p_animateNavigationBarFrameToFrame:self.tallerNavBarFrame andShowTimeButtons:YES];
    [self.exportFilterSegmentedControl setSelectedSegmentIndex:ELExportFilterCustom];
    [self p_setupFetchedResultsControllerWithStartDate:self.customStartDate
                                            andEndDate:self.customEndDate];
    
}

- (void) p_animateNavigationBarFrameToFrame:(CGRect) frame andShowTimeButtons:(BOOL) showTimeButtons
{
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.navigationController.navigationBar.frame = frame;
                         [self p_resizeTableViewToUpperFrame:frame];
                         if (showTimeButtons) {
                             [self p_addTimeButtons];
                         } else {
                             [self p_removeTimeButtons];
                         }
                     } completion:NULL];
}

- (void) p_didSelectStartDateButton
{
    [self p_invokeDatePickerWithDate:self.customStartDate
                         andUserInfo:@"customStartDate"];
}

- (void) p_didSelectEndDateButton
{
    [self p_invokeDatePickerWithDate:self.customEndDate
                         andUserInfo:@"customEndDate"];
}

-(void)p_invokeDatePickerWithDate:(NSDate*)date andUserInfo:(id) userInfo
{
    self.datePickerView.initialDate = date;
    self.datePickerView.userInfo = userInfo;
    [self p_showDatePickerContainer];
}
-(void)p_showDatePickerContainer
{
    [self.datePickerView show];
}

-(void)p_hideDatePickerContainer
{
    [self.datePickerView hide];
}

-(void)p_refreshView
{
    [self.startButton setTitle: [self.customStartDate localizedShortDateString]
                      forState:UIControlStateNormal];
    
    [self.endButton setTitle: [self.customEndDate localizedShortDateString]
                    forState:UIControlStateNormal];
    if ([self.customStartDate timeIntervalSinceDate:self.customEndDate] > 0) {
        [self.endButton setTitleColor:kInvalidDateColor
                             forState:UIControlStateNormal];
        [self.startButton setTitleColor:kInvalidDateColor
                               forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        [self.endButton setTitleColor:kValidDateColor
                             forState:UIControlStateNormal];
        [self.startButton setTitleColor:kValidDateColor
                               forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    [self p_filterCustomTasks];
    
}

- (void) p_addTimeButtons
{
    UIView *navBarView = self.navigationController.navigationBar;
    CGFloat buttonYPositon = CGRectGetHeight(navBarView.frame)-50;
    self.startButton.frame = CGRectMake(10, buttonYPositon, 136, 44);
    self.endButton.frame = CGRectMake(174, buttonYPositon, 136, 44);
    [navBarView addSubview:self.startButton];
    [navBarView addSubview:self.endButton];
}

- (void) p_removeTimeButtons
{
    [self.startButton removeFromSuperview];
    [self.endButton removeFromSuperview];
}

//START Apple suggested hack for custom accessory views
- (void)p_checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath){
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}
//END Apple suggested hack for custom accessory views

- (void)p_setupView
{
    self.originalNavBarFrame = self.navigationController.navigationBar.frame;
    
    self.tallerNavBarFrame   = CGRectMake(CGRectGetMinX(self.originalNavBarFrame), CGRectGetMinY(self.originalNavBarFrame), CGRectGetMaxX(self.originalNavBarFrame), kNavigationBarTallerHeight);
    self.customStartDate = [NSDate lastWeekStartDate];
    self.customEndDate = [NSDate currentWeekStartDate];
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.endButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.startButton setTintColor:[UIColor blackColor]];
    [self.endButton setTintColor:[UIColor blackColor]];
    
    [self.startButton setTitle:[self.customStartDate localizedShortDateString]
                      forState:UIControlStateNormal];
    [self.endButton setTitle:[self.customEndDate localizedShortDateString]
                    forState:UIControlStateNormal];
    
    [self.startButton addTarget:self
                         action:@selector(p_didSelectStartDateButton)
               forControlEvents:UIControlEventTouchUpInside];
    [self.endButton addTarget:self
                       action:@selector(p_didSelectEndDateButton)
             forControlEvents:UIControlEventTouchUpInside];
    
    self.unselectedTasks = [[NSMutableArray alloc] init];
}

- (void)p_resizeTableViewToUpperFrame:(CGRect) upperFrame
{
    CGFloat bottomInset = CGRectGetHeight(self.navigationController.toolbar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(upperFrame)+kStatusBarHeight, 0, bottomInset, 0);
}

#pragma mark - Actions

- (IBAction)didChangeExportFilterValue:(UISegmentedControl *)sender
{
    ELExportFilter selectedIndex = [sender selectedSegmentIndex];
    switch (selectedIndex) {
        case ELExportFilterAll:{
            [self p_filterAllTasks];
        }
            break;
        case ELExportFilterLastWeek:{
            [self p_filterLastWeekTasks];
        }
            break;
        case ELExportFilterCustom:{
            [self p_filterCustomTasks];
        }
            break;
    }
}

- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender
{
    NSString *mailSubject = self.project ? [NSString stringWithFormat:NSLocalizedString(@"%@ report", nil), self.project.name] : NSLocalizedString(@"Report", @"");
    NSMutableDictionary *tasksPerProject = [[NSMutableDictionary alloc] init];
    NSMutableArray *selectedTasks = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    [selectedTasks removeObjectsInArray:self.unselectedTasks];
    
    if (self.project) {
        tasksPerProject[self.project.name] = selectedTasks;
    } else {
        NSArray *sections = [self.fetchedResultsController sections];
        NSArray *allTasks = selectedTasks;
        for (id section in sections) {
            NSString *projectName = [section name];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project.name = %@", projectName];
            NSArray *tasks = [allTasks filteredArrayUsingPredicate:predicate];
            // only export sections (projects) with cells (tasks)
            if ([tasks count]) {
                tasksPerProject[projectName] = tasks;
            }
        }
    }
    
    self.exportMethodActionSheet = [[POActionSheet alloc] initWithTitle:NSLocalizedString(@"How do you want to export?", @"")];
    self.exportMethodActionSheet.presentingView = self;
    __block ELExportTasksViewController *weakSelf = self;
    [self.exportMethodActionSheet addButtonWithTitle:NSLocalizedString(@"Mail", @"")
                                           andAction:^{
                                               [weakSelf presentMailWithSubject:mailSubject
                                                               attachmentString:nil
                                                                        andBody:[tasksPerProject html]];
                                           }];
    [self.exportMethodActionSheet addButtonWithTitle:NSLocalizedString(@"CSV", @"")
                                           andAction:^{
                                               [weakSelf presentMailWithSubject:mailSubject
                                                               attachmentString:[tasksPerProject csv]
                                                                        andBody:NSLocalizedString(@"Generated by <a href=\"http://www.timusapp.com\">Timus</>", @"")];
                                           }];
    [self.exportMethodActionSheet addCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"")
                                                 andAction:NULL];
    [self.exportMethodActionSheet show];
    
}

- (IBAction)didSelectSelectAllTasks:(UIBarButtonItem *)sender
{
    [self.unselectedTasks removeAllObjects];
    [self.tableView reloadData];
}

- (IBAction)didSelectUnSelectAllTasks:(UIBarButtonItem *)sender
{
    self.unselectedTasks = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - ELDatePickerDelegate

-(void)datePicker:(ELDatePickerView *)datePicker didSelectDate:(NSDate *)selectedDate andUserInfo:(id)userInfo
{
    [self p_hideDatePickerContainer];
    [self setValue:selectedDate forKey:userInfo];
    [self p_refreshView];
}

-(void)datePicker:(ELDatePickerView *)datePicker didCancelDateSelectionWithInitialDate:(NSDate *)date andUserInfo:(id)userInfo
{
    [self setValue:date forKey:userInfo];
    [self p_refreshView];
    [self p_hideDatePickerContainer];
}

-(void)datePicker:(ELDatePickerView *)datePicker didUpdateDate:(NSDate *)selectedDate andUserInfo:(id)userInfo
{
    [self setValue:selectedDate forKey:userInfo];
    [self p_refreshView];
}

-(CGFloat)datePickerPresenterViewHeight:(ELDatePickerView *)datePicker
{
    return CGRectGetHeight(APP_WINDOW.frame);
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSelectTaskSegueIdentifier]) {
        ELTaskViewController *taskVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ELTask *selectedTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
        taskVC.task = selectedTask;
    }
}

@end
