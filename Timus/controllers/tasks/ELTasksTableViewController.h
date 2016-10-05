//
//  ELTasksTableViewController.h
//  Timus
//
//  Created by Pedro Oliveira on 4/16/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "CoreDataTableViewController.h"

@class ELProject;
@interface ELTasksTableViewController : CoreDataTableViewController <UISearchBarDelegate>

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) ELProject *project;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

#pragma mark - Actions

- (IBAction)didSelectCancelButton:(UIBarButtonItem *)sender;
- (IBAction)didSelectEditButton:(UIBarButtonItem *)sender;

#pragma mark - Segues

- (IBAction)unwindFromProjectsCollectionViewController:(UIStoryboardSegue*)segue;
- (IBAction)unwindFromNewTaskViewController:(UIStoryboardSegue*)segue;
- (IBAction)unwindFromNewTaskViewControllerCancelledCreateTask:(UIStoryboardSegue*)segue;
- (IBAction)unwindFromNewTaskViewControllerFinishedCreateTask:(UIStoryboardSegue*)segue;

@end
