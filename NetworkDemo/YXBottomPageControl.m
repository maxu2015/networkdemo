//
//  YXBottomPageControl.m
//  YXCaptureApp
//
//  Created by 马旭 on 2017/4/12.
//  Copyright © 2017年 YIXIA. All rights reserved.
//

#import "YXBottomPageControl.h"

@implementation YXBottomPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setNumberOfPages:(NSInteger)numberOfPages {
    [super setNumberOfPages:numberOfPages];
    if (_isCusState) {
        [self configDots];
    }
}
- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    if (_isCusState) {
        [self configDots];
    }
}
- (void)configDots {
    for (int i=0; i<[self.subviews count]; i++) {
        //圆点
        UIView* dot = [self.subviews objectAtIndex:i];
        //添加imageView
        if ([dot.subviews count] == 0) {
            UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 2) ];
            [dot addSubview:view];
        }
        //配置imageView
        UIImageView * view = dot.subviews[0];
        if (i==self.currentPage) {
            view.image=self.selectImage;
//            view.backgroundColor=[UIColor yxt_colorWithHex:@"#FFB71B"];
            dot.backgroundColor = [UIColor clearColor];
        }else {
            view.image=self.defaultImage;
//            view.backgroundColor=[UIColor yxt_colorWithHex:@"#FFFFFF"];
            dot.backgroundColor = [UIColor clearColor];
        }
    }
}
@end
