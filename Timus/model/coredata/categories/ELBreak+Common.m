//
//  ELBreak+Common.m
//  Timus
//
//  Created by Pedro Oliveira on 4/10/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELBreak+Common.h"
#import "ELCoreDataAbstraction.h"
#import "ELTask+Common.h"

@interface ELBreak (Private)
+ (ELBreak*) p_fetchBreakWithSortDescriptors:(NSArray*) sortDescriptors
                                andPredicate:(NSPredicate*) predicate;

@end

@implementation ELBreak (Common)

#pragma mark - Methods

+ (ELBreak*) createWithTitle:(NSString*)title
                      detail:(NSString*)detail
                creationDate:(NSDate*)creationDate
                     endDate:(NSDate*)endDate
                        task:(ELTask*)task
                failureBlock:(void (^)(void))failureBlock
{
    ELBreak *interval = nil;
    
    if (creationDate) {
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                         ascending:YES
                                                                          selector:@selector(compare:)];
        
        interval = [ELCoreDataAbstraction createManagedObjectWithClass:[self class]
                                                       sortDescriptors:@[sortDescriptor]
                                                             predicate:[NSPredicate predicateWithFormat:@"creationDate = %@", creationDate]
                                                          failureBlock:^(NSError *error) {
                                                              if (failureBlock) {
                                                                  failureBlock();
                                                              } else {
                                                                  ELLogError(@"Error: %@", [error description]);
                                                              }
                                                          } createObjectBlock:^(ELBreak *i) {
                                                              i.title = title;
                                                              i.detail = detail;
                                                              i.creationDate = creationDate;
                                                              i.endDate = endDate;
                                                              i.task = task;
                                                          }];
        
    }
    return interval;
}

+ (NSUInteger) countExistingIntervals
{
    return [ELCoreDataAbstraction numberOfObjectWithClass:[self class]];
}

- (void) remove
{
    [ELCoreDataAbstraction removeObject:self];
}

+ (ELBreak*)breakWithCreationDate:(NSDate*) date
{
    NSArray *sortDesc = @[[NSSortDescriptor sortDescriptorWithKey:@"detail" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creationDate = %@", date];
    return [self p_fetchBreakWithSortDescriptors:sortDesc
                                    andPredicate:predicate];
}

- (NSTimeInterval) breakDuration
{
    NSDate *endDate = self.endDate;
    if (!endDate) {
        endDate = [NSDate date];
    }
    return [endDate timeIntervalSinceDate:self.creationDate];
}

- (NSString*) displayDetail
{
    NSString *title;
    
    if ([self.detail length] > 0) {
        title = self.detail;
    } else if (!self.endDate){
        title = NSLocalizedString(@"Current break", @"");
    } else {
        title = NSLocalizedString(@"No break detail available", @"");
    }
    
    return title;
}

- (NSDate*) presentingEndDate
{
    return self.endDate ? self.endDate : [NSDate date];
}

- (void) mergeWithBreaks:(NSMutableSet*)breaks
{
    [breaks removeObject:self];
    for (ELBreak *t in breaks) {
        [self mergeWithStartDate:t.creationDate
                         endDate:t.endDate detail:t.detail
                         isAfter:YES];
    }
    [breaks makeObjectsPerformSelector:@selector(remove)];
    
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

- (void) adjustToParentTask
{
    if (self.task.creationDate && [[self.creationDate earlierDate:self.task.creationDate] isEqualToDate:self.creationDate]) {
        self.creationDate = self.task.creationDate;
    }
    if (self.task.endDate && [[self.endDate laterDate:self.task.endDate] isEqualToDate:self.endDate]) {
        self.endDate = self.task.endDate;
    }
}

#pragma mark - Private Methods

+ (ELBreak*) p_fetchBreakWithSortDescriptors:(NSArray*) sortDescriptors
                                andPredicate:(NSPredicate*) predicate
{
    return (ELBreak*)[ELCoreDataAbstraction firstObjectWithClass:[self class]
                                                 sortDescriptors:sortDescriptors
                                                    andPredicate:predicate];
}

@end
