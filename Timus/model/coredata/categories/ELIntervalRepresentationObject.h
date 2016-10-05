//
//  ELIntervalRepresentationObject.h
//  Timus
//
//  Created by Pedro Oliveira on 9/19/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@protocol ELIntervalRepresentationObject <NSObject>

@required

@property (nonatomic, retain) NSDate* creationDate;
@property (nonatomic, retain) NSDate* endDate;
@property (nonatomic, retain) NSString* detail;

#pragma mark - Methods

- (NSDate*) presentingEndDate;

@end
