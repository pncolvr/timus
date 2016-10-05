//
//  ELTask.h
//  Timus
//
//  Created by Pedro Oliveira on 7/12/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;
@import CoreData;

@class ELBreak, ELProject;
@interface ELTask : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *intervals;
@property (nonatomic, retain) ELProject *project;
@end

@interface ELTask (CoreDataGeneratedAccessors)

- (void)addIntervalsObject:(ELBreak *)value;
- (void)removeIntervalsObject:(ELBreak *)value;
- (void)addIntervals:(NSSet *)values;
- (void)removeIntervals:(NSSet *)values;

@end
