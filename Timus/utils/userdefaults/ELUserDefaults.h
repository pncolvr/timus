//
//  ELUserDefaults.h
//  Timus
//
//  Created by Pedro Oliveira on 4/16/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@class ELProject, ELTask, ELBreak;
@interface ELUserDefaults : NSObject

#pragma mark - Methods

+ (ELUserDefaults*) sharedUserDefaults;

#pragma mark - Properties

@property (nonatomic) ELProject *selectedProject;
@property (nonatomic) ELProject *runningProject;
@property (nonatomic) ELTask *currentTask;
@property (nonatomic) ELBreak *currentBreak;

@end
