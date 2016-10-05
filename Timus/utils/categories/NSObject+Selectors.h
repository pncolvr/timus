//
//  NSObject+Selectors.h
//  Timus
//
//  Created by Pedro Oliveira on 4/24/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@interface NSObject (Selectors)

#pragma mark - Methods

- (void) checkAndPerformSelector:(SEL) selector withObject:(id)arg;

@end
