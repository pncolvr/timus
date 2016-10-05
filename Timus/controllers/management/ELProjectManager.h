//
//  ELProjectManager.h
//  Timus
//
//  Created by Emanuel Coelho on 29/06/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, ELProjectStatus){
    ELProjectNotRunning = 0,
    ELProjectRunning    = 1,
    ELProjectOnBreak    = 2
};

@class ELTask, ELProject, ELBreak;
@interface ELProjectManager : NSObject

#pragma mark - Methods

+ (ELProjectManager*) sharedProjectManager;

-(ELProject*) currentProject;
-(ELTask*) currentTask;
-(ELBreak*) currentBreak;

-(BOOL) canCreateTaskWithProject:(ELProject*)project;
-(BOOL) canCreateBreakWithProject:(ELProject*)project;
-(void) endCurrentTask;
-(ELTask*) createTaskWithProject:(ELProject*)project;
-(ELBreak*)createBreakWithTask:(ELTask*)task;

-(void) endCurrentTaskWithDetail:(NSString*)detail;
-(void) endCurrentBreakWithDetail:(NSString*)detail;

-(ELProjectStatus)statusOfProject:(ELProject*)project;

@end
