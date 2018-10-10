//
//  YXCollectPanel.m
//  YXCollectView
//
//  Created by 马旭 on 16/11/11.
//  Copyright © 2016年 马旭. All rights reserved.
//

#import "YXHorizontalCollectPanel.h"
#import <objc/runtime.h>
@implementation YXHorizontalCollectPanel {
    CGRect _panelFrame;
    UIEdgeInsets _edgeInset;
    CGFloat cellWidth;
    CGFloat cellHight;
    NSInteger _pageCount;
    NSInteger _dataTotal;
}
- (id)init {
    if (self= [super init]) {
        [self createcollection];
        
    }
//    self.backgroundColor=[UIColor clearColor];
    return self;
}
- (id)initWithFrame:(CGRect)frame edgeInset:(UIEdgeInsets)edgeInset {
    if (self=[super initWithFrame:frame]) {
        _panelFrame=frame;
        _edgeInset=edgeInset;
        [self createcollection];
        //        [self addSubview:[self collectionConfig:_collectV]];
    }
    return self;
}
- (void)configCollectPanelFrame:(CGRect)panelFrame
                      edgeInset:(UIEdgeInsets)edgeInset
                      lineCount:(CGFloat)lineCount
                       rowCount:(NSInteger)rowCount
             collectionCellName:(NSString *)collectionCellName
                reuseIdentifier:(NSString *)reuseIdentifier{
    [self configCollectPanelTotal:0 panelFrame:panelFrame edgeInset:edgeInset lineCount:lineCount rowCount:rowCount collectionCellName:collectionCellName reuseIdentifier:reuseIdentifier cellForCollect:nil];

}
- (void)setCellForCollectBlock:(CellForCollect)cellForCollect{
    if (cellForCollect) {
        _cellForCollect=cellForCollect;
    }
}
- (void)configCollectPanelTotal:(NSInteger)total
                     panelFrame:(CGRect)panelFrame
                      edgeInset:(UIEdgeInsets)edgeInset
                      lineCount:(CGFloat)lineCount
                       rowCount:(NSInteger)rowCount
             collectionCellName:(NSString *)collectionCellName
                reuseIdentifier:(NSString *)reuseIdentifier
                 cellForCollect:(CellForCollect)cellForCollect {
    if (cellForCollect) {
        _cellForCollect=cellForCollect;
    }
    _panelFrame=panelFrame;
    self.frame=panelFrame;
    _edgeInset=edgeInset;
    _dataTotal=total;
    _lineCount=lineCount;
    _rowCount=rowCount;
#pragma mark debug 稍后修改
    _pageV.center=CGPointMake(_panelFrame.size.width/2, _panelFrame.size.height-20);
    [self collectionConfig:_collectV collectionCellName:collectionCellName reuseIdentifier:reuseIdentifier];
}
-(void)setPageCenterYtoBottom:(CGFloat)centerY {
    _pageV.center=CGPointMake(_panelFrame.size.width/2, _panelFrame.size.height-centerY);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self setPage:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setPage:scrollView];
}
- (void)setPage:(UIScrollView *)scrollView {
    NSInteger last=(NSInteger)(scrollView.contentOffset.x)%(NSInteger)([[UIScreen mainScreen] bounds].size.width);
    NSInteger index;
    if (last==0) {
        index=scrollView.contentOffset.x/([[UIScreen mainScreen] bounds].size.width);
    }else {
        index=scrollView.contentOffset.x/([[UIScreen mainScreen] bounds].size.width)+1;
    }
    [_pageV setCurrentPage:index];
}
- (NSInteger)pageCount:(NSInteger )all eachSectionNum:(NSInteger)eachNum {
    NSInteger lastNum=all%eachNum;
    if (lastNum!=0) {
        return all/eachNum+1;
    }else {
        return all/eachNum;
    }
}
- (void)createcollection {
    
        _layout = [[UICollectionViewFlowLayout alloc]init];
    _collectV=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,0,0)collectionViewLayout:_layout];

    _collectV.collectionViewLayout=_layout;
    [self addSubview:_collectV];
    _pageV=[[YXBottomPageControl alloc]initWithFrame:CGRectMake(0, 0, 50, 10)];
    [self addSubview:_pageV];
    _collectV.backgroundColor=[UIColor clearColor];
}
- (void)setPageControlHide:(BOOL)isHide {
   _pageV.alpha= isHide ? 0:1;
}
- (UICollectionView *)collectionConfig:(UICollectionView *)collect
                    collectionCellName:(NSString *)collectionCellname
                       reuseIdentifier:(NSString *)reuseIdentifier{
    _layout.scrollDirection =
    UICollectionViewScrollDirectionHorizontal;
    
    CGFloat width=_panelFrame.size.width-_edgeInset.left-_edgeInset.right;
    cellWidth=width/_lineCount;
    CGFloat hight=_panelFrame.size.height-_edgeInset.bottom-_edgeInset.top;
    cellHight=(hight-_rowCount*0.5)/_rowCount;

    _layout.itemSize = CGSizeMake(cellWidth, cellHight);
    _layout.minimumInteritemSpacing=_minimumInteritemSpacing;
    _layout.minimumLineSpacing = _minimumLineSpacing;
    collect.frame=CGRectMake(_edgeInset.left, _edgeInset.top, width, hight);
    collect.collectionViewLayout=_layout;
#pragma mark debug
    collect.delegate=self;
    collect.dataSource=self;
//    collect.pagingEnabled=YES;
    const char *classname=[collectionCellname cStringUsingEncoding:NSASCIIStringEncoding];
    //根据类名获取类
    Class newClass = objc_getClass(classname);
    [collect registerClass:[newClass class] forCellWithReuseIdentifier:reuseIdentifier];
    collect.showsHorizontalScrollIndicator=NO;
    return collect;
}
- (void)collectNumber:(CollectNum)collectNumber {
    _collectNumber=collectNumber;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_collectNumber) {
        _dataTotal=_collectNumber();
    }
    _pageCount=[self pageCount:_dataTotal eachSectionNum:_lineCount*_rowCount];
    [_pageV setNumberOfPages:_pageCount];
    if (_isDontComplementCollect) {
        return _dataTotal;
    }
    return _pageCount*_lineCount*_rowCount;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.layout){
       return  UIEdgeInsetsMake(self.layout.sectionInset.top, self.layout.sectionInset.left, self.layout.sectionInset.bottom, self.layout.sectionInset.right);
    }
    return  UIEdgeInsetsMake(0, 0, 0, 0);
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(cellWidth, cellHight);
//}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell=nil;
    NSInteger dataIndex=[self cellIndex:indexPath];
    
    if (_cellForCollect) {
        cell=_cellForCollect(collectionView,indexPath,dataIndex);
    }
    if (dataIndex>_dataTotal-1) {
//        cell.contentView.alpha=0;
    }
    return cell;
}
- (void)collectDidSelect:(CollectDidSelect)selecter{
    _collectDidSelect=selecter;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_collectDidSelect) {
        NSInteger dataIndex=[self cellIndex:indexPath];

        _collectDidSelect(indexPath,dataIndex);
    }
}
//数据横向转向
- (NSInteger)cellIndex:(NSIndexPath *)indexPath {
    NSInteger eachPageCount=_rowCount*_lineCount;
    NSInteger currentPage = indexPath.row/eachPageCount;
    NSInteger lastIndex = indexPath.row%eachPageCount;
    NSInteger lineX= lastIndex/_rowCount;
    NSInteger rowY= lastIndex%_rowCount;
    NSInteger startIndex =0;
    startIndex=_lineCount*rowY+lineX+currentPage*eachPageCount;
    return startIndex;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
