//
//  NetManager.h
//  NetworkDemo
//
//  Created by 马旭 on 2018/7/17.
//  Copyright © 2018年 马旭. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef void(^Success)(id responseObject,NSURLResponse *response);
typedef void(^Failure)(NSError *error,NSURLResponse *response);




@interface NetManager : NSObject<NSURLSessionDataDelegate,NSURLSessionTaskDelegate,NSURLSessionDelegate>
+(id)shareManager;
- (void)requstWithUrl:(NSString *)urlStr
              success:(Success)success
              failure:(Failure)failure;
- (void)getWithUrl:(NSString *)urlStr domn:(NSString*)urlp;
- (void)newGetWithUrl:(NSString *)urlStr;
@end
