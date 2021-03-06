//
//  ImageTool.m
//  NetworkDemo
//
//  Created by 马旭 on 2018/9/27.
//  Copyright © 2018年 马旭. All rights reserved.
//

#import "ImageTool.h"
@implementation ImageTool
- (dispatch_queue_t)theQueue {
    if (!_theQueue) {
        _theQueue=dispatch_queue_create("theImageQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _theQueue;
}
-(UIImage *)imageFromBundleWithName:(NSString *)imageName {
    NSString *thumbFile = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],imageName];
    UIImage *thumbImage = [UIImage imageWithContentsOfFile:thumbFile];
    return thumbImage;
}
- (void)imageByBitmapWithImageName:(NSString *)originImageName size:(CGSize)size redrawFinsh:(void(^)(UIImage *reImage))redrawFinsh{
    dispatch_async(self.theQueue, ^{
        UIImage *oriImage=[self imageFromBundleWithName:originImageName];
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(oriImage.CGImage) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
        if (!context) return ;
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), oriImage.CGImage); // decode
        CGImageRef resultImage = CGBitmapContextCreateImage(context);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (redrawFinsh) {
                redrawFinsh([UIImage imageWithCGImage:resultImage] );
            }
            CFRelease(context);
        });
    });
}
- (void)imageByIOWithImageName:(NSString *)originImageName size:(CGSize)size redrawFinsh:(void(^)(UIImage *reImage))redrawFinsh {
    dispatch_async(self.theQueue, ^{
        NSURL *imageURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:originImageName ofType:@"png"] isDirectory:YES ];
        NSDictionary *option=@{(__bridge id)kCGImageSourceShouldCache:@YES};
        CGImageSourceRef source=CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
        CGImageRef imageRef=CGImageSourceCreateImageAtIndex(source, 0,(__bridge CFDictionaryRef) option);
        UIImage *resultImage=[UIImage imageWithCGImage:imageRef];
        if (!resultImage) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (redrawFinsh) {
                redrawFinsh(resultImage);
            }
            CGImageRelease(imageRef);
            CFRelease(source);
        });

    });
}
/*
 CGFloat rHeight=image.size.width*3/4;
 [image drawInRect:CGRectMake(0, (image.size.height/2-rHeight/2)*rate, image.size.width,rHeight )];

 */
- (UIImage *)cutImage:(NSString *)imageName
        imageViewSize:(CGSize)size
             clipRect:(CGRect)rect {
    UIImage *originImage=[self imageFromBundleWithName:imageName];
   return  [self cutOryImage:originImage imageViewSize:size clipRect:rect];

}
- (UIImage *)cutOryImage:(UIImage *)image
        imageViewSize:(CGSize)size
             clipRect:(CGRect)rect {
    //图片大小和实际显示大小的比例
    CGFloat scale_width = image.size.width/size.width;
    CGFloat scale_height = image.size.height/size.height;
    //实际剪切区域
    CGRect clipRect = CGRectMake(rect.origin.x * scale_width,
                                 rect.origin.y * scale_height,
                                 rect.size.width * scale_width,
                                 rect.size.height * scale_width);
    
    //开启图形上下文
    UIGraphicsBeginImageContext(clipRect.size);
    //画图
    [image drawAtPoint:CGPointMake(-clipRect.origin.x, -clipRect.origin.y)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imageByRedrawWithImageName:(NSString *)originImageName size:(CGSize)size redrawFinsh:(void(^)(UIImage *reImage))redrawFinsh{
    dispatch_async(self.theQueue, ^{
         UIImage *originImage=[self imageFromBundleWithName:originImageName];
        UIGraphicsBeginImageContextWithOptions(originImage.size, NO, 0);
        CGRect rect=CGRectMake(0, 25, size.width, size.height);
       
        CGFloat rHeight=originImage.size.width*3/4;
        CGRect rect2=CGRectMake(0, -(originImage.size.height/2-rHeight/2)*0.78, originImage.size.width, rHeight);

//        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
//        [path addClip];
        [originImage drawInRect:rect2];
 
        UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (redrawFinsh) {
                redrawFinsh(resultImage);
            }
        });
    });
}
- (void)imageByRedrawWithImage:(UIImage *)originImage size:(CGSize)size redrawFinsh:(void(^)(UIImage *reImage))redrawFinsh{
    dispatch_async(self.theQueue, ^{
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGRect rect=CGRectMake(0, 0, size.width, size.height);
        [originImage drawInRect:rect];
        UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (redrawFinsh) {
                redrawFinsh(resultImage);
            }
        });
    });
}
@end
