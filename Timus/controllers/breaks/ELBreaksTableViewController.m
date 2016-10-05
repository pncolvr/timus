//
//  ELBreaksTableViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 9/15/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELBreak+Common.h"
#import "ELBreakViewController.h"
#import "ELBreaksTableViewController.h"
#import "ELCoreDataStack.h"
#import "ELInformationView.h"
#import "ELProjectManager.h"
#import "ELTask+Common.h"
#import "POActionSheet.h"
#import "UITableViewController+ELTable.h"
#import "ELAddBreakViewController.h"
#import "ELProject+Common.h"
#import "UIColor+Utils.h"
#import "ELBreak+Common.h"
#import "NSString+TimeFormatting.h"
#import "ELBreakCell.h"

#define kBreakCellReuseIdentifier @"kBreakCellReuseIdentifier"
#define kDidSelectBreakSegueIdentifier @"kDidSelectBreakSegueIdentifier"
#define kDismissSegueIdentifier @"kDismissSegueIdentifier"
#define kAddBreakSegue @"kAddBreakSegue"

@interface ELBreaksTableViewController ()

- (void) p_setupUserInterface;
- (void) p_setupFetchedResultsController;
- (void) p_updateUserInterface;
- (void) p_showEmptyView;
- (void) p_hideEmptyView;
- (void) p_updateTableForEditing:(BOOL) editing;
- (void) p_registerNotifications;
- (void) p_updateTimerLabel:(NSNotification *)note;
- (void) p_updateCellOfRunningBreak:(ELBreak *)interval;

@property (nonatomic, strong) UIView *emptyView;

@end

@implementation ELBreaksTableViewController {
    POActionSheet *_currentBreakActionSheet;
}

#pragma mark - View Lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self p_registerNotifications];
    [self applyTableUserInterfaceChanges];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_setupFetchedResultsController];
    [self p_updateUserInterface];
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
    ELBreakCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kBreakCellReuseIdentifier];
    
    ELBreak *interval = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSTimeInterval breakDuration = [interval breakDuration];
    
    cell.breakDescritpionLabel.text = [interval displayDetail];
    cell.breakTimeLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:breakDuration];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        ELBreak *interval = [self.fetchedResultsController objectAtIndexPath:indexPath];
        ELBreak *currentBreak = [[ELProjectManager sharedProjectManager] currentBreak];
        if ([interval isEqual:currentBreak]) {
            _currentBreakActionSheet = [[POActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete the current break?", @"")];
            [_currentBreakActionSheet addDestructiveButtonWithTitle:NSLocalizedString(@"Yes", @"")
                                                          andAction:^{
                                                              [[ELProjectManager sharedProjectManager] endCurrentBreakWithDetail:@""];
                                                              [interval remove];
                                                          }];
            [_currentBreakActionSheet addButtonWithTitle:NSLocalizedString(@"No", @"")
                                                 andAction:nil];
            [_currentBreakActionSheet setPresentingView:self];
            [_currentBreakActionSheet show];
        } else {
            [interval remove];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - Private Methods

- (void) p_setupUserInterface
{
    self.navigationItem.title = [self.task displayDetail];
}

- (void) p_registerNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_updateTimerLabel:)
                                                 name:kCurrentProjectDidUpdateNotification
                                               object:nil];
}

- (void) p_updateTimerLabel:(NSNotification *)note
{
    ELTask *currentTask = [[ELProjectManager sharedProjectManager] currentTask];
    if ([currentTask isEqual:self.task]) {
        ELBreak *currentBreak = [[ELProjectManager sharedProjectManager ] currentBreak];
        [self p_updateCellOfRunningBreak:currentBreak];
    }
}

- (void) p_updateCellOfRunningBreak:(ELBreak *)interval
{
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:interval];
    ELBreakCell *cell = (ELBreakCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    //we need to always change all properties in case that the application is killed
    //and we need to restore the correct user interface state
    switch ([[ELProjectManager sharedProjectManager] statusOfProject:self.task.project]) {
        case ELProjectOnBreak:
            [cell.breakDescritpionLabel setFont:kRunningProjectFont];
            [cell.breakDescritpionLabel setTextColor:kNonProductiveTimeColor];
            [cell.breakTimeLabel setTextColor:kNonProductiveTimeColor];
            break;
        //a break is never productive time so it makes no sense to have it change to productive colors
        case ELProjectRunning:
        case ELProjectNotRunning:
        default:
            [cell.breakDescritpionLabel setFont:kNoRunningProjectFont];
            [cell.breakDescritpionLabel setTextColor:kNoCurrentWorkTimeColor];
            [cell.breakTimeLabel setTextColor:kNoCurrentWorkTimeColor];
            break;
    }
}

- (void) p_setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ELBreak class])];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                              ascending:NO
                                                               selector:@selector(compare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"task = %@", self.task];
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
                                           andInformationText:NSLocalizedString(@"No breaks", @"")];
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

- (void) p_updateUserInterface
{
    self.navigationItem.title = [self.task displayDetail];
    if ([self.fetchedResultsController.fetchedObjects count]) {
        [self p_hideEmptyView];
    } else {
        [self p_showEmptyView];
    }
}

#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kDidSelectBreakSegueIdentifier]) {
        ELBreakViewController *breakViewController = segue.destinationViewController;
        NSIndexPath *indexPath;
        if (self.searchDisplayController.isActive) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
        }
        ELBreak *selectedBreak = [self.fetchedResultsController objectAtIndexPath:indexPath];
        breakViewController.interval = selectedBreak;
    }
    
    if ([segue.identifier isEqualToString:kAddBreakSegue]) {
        ELAddBreakViewController *addBreakViewController = [segue.destinationViewController viewControllers][0];
        addBreakViewController.parentTask = self.task;
    }
}

- (IBAction)unwindFromNewTaskViewControllerCancelledCreateTask:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}

- (IBAction)unwindFromNewTaskViewControllerFinishedCreateTask:(UIStoryboardSegue*)segue
{
    LOG_METHOD_NAME
}

#pragma mark - IBActions

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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"task = %@", self.task];
    
    if (searchText.length > 0) {
        predicate = [NSPredicate predicateWithFormat:@"task = %@ AND detail CONTAINS[cd] %@", self.task, searchText];
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
@end
