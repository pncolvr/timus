//
//  ELCoreDataStack.h
//  Timus
//
//  Created by Pedro Oliveira on 4/8/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@interface ELCoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

#pragma mark - Methods

- (NSURL *)applicationDocumentsDirectory;
+ (ELCoreDataStack*) sharedCoreDataStack;
- (void) loadPersistedObjects;

@end
