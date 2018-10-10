//
//  WBModularizedGCDProxy.h
//  Pods
//
//  Created by yuxi on 2017/8/21.
//
//

#import <Foundation/Foundation.h>

#ifndef _WBMODULARIZEDGCDPROXY_H_
#define _WBMODULARIZEDGCDPROXY_H_


#ifndef _WEIBOMAINTHREADHOOK_H_

#ifdef __cplusplus
extern "C"{
#endif
void wb_dispatch_sync(dispatch_queue_t queue, NSString* moduleName, DISPATCH_NOESCAPE dispatch_block_t block);
void wb_dispatch_async(dispatch_queue_t queue, NSString* moduleName, dispatch_block_t block);
void wb_dispatch_after(dispatch_time_t when, dispatch_queue_t queue, NSString* moduleName, dispatch_block_t block);
#ifdef __cplusplus
}
#endif

#endif //_WEIBOMAINTHREADHOOK_H_

#endif //_WBMODULARIZEDGCDPROXY_H_
