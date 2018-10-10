//
//  CoverCollectionViewCell.m
//  NetworkDemo
//
//  Created by 马旭 on 2018/7/22.
//  Copyright © 2018年 马旭. All rights reserved.
//
//galPhoto/?id=1234
#import "CoverCollectionViewCell.h"
#import "NetManager.h"
#import "YXLiveAdCollectionViewCell.h"
#define   SWIDTH     [UIScreen mainScreen].bounds.size.width
#define   SHEIGHT    [UIScreen mainScreen].bounds.size.height
@implementation CoverCollectionViewCell
/*
 wcc=={
 JieID = 251165;
 ListContent =     (
 "http://meinvtu-10034978.cossh.myqcloud.com/mete/mete_tt00001.jpg",
 "http://meinvtu-10034978.cossh.myqcloud.com/mete/mete_tt00002.jpg",
 "http://meinvtu-10034978.cossh.myqcloud.com/mete/mete_tt00003.jpg",
 "http://meinvtu-10034978.cossh.myqcloud.com/mete/mete_tt00004.jpg",
 "http://meinvtu-10034978.cossh.myqcloud.com/mete/mete_tt00005.jpg",
 "http://meinvtu-10034978.cossh.myqcloud.com/mete/mete_tt00006.jpg"
 );
 title = "\U81ea\U62cd\U793e\U533a";
 }*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor=[UIColor grayColor];
    [self createPanle];
}
- (NSMutableArray *)array{
    if (!_array) {
        _array=[NSMutableArray new];
    }
    return _array;
}
- (void)getDetilData:(NSString *)jeid {
    __weak typeof(self) weaks=self;
  
    [[NetManager shareManager] requstWithUrl:[NSString stringWithFormat:@"http://api.kongyouran.com/galPhoto/?id=%@",jeid] success:^(id responseObject, NSURLResponse *response) {
        NSLog(@"wcc==%@",responseObject);
        NSArray *arr=[responseObject objectForKey:@"ListContent"];
        if (arr&&arr.count>0) {
            [weaks.array addObjectsFromArray:arr];
            [weaks.panel.collectV reloadData];
        }
//        NSInteger total=[[responseObject objectForKey:@"total"] integerValue];
//        [weaks.muData addObjectsFromArray:arr];
//        [weaks.dataArray addObjectsFromArray:arr];
//        [weaks.collectionView reloadData];
    } failure:^(NSError *error, NSURLResponse *response) {
        
    }];
}
- (void)createPanle {
    _panel=[[YXHorizontalCollectPanel alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT) edgeInset:UIEdgeInsetsMake(0, 9, 0, 9)];
    [_panel setPageControlHide:YES];
    _panel.collectV.bounces=NO;
    _panel.isDontComplementCollect=YES;
    _panel.collectV.pagingEnabled=NO;
    [self.contentView addSubview:_panel];
    _panel.minimumLineSpacing=9;
    _panel.minimumInteritemSpacing=9;
    [_panel configCollectPanelFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT) edgeInset:UIEdgeInsetsMake(0, 9, 0, 9) lineCount:1 rowCount:1 collectionCellName:@"YXLiveAdCollectionViewCell" reuseIdentifier:@"YXLiveAdCollectionViewCell"];
    __weak typeof(self) weaks=self;

    [_panel collectNumber:^NSInteger{
        return weaks.array.count;
    }];
    [_panel setCellForCollect:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath, NSInteger dataIndex) {
        NSString *url=weaks.array[indexPath.row];
YXLiveAdCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"YXLiveAdCollectionViewCell" forIndexPath:indexPath];
        [cell setCoverWithUrl:url];
        return cell;
    }];
}
@end
