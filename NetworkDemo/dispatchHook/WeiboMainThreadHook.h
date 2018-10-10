//
//  WeiboMainThreadHook.h
//  Pods
//
//  Created by yuxi on 2017/8/21.
//
//

#import <Foundation/Foundation.h>

#ifndef _WEIBOMAINTHREADHOOK_H_
#define _WEIBOMAINTHREADHOOK_H_

#ifdef __OBJC__


#ifndef MODULE_NAME
#define MODULE_NAME nil
//# if DEBUG
//#  error "当前模块未定义 CURRENT_MODULE_NAME"
//# endif
#endif

#ifndef DEBUG
#define dispatch_sync(queue, ...)  wb_dispatch_sync((queue), (CURRENT_MODULE_NAME), ( __VA_ARGS__ ))
#define dispatch_async(queue, ...) wb_dispatch_async((queue), (CURRENT_MODULE_NAME), ( __VA_ARGS__ ))
#define dispatch_after(when, queue, ...) wb_dispatch_after((when), (queue), (CURRENT_MODULE_NAME), ( __VA_ARGS__ ))
#endif

#ifdef __cplusplus
extern "C"{
#endif

void wb_dispatch_sync(dispatch_queue_t queue, NSString* moduleName, DISPATCH_NOESCAPE dispatch_block_t block);
    
void wb_dispatch_async(dispatch_queue_t queue, NSString* moduleName, dispatch_block_t block);

void wb_dispatch_after(dispatch_time_t when, dispatch_queue_t queue, NSString* moduleName, dispatch_block_t block);


#ifdef __cplusplus
}
#endif


#endif //__OBJC__

#endif //_WEIBOMAINTHREADHOOK_H_
