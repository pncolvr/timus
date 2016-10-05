//
//  NSDate+Localization.m
//  Timus
//
//  Created by Emanuel Coelho on 06/07/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "NSDate+Localization.h"

@implementation NSDate (Localization)

#pragma mark - Methods

-(NSString *)localizedDateString
{
 return   [NSDateFormatter localizedStringFromDate:self
                                   dateStyle:NSDateFormatterMediumStyle
                                         timeStyle:NSDateFormatterShortStyle];
}

-(NSString *)localizedShortDateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    [dateFormat setLocale:[NSLocale currentLocale]];
    return [dateFormat stringFromDate:self];
}

@end
