//
//  UIManagedDocument+Customization.m
//  Timus
//
//  Created by Pedro Oliveira on 6/5/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "UIManagedDocument+Customization.h"

@implementation UIManagedDocument (Customization)

#pragma mark - Methods

- (void) setupPersistentStoreOptions
{
    NSDictionary *options = @{ NSPersistentStoreUbiquitousContentNameKey: @"Store",
                               NSMigratePersistentStoresAutomaticallyOption: @YES,
                               NSInferMappingModelAutomaticallyOption:@YES};
    self.persistentStoreOptions = options;
}

@end
