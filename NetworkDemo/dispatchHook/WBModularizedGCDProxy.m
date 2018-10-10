//
//  WBModularizedGCDProxy.m
//  Pods
//
//  Created by yuxi on 2017/8/21.
//
//

#import <dlfcn.h>
#import "WBModularizedGCDProxy.h"
#import "WBGCDModularizeTimeProfiler.h"

static NSString* const KWABTest_GCD = @"KWABTest_GCD";


typedef void (*wb_dispatch_sync_fun)(dispatch_queue_t queue, DISPATCH_NOESCAPE dispatch_block_t block);
typedef void (*wb_dispatch_async_fun)(dispatch_queue_t queue, dispatch_block_t block);

typedef void (*wb_dispatch_after_fun)(dispatch_time_t when, dispatch_queue_t queue, dispatch_block_t block);


static BOOL abtest_enable(void);


void wb_dispatch_sync(dispatch_queue_t queue, NSString* moduleName, DISPATCH_NOESCAPE dispatch_block_t block)
{
    static dispatch_once_t onceToken;
    static wb_dispatch_sync_fun origin_dispatch_sync = nil;
    dispatch_once(&onceToken, ^{
        origin_dispatch_sync = dlsym(RTLD_DEFAULT, "dispatch_sync");
    });
    
    
    if (NULL == origin_dispatch_sync) {
        assert(0);
        return;
    }
    
    if (abtest_enable())
    {
        if ([[NSThread currentThread] isMainThread])
        {
            origin_dispatch_sync(queue, ^{
                if (NULL != block)
                {
                    block();
                }
            });
        }
        else
        {
            NSString* uuid = [[NSUUID UUID] UUIDString];
            origin_dispatch_sync(queue, ^{
                
                if (NULL != block)
                {
                    [WBGCDModularizeTimeProfiler startTimeStampWithModuleName:moduleName andUUID:uuid];
                    block();
                    [WBGCDModularizeTimeProfiler stopTimeStampWithUUID:uuid];
                }
                
            });
            
        }
    }
    else
    {
        origin_dispatch_sync(queue, ^{
            if (NULL != block)
            {
                block();
            }
        });
    }
    
}

void wb_dispatch_async(dispatch_queue_t queue, NSString* moduleName, dispatch_block_t block)
{
    static dispatch_once_t onceToken;
    static wb_dispatch_async_fun origin_dispatch_async = nil;
    dispatch_once(&onceToken, ^{
        origin_dispatch_async = dlsym(RTLD_DEFAULT, "dispatch_async");
    });
    
    
    if (NULL == origin_dispatch_async) {
        assert(0);
        return;
    }

    
    if (abtest_enable())
    {
        NSString* uuid = [[NSUUID UUID] UUIDString];
        origin_dispatch_async(queue, ^{
            
            if (nil != block)
            {
                [WBGCDModularizeTimeProfiler startTimeStampWithModuleName:moduleName andUUID:uuid];
                block();
                [WBGCDModularizeTimeProfiler stopTimeStampWithUUID:uuid];
            }
            
        });

    }
    else
    {
        origin_dispatch_async(queue, ^{
            if (NULL != block)
            {
                block();
            }
        });

    }

    
    
}

void wb_dispatch_after(dispatch_time_t when, dispatch_queue_t queue, NSString* moduleName, dispatch_block_t block)
{
    static dispatch_once_t onceToken;
    static wb_dispatch_after_fun origin_dispatch_after = nil;
    dispatch_once(&onceToken, ^{
        origin_dispatch_after = dlsym(RTLD_DEFAULT, "dispatch_after");
    });
    
    
    if (nil == origin_dispatch_after) {
        assert(0);
        return;
    }

    
    if (abtest_enable())
    {
        NSString* uuid = [[NSUUID UUID] UUIDString];
        origin_dispatch_after(when, queue, ^{
            
            if (nil != block)
            {
                [WBGCDModularizeTimeProfiler startTimeStampWithModuleName:moduleName andUUID:uuid];
                block();
                [WBGCDModularizeTimeProfiler stopTimeStampWithUUID:uuid];
            }
        });

    }
    else
    {
        origin_dispatch_after(when, queue, ^{
            if (nil != block)
            {
                block();
            }
        });

        
    }

    
    
    
}

static BOOL abtest_enable()
{
    static dispatch_once_t onceToken;
    static BOOL isEnable = NO;
    dispatch_once(&onceToken, ^{
        isEnable = NO;
		NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"global_WBABTestconfiguration"];
		if (nil != dict  &&  [dict isKindOfClass:[NSDictionary class]]){
			isEnable = [dict wbt_boolForKey:KWABTest_GCD defaultValue:NO];
		}
    });
    
    
    return isEnable;
}





