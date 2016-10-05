//
//  NSSet+Utils.h
//  Timus
//
//  Created by Pedro Oliveira on 07/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@interface NSSet (Utils)

#pragma mark - Methods

- (NSMutableSet*) tasksWithStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate;
- (NSMutableSet*) breaksWithStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate;

@end
