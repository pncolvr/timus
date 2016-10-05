//
//  ELProject.h
//  Timus
//
//  Created by Pedro Oliveira on 7/12/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;
@import CoreData;

@class ELTask;

@interface ELProject : NSManagedObject

@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *tasks;
@property (nonatomic, retain) NSDate *modifiedDate;
@end

@interface ELProject (CoreDataGeneratedAccessors)

- (void)addTasksObject:(ELTask *)value;
- (void)removeTasksObject:(ELTask *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
