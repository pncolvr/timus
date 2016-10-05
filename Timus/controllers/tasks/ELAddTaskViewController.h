//
//  ELAddTaskViewController.h
//  Timus
//
//  Created by Pedro Oliveira on 10/11/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELGenericEditAndNewController.h"

@class ELProject;
@interface ELAddTaskViewController : ELGenericEditAndNewController

#pragma mark - Properties

@property (nonatomic, strong) ELProject *parentProject;

@end
