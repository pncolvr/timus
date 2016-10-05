//
//  ELNewProjectViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 4/14/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELNewProjectViewController.h"
#import "ELCircleButton.h"
#import "ELCoreDataStack.h"
#import "ELProject+Common.h"
#import "RPFloatingPlaceholderTextField.h"
#import "RPFloatingPlaceholderTextView.h"

#pragma mark - Constants

#define kProjectCreated @"kProjectCreated"

@implementation ELNewProjectViewController

#pragma mark - Actions

- (IBAction)didSelectDoneButton:(UIBarButtonItem *)sender
{
    NSManagedObjectContext *context = [[ELCoreDataStack sharedCoreDataStack] managedObjectContext];
    [context performBlock:^{
        [ELProject createWithName:self.projectNameTextField.text
                           detail:self.projectDetailsTextView.text
                            image:self.projectImageButton.imageView.image
                            tasks:nil
                     creationDate:[NSDate date]
                     failureBlock:^{
                         ELLogEmergency(@"Failed to create project %@", self.projectNameTextField.text);
                     }];
    }];
    
    [self performSegueWithIdentifier:kProjectCreated
                              sender:sender];
}

@end
