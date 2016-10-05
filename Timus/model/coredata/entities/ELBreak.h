//
//  ELBreak.h
//  Timus
//
//  Created by Pedro Oliveira on 7/12/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;
@import CoreData;

@class ELTask;

@interface ELBreak : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) ELTask *task;

@end
