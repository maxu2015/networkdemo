//
//  YXBottomPageControl.h
//  YXCaptureApp
//
//  Created by 马旭 on 2017/4/12.
//  Copyright © 2017年 YIXIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXBottomPageControl : UIPageControl
@property (nonatomic,assign) BOOL isCusState;
@property (nonatomic,retain) UIImage *selectImage;
@property (nonatomic,retain) UIImage *defaultImage;
@end
