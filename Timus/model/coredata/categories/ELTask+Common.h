//
//  ELTask+Common.h
//  Timus
//
//  Created by Pedro Oliveira on 4/10/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELIntervalRepresentationObject.h"
#import "ELTask.h"

@interface ELTask (Common) <ELIntervalRepresentationObject>

#pragma mark - Methods

+ (ELTask*) createWithTitle:(NSString*) title
                     detail:(NSString*)detail
                      image:(UIImage*) image
               creationDate:(NSDate*) creationDate
                    project:(ELProject*)project
               failureBlock:(void (^)(void))failureBlock;

+ (ELTask*)taskWithCreationDate:(NSDate*) date;
+ (NSUInteger) countExistingTasks;
- (NSDate*) presentingEndDate;
- (NSString*) displayDetail;
- (void) remove;

- (NSTimeInterval) totalWorkTimeInSeconds;
- (NSTimeInterval) totalBreakTimeInSeconds;
- (NSTimeInterval) totalProductiveTimeInSeconds;
- (void) mergeWithTasks:(NSMutableSet*)tasks;
- (void) mergeWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate detail:(NSString*)detail isAfter:(BOOL)isAfter;
@end
