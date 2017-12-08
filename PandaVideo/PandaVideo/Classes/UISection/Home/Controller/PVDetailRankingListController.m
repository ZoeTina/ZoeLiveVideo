//
//  PVDetailRankingListController.m
//  PandaVideo
//
//  Created by cara on 17/9/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDetailRankingListController.h"
#import "PVRankListTwoOrThreeCell.h"
#import "PVDemandViewController.h"
#import "PVVideoListModel.h"

static  NSString* resuPVRankListTwoOrThreeCell = @"resuPVRankListTwoOrThreeCell";

@interface PVDetailRankingListController () <UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property(nonatomic, strong)UICollectionView* specialCollectView;
@property(nonatomic, strong)NSMutableArray*   dataSource;
//当前页数
@property(nonatomic, assign)NSInteger currentIndex;
//总页数
@property(nonatomic, assign)NSInteger pageAllIndex;
//请求列表的链接
@property(nonatomic, copy)NSString* listUrl;

@end

@implementation PVDetailRankingListController

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

-(void)setupUI{
    [self.view addSubview:self.specialCollectView];
}

-(void)loadData{
    [PVNetTool getDataWithUrl:self.url success:^(id result) {
        [self.specialCollectView.mj_footer resetNoMoreData];
        if (result[@"models"] && [result[@"models"] isKindOfClass:[NSArray class]]) {
            NSArray* jsonArr = result[@"models"];
            NSDictionary* jsonDict = jsonArr.firstObject;
            NSString* listUrl = jsonDict[@"modelUrl"];
            self.listUrl = listUrl;
            [self loadListData:listUrl];
        }
    } failure:^(NSError *error) {
        [self.specialCollectView.mj_header endRefreshing];
    }];
}

-(void)loadListData:(NSString*)url{
    [PVNetTool getDataWithUrl:url success:^(id result) {
        [self.specialCollectView.mj_header endRefreshing];
        [self.specialCollectView.mj_footer endRefreshing];
        if (result[@"videoList"] && [result[@"videoList"] isKindOfClass:[NSArray class]]) {
            NSArray* jsonArr = result[@"videoList"];
            if ([self.listUrl isEqualToString:url]) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary* jsonDict in jsonArr) {
                PVVideoListModel* videoListModel = [[PVVideoListModel alloc]  init];
                [videoListModel setValuesForKeysWithDictionary:jsonDict];
                [self.dataSource addObject:videoListModel];
            }
            [self.specialCollectView reloadData];
        }
        if (result[@"currentIndex"]) {
            self.currentIndex = [NSString stringWithFormat:@"%@",result[@"currentIndex"]].integerValue;
        }
        if (result[@"pageAllIndex"]) {
            self.pageAllIndex = [NSString stringWithFormat:@"%@",result[@"pageAllIndex"]].integerValue;
        }
    } failure:^(NSError *error) {
        if (self.currentIndex != 0) {
            self.currentIndex--;
        }
        [self.specialCollectView.mj_header endRefreshing];
        [self.specialCollectView.mj_footer endRefreshing];
    }];
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
    
    PVRankListTwoOrThreeCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVRankListTwoOrThreeCell forIndexPath:indexPath];

    cell.index = indexPath.item;
    cell.isRanking = true;
    cell.videoListModel = self.dataSource[indexPath.item];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
    PVVideoListModel* model = self.dataSource[indexPath.item];
    vc.url = model.info.jsonUrl;
    [self.navigationController pushViewController:vc animated:true];
}

//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat  width = collectionView.sc_width-15;
    return CGSizeMake(width, IPHONE6WH(80));
}

-(UICollectionView *)specialCollectView{
    if (!_specialCollectView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        layOut.minimumLineSpacing = 5;
        layOut.minimumInteritemSpacing = 5;
        CGRect frame = CGRectMake(1, 1, ScreenWidth, self.view.sc_height-1);
        _specialCollectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layOut];
        CGFloat bottom = kiPhoneX ? 34 : 1;
        _specialCollectView.sc_height = self.view.sc_height-bottom;
        //设置数据源和代理
        _specialCollectView.delegate = self;
        _specialCollectView.dataSource = self;
        _specialCollectView.backgroundColor = [UIColor whiteColor];
        [_specialCollectView  registerNib:[UINib nibWithNibName:@"PVRankListTwoOrThreeCell" bundle:nil] forCellWithReuseIdentifier:resuPVRankListTwoOrThreeCell];
        CGFloat bottom_height = kiPhoneX ? 101 : 67;
        _specialCollectView.contentInset = UIEdgeInsetsMake(0, 0, bottom_height, 0);
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
