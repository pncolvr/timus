//
//  POPromptButton.h
//  Timus
//
//  Created by Pedro Oliveira on 7/31/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@interface POPromptButton : NSObject

#pragma mark - Methods

- (instancetype) initWithTitle:(NSString*) aTitle
           andAction:(void (^)(NSString*)) aAction;

#pragma mark - Properties

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) void (^action)(NSString*);

@end
