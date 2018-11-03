//
//  YXLiveAdCollectionViewCell.m
//  YXLiveVideoApp
//
//  Created by 马旭 on 2018/8/8.
//  Copyright © 2018年 YIXIA. All rights reserved.
//

#import "YXLiveAdCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ImageTool.h"
@implementation YXLiveAdCollectionViewCell
- (UIImageView *)cover {
    if (!_cover) {
        _cover=[UIImageView new];
        [_cover  setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _cover.contentMode =  UIViewContentModeScaleAspectFit;
        _cover.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    }
    return _cover;
}
- (id)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        [self.contentView addSubview:self.cover];
//        self.cover.frame=self.contentView.bounds;
        self.cover.frame=CGRectMake(0, 100, 200, 200*3/4);

        self.cover.layer.cornerRadius=4;
        self.cover.layer.masksToBounds=YES;
    }
    return self;
}
- (void)setCoverWithUrl:(NSString *)url {
//    [self.cover sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[self defaultImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//    }];
    ImageTool *tool=[ImageTool new];
    __weak typeof(self) weaks=self;
    __strong typeof(self) strongS=weaks;
   UIImage *image= [tool cutImage:@"test2@2x" imageViewSize:self.cover.frame.size clipRect:CGRectMake(0, 30, CGRectGetWidth(self.cover.bounds), CGRectGetWidth(self.cover.bounds)*3/4)];
    self.cover.image=image;
    //self.cover.bounds.size
//    [tool imageByRedrawWithImageName:@"test2@2x" size:CGSizeMake(100, 75) redrawFinsh:^(UIImage * _Nonnull reImage) {
//        strongS.cover.image=reImage;
//    }];

#if 0
    [tool imageByRedrawWithImageName:@"Yi_Common_loading_default@3x" size:CGSizeMake(100, 100) redrawFinsh:^(UIImage * _Nonnull reImage) {
        strongS.cover.image=reImage;
    }];
    [tool imageByIOWithImageName:@"Yi_Common_loading_default@3x" size:CGSizeMake(100, 100) redrawFinsh:^(UIImage * _Nonnull reImage) {
        strongS.cover.image=reImage;
    }];
    [tool imageByBitmapWithImageName:@"Yi_Common_loading_default@3x" size:CGSizeMake(100, 100) redrawFinsh:^(UIImage * _Nonnull reImage) {
        strongS.cover.image=reImage;
    }];
#endif
}
- (UIImage*)defaultImage {
    return [UIImage new];
}

@end
