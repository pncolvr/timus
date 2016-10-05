//
//  ELTasksTableViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 4/16/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELCoreDataStack.h"
#import "ELInformationView.h"
#import "ELNewTaskViewController.h"
#import "ELProjectManager.h"
#import "ELTask+Common.h"
#import "ELTaskViewController.h"
#import "ELTasksTableViewController.h"
#import "POActionSheet.h"
#import "UITableViewController+ELTable.h"
#import "ELAddTaskViewController.h"
#import "ELTaskCell.h"
#import "NSString+TimeFormatting.h"
#import "ELProject+Common.h"
#import "UIColor+Utils.h"

#pragma mark - Constants

#define kDismissSegueIdentifier @"kDismissSegueIdentifier"
#define kNewIntervalSegueIdentifier @"kNewIntervalSegueIdentifier"
#define kNewTaskSegueIdentifier @"kNewTaskSegueIdentifier"
#define kSelectedTaskSegueIdentifier @"kSelectedTaskSegueIdentifier"
#define kTaskCellReuseIdentifier @"kTaskCellReuseIdentifier"
#define kAddTaskSegue @"kAddTaskSegue"

@interface ELTasksTableViewController ()

- (void) p_defaultProjectDidChange;
- (void) p_updateProject;
- (void) p_setupUserInterface;
- (void) p_setupFetchedResultsController;
- (void) p_updateUserInterface;
- (void) p_showEmptyView;
- (void) p_hideEmptyView;
- (void) p_updateTableForEditing:(BOOL) editing;
- (void) p_registerNotifications;
- (void) p_updateTimerLabel:(NSNotification *)note;
- (void) p_updateCellOfRunningTask:(ELTask*) task;

@property (nonatomic, strong) UIView *emptyView;

@end

@implementation ELTasksTableViewController {
    POActionSheet *_currentTaskActionSheet;
}

#pragma mark - View Lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self p_updateProject];
    [self p_registerNotifications];
    [self applyTableUserInterfaceChanges];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_updateUserInterface];
    [self p_updateCellOfRunningTask:[[ELProjectManager sharedProjectManager ] currentTask]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self p_setupFetchedResultsController];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ELTaskCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTaskCellReuseIdentifier
                                                            forIndexPath:indexPath];
    
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        ELTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
        ELTask *currentTask = [[ELProjectManager sharedProjectManager] currentTask];
        if ([task isEqual:currentTask]) {
            _currentTaskActionSheet = [[POActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete the running task?", @"")];
            [_currentTaskActionSheet addDestructiveButtonWithTitle:NSLocalizedString(@"Yes", @"")
                                                         andAction:^{
                                                             [[ELProjectManager sharedProjectManager] endCurrentTaskWithDetail:@""];
                                                             [task remove];
                                                         }];
            [_currentTaskActionSheet addButtonWithTitle:NSLocalizedString(@"No", @"")
                                              andAction:nil];
            [_currentTaskActionSheet setPresentingView:self];
            [_currentTaskActionSheet show];
        } else {
            [task remove];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - Private Methods

- (void) p_defaultProjectDidChange
{
    [self p_updateProject];
}

- (void) p_updateProject
{
    self.project = [[ELUserDefaults sharedUserDefaults] selectedProject];
    [self p_setupUserInterface];
    [self p_setupFetchedResultsController];
}

- (void) p_setupUserInterface
{
    self.navigationItem.title = self.project.name;
}

- (void) p_setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ELTask class])];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                              ascending:NO
                                                               selector:@selector(compare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"project = %@", self.project];
    NSManagedObjectContext *context = [[ELCoreDataStack sharedCoreDataStack] managedObjectContext];
    self.fetchedResultsController   = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    
}

- (void) p_showEmptyView
{
    [self p_hideEmptyView];
    self.emptyView = [[ELInformationView alloc] initWithFrame:self.view.frame
                                           andInformationText:NSLocalizedString(@"No tasks", @"")];
    [self.view.superview addSubview:self.emptyView];
    self.tableView.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem  = nil;
    self.navigationItem.leftBarButtonItem = self.backButton;
}

- (void) p_hideEmptyView
{
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
    self.tableView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem  = self.editButton;
}

- (void) p_updateTableForEditing:(BOOL) editing
{
    [self.navigationController setEditing:editing
                                 animated:YES];
    if (editing) {
        [self.editButton setTitle:NSLocalizedString(@"Done", @"")];
        [self.editButton setStyle:UIBarButtonItemStyleDone];
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        [self.editButton setTitle:NSLocalizedString(@"Edit", @"")];
        [self.editButton setStyle:UIBarButtonItemStyleBordered];
        self.navigationItem.leftBarButtonItem = self.backButton;
    }
}

#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kNewTaskSegueIdentifier]) {
        ELNewTaskViewController * newTaskVC = segue.destinationViewController;
        newTaskVC.project = self.project;
    }
    
    if ([segue.identifier isEqualToString:kSelectedTaskSegueIdentifier]) {
        ELTaskViewController *taskVC = segue.destinationViewController;
        NSIndexPath *indexPath;
        if (self.searchDisplayController.isActive) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
        }
        ELTask *selectedTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
        taskVC.task = selectedTask;
    }
    
    if ([segue.identifier isEqualToString:kAddTaskSegue]) {
        ELAddTaskViewController *addTaskViewController = [segue.destinationViewController viewControllers][0];
        addTaskViewController.parentProject = self.project;
    }
}

- (IBAction)unwindFromProjectsCollectionViewController:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NOT_IMPLEMENTED
}

- (IBAction)unwindFromNewTaskViewController:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NOT_IMPLEMENTED
}

- (IBAction)unwindFromNewTaskViewControllerCancelledCreateTask:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}

- (IBAction)unwindFromNewTaskViewControllerFinishedCreateTask:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}

- (void) p_updateUserInterface
{
    if ([self.fetchedResultsController.fetchedObjects count]) {
        [self p_hideEmptyView];
    } else {
        [self p_showEmptyView];
    }
}

#pragma mark - Actions

- (IBAction)didSelectCancelButton:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:kDismissSegueIdentifier
                              sender:self];
    
}

- (IBAction)didSelectEditButton:(UIBarButtonItem *)sender
{
    [self p_updateTableForEditing:!self.tableView.editing];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [super controllerDidChangeContent:controller];
    [self p_updateUserInterface];
}

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project = %@", self.project];
    
    if (searchText.length > 0) {
        predicate = [NSPredicate predicateWithFormat:@"project = %@ AND detail CONTAINS[cd] %@", self.project, searchText];
    }
    
    self.fetchedResultsController.fetchRequest.predicate = predicate;
    
    NSError *error;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    if (!success) {
        ELLogEmergency(@"error: %@", [error description]);
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self p_setupFetchedResultsController];
}

#pragma mark - Private Methods

-(void)p_registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_defaultProjectDidChange)
                                                 name:kDefaultProjectDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_updateTimerLabel:)
                                                 name:kCurrentProjectDidUpdateNotification
                                               object:nil];
}

- (void) p_updateTimerLabel:(NSNotification *)note
{
    ELProject *currentProject = [[ELProjectManager sharedProjectManager] currentProject];
    if ([currentProject isEqualToProject:self.project]) {
        ELTask *currentTask = [[ELProjectManager sharedProjectManager ] currentTask];
        [self p_updateCellOfRunningTask:currentTask];
    }
}

- (void) p_updateCellOfRunningTask:(ELTask *)task
{
    NSTimeInterval seconds = [task totalWorkTimeInSeconds];
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:task];
    ELTaskCell *cell = (ELTaskCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.taskTotalWorkTimer.text = [NSString timeIndicatorStringWithElapsedSeconds:seconds];
    //we need to always change all properties in case that the application is killed
    //and we need to restore the correct user interface state
    switch ([[ELProjectManager sharedProjectManager] statusOfProject:self.project]) {
        case ELProjectRunning:
            [cell.tasksDescription setFont:kRunningProjectFont];
            [cell.tasksDescription setTextColor:kProductiveTimeColor];
            [cell.taskTotalWorkTimer setTextColor:kProductiveTimeColor];
            [cell.numberOfBreaksLabel setTextColor:kProductiveTimeColor];
            break;
        case ELProjectOnBreak:
            [cell.tasksDescription setFont:kRunningProjectFont];
            [cell.tasksDescription setTextColor:kNonProductiveTimeColor];
            [cell.taskTotalWorkTimer setTextColor:kNonProductiveTimeColor];
            [cell.numberOfBreaksLabel setTextColor:kNonProductiveTimeColor];
            break;
        case ELProjectNotRunning:
        default:
            [cell.tasksDescription setFont:kNoRunningProjectFont];
            [cell.tasksDescription setTextColor:kNoCurrentWorkTimeColor];
            [cell.taskTotalWorkTimer setFont:kNoRunningProjectFont];
            [cell.numberOfBreaksLabel setTextColor:kNoCurrentWorkTimeColor];
            break;
    }
}

@end
