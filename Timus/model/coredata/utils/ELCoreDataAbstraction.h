//
//  ELCoreDataAbstraction.h
//  Timus
//
//  Created by Pedro Oliveira on 4/10/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@interface ELCoreDataAbstraction : NSObject

#pragma mark - Methods

+ (id) createManagedObjectWithClass:(Class) className
                    sortDescriptors:(NSArray*) sortDescriptors
                          predicate:(NSPredicate*)predicate
                       failureBlock:(void (^)(NSError*))failureBlock
                  createObjectBlock:(void (^)(id obj))createObjectBlock;

+ (NSUInteger) numberOfObjectWithClass:(Class) className;
+ (NSManagedObject*) firstObjectWithClass:(Class) className
                          sortDescriptors:(NSArray*)sortDescriptors
                             andPredicate:(NSPredicate*)predicate;

+ (void)removeObject:(NSManagedObject*)object;

@end
