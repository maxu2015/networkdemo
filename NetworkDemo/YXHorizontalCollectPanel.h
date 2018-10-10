//
//  YXCollectPanel.h
//  YXCollectView
//
//  Created by 马旭 on 16/11/11.
//  Copyright © 2016年 马旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXBottomPageControl.h"
typedef UICollectionViewCell *(^CellForCollect)(UICollectionView *collectionView,NSIndexPath* indexPath,NSInteger dataIndex);

typedef void(^CollectDidSelect)(NSIndexPath* indexPath,NSInteger dataIndex);
typedef NSInteger(^CollectNum)(void);
@interface YXHorizontalCollectPanel : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,retain) UICollectionView *collectV;
@property (nonatomic,assign) BOOL isDontComplementCollect;
@property (nonatomic,assign) CGFloat lineCount;//列数
@property (nonatomic,assign) NSInteger rowCount;//行数
@property (nonatomic,retain) YXBottomPageControl *pageV;
@property (nonatomic,copy) CellForCollect cellForCollect;
@property (nonatomic,copy) CollectDidSelect collectDidSelect;
@property (nonatomic,copy) CollectNum collectNumber;
@property (nonatomic,retain) UICollectionViewFlowLayout * layout;
@property (nonatomic,assign) CGFloat minimumInteritemSpacing;
@property (nonatomic,assign) CGFloat minimumLineSpacing;

- (id)initWithFrame:(CGRect)frame edgeInset:(UIEdgeInsets)edgeInset;
- (void)setCellForCollectBlock:(CellForCollect)cellForCollect;
- (void)collectDidSelect:(CollectDidSelect)selecter;
- (void)collectNumber:(CollectNum)collectNumber;
- (void)configCollectPanelTotal:(NSInteger)total
                     panelFrame:(CGRect)panelFrame
                      edgeInset:(UIEdgeInsets)edgeInset
                      lineCount:(CGFloat)lineCount
                       rowCount:(NSInteger)rowCount
             collectionCellName:(NSString *)collectionCellName
                reuseIdentifier:(NSString *)reuseIdentifier
                 cellForCollect:(CellForCollect)cellForCollect ;
- (void)configCollectPanelFrame:(CGRect)panelFrame
                      edgeInset:(UIEdgeInsets)edgeInset
                      lineCount:(CGFloat)lineCount
                       rowCount:(NSInteger)rowCount
             collectionCellName:(NSString *)collectionCellName
                reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setPageControlHide:(BOOL)isHide;
- (void)setPageCenterYtoBottom:(CGFloat)centerY;
@end
