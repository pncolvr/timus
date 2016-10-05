//
//  NSString+TimeFormatting.m
//  Timus
//
//  Created by Pedro Oliveira on 6/27/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "NSString+TimeFormatting.h"

#pragma mark - Constants

#define kMaxHours 86400
#define kMaxMinutes 3600
#define kMaxSeconds 60

#define kLongDateFormat @"HH:mm:ss"
#define kShortDateFormat @"HH:mm:ss"

@implementation NSString (TimeFormatting)

#pragma mark - Methods

+ (NSString*) timeIndicatorStringWithElapsedSeconds:(NSTimeInterval) totalSeconds
{
    int days = totalSeconds / kMaxHours;
    totalSeconds = totalSeconds - (days*kMaxHours);
    int hours = totalSeconds /kMaxMinutes;
    totalSeconds = totalSeconds - (hours*kMaxMinutes);
    int minutes = totalSeconds / kMaxSeconds;
    int seconds = totalSeconds - (minutes * kMaxSeconds);
    NSMutableString *formattedTime = [[NSMutableString alloc] initWithFormat:@"%02dh%02dm%02ds",hours, minutes, seconds];
    if (days > 0) {
        formattedTime = [[NSMutableString alloc] initWithFormat:@"%02dd%@",days,formattedTime];
    }
    return formattedTime;
}

@end
