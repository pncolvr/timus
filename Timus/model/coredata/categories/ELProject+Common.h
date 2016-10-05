//
//  ELProject+Common.h
//  Timus
//
//  Created by Pedro Oliveira on 4/9/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELProject.h"

@interface ELProject (Common)

#pragma mark - Methods

+ (ELProject*) createWithName:(NSString*)name
                       detail:(NSString*)detail
                        image:(UIImage*)image
                        tasks:(NSSet*) tasks
                 creationDate:(NSDate*)creationDate
                 failureBlock:(void (^)(void))failureBlock;

+ (NSUInteger) countExistingProjects;
+ (ELProject*) projectWithCreationDate:(NSDate*) date;
+ (ELProject*) firstProjectOrderedByName;
- (ELTask *) currentTask;
- (void) remove;
- (NSTimeInterval) totalWorkTimeInSeconds;
- (NSTimeInterval) totalProductiveTimeInSeconds;
- (NSTimeInterval) totalBreakTimeInSeconds;
- (BOOL) isEqualToProject:(ELProject*)object;

@end
