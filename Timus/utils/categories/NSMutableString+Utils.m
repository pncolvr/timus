//
//  NSMutableString+Utils.m
//  Timus
//
//  Created by Pedro Oliveira on 10/13/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "NSMutableString+Utils.h"

@implementation NSMutableString (Utils)

#pragma mark - Methods

+(NSMutableString*) stringWithContentsOfFileNamed:(NSString*)fileName andExtension:(NSString*)extension
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName
                                                         ofType:extension];
    return [[NSString stringWithContentsOfFile:filePath
                                     encoding:NSUTF8StringEncoding
                                        error:NULL] mutableCopy];
}

@end
