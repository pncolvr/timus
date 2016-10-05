//
//  ELProjectManager.m
//  Timus
//
//  Created by Emanuel Coelho on 29/06/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELBreak+Common.h"
#import "ELProject+Common.h"
#import "ELProjectManager.h"
#import "ELTask+Common.h"
#import "ELTimer.h"

@interface ELProjectManager ()

@property (nonatomic, strong) ELProject *project;
@property (nonatomic, strong) ELBreak *pause;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) ELTask *task;

@property (nonatomic, strong) ELTimer *timer;

- (void) p_startTimer;
- (void) p_stopTimer;

@end

@implementation ELProjectManager

#pragma mark - View Lifecycle

+ (ELProjectManager*) sharedProjectManager
{
    static ELProjectManager *_singleton;
    if (!_singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _singleton = [ELProjectManager new];
        });
    }
    return _singleton;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.project = [[ELUserDefaults sharedUserDefaults] runningProject];
        self.task    = [[ELUserDefaults sharedUserDefaults] currentTask];
        self.pause   = [[ELUserDefaults sharedUserDefaults] currentBreak];
    }
    return self;
}

#pragma mark - Dynamic Properties

-(ELProject*) currentProject
{
    return self.project;
}

-(ELTask*) currentTask
{
    return self.task;
}

-(ELBreak *)currentBreak
{
    return self.pause;
}

-(void)setProject:(ELProject *)project
{
    _project = project;
    [[ELUserDefaults sharedUserDefaults] setRunningProject:project];
}

-(void)setTask:(ELTask *)task
{
    _task = task;
    [[ELUserDefaults sharedUserDefaults] setCurrentTask:_task];
    _task ? [self p_startTimer] : [self p_stopTimer];
}

-(void)setPause:(ELBreak *)pause
{
    _pause = pause;
    [[ELUserDefaults sharedUserDefaults] setCurrentBreak:pause];
}

#pragma mark - Methods

-(BOOL)canCreateTaskWithProject:(ELProject*)project
{
    if (!self.project) {
        self.project = project;
    }
    return ([project isEqualToProject:self.project]) ? self.currentTask == nil : NO;
}


-(ELTask*)createTaskWithProject:(ELProject*)project
{
    NSDate *currentDate = [NSDate date];
    project.modifiedDate = currentDate;
    self.task = [ELTask createWithTitle:@"" detail:nil image:nil creationDate:currentDate project:project failureBlock:nil];
    self.project = project;
    return self.task;
}

-(void) endCurrentTaskWithDetail:(NSString*)detail
{
    NSDate *currentDate = [NSDate date];
    if (detail) {
        self.task.detail = detail;
    }
    self.task.project.modifiedDate = currentDate;
    if (!self.task.endDate) {
        self.task.endDate = currentDate;
    }
    if (self.pause) {
        self.pause.endDate = currentDate;
    }
    //enable other tasks and other projects
    self.pause = nil;
    self.task = nil;
    self.project = nil;
}

-(void) endCurrentTask
{
    NSDate *currentDate = [NSDate date];
    
    if (self.pause) {
        self.pause.endDate = currentDate;
    }
    //enable other tasks and other projects
    self.pause = nil;
    self.task = nil;
    self.project = nil;
}

-(BOOL) canCreateBreakWithProject:(ELProject*)project;
{
    return ([project isEqualToProject:self.project]) ? YES : NO;
}

-(ELBreak*)createBreakWithTask:(ELTask*)task
{
    self.pause = [ELBreak createWithTitle:nil
                                   detail:nil
                             creationDate:[NSDate date]
                                  endDate:nil
                                     task:task
                             failureBlock:nil];
    return self.pause;
}

- (void) endCurrentBreakWithDetail:(NSString *) detail
{
    self.pause.detail = detail;
    self.pause.endDate = [NSDate date];
    //enable further breaks
    self.pause = nil;
}

-(ELProjectStatus)statusOfProject:(ELProject *)project
{
    ELBreak *currentBreak = nil;
    ELTask *currentTask = nil;
    ELProjectStatus status = ELProjectNotRunning;
    
    if ([[self currentProject] isEqualToProject:project]) {
        currentBreak = [self currentBreak];
        currentTask = [self currentTask];
    }
    
    if (currentTask) {
        status = ELProjectRunning;
    }
    
    if (currentBreak) {
        status = ELProjectOnBreak;
    }
    
    if (!currentBreak && !currentTask) {
        status = ELProjectNotRunning;
    }
    
    return status;
}

#pragma mark - Private Methods

- (void) p_startTimer
{
    self.timer = [ELTimer scheduledTimerWithTimeInterval:1.0f
                                                userInfo:nil
                                                 repeats:YES
                                               tickBlock:^(ELTimer *timer, id userInfo) {
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentProjectDidUpdateNotification
                                                                                                       object:self.project];
                                               } completionBlock:nil];
}

- (void) p_stopTimer
{
    [self.timer invalidateAndExecuteCompletionBlock:YES];
    self.timer = nil;
}

@end
