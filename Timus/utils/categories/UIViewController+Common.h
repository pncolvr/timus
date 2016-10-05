//
//  UIViewController+Common.h
//  Timus
//
//  Created by Pedro Oliveira on 9/27/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import UIKit;

@interface UIViewController (Common)

#pragma mark - Methods

- (void) presentMailWithSubject:(NSString*) subject attachmentString:(NSString*)attach andBody:(NSString*)body;

@end
