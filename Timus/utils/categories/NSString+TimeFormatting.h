//
//  NSString+TimeFormatting.h
//  Timus
//
//  Created by Pedro Oliveira on 6/27/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@interface NSString (TimeFormatting)

#pragma mark - Methods

+ (NSString*) timeIndicatorStringWithElapsedSeconds:(NSTimeInterval) totalSeconds;

@end
