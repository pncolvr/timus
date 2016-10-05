//
//  ELProject+Common.m
//  Timus
//
//  Created by Pedro Oliveira on 4/9/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELCoreDataAbstraction.h"
#import "ELProject+Common.h"
#import "ELTask+Common.h"

@interface ELProject (Private)

+ (ELProject*) p_fetchProjectWithSortDescriptors:(NSArray*) sortDescriptors
                                    andPredicate:(NSPredicate*) predicate;

@end
@implementation ELProject (Common)

#pragma mark - Methods

+ (ELProject*) createWithName:(NSString*)name
                       detail:(NSString*)detail
                        image:(UIImage*)image
                        tasks:(NSSet*) tasks
                 creationDate:(NSDate*)creationDate
                 failureBlock:(void (^)(void))failureBlock
{
    ELProject *project = nil;
    
    if (creationDate) {
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                         ascending:YES
                                                                          selector:@selector(compare:)];
        
        project = [ELCoreDataAbstraction createManagedObjectWithClass:[self class]
                                                      sortDescriptors:@[sortDescriptor]
                                                            predicate:[NSPredicate predicateWithFormat:@"creationDate = %@", creationDate]
                                                         failureBlock:^(NSError *error) {
                                                             if (failureBlock) {
                                                                 failureBlock();
                                                             } else {
                                                                 ELLogError(@"Error: %@", [error description]);
                                                             }
                                                         } createObjectBlock:^(ELProject *p) {
                                                             p.name = name;
                                                             p.detail = detail;
                                                             p.image = image;
                                                             p.tasks = tasks;
                                                             p.creationDate = creationDate;
                                                             p.modifiedDate = creationDate;
                                                         }];
        
    }
    
    return project;
}

+ (NSUInteger) countExistingProjects
{
    return [ELCoreDataAbstraction numberOfObjectWithClass:[self class]];
}

+ (ELProject*) projectWithCreationDate:(NSDate*) date
{
    NSArray *sortDesc = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creationDate = %@", date];
    return [self p_fetchProjectWithSortDescriptors:sortDesc
                                      andPredicate:predicate];
}

+ (ELProject*) firstProjectOrderedByName
{
    NSArray *sortDesc = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    NSPredicate *predicate = nil; //fetch all
    return [self p_fetchProjectWithSortDescriptors:sortDesc
                                      andPredicate:predicate];
}

- (ELTask *) currentTask
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"endDate=nil"];
    return [[self.tasks filteredSetUsingPredicate:predicate] anyObject];
}

+ (ELProject*) p_fetchProjectWithSortDescriptors:(NSArray*) sortDescriptors
                                    andPredicate:(NSPredicate*) predicate
{
    return (ELProject*)[ELCoreDataAbstraction firstObjectWithClass:[self class]
                                                   sortDescriptors:sortDescriptors
                                                      andPredicate:predicate];
}

- (void) remove
{
    [ELCoreDataAbstraction removeObject:self];
}

-(BOOL)isEqualToProject:(ELProject*)object
{
    ELProject *project = object;
    return [project.creationDate isEqualToDate:self.creationDate];
}

- (NSTimeInterval) totalWorkTimeInSeconds
{
    NSTimeInterval seconds = 0;
    for (ELTask *task in self.tasks) {
        seconds += [task totalWorkTimeInSeconds];
    }
    return seconds;
}

- (NSTimeInterval) totalProductiveTimeInSeconds
{
    NSTimeInterval seconds = 0;
    for (ELTask *task in self.tasks) {
        seconds += [task totalProductiveTimeInSeconds];
    }
    return seconds;
}

- (NSTimeInterval) totalBreakTimeInSeconds
{
    NSTimeInterval seconds = 0;
    for (ELTask *task in self.tasks) {
        seconds += [task totalBreakTimeInSeconds];
    }
    return seconds;
}


@end
