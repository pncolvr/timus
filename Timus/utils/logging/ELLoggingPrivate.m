//
//  ELLoggingPrivate.m
//  Elastic Lobster
//
//  Created by Pedro Oliveira on 30/03/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "asl.h"

@implementation ELLoggingPrivate

#pragma mark - Functions

void ELLogPrivate(NSUInteger logLevel, NSString* format, ...)
{
    if (logLevel <= EL_MAX_LOG_LEVEL) {
        aslclient log_client = asl_open("EL", "EL Facility", ASL_OPT_STDERR);
        
        int asl_log_level = ASL_LEVEL_DEBUG; // default log level is debug (this clears an analyze issue)
        switch(logLevel) {
            case EL_LOG_LEVEL_EMERGENCY: asl_log_level = ASL_LEVEL_EMERG;   break;
            case EL_LOG_LEVEL_ALERT:     asl_log_level = ASL_LEVEL_ALERT;   break;
            case EL_LOG_LEVEL_CRITICAL:  asl_log_level = ASL_LEVEL_CRIT;    break;
            case EL_LOG_LEVEL_ERROR:     asl_log_level = ASL_LEVEL_ERR;     break;
            case EL_LOG_LEVEL_WARNING:   asl_log_level = ASL_LEVEL_WARNING; break;
            case EL_LOG_LEVEL_INFO:      asl_log_level = ASL_LEVEL_INFO;    break;
            case EL_LOG_LEVEL_DEBUG:
            default:                asl_log_level = ASL_LEVEL_DEBUG;   break;
        }
        va_list  args;
        va_start(args, format);
        NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
        asl_log(log_client, NULL, asl_log_level, "%s", [msg UTF8String]);
        
        va_end(args);
        asl_close(log_client);
        
    }

}

@end
