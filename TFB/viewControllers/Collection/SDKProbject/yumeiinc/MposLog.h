//
//  MposLog.h
//  MposUtils
//
//  Created by kevintu@paxsz.com on 9/25/14.
//  Copyright (c) 2014 pax. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @abstract log level enumeration
 @constant LOG_LEVEL_NONE   log level none
 @constant LOG_LEVEL_ERR    log level error
 @constant LOG_LEVEL_WRN    log level warning
 @constant LOG_LEVEL_DBG    log level debug
 @constant LOG_LEVEL_INFO   log level verbose information
 */
typedef enum {
    LOG_LEVEL_NONE    = 0,
    LOG_LEVEL_ERR     = 1,
    LOG_LEVEL_WRN     = 2,
    LOG_LEVEL_DBG     = 3,
    LOG_LEVEL_INFO    = 4
} MposLogLevel;

#ifdef __cplusplus
extern "C" {
#endif

/*!
 @abstract set current log level to the specified one
 @discussion the default log level is LOG_LEVEL_WRN.
    set to LOG_LEVEL_NONE to disable all log outputs,set to LOG_LEVEL_INFO for most verbose log outputs
 @param level
    the specified log level to set
 */
void MposSetLogLevel(MposLogLevel level);

#pragma mark - internal interfaces
/*!
 @abstract the internal log utilities
 */
void MposDebug(MposLogLevel logLevelIn, const char *fileName, int lineNumber, NSString *fmt, ...);
#define MLogI(format...) MposDebug(LOG_LEVEL_INFO, __FILE__,__LINE__,format)
#define MLogD(format...) MposDebug(LOG_LEVEL_DBG, __FILE__,__LINE__,format)
#define MLogW(format...) MposDebug(LOG_LEVEL_WRN, __FILE__,__LINE__,format)
#define MLogE(format...) MposDebug(LOG_LEVEL_ERR, __FILE__,__LINE__,format)

#ifdef __cplusplus
}
#endif
