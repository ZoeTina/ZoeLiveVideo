//
//  PVSpecialDetailViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/10.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSpecialDetailViewController.h"
#import "PVRecommandCollectionViewCell.h"
#import "PVSpecialSecondDetailController.h"
#import "PVSpecialTopicModel.h"

static  NSString* resuPVRecommandCollectionViewCell = @"resuPVRecommandCollectionViewCell";

@interface PVSpecialDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

///展示专题的CollectView
@property(nonatomic, strong)UICollectionView* specialCollectView;
@property(nonatomic, strong)NSMutableArray*   dataSource;
//当前页数
@property(nonatomic, assign)NSInteger currentIndex;
//总页数
@property(nonatomic, assign)NSInteger pageAllIndex;
//请求列表的链接
@property(nonatomic, copy)NSString* listUrl;

@end

@implementation PVSpecialDetailViewController

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    self.currentIndex = 0;
    PV(pv)
    self.specialCollectView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [pv loadData];
    }];
    [self.specialCollectView.mj_header beginRefreshing];
    self.specialCollectView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        if((pv.currentIndex+1) == pv.pageAllIndex)return;
        pv.currentIndex++;
        NSString* url = [pv.listUrl componentsSeparatedByString:@".json"].firstObject;
        NSString* loadUrl = [NSString stringWithFormat:@"%@_%ld.json",url,pv.currentIndex];
        [pv loadListData:loadUrl];
    }];
}

-(void)loadData{
    [self.specialCollectView.mj_footer resetNoMoreData];
    NSString* listUrl = self.topicModel.topicColumnUrl;
    self.listUrl = listUrl;
    [self loadListData:listUrl];
}
-(void)loadListData:(NSString*)listUrl{
    [PVNetTool getDataWithUrl:listUrl success:^(id result) {
        [self.specialCollectView.mj_header endRefreshing];
        [self.specialCollectView.mj_footer endRefreshing];
        if (result[@"topicList"] && [result[@"topicList"] isKindOfClass:[NSArray class]]) {
            NSArray* jsonArr = result[@"topicList"];
            if ([self.listUrl isEqualToString:listUrl]) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary* jsonDict in jsonArr) {
                PVSpecialTopicModel* specialTopicModel = [[PVSpecialTopicModel alloc]  init];
                [specialTopicModel setValuesForKeysWithDictionary:jsonDict];
                [self.dataSource addObject:specialTopicModel];
            }
        }
        if (result[@"currentIndex"]) {
            self.currentIndex = [NSString stringWithFormat:@"%@",result[@"currentIndex"]].integerValue;
        }
        if (result[@"pageAllIndex"]) {
            self.pageAllIndex = [NSString stringWithFormat:@"%@",result[@"pageAllIndex"]].integerValue;
        }
        [self.specialCollectView reloadData];
    } failure:^(NSError *error) {
        if (self.currentIndex != 0) {
            self.currentIndex--;
        }
        [self.specialCollectView.mj_header endRefreshing];
        [self.specialCollectView.mj_footer endRefreshing];
        NSLog(@"--------error---------%@",error);
    }];
}

-(void)setupUI{
    [self.view addSubview:self.specialCollectView];
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PVRecommandCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVRecommandCollectionViewCell forIndexPath:indexPath];
    cell.type = 0;
    cell.isSpecial = true;
    cell.specialTopicModel = self.dataSource[indexPath.item];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PVSpecialSecondDetailController* vc = [[PVSpecialSecondDetailController alloc]  init];
    PVSpecialTopicModel* model = self.dataSource[indexPath.item];
    vc.menuUrl = model.topicUrl;
    [self.navigationController pushViewController:vc animated:true];
}

//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth-20, (ScreenWidth-20)*9/16+55);
}

-(UICollectionView *)specialCollectView{
    if (!_specialCollectView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        layOut.minimumLineSpacing = 5;
        layOut.minimumInteritemSpacing = 5;
        CGRect frame = CGRectMake(1, 1, ScreenWidth, self.view.sc_height-1);
        _specialCollectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layOut];
        //设置数据源和代理
        _specialCollectView.delegate = self;
        _specialCollectView.dataSource = self;
        _specialCollectView.backgroundColor = [UIColor whiteColor];
        [_specialCollectView  registerNib:[UINib nibWithNibName:@"PVRecommandCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVRecommandCollectionViewCell];
        CGFloat bottom = kiPhoneX ? (107 + 64) : 107;
        _specialCollectView.contentInset = UIEdgeInsetsMake(0, 0,bottom , 0);
        _specialCollectView.scrollsToTop = true;
    }
    return _specialCollectView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
