//
//  ELAddBreakViewController.h
//  Timus
//
//  Created by Pedro Oliveira on 10/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELGenericEditAndNewController.h"

@class ELTask;
@interface ELAddBreakViewController : ELGenericEditAndNewController

#pragma mark - Properties

@property (nonatomic, strong) ELTask* parentTask;

@end
