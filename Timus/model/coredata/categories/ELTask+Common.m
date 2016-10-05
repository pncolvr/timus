//
//  ELTask+Common.m
//  Timus
//
//  Created by Pedro Oliveira on 4/10/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELBreak+Common.h"
#import "ELCoreDataAbstraction.h"
#import "ELTask+Common.h"
#import "ELProject+Common.h"

@interface ELTask (Private)

+ (ELTask*) p_fetchTaskWithSortDescriptors:(NSArray*) sortDescriptors
                              andPredicate:(NSPredicate*) predicate;

@end

@implementation ELTask (Common)

#pragma mark - Methods

+ (ELTask*) createWithTitle:(NSString*) title
                     detail:(NSString*)detail
                      image:(UIImage*) image
               creationDate:(NSDate*) creationDate
                    project:(ELProject*)project
               failureBlock:(void (^)(void))failureBlock;
{
    ELTask *task = nil;
    
    if (creationDate) {
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                         ascending:YES
                                                                          selector:@selector(compare:)];
        
        task = [ELCoreDataAbstraction createManagedObjectWithClass:[self class]
                                                   sortDescriptors:@[sortDescriptor]
                                                         predicate:[NSPredicate predicateWithFormat:@"creationDate = %@", creationDate]
                                                      failureBlock:^(NSError *error) {
                                                          if (failureBlock) {
                                                              failureBlock();
                                                          } else {
                                                              ELLogError(@"Error: %@", [error description]);
                                                          }
                                                      } createObjectBlock:^(ELTask *t) {
                                                          t.title = title;
                                                          t.detail = detail;
                                                          t.creationDate = creationDate;
                                                          t.endDate = nil;
                                                          t.project = project;
                                                      }];
        
    }
    return task;
}

+ (NSUInteger) countExistingTasks
{
    return [ELCoreDataAbstraction numberOfObjectWithClass:[self class]];
}

- (NSString*) displayDetail
{
    NSString *title;
    
    if ([self.detail length] > 0) {
        title = self.detail;
    } else if (!self.endDate){
        title = NSLocalizedString(@"Current task", @"");
    } else {
        title = NSLocalizedString(@"No task detail available", @"");
    }
    
    return title;
}

- (void) remove
{
    [ELCoreDataAbstraction removeObject:self];
}

- (NSTimeInterval) totalWorkTimeInSeconds
{
    NSDate *endDate = self.endDate;
    if (!endDate) {
        endDate = [NSDate date];
    }
    return round([endDate timeIntervalSinceDate:self.creationDate]);
}

- (NSTimeInterval) totalBreakTimeInSeconds
{
    NSTimeInterval seconds = 0;
    for (ELBreak *b in self.intervals) {
        seconds += [b breakDuration];
    }
    return round(seconds);
}

- (NSTimeInterval) totalProductiveTimeInSeconds
{
    return [self totalWorkTimeInSeconds] - [self totalBreakTimeInSeconds];
}

+ (ELTask*)taskWithCreationDate:(NSDate*) date
{
    NSArray *sortDesc = @[[NSSortDescriptor sortDescriptorWithKey:@"detail" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creationDate = %@", date];
    return [self p_fetchTaskWithSortDescriptors:sortDesc
                                   andPredicate:predicate];
}


- (NSDate*) presentingEndDate
{
    return self.endDate ? self.endDate : [NSDate date];
}

- (void) mergeWithTasks:(NSMutableSet*)tasks
{
    [tasks removeObject:self];
    for (ELTask *t in tasks) {
        [self mergeWithStartDate:t.creationDate
                         endDate:t.endDate detail:t.detail
                         isAfter:YES];
        [self addIntervals:t.intervals];
    }
    [self.intervals makeObjectsPerformSelector:@selector(adjustToParentTask)];
    [tasks makeObjectsPerformSelector:@selector(remove)];
    
}

- (void) mergeWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate detail:(NSString*)detail isAfter:(BOOL)isAfter
{
    NSDate *newStartDate = [self.creationDate earlierDate:startDate];
    NSDate *newEndDate = [self.endDate laterDate:endDate];
    if (!newStartDate) {
        newStartDate = self.creationDate;
        if (!newStartDate) {
            newStartDate = startDate;
        }
    }
    if (!newEndDate) {
        newEndDate = self.endDate;
        if (!newEndDate) {
            newEndDate = endDate;
        }
    }
    self.creationDate = newStartDate;
    self.endDate = newEndDate;
    
    if (!self.detail) self.detail = kEmptyString;
    if (!detail) detail = kEmptyString;
    if (isAfter) {
        self.detail = [NSString stringWithFormat:@"%@\n%@",self.detail,detail];
    } else {
        self.detail = [NSString stringWithFormat:@"%@\n%@",detail,self.detail];
    }
    NSString *newDetail = [self.detail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.detail = newDetail ? newDetail : kEmptyString;
}

#pragma mark - Private Methods

+ (ELTask*) p_fetchTaskWithSortDescriptors:(NSArray*) sortDescriptors
                              andPredicate:(NSPredicate*) predicate
{
    return (ELTask*)[ELCoreDataAbstraction firstObjectWithClass:[self class]
                                                sortDescriptors:sortDescriptors
                                                   andPredicate:predicate];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@",self.project.name ,self.displayDetail];
}

@end
