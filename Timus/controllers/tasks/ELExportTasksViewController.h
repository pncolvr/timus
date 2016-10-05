//
//  ELExportTasksViewController.h
//  Timus
//
//  Created by Pedro Oliveira on 9/27/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "CoreDataTableViewController.h"

@class ELProject;
@interface ELExportTasksViewController : CoreDataTableViewController <ELDatePickerDelegate>

#pragma mark - Properties

@property (strong, nonatomic) ELProject *project;
@property (weak, nonatomic) IBOutlet UISegmentedControl *exportFilterSegmentedControl;

#pragma mark - Actions

- (IBAction)didChangeExportFilterValue:(UISegmentedControl *)sender;
- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender;
- (IBAction)didSelectSelectAllTasks:(UIBarButtonItem *)sender;
- (IBAction)didSelectUnSelectAllTasks:(UIBarButtonItem *)sender;

@end
