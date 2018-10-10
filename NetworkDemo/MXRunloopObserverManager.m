//
//  MXRunloopObserverManager.m
//  NetworkDemo
//
//  Created by 马旭 on 2018/10/5.
//  Copyright © 2018年 马旭. All rights reserved.
//

#import "MXRunloopObserverManager.h"
static MXRunloopObserverManager *_instance;
@implementation MXRunloopObserverManager
+(id)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[MXRunloopObserverManager alloc] init];
    });
    return _instance;
}
- (void)addObserver {
    CFRunLoopObserverRef observer=CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"mx---进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"mx---即将处理Timer事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"mx---即将处理Source事件");
                break;
            case kCFRunLoopBeforeWaiting:{
                NSLog(@"mx---即将休眠");
                @autoreleasepool {
                    NSString *str=@"wwwww";
                  @autoreleasepool {
                        
                    }
                    NSLog(@"mx---%@",str);
                }
            }
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"mx---被唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"mx---退出RunLoop");
                break;
                
            default:
                break;
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
}
@end
