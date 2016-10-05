//
//  ELUserDefaults.m
//  Timus
//
//  Created by Pedro Oliveira on 4/16/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELBreak+Common.h"
#import "ELProject+Common.h"
#import "ELTask+Common.h"

#define kCurrentBreakKey   @"kCurrentBreakKey"
#define kCurrentTaskKey    @"kCurrentTaskKey"
#define kDefaultProjectKey @"kDefaultProjectKey"
#define kRunningProjectKey @"kRunningProjectKey"

@interface ELUserDefaults ()

- (void) p_saveData:(id)data forKey:(NSString*)key;
- (id)p_retrieveDataForKey:(NSString*)key;

@end

@implementation ELUserDefaults
@dynamic selectedProject, currentTask, runningProject, currentBreak;

#pragma mark - View Lifecycle

+ (ELUserDefaults*) sharedUserDefaults
{
    static ELUserDefaults *__singleton;
    
    if (!__singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __singleton = [ELUserDefaults new];
        });
    }
    
    return __singleton;
}

#pragma mark - Dynamic Properties

-(ELProject *)selectedProject
{
    NSDate *projectCreationDate = [self p_retrieveDataForKey:kDefaultProjectKey];
    ELProject *project;
    
    if (projectCreationDate) {
        //try to fetch project with creation date
        project = [ELProject projectWithCreationDate:projectCreationDate];
    }

    if (!projectCreationDate || !project) {
        // try to return first project
        project = [ELProject firstProjectOrderedByName];
        self.selectedProject = project;
    }
    
    return project;
}

-(void)setSelectedProject:(ELProject *)defaultProject
{
    [self p_saveData:defaultProject.creationDate
              forKey:kDefaultProjectKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDefaultProjectDidChangeNotification
                                                        object:nil];
}

-(ELProject *)runningProject
{
    NSDate *projectCreationDate = [self p_retrieveDataForKey:kRunningProjectKey];
    ELProject *project;
    
    if (projectCreationDate) {
        //try to fetch project with creation date
        project = [ELProject projectWithCreationDate:projectCreationDate];
    }
    return project;
}

-(void)setRunningProject:(ELProject *)runningProject
{
    [self p_saveData:runningProject.creationDate
              forKey:kRunningProjectKey];
}

-(ELTask *)currentTask
{
    NSDate *taskCreationDate = [self p_retrieveDataForKey:kCurrentTaskKey];
    ELTask *task;
    
    if (taskCreationDate) {
        //try to fetch project with creation date
        task = [ELTask taskWithCreationDate:taskCreationDate];
    }
    return task;

}

-(void)setCurrentTask:(ELTask *)currentTask
{
    [self p_saveData:currentTask.creationDate
              forKey:kCurrentTaskKey];
}

-(void)setCurrentBreak:(ELBreak *)currentBreak
{
    [self p_saveData:currentBreak.creationDate
              forKey:kCurrentBreakKey];
}

-(ELBreak *)currentBreak
{
    
    NSDate *creationDate = [self p_retrieveDataForKey:kCurrentBreakKey];
    ELBreak *pause;
    
    if(creationDate){
        //try to fetch break with creation date
        pause = [ELBreak breakWithCreationDate:creationDate];
    }
    
    return pause;
}

#pragma mark - Private Methods

- (void) p_saveData:(id)data forKey:(NSString*)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data
                     forKey:key];
    [userDefaults synchronize];
}
- (id)p_retrieveDataForKey:(NSString*)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}
@end
