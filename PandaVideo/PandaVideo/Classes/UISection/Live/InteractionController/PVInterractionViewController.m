//
//  PVInterractionViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInterractionViewController.h"
#import "PVInteractiveZBViewController.h"
#import "PVRecommandCollectionViewCell.h"
#import "PVRecommandReusableView.h"
#import "PVReCommandFootReusableView.h"
#import "PVHomeInterractionCell.h"
#import "PVTempletModel.h"
#import "PVBannerModel.h"
#import "PVTextTemplet.h"

static NSString* resuPVHomeInterractionCell = @"resuPVHomeInterractionCell";
static NSString* resuPVRecommandCollectionViewCell = @"resuPVRecommandCollectionViewCell";
static NSString* resuPVHeadRecommandCollectionReusableView = @"PVHeadRecommandCollectionReusableView";
static NSString* resuPVReCommandFootReusableView = @"resuPVReCommandFootReusableView";
static NSString* resuPVRecommandReusableView = @"resuPVRecommandReusableView";

@interface PVInterractionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

///展示模版的CollectView
@property(nonatomic, strong) UICollectionView   *templetCollectView;
@property(nonatomic, strong)NSMutableArray      *templetDataSource;
@property(nonatomic, strong)NSMutableArray* advImages;
///btn模版
@property(nonatomic,strong)UIView* btnView;
@property(nonatomic,strong)NSMutableArray* btnDataSource;
@property(nonatomic,strong)NSMutableArray* imageBtnsDataSource;
///文本模板
@property(nonatomic,strong)PVTextTemplet* textTemplet;
@property(nonatomic,strong)NSMutableArray* textDataSource;

///广播
@property(nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation PVInterractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reminderBtn.hidden = true;
    MJWeakSelf
    self.templetCollectView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
  //  [self.templetCollectView.mj_header beginRefreshing];

//    self.templetCollectView.mj_footer = [PVAnimFooterRefresh footerWithRefreshingBlock:^{
//        [weakSelf getListData];
//    }];
    [self setupUI];
}


-(void)setUrl:(NSString *)url{
    _url = url;
    
    [PVNetTool getDataWithUrl:url success:^(id result) {
        if ([result[@"models"] isKindOfClass:[NSArray class]]) {
            [self.templetDataSource removeAllObjects];
            NSArray* jsonArr = result[@"models"];
            for (NSDictionary* dict in jsonArr) {
                PVTempletModel* templetModel = [[PVTempletModel alloc]  init];
                [templetModel setValuesForKeysWithDictionary:dict];
                [self.templetDataSource addObject:templetModel];
            }
            [self loadTempletData];
        }
        NSLog(@"----result = %@-----",result);
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadTempletData{
    
    if (self.templetDataSource.count == 0)return;
    NSMutableArray* pramas = [NSMutableArray arrayWithCapacity:self.templetDataSource.count];
    for (PVTempletModel* model in self.templetDataSource) {
        PVNetModel* netModel = [[PVNetModel alloc]  initIsGetOrPost:true Url:model.modelUrl param:nil];
        [pramas addObject:netModel];
    }
    [PVNetTool getMoreDataWithParams:pramas success:^(id result) {
        [self.templetCollectView.mj_header endRefreshing];
        if (result != nil) {
            for (int idx=0; idx<self.templetDataSource.count; idx++) {
                NSString* resultKey = [NSString stringWithFormat:@"%d",idx];
                PVTempletModel* templetModel = self.templetDataSource[idx];
                if (templetModel.modelType.integerValue == 1 || templetModel.modelType.integerValue == 2 || templetModel.modelType.integerValue == 3 || templetModel.modelType.integerValue == 21) {
                    id barners = result[resultKey][@"bannerList"];
                    if ([barners isKindOfClass:[NSArray class]]) {
                        [templetModel.modelDataSource removeAllObjects];
                        for (NSDictionary*dict in barners) {
                            PVBannerModel* bannerModel = [[PVBannerModel alloc]  init];
                            [bannerModel setValuesForKeysWithDictionary:dict];
                            [templetModel.modelDataSource addObject:bannerModel];
                        }
                        if (templetModel.modelType.integerValue == 1) {
                            [self.advImages removeAllObjects];
                            [self.advImages addObjectsFromArray:templetModel.modelDataSource];
                        }else if (templetModel.modelType.integerValue == 2){
                            [self.btnDataSource removeAllObjects];
                            [self.btnDataSource addObjectsFromArray:templetModel.modelDataSource];
                        }else if (templetModel.modelType.integerValue == 21){
                            [self.imageBtnsDataSource removeAllObjects];
                            [self.imageBtnsDataSource addObjectsFromArray:templetModel.modelDataSource];
                            [self.imageBtnsDataSource removeObjectAtIndex:0];
                        }else if (templetModel.modelType.integerValue == 3){
                            [self.textDataSource removeAllObjects];
                            [self.textDataSource addObjectsFromArray:templetModel.modelDataSource];
                        }
                    }
                }else{
                    id jsonDict = result[resultKey];
                    PVVideoTemletModel*  videoTemletModel = [[PVVideoTemletModel alloc]  init];
                    [videoTemletModel setValuesForKeysWithDictionary:jsonDict];
                    templetModel.videoTemletModel = videoTemletModel;
                }
            }
            if (self.advImages.count) {
               // [self.pagerView reloadData];
            }
            [self.templetCollectView reloadData];
        }
    } failure:^(NSArray *errors) {
        //提示网络错误
        [self.templetCollectView.mj_header endRefreshing];
    }];
}






- (void)loadData{
    
    int64_t delayInSeconds = 5.0;      // 延迟的时间
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.templetCollectView.mj_header endRefreshing];
    });

}

- (void) getListData{
    
    int64_t delayInSeconds = 5.0;      // 延迟的时间
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.templetCollectView.mj_footer endRefreshing];
    });
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self.appDelegate stopBroadCastPlay];
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.templetCollectView belowSubview:self.scNavigationBar];
    self.templetCollectView.frame = self.view.bounds;
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        PVRecommandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVRecommandCollectionViewCell forIndexPath:indexPath];
        cell.type = 1;
        return cell;
    }
    PVHomeInterractionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVHomeInterractionCell forIndexPath:indexPath];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        PVRecommandReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVRecommandReusableView forIndexPath:indexPath];
        headerView.type = 2;
        if (indexPath.section == 1) {
            headerView.titleLabel.text = @"精彩合集";
        }
        headerView.hidden = false;
        if (indexPath.section == 0){
            headerView.hidden = true;
        }
        return headerView;
    }
    PVReCommandFootReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVReCommandFootReusableView forIndexPath:indexPath];
    footerView.hidden = true;
    return footerView;
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat width = ScreenWidth-20;
    CGFloat height = width*9/16;
    CGFloat margin = 60;
    if (indexPath.section == 1) {
        width = (collectionView.sc_width-30)*0.5;
        height = width*9/16 + margin;
    }
    return CGSizeMake(width,height);
    
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,10,10,10);
}

/// MARK:- ====================== 懒加载 ======================
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (!section) {
        return CGSizeMake(ScreenWidth,0.01);
    }
    return CGSizeMake(ScreenWidth,40);
}
//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (!section) {
        return CGSizeMake(ScreenWidth,10);
    }
    return CGSizeMake(ScreenWidth,0.01);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dictionary = [NSDictionary new];
    // videoType(1:视频 2:直播 3:预告)

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *URLString = @"http://baobab.wdjcdn.com/1457546796853_5976_854x480.mp4";
            dictionary = @{@"videoType":@"1",@"videoUrl":URLString};

        }else if(indexPath.row == 1){
            NSString *URLString = @"http://101.207.176.15/hdlive/sctv1/3.m3u8";
            dictionary = @{@"videoType":@"2",@"videoUrl":URLString};
        }
    }else if(indexPath.section == 1) {
    
        NSString *URLString = @"http://baobab.wdjcdn.com/1457546796853_5976_854x480.mp4";
        dictionary = @{@"videoType":@"1",@"videoUrl":URLString};
    }

    //    NSString *URLString= @"http://101.204.242.38:80/PLTV/88888888/224/3221226843/3.m3u8?icpid=88888888&from=13&hms_devid=3&prioritypopid=13";
    PVInteractiveZBViewController *view = [[PVInteractiveZBViewController alloc] initDictionary:dictionary];
    [self.navigationController pushViewController:view animated:YES];
}

// MARK: - ==============懒加载==============
-(UICollectionView *)templetCollectView{
    if (!_templetCollectView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        layOut.minimumLineSpacing = 5;
        layOut.minimumInteritemSpacing = 5;
        _templetCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
        //设置数据源和代理
        _templetCollectView.delegate = self;
        _templetCollectView.dataSource = self;
        _templetCollectView.backgroundColor = [UIColor whiteColor];
        _templetCollectView.scrollsToTop = true;
        _templetCollectView.showsVerticalScrollIndicator = false;
        _templetCollectView.showsHorizontalScrollIndicator = false;
        _templetCollectView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, kTabBarHeight, 0);
        [_templetCollectView registerNib:[UINib nibWithNibName:@"PVRecommandReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resuPVRecommandReusableView];
        [_templetCollectView registerNib:[UINib nibWithNibName:@"PVReCommandFootReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:resuPVReCommandFootReusableView];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVRecommandCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVRecommandCollectionViewCell];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVHomeInterractionCell" bundle:nil] forCellWithReuseIdentifier:resuPVHomeInterractionCell];

    }
    return _templetCollectView;
}
-(NSMutableArray *)templetDataSource{
    if (!_templetDataSource) {
        _templetDataSource = [NSMutableArray array];
    }
    return _templetDataSource;
}
@end
