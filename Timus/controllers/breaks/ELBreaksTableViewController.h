//
//  ELBreaksTableViewController.h
//  Timus
//
//  Created by Pedro Oliveira on 9/15/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "CoreDataTableViewController.h"

@class ELTask;
@interface ELBreaksTableViewController : CoreDataTableViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) ELTask *task;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

- (IBAction)didSelectCancelButton:(UIBarButtonItem *)sender;
- (IBAction)didSelectEditButton:(UIBarButtonItem *)sender;

//Segues
- (IBAction)unwindFromNewTaskViewControllerCancelledCreateTask:(UIStoryboardSegue*)segue;
- (IBAction)unwindFromNewTaskViewControllerFinishedCreateTask:(UIStoryboardSegue*)segue;
@end
