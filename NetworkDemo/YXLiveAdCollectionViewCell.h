//
//  YXLiveAdCollectionViewCell.h
//  YXLiveVideoApp
//
//  Created by 马旭 on 2018/8/8.
//  Copyright © 2018年 YIXIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLiveAdCollectionViewCell : UICollectionViewCell
@property (nonatomic,retain) UIImageView *cover;
- (void)setCoverWithUrl:(NSString *)url;
@end
