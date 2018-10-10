//
//  NetManager.m
//  NetworkDemo
//
//  Created by 马旭 on 2018/7/17.
//  Copyright © 2018年 马旭. All rights reserved.
//
//http://45.32.91.83/album/all?PHPSESSID=dg79u3sjhfdhabgjelt475b2t5&app=Meitu&it=1516103825&pageIndex=1&pageSize=10&styleId=0&type=0&version=1.2
#import "NetManager.h"
static NetManager *_intance;
@implementation NetManager {
    NSMutableData *dataM;
}
+(id)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _intance=[[NetManager alloc] init];
    });
    return _intance;
}
- (void)requstWithUrl:(NSString *)urlStr
              success:(Success)success
              failure:(Failure)failure {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          if (error) {
                                              if (failure) {
                                                  failure(error,response);
                                              }
                                          }else {
                                              if (success) {
                                                  NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      success(dic,response);
                                                  });
                                                  NSLog(@"wcc===%@",dic);
                                                  
                                              }
                                          }
                                          //默认在子线程中解析数据
                                          NSLog(@"%@", [NSThread currentThread]);
                                      }];
    //发送请求（执行Task）
    [dataTask resume];
    
}
- (void)getWithUrl:(NSString *)urlStr domn:(NSString*)urlp{
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    NSMutableDictionary<NSString *, NSString *> *paramToReturn = [NSMutableDictionary new];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull queryItem, NSUInteger idx, BOOL * _Nonnull stop) {
        [paramToReturn setObject:queryItem.value forKey:queryItem.name];
    }];
    NSLog(@"data==%@",paramToReturn);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //    request.HTTPMethod=@"GET";
    //    NSData *dataJ= [NSJSONSerialization dataWithJSONObject:paramToReturn options:NSJSONWritingPrettyPrinted error:nil];
    //    request.HTTPBody=dataJ;
    NSURLSessionConfiguration*configuration= [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.waitsForConnectivity=YES;
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request];
    [dataTask resume];
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [dataM appendData:data];
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    dataM=[NSMutableData data];
    completionHandler(NSURLSessionResponseAllow);
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:dataM options:0 error:nil];
    NSLog(@"wcc===%@",dic);
}
@end
