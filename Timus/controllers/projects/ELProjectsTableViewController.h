//
//  ELProjectsCollectionViewController.h
//  Timus
//
//  Created by Pedro Oliveira on 4/18/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface ELProjectsTableViewController : CoreDataTableViewController

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *exportButton;

#pragma mark - Actions

- (IBAction) unwindFromNewProjectViewController:(UIStoryboardSegue*) segue;
- (IBAction) unwindFromExportTasksViewControllerWithBack:(UIStoryboardSegue*) segue;
- (IBAction) didSelectEditButton:(UIBarButtonItem *)sender;

@end
