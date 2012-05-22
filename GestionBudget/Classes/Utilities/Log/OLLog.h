//
//  Created by Rémi Lavedrine on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


// LIST OF LOG LEVELS
#define LOG_LVL_ERR 4
#define LOG_LVL_WRN 3
#define LOG_LVL_INF 2
#define LOG_LVL_DBG	1

#import "OLLogSetter.h"

// GENERIC
#if (defined(LOGGING_ENABLED) && LOGGING_ENABLED)
#define __RL_LOG_FORMAT(value, ...) NSLog(@"%s %@ - %@", __PRETTY_FUNCTION__, value, [NSString stringWithFormat:__VA_ARGS__])
#else
#define __RL_LOG_FORMAT(...)
#endif

// ERROR
#if (defined(LOGGING_LEVEL) && (LOGGING_LEVEL <= LOG_LVL_ERR))
#define RLLogError(...) __RL_LOG_FORMAT(@"ERR", __VA_ARGS__)
#else
#define RLLogError(...)
#endif

// WARNING
#if (defined(LOGGING_LEVEL) && (LOGGING_LEVEL <= LOG_LVL_WRN))
#define RLLogWarning(...) __RL_LOG_FORMAT(@"WRN",__VA_ARGS__)
#else
#define RLLogWarning(...)
#endif

// INFO
#if (defined(LOGGING_LEVEL) && (LOGGING_LEVEL <= LOG_LVL_INF))
#define RLLogInfo(...) __RL_LOG_FORMAT(@"INF",__VA_ARGS__)
#else
#define RLLogInfo(...)
#endif

// DEBUG
#if (defined(LOGGING_LEVEL) && (LOGGING_LEVEL <= LOG_LVL_DBG))
#define RLLogDebug(...) __RL_LOG_FORMAT(@"DBG", __VA_ARGS__)
#else
#define RLLogDebug(...)
#endif

