//
//  ELProjectsCollectionViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 4/18/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELCoreDataStack.h"
#import "ELInformationView.h"
#import "ELProject+Common.h"
#import "ELProjectCell.h"
#import "ELProjectManager.h"
#import "ELProjectsTableViewController.h"
#import "NSString+TimeFormatting.h"
#import "POActionSheet.h"
#import "UIColor+Utils.h"
#import "UITableViewController+ELTable.h"
#import "CargoBay.h"

#pragma mark - Constants

#define kProjectSelectedSegueIdentifier @"kProjectSelectedSegueIdentifier"
#define kProjectCellIdentifier @"kProjectCellIdentifier"
#define kNewProjectSegueIdentifier @"newProjectSegueIdentifier"

@interface ELProjectsTableViewController ()

@property (nonatomic, strong) UIView *emptyView;

- (void) p_formatTableViewStyles;
- (void) p_prepareFetchedResultsController;
- (void) p_updateDefaultProject;
- (void) p_updateDefaultProjectWithProject:(ELProject*)project;
- (void) p_updateTimerLabel:(NSNotification*)note;
- (void) p_registerNotifications;
- (void) p_updateUserInterface;
- (void) p_updateUserInterfaceFromStoreChange;
- (void) p_showEmptyView;
- (void) p_hideEmptyView;
- (void) p_reloadVisbleCells;
- (void) p_updateWorkColorInCell:(ELProjectCell*)cell andProject:(ELProject*) project;
- (void) p_updateExportButtonVisibility;

//In app validation
- (void) p_validateInAppPurchases;
- (void) p_activateExportButton:(BOOL)activate;
- (void) p_activateAddProjectButton:(BOOL)activate;

@property (nonatomic, assign, getter = isUpdatingTable) BOOL updatingTable;

@end

@implementation ELProjectsTableViewController {
    POActionSheet *_currentProjectActionSheet;
}

#pragma mark - View Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_updateUserInterface];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self applyTableUserInterfaceChanges];
    [self p_registerNotifications];
    [self p_prepareFetchedResultsController];
    [self p_updateDefaultProject];
    [self p_formatTableViewStyles];
    [self p_validateInAppPurchases];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self p_prepareFetchedResultsController];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

-(void) p_formatTableViewStyles
{
    UIColor *tableBackgroundColor = [UIColor whiteColor];
    self.searchDisplayController.searchResultsTableView.backgroundColor = tableBackgroundColor;
    [self.searchDisplayController.searchResultsTableView setRowHeight:102.0f];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void) p_prepareFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ELProject class])];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modifiedDate"
                                                              ascending:NO
                                                               selector:@selector(compare:)]];
    request.predicate = nil; // all projects
    NSManagedObjectContext *context = [[ELCoreDataStack sharedCoreDataStack] managedObjectContext];
    self.fetchedResultsController   = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
}

- (void) p_updateDefaultProject
{
    ELProject *p = [[ELUserDefaults sharedUserDefaults] selectedProject];
    if (p) {
        [self performSegueWithIdentifier:kProjectSelectedSegueIdentifier
                                  sender:self];
        
    }
}

- (void) p_updateDefaultProjectWithProject:(ELProject*)project
{
    [[ELUserDefaults sharedUserDefaults] setSelectedProject:project];
}


- (void) p_updateTimerLabel:(NSNotification*)note
{
    ELProject *project = [note object];
    NSTimeInterval seconds = [project totalWorkTimeInSeconds];
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:project];
    ELProjectCell *cell = (ELProjectCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [self p_updateWorkColorInCell:cell andProject:project];
    [self p_updateExportButtonVisibility];
    
    cell.projectWorkTimeLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:seconds];
    
}

- (void) p_registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_updateTimerLabel:)
                                                 name:kCurrentProjectDidUpdateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_updateUserInterfaceFromStoreChange)
                                                 name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                               object:nil];
}

- (void) p_updateUserInterface
{
    if ([self.fetchedResultsController.fetchedObjects count]) {
        [self p_hideEmptyView];
        [self p_reloadVisbleCells];
    } else {
        [self p_showEmptyView];
    }
    [self p_updateExportButtonVisibility];
}

- (void) p_showEmptyView
{
    [self p_hideEmptyView];
    self.emptyView = [[ELInformationView alloc] initWithFrame:self.view.frame
                                           andInformationText:NSLocalizedString(@"No projects", @"")];
    [self.view.superview addSubview:self.emptyView];
    self.tableView.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void) p_hideEmptyView
{
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
    self.tableView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = self.editButton;
}

- (void) p_reloadVisbleCells
{
    NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
    [self.tableView reloadRowsAtIndexPaths:visibleRows
                          withRowAnimation:UITableViewRowAnimationNone];
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
    }
}

- (void) p_updateWorkColorInCell:(ELProjectCell*)cell andProject:(ELProject*) project
{
    //we need to always change all properties in case that the application is killed
    //and we need to restore the correct user interface state
    switch ([[ELProjectManager sharedProjectManager] statusOfProject:project]) {
        case ELProjectRunning:
            [cell.projectWorkTimeLabel setTextColor:kProductiveTimeColor];
            [cell.projectNameLabel setFont:kRunningProjectFont];
            [cell.projectNameLabel setTextColor:kProductiveTimeColor];
            [cell.numberOfTasksLabel setTextColor:kProductiveTimeColor];
            break;
        case ELProjectOnBreak:
            [cell.projectWorkTimeLabel setTextColor:kNonProductiveTimeColor];
            [cell.projectNameLabel setFont:kRunningProjectFont];
            [cell.projectNameLabel setTextColor:kNonProductiveTimeColor];
            [cell.numberOfTasksLabel setTextColor:kNonProductiveTimeColor];
            break;
        case ELProjectNotRunning:
        default:
            [cell.projectWorkTimeLabel setTextColor:kNoCurrentWorkTimeColor];
            [cell.projectNameLabel setFont:kNoRunningProjectFont];
            [cell.projectNameLabel setTextColor:kNoCurrentWorkTimeColor];
            [cell.numberOfTasksLabel setTextColor:kNoCurrentWorkTimeColor];
            break;
    }
}

- (void) p_updateUserInterfaceFromStoreChange
{
    if (!self.isUpdatingTable) {
        self.updatingTable = YES;
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self p_prepareFetchedResultsController];
            [self p_updateUserInterface];
            self.updatingTable = NO;
        });
    }
}

- (void) p_updateExportButtonVisibility
{
    for (ELProject *project in self.fetchedResultsController.fetchedObjects) {
        if ([project totalWorkTimeInSeconds]) {
            [self.exportButton setStyle:UIBarButtonItemStyleBordered];
            [self.exportButton setTitle:NSLocalizedString(@"Export", @"")];
            [self.exportButton setTitle:@""];
            [self.exportButton setEnabled:YES];
            
            [self.exportButton setEnabled:NO];
            
            return;
        }
    }
    [self.exportButton setStyle:UIBarButtonItemStylePlain];
    [self.exportButton setTitle:@""];
    [self.exportButton setEnabled:NO];
}

-(void) p_validateInAppPurchases{
    NSArray *identifiers = kInAppIdentifiers;
    [[CargoBay sharedManager] productsWithIdentifiers:[NSSet setWithArray:identifiers]
                                              success:^(NSArray *products, NSArray *invalidIdentifiers) {
                                                  NSLog(@"Products: %@", products);
                                                  
                                                  
                                                  NSLog(@"Invalid Identifiers: %@", invalidIdentifiers);
                                              } failure:^(NSError *error) {
                                                  NSLog(@"Error: %@", error);
                                              }];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELProject *project  = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ELProjectCell *cell =     [self.tableView dequeueReusableCellWithIdentifier:kProjectCellIdentifier
                                                                   forIndexPath:indexPath];
    
    UIImage *projectImage = project.image;
    cell.projectImageView.image = projectImage;
    
    cell.projectNameLabel.text  = project.name;
    
    NSTimeInterval seconds = [project totalWorkTimeInSeconds];
    cell.projectWorkTimeLabel.text = [NSString timeIndicatorStringWithElapsedSeconds:seconds];
    
    NSUInteger numberOfTasks = [project.tasks count];
    
    [self p_updateWorkColorInCell:cell andProject:project];
    
    if(!numberOfTasks){
        cell.numberOfTasksLabel.text = NSLocalizedString(@"0 tasks",@"");
        [cell.numberOfTasksLabel setTextColor: kZeroTasksColor];
    }else if(numberOfTasks==1){
        cell.numberOfTasksLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"%lu task",@""), (unsigned long)numberOfTasks];
    }else{
        cell.numberOfTasksLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"%lu tasks",@""),(unsigned long)numberOfTasks];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        ELProject *project = [self.fetchedResultsController objectAtIndexPath:indexPath];
        ELProject *currentProject = [[ELProjectManager sharedProjectManager] currentProject];
        if ([project isEqualToProject:currentProject]) {
            _currentProjectActionSheet = [[POActionSheet alloc] initWithTitle:NSLocalizedString(@"This project has a running task. Are you sure you want to delete it?", @"")];
            [_currentProjectActionSheet addDestructiveButtonWithTitle:NSLocalizedString(@"Yes", @"")
                                                            andAction:^{
                                                                [[ELProjectManager sharedProjectManager] endCurrentTaskWithDetail:@""];
                                                                [project remove];
                                                            }];
            [_currentProjectActionSheet addButtonWithTitle:NSLocalizedString(@"No", @"")
                                                 andAction:nil];
            [_currentProjectActionSheet setPresentingView:self];
            [_currentProjectActionSheet show];
        } else {
            [project remove];
        }
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELProject *project = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self p_updateDefaultProjectWithProject:project];
}

#pragma mark - Segues

- (IBAction) unwindFromNewProjectViewController:(UIStoryboardSegue*) segue
{
    LOG_METHOD_NAME
}

- (IBAction) unwindFromExportTasksViewControllerWithBack:(UIStoryboardSegue*) segue
{
    LOG_METHOD_NAME
}

#pragma mark - IBActions

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
    NSPredicate *predicate = nil;
    
    if (searchText.length > 0) {
        predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
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
    [self p_prepareFetchedResultsController];
}

-(void) p_activateAddProjectButton:(BOOL)activate
{
    
}

-(void) p_activateExportButton:(BOOL)activate
{
    
}
@end
