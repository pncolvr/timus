//
//  UITableViewController+ELTable.m
//  Timus
//
//  Created by Pedro Oliveira on 10/4/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "UITableViewController+ELTable.h"

@implementation UITableViewController (ELTable)

#pragma mark - Methods

- (void) applyTableUserInterfaceChanges
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIColor *tableBackgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = tableBackgroundColor;
    self.searchDisplayController.searchResultsTableView.backgroundColor = tableBackgroundColor;
    
    if ([self respondsToSelector:@selector(searchBar)]) {
        [[self valueForKey:@"searchBar"] setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    //remove search bar line
    self.searchDisplayController.searchBar.layer.borderWidth = 1;
    self.searchDisplayController.searchBar.layer.borderColor = [[UIColor whiteColor] CGColor];
    //hide search bar
    CGRect bounds = self.tableView.bounds;
    bounds.origin.y = self.tableView.bounds.origin.y + self.searchDisplayController.searchBar.bounds.size.height;
    self.tableView.bounds = bounds;
}

@end
