//
//  WBGCDModularizeTimeProfiler.m
//  Pods
//
//  Created by yuxi on 2017/8/22.
//
//

#import "WBGCDModularizeTimeProfiler.h"
#import "WBMModuleManager.h"
#import "WBMTimeProfiler.h"
#import <mach/mach_time.h>


@interface WBGCDModularizedRecord : NSObject
@property (readwrite, strong) NSString* moduleName;
@property (readwrite, assign) uint64_t startTimeStamp;
@property (readwrite, assign) uint64_t endTimeStamp;
- (instancetype)initWithModuleName:(NSString*)moduleName;
- (void)stopTimeRecord;
- (uint64_t)duringAbsTime;
- (BOOL)validate;
@end


@interface WBGCDModularizeTimeProfiler(){
    NSMutableDictionary* _nonClosedRecordDict;
    BOOL _isFinished;
}
+ (instancetype)_sharedInstance;
- (void)_startTimeStampWithModuleName:(NSString*)moduleName andUUID:(NSString*)uuid;
- (void)_stopTimeStampWithUUID:(NSString*)uuid;
- (void)_finishRecord;
- (BOOL)_isFinished;
@end


@implementation WBGCDModularizeTimeProfiler


+ (instancetype)_sharedInstance{
    static dispatch_once_t onceToken;
    static WBGCDModularizeTimeProfiler* inatance = nil;
    dispatch_once(&onceToken, ^{
        inatance = [[[self class] alloc] init];
    });
    
    return inatance;
}

+ (void)startTimeStampWithModuleName:(NSString*)moduleName andUUID:(NSString*)uuid{
    [[self _sharedInstance] _startTimeStampWithModuleName:moduleName andUUID:uuid];
}

+ (void)stopTimeStampWithUUID:(NSString*)uuid{
    [[self _sharedInstance] _stopTimeStampWithUUID:uuid];
}

+ (void)finishRecord{
    [[self _sharedInstance] _finishRecord];
}

+ (BOOL)isFinished{
    return [[self _sharedInstance] _isFinished];
}



- (instancetype)init{
    self =  [super init];
    if (self) {
        _isFinished = NO;
        _nonClosedRecordDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)_startTimeStampWithModuleName:(NSString*)moduleName andUUID:(NSString*)uuid{
    
    if (NO == [NSThread isMainThread]) {
        /*应对callback queue 的情况*/
        return;
    }
    
    if (YES == _isFinished)
        return;
    
    
    if (nil == moduleName) {
        assert(0);
        return;
    }
    
    if (nil == uuid) {
        assert(0);
        return;
    }
    
    WBGCDModularizedRecord* record = [[WBGCDModularizedRecord alloc] initWithModuleName:moduleName];
    assert([[record moduleName] isEqualToString:moduleName]);
    [_nonClosedRecordDict wbt_setObject:record forKey:uuid];
    
}

- (void)_stopTimeStampWithUUID:(NSString*)uuid{
    
    if (NO == [NSThread isMainThread]) {
        /*应对callback queue 的情况*/
        return;
    }
    
    if (YES == _isFinished)
        return;
    
    if (nil == uuid) {
        assert(0);
        return;
    }
    
    WBGCDModularizedRecord* record = [_nonClosedRecordDict objectForKey:uuid];
    [_nonClosedRecordDict removeObjectForKey:uuid];
    
    
    [record stopTimeRecord];
    if (NO == [record validate]) {
        return;
    }
    
    [[WBMModuleManager shareManager].profiler addModuleName:[record moduleName]
                                                       Step:@"mainThread"
                                              duringAbsTime:[record duringAbsTime]];
}

- (void)_finishRecord{
    
    _isFinished = YES;
    
    if (NO == [NSThread isMainThread]) {
        assert(0);
        return;
    }
    for(WBGCDModularizedRecord* record in [_nonClosedRecordDict allValues])
    {
        
        [record stopTimeRecord];
        if (NO == [record validate])
            continue;
        
        [[WBMModuleManager shareManager].profiler addModuleName:[record moduleName]
                                                           Step:@"mainThread"
                                                  duringAbsTime:[record duringAbsTime]];
    }
    
    [_nonClosedRecordDict removeAllObjects];
    
}

- (BOOL)_isFinished{
    return _isFinished;
}



@end


@implementation WBGCDModularizedRecord

- (instancetype)initWithModuleName:(NSString*)moduleName{
    
    self = [super init];
    if (self) {
        _moduleName = moduleName;
        _startTimeStamp = mach_absolute_time();
        _endTimeStamp = 0;
    }
    
    return self;
}

- (void)stopTimeRecord{
    _endTimeStamp = mach_absolute_time();
}

- (uint64_t)duringAbsTime{
    
    if (0 != _endTimeStamp  &&  0 != _startTimeStamp) {
        return _endTimeStamp - _startTimeStamp;
    }
    else{
        return 0;
    }
    
}

- (BOOL)validate{
    
    BOOL isValidate = NO;
    do{
        
        if(nil == _moduleName)
            break;
        
        if (nil == _startTimeStamp)
            break;
        
        if (nil == _endTimeStamp)
            break;
        
        isValidate = YES;
        
    }while(0);
    
    
    return isValidate;
    
}


@end
