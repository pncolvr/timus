//
//  ELLogging.h
//  Elastic Lobster
//
//  Created by Pedro Oliveira on 30/03/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELLoggingPrivate.h"

#define EL_LOG_LEVEL_NONE        -1
#define EL_LOG_LEVEL_EMERGENCY   0
#define EL_LOG_LEVEL_ALERT       1
#define EL_LOG_LEVEL_CRITICAL    2
#define EL_LOG_LEVEL_ERROR       3
#define EL_LOG_LEVEL_WARNING     4
#define EL_LOG_LEVEL_NOTICE      5
#define EL_LOG_LEVEL_INFO        6
#define EL_LOG_LEVEL_DEBUG       7
#define EL_LOG_LEVEL_ALL         99

#if DEBUG
#define EL_LOG_TO_TEST_FLIGHT 0
#else
#define EL_LOG_TO_TEST_FLIGHT 1
#endif
#define EL_MAX_LOG_LEVEL EL_LOG_LEVEL_ALL

#if (EL_MAX_LOG_LEVEL != EL_LOG_LEVEL_NONE)
    #define ELLog(log_level, format, ...)                   \
        do {                                                        \
            ELLogPrivate(log_level, format, ##__VA_ARGS__); \
        } while (0);
#else
    #define ELLog(log_level, format, ...) do {} while(0);
#endif

#define ELLogEmergency(format, ...)                       \
ELLog(EL_LOG_LEVEL_EMERGENCY, format, ##__VA_ARGS__)

#define ELLogAlert(format, ...)                       \
ELLog(EL_LOG_LEVEL_ALERT, format, ##__VA_ARGS__)

#define ELLogCritical(format, ...)                       \
ELLog(EL_LOG_LEVEL_CRITICAL, format, ##__VA_ARGS__)

#define ELLogError(format, ...)                       \
ELLog(EL_LOG_LEVEL_ERROR, format, ##__VA_ARGS__)

#define ELLogWarning(format, ...)                       \
    ELLog(EL_LOG_LEVEL_WARNING, format, ##__VA_ARGS__)

#define ELLogNotice(format, ...)                        \
    ELLog(EL_LOG_LEVEL_NOTICE, format, ##__VA_ARGS__)

#define ELLogInfo(format, ...)                       \
ELLog(EL_LOG_LEVEL_INFO, format, ##__VA_ARGS__)

#define ELLogDebug(format, ...)                         \
    ELLog(EL_LOG_LEVEL_DEBUG, format, ##__VA_ARGS__)

