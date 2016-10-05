//
//  NSSet+Utils.m
//  Timus
//
//  Created by Pedro Oliveira on 07/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "NSSet+Utils.h"

@interface NSSet (Private)

- (NSMutableSet*) p_filteredSetWithStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate;

@end

@implementation NSSet (Utils)

#pragma mark - Methods

- (NSMutableSet*) tasksWithStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate
{
    return [self p_filteredSetWithStartDate:startDate
                                 andEndDate:endDate];
}

- (NSMutableSet*) breaksWithStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate
{
    return [self p_filteredSetWithStartDate:startDate
                                 andEndDate:endDate];
}

#pragma mark - Private Methods
- (NSMutableSet*) p_filteredSetWithStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((%@ >= creationDate && (endDate == NULL || %@ <= endDate)) || (%@ >= creationDate && (endDate == NULL || %@ <= endDate))) || (creationDate >= %@  && (endDate == NULL || endDate <= %@))", startDate, startDate, endDate, endDate,startDate, endDate];
    return [[self filteredSetUsingPredicate:predicate] mutableCopy];
}

@end
