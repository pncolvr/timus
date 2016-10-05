//
//  NSDate+Common.h
//  Timus
//
//  Created by Pedro Oliveira on 9/27/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@interface NSDate (Common)

#pragma mark - Methods

+ (NSDate*) currentWeekStartDate;
+ (NSDate*) lastWeekStartDate;

@end
