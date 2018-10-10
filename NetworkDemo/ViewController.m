//
//  ViewController.m
//  NetworkDemo
//
//  Created by 马旭 on 2018/7/17.
//  Copyright © 2018年 马旭. All rights reserved.
//

#import "ViewController.h"
#import "NetManager.h"
#import "MainCollectionViewController.h"
#import "MxLayout.h"
#define   SWIDTH     [UIScreen mainScreen].bounds.size.width
#define   SHEIGHT    [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController
//http://api.kongyouran.com/gallery/?page=1&id=0&type=good
- (void)test {
    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 200, 22)];
    UIView *vb=[[UIView alloc] initWithFrame:CGRectMake(0, 100, 200, 22)];
    vb.backgroundColor=[UIColor blueColor];
    [self.view addSubview:vb];
    
    img.backgroundColor=[UIColor redColor];
    img.image=[UIImage imageNamed:@"Yi_Homepage_Tag_Img_Yellow_Normal@3x"];
    UIImage *mm=[UIImage imageNamed:@"Yi_Homepage_Tag_Img_Yellow_Normal@3x"];
    CGFloat width = mm.size.width / 2.0;
    CGFloat height = mm.size.height / 2.0;
    UIImage *newImage = [mm resizableImageWithCapInsets:UIEdgeInsetsMake(height,width,height,width) resizingMode:UIImageResizingModeStretch];//取正中间一个点，拉伸方式
    img.image=newImage;
    img.layer.anchorPoint=CGPointMake(0.5, 1);
    [self.view addSubview:img];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    MxLayout *flowLayout = [[MxLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SWIDTH, SHEIGHT);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0,0, 0,0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    MainCollectionViewController *vc=[[MainCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    [self.navigationController presentViewController:vc animated:NO completion:^{
        
    }];
//    [self.navigationController  pushViewController:vc animated:YES];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
