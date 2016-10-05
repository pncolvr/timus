//
//  POPromptAlertView.h
//  Timus
//
//  Created by Pedro Oliveira on 7/31/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "POAlertView.h"

@interface POPromptAlertView : POAlertView

#pragma mark - Methods

- (void) addButtonWithTitle:(NSString*) title andAction:(void (^)(NSString*))action;

@end
