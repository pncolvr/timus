//
//  NSMutableString+Utils.h
//  Timus
//
//  Created by Pedro Oliveira on 10/13/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@interface NSMutableString (Utils)

#pragma mark - Methods

+(NSMutableString*) stringWithContentsOfFileNamed:(NSString*)fileName andExtension:(NSString*)extension;

@end
