//
//  MxLayout.m
//  NetworkDemo
//
//  Created by 马旭 on 2018/8/9.
//  Copyright © 2018年 马旭. All rights reserved.
//

#import "MxLayout.h"

@implementation MxLayout
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr=[self layoutAttributesForItemAtIndexPath:itemIndexPath];
//        if (itemIndexPath.row==0||itemIndexPath.row==1) {
            attr.transform=CGAffineTransformMakeScale(0.01, 0.01);
//        }
    return attr;
}
@end
