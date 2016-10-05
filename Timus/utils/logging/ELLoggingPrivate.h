//
//  ELLoggingPrivate.h
//  Elastic Lobster
//
//  Created by Pedro Oliveira on 30/03/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@interface ELLoggingPrivate : NSObject

#pragma mark - Functions

void ELLogPrivate(NSUInteger logLevel, NSString* format, ...)NS_FORMAT_FUNCTION(2,3);

@end
