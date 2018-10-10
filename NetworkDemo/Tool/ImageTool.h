//
//  ImageTool.h
//  NetworkDemo
//
//  Created by 马旭 on 2018/9/27.
//  Copyright © 2018年 马旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ImageTool : NSObject
@property (nonatomic,strong) dispatch_queue_t theQueue;
- (void)imageByRedrawWithImage:(UIImage *)originImage size:(CGSize)size redrawFinsh:(void(^)(UIImage *reImage))redrawFinsh;
- (void)imageByRedrawWithImageName:(NSString *)originImageName size:(CGSize)size redrawFinsh:(void(^)(UIImage *reImage))redrawFinsh;
- (void)imageByIOWithImageName:(NSString *)originImageName size:(CGSize)size redrawFinsh:(void(^)(UIImage *reImage))redrawFinsh;
- (void)imageByBitmapWithImageName:(NSString *)originImageName size:(CGSize)size redrawFinsh:(void(^)(UIImage *reImage))redrawFinsh;
@end

NS_ASSUME_NONNULL_END
