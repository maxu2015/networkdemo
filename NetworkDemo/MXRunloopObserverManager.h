//
//  MXRunloopObserverManager.h
//  NetworkDemo
//
//  Created by 马旭 on 2018/10/5.
//  Copyright © 2018年 马旭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXRunloopObserverManager : NSObject
- (void)addObserver;
+(id)shareManager;
@end

NS_ASSUME_NONNULL_END
