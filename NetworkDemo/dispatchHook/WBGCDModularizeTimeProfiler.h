//
//  WBGCDModularizeTimeProfiler.h
//  Pods
//
//  Created by yuxi on 2017/8/22.
//
//

#import <Foundation/Foundation.h>

@interface WBGCDModularizeTimeProfiler : NSObject
+ (void)startTimeStampWithModuleName:(NSString*)moduleName andUUID:(NSString*)uuid;
+ (void)stopTimeStampWithUUID:(NSString*)uuid;

+ (void)finishRecord;
+ (BOOL)isFinished;

@end
