//
//  CoverCollectionViewCell.h
//  NetworkDemo
//
//  Created by 马旭 on 2018/7/22.
//  Copyright © 2018年 马旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHorizontalCollectPanel.h"

@interface CoverCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (nonatomic,copy) NSString*jieid;
@property (nonatomic,strong) YXHorizontalCollectPanel *panel;
@property (nonatomic,strong) NSMutableArray *array;
- (void)getDetilData:(NSString *)jeid;
@end
