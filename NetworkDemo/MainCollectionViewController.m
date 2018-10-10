//
//  MainCollectionViewController.m
//  NetworkDemo
//
//  Created by 马旭 on 2018/7/22.
//  Copyright © 2018年 马旭. All rights reserved.
//
///galPhoto/?id=1234
#import "MainCollectionViewController.h"
#import "CoverCollectionViewCell.h"
#import "NetManager.h"
#import "UIImageView+WebCache.h"
#import "MXRunloopObserverManager.h"
@interface MainCollectionViewController (){
    NSInteger _page;
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *muData;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger channelId;
@property (nonatomic,strong) NSArray *typeArray;
@property (nonatomic,copy)   NSString *typeStr;
@property (nonatomic,assign) NSInteger changeIndex;
@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray=[NSMutableArray new];
    self.muData=[NSMutableArray new];
    self.typeArray=@[@"2",@"13",@"26",@"14",@"12",@"11"];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"CoverCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.pagingEnabled=YES;
    // Do any additional setup after loading the view.
    [self getDataWithPage:self.page channelid:13 type:@"new"];
    UIButton *bu=[[UIButton alloc] initWithFrame:CGRectMake(10, 40, 60, 60)];
    bu.layer.cornerRadius=30;
    bu.layer.masksToBounds=YES;
    bu.layer.borderWidth=2;
    bu.layer.borderColor=[[UIColor whiteColor] CGColor];
    [bu setTitle:@"换一换" forState:0];
    [bu addTarget:self action:@selector(change) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:bu];
    UIButton *forwordbu=[[UIButton alloc] initWithFrame:CGRectMake(110, 40, 60, 60)];
    forwordbu.layer.cornerRadius=30;
    forwordbu.layer.masksToBounds=YES;
    forwordbu.layer.borderWidth=2;
    forwordbu.layer.borderColor=[[UIColor whiteColor] CGColor];
    [forwordbu setTitle:@"跳一跳" forState:0];
    [forwordbu addTarget:self action:@selector(jump) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:forwordbu];

    [[MXRunloopObserverManager shareManager] addObserver];
}
- (NSInteger)page {
    if (_page==0) {
       NSInteger num= [[[NSUserDefaults standardUserDefaults] objectForKey:@"page"] integerValue];
        if (num<1) {
            num=1;
        }
        _page=num;
    }
    return _page;
}
- (void)setPage:(NSInteger)page {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    _page=page;
}
-(void)change {
    [self.dataArray removeAllObjects];
    self.collectionView.contentOffset=CGPointMake(0, 0);
    self.page=1;
    if (_changeIndex==self.typeArray.count) {
        _changeIndex=0;
    }
    self.channelId=[self.typeArray[_changeIndex] integerValue];
    [self getDataWithPage:self.page channelid:[self.typeArray[_changeIndex] integerValue] type:@"new"];
    _changeIndex++;
}
//- (void)insertData {
//    __weak typeof(self) weakSelf=self;
//    [self.dataArray addObject:[self.muData objectAtIndex:2]];
//    [self.collectionView performBatchUpdates:^{
//        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
//
//    } completion:^(BOOL finished) {
//
//    }];
//}
- (void)jump {
    self.page+=10;
    [self getDataWithPage:_page channelid:[self.typeArray[_changeIndex] integerValue] type:@"new"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   // [self insertData];
   
}
-(NSString *)configUrl:(NSInteger )page
             channelid:(NSInteger)channelid
                  type:(NSString*)type {
    return  [NSString stringWithFormat:@"http://api.kongyouran.com/gallery/?page=%ld&id=%ld&type=%@",(long)page,(long)channelid,type];
}
- (void)getDataWithPage:(NSInteger)page
              channelid:(NSInteger)channelid
                   type:(NSString*)type{
    __weak typeof(self) weaks=self;
    /*            HeadPic = "http://meinvtu-10034978.cossh.myqcloud.com/mete/mete_tt00001.jpg";
     JieID = 251165;
     JieTitle = "\U81ea\U62cd\U793e\U533a";
*/
    [[NetManager shareManager] requstWithUrl:[self configUrl:page channelid:channelid type:type] success:^(id responseObject, NSURLResponse *response) {
        NSLog(@"wcc==%@",responseObject);
        NSArray *arr=[responseObject objectForKey:@"list"];
        NSInteger total=[[responseObject objectForKey:@"total"] integerValue];
        [weaks.muData addObjectsFromArray:arr];
        [weaks.dataArray addObjectsFromArray:arr];
        [weaks.collectionView reloadData];
        
    } failure:^(NSError *error, NSURLResponse *response) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return self.dataArray.count;//
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row<self.dataArray.count) {
        NSDictionary *dic=self.dataArray[indexPath.row];
        if (cell.array.count>0) {
            [cell.array removeAllObjects];
            [cell.panel.collectV reloadData];
        }
        [cell getDetilData:[dic objectForKey:@"JieID"]];
        if (indexPath.row==self.dataArray.count-1) {
            self.page+=1;
            [self getDataWithPage:self.page channelid:_channelId type:@"new"];
        }
    }
   
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
