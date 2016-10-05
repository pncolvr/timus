//
//  ELAppearanceManager.h
//  Timus
//
//  Created by Pedro Oliveira on 4/19/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@interface ELAppearanceManager : NSObject

#pragma mark - Methods

+ (ELAppearanceManager *)sharedAppearanceManager;
- (void) applyDefaultUserInterface;

@end
