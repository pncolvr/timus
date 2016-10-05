//
//  ELBreak+Common.h
//  Timus
//
//  Created by Pedro Oliveira on 4/10/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELIntervalRepresentationObject.h"
#import "ELBreak.h"

@interface ELBreak (Common) <ELIntervalRepresentationObject>

#pragma mark - Methods

+ (ELBreak*) createWithTitle:(NSString*)title
                      detail:(NSString*)detail
                creationDate:(NSDate*)creationDate
                     endDate:(NSDate*)endDate
                        task:(ELTask*)task
                failureBlock:(void (^)(void))failureBlock;

+ (NSUInteger) countExistingIntervals;
+ (ELBreak*)breakWithCreationDate:(NSDate*) date;
- (NSTimeInterval) breakDuration;
- (void) remove;
- (NSString*) displayDetail;
- (NSDate*) presentingEndDate;

- (void) mergeWithBreaks:(NSMutableSet*)breaks;
- (void) mergeWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate detail:(NSString*)detail isAfter:(BOOL)isAfter;
- (void) adjustToParentTask;
@end
