//
//  ELCoreDataAbstraction.m
//  Timus
//
//  Created by Pedro Oliveira on 4/10/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELCoreDataAbstraction.h"
#import "ELCoreDataStack.h"

@implementation ELCoreDataAbstraction

#pragma mark - Methods

+ (id) createManagedObjectWithClass:(Class) className
                    sortDescriptors:(NSArray*) sortDescriptors
                          predicate:(NSPredicate*)predicate
                       failureBlock:(void (^)(NSError*))failureBlock
                  createObjectBlock:(void (^)(id obj))createObjectBlock
{
    NSError *error;
    NSArray *matches = [self objectsWithClassName:className
                                  sortDescriptors:sortDescriptors
                                     andPredicate:predicate
                                         andError:error];
    NSManagedObject *obj = [matches firstObject];
    
    if (!matches || [matches count] > 1) { //error
        if (failureBlock) {
            failureBlock(error);
        } else {
            ELLogError(@"Failed to fetch managed object, this case was no treated");
        }
    } else if (![matches count]) { //create new
        obj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(className)
                                            inManagedObjectContext:[[ELCoreDataStack sharedCoreDataStack] managedObjectContext]];
        if (createObjectBlock) {
            createObjectBlock(obj);
        }
    }
    
    return obj;
}

+ (NSUInteger) numberOfObjectWithClass:(Class) className
{
    NSManagedObjectContext *context = [[ELCoreDataStack sharedCoreDataStack] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass(className)
                                   inManagedObjectContext:context]];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [context countForFetchRequest:request error:&err];
    if(count == NSNotFound) {
        count = 0;
    }
    return count;
}

+ (NSManagedObject*) firstObjectWithClass:(Class) className
                          sortDescriptors:(NSArray*)sortDescriptors
                             andPredicate:(NSPredicate*)predicate
{
    
    return [[self objectsWithClassName:className
                       sortDescriptors:sortDescriptors
                          andPredicate:predicate
                              andError:nil] firstObject];
}

+ (NSArray*) objectsWithClassName:(Class)className
                  sortDescriptors:(NSArray*)sortDescriptors
                     andPredicate:(NSPredicate*)predicate
                         andError:(NSError*)error
{
    NSString *entityName = NSStringFromClass(className);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = sortDescriptors;
    request.predicate = predicate;
    NSManagedObjectContext *context = [[ELCoreDataStack sharedCoreDataStack] managedObjectContext];
    return [context executeFetchRequest:request
                                  error:&error];
    
}

+ (void)removeObject:(NSManagedObject*)object
{
    NSManagedObjectContext *context = [[ELCoreDataStack sharedCoreDataStack] managedObjectContext];
    [context performBlock:^{
        [context deleteObject:object];
    }];
}

@end
