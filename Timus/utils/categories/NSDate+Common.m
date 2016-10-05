//
//  NSDate+Common.m
//  Timus
//
//  Created by Pedro Oliveira on 9/27/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "NSDate+Common.h"

@implementation NSDate (Common)

#pragma mark - Methods

+ (NSDate*) currentWeekStartDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday | NSCalendarUnitHour
                                                                                    | NSCalendarUnitMinute | NSCalendarUnitSecond
                                                                          fromDate:currentDate];
    
    NSInteger currentDay    = [currentComponents weekday];
    NSInteger currentHour   = [currentComponents hour] - 1;
    NSInteger currentMinute = [currentComponents minute];
    NSInteger currentSecond = [currentComponents second];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay: (-1 * currentDay)];
    [comps setHour: (-1 * currentHour)];
    [comps setMinute: (-1 * currentMinute)];
    [comps setSecond: (-1 * currentSecond)];
    
    return [gregorian dateByAddingComponents:comps
                                      toDate:currentDate
                                     options:NSCalendarWrapComponents];
}

+ (NSDate*) lastWeekStartDate
{
    NSDate *currentWeekStartDate = [self currentWeekStartDate];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSDate *date = [NSDate date];
    NSInteger weekOfYear = [gregorian component:NSCalendarUnitWeekOfYear fromDate:date];
    [comps setWeekOfYear:weekOfYear-1];
    
    return [gregorian dateByAddingComponents:comps
                                      toDate:currentWeekStartDate
                                     options:NSCalendarWrapComponents];
}

@end
