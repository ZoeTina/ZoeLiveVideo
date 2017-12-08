//
//  PVChoiceColumnController.m
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVChoiceColumnController.h"
#import "PVTextTemplet.h"
#import "PVRecommandCollectionViewCell.h"
#import "PVRecommandReusableView.h"
#import "PVReCommandFootReusableView.h"
#import "PVHeadRecommandCollectionReusableView.h"
#import "PVLiveTelevisionCell.h"
#import "PVInteractionLiveCell.h"
#import "PVVideoTemmpletCell.h"
#import "PVRankingListCell.h"
#import "PVRankListTwoOrThreeCell.h"
#import "PVRankListfourOrFiveCell.h"
#import "PVStarTempletCell.h"
#import "PVDemandViewController.h"
#import "SCButton.h"
#import "PVSpecialViewController.h"
#import "PVFindHomeViewController.h"
#import "PVHomeViewController.h"
#import "PVVideoTemletModel.h"
#import "PVBannerModel.h"
#import "PVModelTitleDataModel.h"
#import "PVHomeBannerCell.h"
#import "PVPictrueTemmpletCell.h"
#import "PVWebViewController.h"
#import "PVRankingListController.h"
#import "PVChoiceSecondColumnModel.h"
#import "PVBannerCollectionViewCell.h"
#import "PVLeftEqualFlowLayout.h"

CGFloat PVCellMarginWidth = 3;
CGFloat PVCellLeftMarginWidth = 7;

static NSString* resuPVHeadRecommandCollectionReusableView = @"PVHeadRecommandCollectionReusableView";
static NSString* resuPVRecommandReusableView = @"resuPVRecommandReusableView";
static NSString* resuPVRecommandCollectionViewCell = @"resuPVRecommandCollectionViewCell";
static NSString* resuPVReCommandFootReusableView = @"resuPVReCommandFootReusableView";
static NSString* resuPVLiveTelevisionCell = @"resuPVLiveTelevisionCell";
static NSString* resuPVInteractionLiveCell = @"resuPVInteractionLiveCell";
static NSString* resuPVVideoTemmpletCell = @"resuPVVideoTemmpletCell";
static NSString* resuPVRankingListCell = @"resuPVRankingListCell";
static NSString* resuPVRankListTwoOrThreeCell = @"resuPVRankListTwoOrThreeCell";
static NSString* resuPVRankListfourOrFiveCell = @"resuPVRankListfourOrFiveCell";
static NSString* resuPVStarTempletCell = @"resuPVStarTempletCell";
static NSString* resuPVPictrueTemmpletCell = @"resuPVPictrueTemmpletCell";
static NSString* resuPVBannerCollectionViewCell = @"resuPVBannerCollectionViewCell";

@interface PVChoiceColumnController () <UICollectionViewDataSource,UICollectionViewDelegate>

///广告和快捷入口,文本模板的容器
@property(nonatomic,strong)UIView* containerView;
@property(nonatomic, strong)NSMutableArray* advImages;
@property(nonatomic,strong)NSMutableArray* btnDataSource;
@property(nonatomic,strong)NSMutableArray* imageBtnsDataSource;
///文本模板
@property(nonatomic,strong)PVTextTemplet* textTemplet;
@property(nonatomic,strong)NSMutableArray* textDataSource;
///展示模版的CollectView
@property(nonatomic, strong)UICollectionView* templetCollectView;
///纯图片模板数据
@property(nonatomic, strong)PVBannerModel* imageBannerModel;
@property(nonatomic, strong)PVLeftEqualFlowLayout*  leftEqualFlowLayout;

@end

@implementation PVChoiceColumnController


-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self  setupUI];
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navType == 1) {
        CGFloat bottom = kiPhoneX ?  24 : 0;
        self.templetCollectView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, bottom, 0);
        [self.view insertSubview:self.templetCollectView belowSubview:self.scNavigationBar];
    }else if (self.navType == 2){//互动直播
        self.templetCollectView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, kTabBarHeight, 0);
        [self.view addSubview:self.templetCollectView];
    }else if (self.navType == 3){//活动首页
      //  CGFloat bottom = kiPhoneX ?  46 : 22;
        self.templetCollectView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
        [self.view addSubview:self.templetCollectView];
    }else{
    //    CGFloat bottom = kiPhoneX ? (104+kTabBarHeight + 24) : (104+kTabBarHeight);
        CGFloat bottom = kiPhoneX ? (104 + 24) : (104);
        self.templetCollectView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
        [self.view addSubview:self.templetCollectView];
    }
    [self.templetCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(@(0));
        make.width.equalTo(@(ScreenWidth));
    }];
    
    PV(pv)
    self.templetCollectView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [pv loadData];
    }];
    [self.templetCollectView.mj_header beginRefreshing];
}
-(void)setupNavigationBar{
    if (self.navTitle.length) {
       // self.scNavigationItem.title = self.navTitle;
    }
}

-(void)loadData{
    [PVNetTool getDataWithUrl:self.url success:^(id result) {
        if (result) {
            PVChoiceSecondColumnModel *  secondColumnModel = [[PVChoiceSecondColumnModel  alloc]  init];
            [secondColumnModel setValuesForKeysWithDictionary:result];
            self.secondColumnModel = secondColumnModel;
            if (self.navTitle.length) {
                self.scNavigationItem.title = secondColumnModel.baseInfo.name;
            }
        }
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
    } failure:^(NSError *error) {
        [self.templetCollectView.mj_header endRefreshing];
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
        
        NSLog(@" result = %@",result);
        
        [self.templetCollectView.mj_header endRefreshing];
        if (result != nil) {
            for (int idx=0; idx<self.templetDataSource.count; idx++) {
                NSString* resultKey = [NSString stringWithFormat:@"%d",idx];
                PVTempletModel* templetModel = self.templetDataSource[idx];
                
                PV(pv)
                if (templetModel.modelType.integerValue == 14) {//刷新频道
                    [templetModel setUpdateCollectionView:^{
                        [pv.templetCollectView reloadData];
                    }];
                }
                if (templetModel.modelType.integerValue == 1 || templetModel.modelType.integerValue == 2 || templetModel.modelType.integerValue == 3 ||
                    templetModel.modelType.integerValue == 16 ||
                    templetModel.modelType.integerValue == 21) {
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
                        }else if (templetModel.modelType.integerValue == 3){
                            [self.textDataSource removeAllObjects];
                            [self.textDataSource addObjectsFromArray:templetModel.modelDataSource];
                        }else if (templetModel.modelType.integerValue == 16){
                            self.imageBannerModel = templetModel.modelDataSource.firstObject;
                        }
                    }
                }else{
                    id jsonDict = result[resultKey];
                    PVVideoTemletModel*  videoTemletModel = [[PVVideoTemletModel alloc]  init];
                    [videoTemletModel setValuesForKeysWithDictionary:jsonDict];
                    templetModel.videoTemletModel = videoTemletModel;
                }
            }
            self.leftEqualFlowLayout.templetDataSource = self.templetDataSource;
            [self.templetCollectView reloadData];
        }
    } failure:^(NSArray *errors) {
        //提示网络错误
        [self.templetCollectView.mj_header endRefreshing];
    }];
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.templetDataSource.count;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    PVTempletModel* templetModel = self.templetDataSource[section];
    NSInteger type = templetModel.modelType.integerValue;
    NSInteger count = templetModel.videoTemletModel.count;
    if (type == 1 || type == 2 || type == 21) {
        return 1;
    }else if (type == 3){
        return 0;
    }else if (type == 4){
        return (count > 5) ? 5 : count;
    }else if (type == 5){
        return (count > 6) ? 6 : count;
    }else if (type == 6){
        return (count > 5) ? 5 : count;
    }else if (type == 7){
        return (count > 5) ? 5 : count;
    }else if (type == 8){
        return (count > 5) ? 5 : count;
    }else if (type == 9){
        return (count > 5) ? 5 : count;
    }else if (type == 10){///明星
        return 1;
    }else if (type == 11){///立体模板
        return 1;
    }else if (type == 12){
        return (count > 4) ? 4 : count;
    }else if (type == 13){
        return (count > 6) ? 6 : count;
    }else if (type == 14){
        return (count > 3) ? 3 : count;
    }else if (type == 15){
        return (count > 5) ? 5 : count;
    }else if (type == 16){
        return 1;
    }else{
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PVTempletModel* templetModel = self.templetDataSource[indexPath.section];
    NSInteger type = templetModel.modelType.integerValue;
    PV(pv)
    if (type == 1) {
        PVBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVBannerCollectionViewCell forIndexPath:indexPath];
        cell.type = 1;
        [cell setPVBannerCollectionViewCellCallBlock:^(PVBannerModel *bannerModel) {
            [pv jumpBannerListModel:bannerModel];
        }];
        [cell listDataSource:self.advImages];
        return cell;
    }else if (type == 2){
        PVBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVBannerCollectionViewCell forIndexPath:indexPath];
        cell.type = 2;
        [cell setPVBannerCollectionViewCellCallBlock:^(PVBannerModel *bannerModel) {
            [pv jumpBannerListModel:bannerModel];
        }];
        [cell listDataSource:self.btnDataSource];
        return cell;
    }else if (type == 21){
        PVBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVBannerCollectionViewCell forIndexPath:indexPath];
        cell.type = 3;
        [cell setPVBannerCollectionViewCellCallBlock:^(PVBannerModel *bannerModel) {
            [pv jumpBannerListModel:bannerModel];
        }];
        [cell listDataSource:self.imageBtnsDataSource];
        return cell;
    }else if (type == 4) {///2横(小)3竖图模板
        PVRecommandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVRecommandCollectionViewCell forIndexPath:indexPath];
        cell.type = indexPath.item > 1 ? 3 : 1 ;
        cell.modelType = type;
        cell.videoListModel = templetModel.videoTemletModel.videoListModel[indexPath.item];
        
        return cell;
    }else if (type == 5){///6横(小)图模板
        PVRecommandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVRecommandCollectionViewCell forIndexPath:indexPath];
        cell.type = 1;
        cell.modelType = type;
        cell.videoListModel = templetModel.videoTemletModel.videoListModel[indexPath.item];
        return cell;
    }else if (type == 6){///1横(大)4横(小)图模板
        PVRecommandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVRecommandCollectionViewCell forIndexPath:indexPath];
        cell.type = indexPath.item > 0 ? 1 : 0;
        cell.modelType = type;
        cell.videoListModel = templetModel.videoTemletModel.videoListModel[indexPath.item];
        return cell;
    }else if (type == 7){///2横(大)图(活动)模板
        PVRecommandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVRecommandCollectionViewCell forIndexPath:indexPath];
        cell.type = 0;
        cell.modelType = type;
        cell.videoListModel = templetModel.videoTemletModel.videoListModel[indexPath.item];
        return cell;
    }else if (type == 8){///2横(大)图(非活动)模板
        PVRecommandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVRecommandCollectionViewCell forIndexPath:indexPath];
        cell.type = 0;
        cell.modelType = type;
        cell.videoListModel = templetModel.videoTemletModel.videoListModel[indexPath.item];
        return cell;
    }else if (type == 9){///2横(大)图(直播)模板
        PVInteractionLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVInteractionLiveCell forIndexPath:indexPath];
        cell.videoListModel = templetModel.videoTemletModel.videoListModel[indexPath.item];
        return cell;
    }else if (type == 10){///5圆图(明星)模板
        PVStarTempletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVStarTempletCell forIndexPath:indexPath];
        return cell;
    }else if (type == 11){///画廊模板
        PVVideoTemmpletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVVideoTemmpletCell forIndexPath:indexPath];
        cell.videoDataSource =  templetModel.videoTemletModel.videoListModel;
        [cell setPVVideoTemmpletCellCallBlock:^(PVVideoListModel *videoListModel) {
            [pv jumpVideoListModel:videoListModel];
        }];
        return cell;
    }else if (type == 12){///1横(大)3竖(小)模板
        PVRecommandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVRecommandCollectionViewCell forIndexPath:indexPath];
        if (indexPath.item == 0) {
            cell.type = 0;
        }else{
            cell.type = indexPath.item > 0 ? 3 : 1 ;
        }
        cell.modelType = type;
        cell.videoListModel = templetModel.videoTemletModel.videoListModel[indexPath.item];
        return cell;
    }else if (type == 13){///6竖(小)图模板
        PVRecommandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVRecommandCollectionViewCell forIndexPath:indexPath];
        cell.type = 3 ;
        cell.modelType = type;
        cell.videoListModel = templetModel.videoTemletModel.videoListModel[indexPath.item];
        return cell;
    }else if (type == 14){///3横(小)图模板
        NSInteger count = templetModel.videoTemletModel.videoListModel.count;
        PVLiveTelevisionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVLiveTelevisionCell forIndexPath:indexPath];
        if (count >= 3 && indexPath.row == 2) {
            cell.isFirst = false;
            cell.isLast = true;
        }else if (count == 2 && indexPath.row == 1){
            cell.isFirst = false;
            cell.isLast = true;
        }else if (count == 1 && indexPath.row == 0){
            cell.isFirst = true;
            cell.isLast = true;
        }else{
            cell.isFirst = false;
            cell.isLast = false;
        }
        cell.videoListModel = templetModel.videoTemletModel.videoListModel[indexPath.item];
        return cell;
    }else if (type == 15){//1横(大)2横(小)2文本(排行榜)模板
        return [self rankListCell:indexPath];
    }else if (type == 16){//一张纯图片模板
        PVPictrueTemmpletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVPictrueTemmpletCell forIndexPath:indexPath];
        cell.bannerModel = self.imageBannerModel;
        return cell;
    }else{
        return [[UICollectionViewCell alloc]  init];
    }
}

-(UICollectionViewCell*)rankListCell:(NSIndexPath*)indexPath{
    PVTempletModel* templetModel = self.templetDataSource[indexPath.section];
    PVVideoListModel* videoListModel = templetModel.videoTemletModel.videoListModel[indexPath.item];
    if (indexPath.item == 0) {
        PVRankingListCell *cell = [self.templetCollectView dequeueReusableCellWithReuseIdentifier:resuPVRankingListCell forIndexPath:indexPath];
        cell.videoListModel = videoListModel;
        return cell;
    }else if (indexPath.item == 1 || indexPath.item == 2){
        PVRankListTwoOrThreeCell *cell = [self.templetCollectView dequeueReusableCellWithReuseIdentifier:resuPVRankListTwoOrThreeCell forIndexPath:indexPath];
        cell.index = indexPath.item;
        cell.videoListModel = videoListModel;
        cell.isRanking = true;
        return cell;
    }
    PVRankListfourOrFiveCell *cell = [self.templetCollectView dequeueReusableCellWithReuseIdentifier:resuPVRankListfourOrFiveCell forIndexPath:indexPath];
    cell.index = indexPath.item;
    cell.videoListModel = videoListModel;
    return cell;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    PV(pv)
    PVTempletModel* templetModel = self.templetDataSource[indexPath.section];
    NSInteger type = templetModel.modelType.integerValue;
    if (type < 4  || type == 21 || type == 16) {
        if (kind == UICollectionElementKindSectionHeader) {
            if (type == 1) {
                PVHeadRecommandCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVHeadRecommandCollectionReusableView forIndexPath:indexPath];
                headerView.hidden = true;
                return headerView;
            }else if(type == 2){
                PVHeadRecommandCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVHeadRecommandCollectionReusableView forIndexPath:indexPath];
                headerView.hidden = true;
                return headerView;
            }else if(type == 16){
                PVHeadRecommandCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVHeadRecommandCollectionReusableView forIndexPath:indexPath];
                headerView.hidden = true;
                return headerView;
            }else if(type == 21){
                PVHeadRecommandCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVHeadRecommandCollectionReusableView forIndexPath:indexPath];
                headerView.hidden = true;
                return headerView;
            }else if (type == 3){
                PVHeadRecommandCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVHeadRecommandCollectionReusableView forIndexPath:indexPath];
                [self.textTemplet removeFromSuperview];
                self.textTemplet = nil;
                [headerView addSubview:self.textTemplet];
                headerView.hidden = false;
                return headerView;
            }
        }else{
            PVReCommandFootReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVReCommandFootReusableView forIndexPath:indexPath];
            footerView.hidden = true;
            return footerView;
        }
    }
    
    if (kind == UICollectionElementKindSectionHeader) {
        PVRecommandReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVRecommandReusableView forIndexPath:indexPath];
        PVModelTitleDataModel* titleDataModel = templetModel.videoTemletModel.modelTitleDataModel;
        headerView.modelTitleDataModel = titleDataModel;
        headerView.hidden = false;
        if (templetModel.videoTemletModel.modelTitleDataModel.modelTitleType.intValue == 0){
            headerView.hidden = true;
        }else{
            headerView.hidden = false;
        }
        
        [headerView setPVRecommandReusableViewCallBlock:^(ModelWord *modelWord, ClickedType clickedType) {
            PVJumpModel* jumpModel = [[PVJumpModel alloc]  init];
            if (clickedType == ClickedLeft) {
                jumpModel.jumpID = modelWord.modelArrowData.ArrowType;
                jumpModel.jumpVCID = modelWord.modelArrowData.ArrowId;
                jumpModel.jumpUrl = modelWord.modelArrowData.ArrowUrl;
                jumpModel.jumpTitle = modelWord.modelArrowData.ArrowTit;
            }else if (clickedType == ClickedRight){
                jumpModel.jumpID = modelWord.modelKeyData.modelKeyType;
                jumpModel.jumpVCID = modelWord.modelKeyData.modelKeyId;
                jumpModel.jumpUrl = modelWord.modelKeyData.modelKeyUrl;
                jumpModel.jumpTitle = modelWord.modelKeyData.modelKeyTxt;
            }else{
                jumpModel.jumpID = modelWord.modelTitleUrlType;
                jumpModel.jumpVCID = modelWord.modelTitleUrlId;
                jumpModel.jumpUrl = modelWord.modelJumpUrl;
                jumpModel.jumpTitle = modelWord.modelTitleTxt;
            }
            jumpModel.jumpVC = pv;
            jumpModel.secondColumnModel=pv.secondColumnModel;
            PVUniversalJump* universalJump = [[PVUniversalJump alloc]  initPVUniversalJumpWithPVJumpModel:jumpModel];
            [universalJump jumpVniversalJumpVC];
        }];
        return headerView;
    }
    
    ///尾部
    PVReCommandFootReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVReCommandFootReusableView forIndexPath:indexPath];
    footerView.hidden = false;
    if ((!templetModel.videoTemletModel.modelMoreData.modelMore.integerValue && !templetModel.videoTemletModel.hasChangeData.hasChange.integerValue) || templetModel.modelType.intValue == 11) {
        footerView.hidden = true;
    }else{
        footerView.hidden = false;
    }
    footerView.videoTemletModel = templetModel.videoTemletModel;
    
    ModelMoreData*  modelMoreData =  templetModel.videoTemletModel.modelMoreData;
    [footerView setPVReCommandFootReusableViewCallBlock:^(BOOL isCharge) {
        if (isCharge) {//换一换
            NSInteger videoListCount = templetModel.videoTemletModel.videoListModel.count;
            NSInteger itemCount = [pv collectionView:collectionView numberOfItemsInSection:indexPath.section];
            NSMutableArray* videoList = [NSMutableArray arrayWithArray:templetModel.videoTemletModel.videoListModel];
            NSMutableArray* deleteVideoList = [NSMutableArray arrayWithCapacity:itemCount];
            if (videoListCount >= itemCount ) {//开始换
                NSUInteger index = videoListCount-itemCount;
                if (templetModel.modelType.intValue == 11 && videoListCount>3) {//画廊
                    PVVideoTemmpletCell* temmpletCell = (PVVideoTemmpletCell*)[collectionView cellForItemAtIndexPath:indexPath];
                    NSMutableArray *indexArr =  [NSMutableArray arrayWithArray:temmpletCell.pagerView.visibleIndexs];
                    for (NSNumber* index in indexArr) {
                        [deleteVideoList addObject:videoList[index.intValue]];
                    }
                    [videoList removeObjectsInArray:deleteVideoList];
                    [videoList addObjectsFromArray:deleteVideoList];
                }else {
                    index = (index >= itemCount) ?  itemCount : index;
                    if (index == 0) {
                        index = 1;
                    }
                    for (int idx=0; idx<index; idx++) {
                        [deleteVideoList addObject:videoList[idx]];
                    }
                    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, index)];
                    [videoList removeObjectsAtIndexes:indexSet];
                    [videoList addObjectsFromArray:deleteVideoList];
                }
                [templetModel.videoTemletModel.videoListModel removeAllObjects];
                [templetModel.videoTemletModel.videoListModel addObjectsFromArray:videoList];
                NSIndexSet* setSection = [NSIndexSet indexSetWithIndex:indexPath.section];
                [collectionView reloadSections:setSection];
            }
            PVLog(@"换一换");
        }else{//跳转
            PVJumpModel* jumpModel = [[PVJumpModel alloc]  init];
            jumpModel.jumpID = modelMoreData.modelMoreType;
            jumpModel.jumpVCID = modelMoreData.modelMoreId;
            jumpModel.jumpUrl = modelMoreData.modelMoreUrl;
            jumpModel.jumpTitle = modelMoreData.modelMoreTxt;
            jumpModel.jumpVC = pv;
            jumpModel.secondColumnModel=pv.secondColumnModel;
            PVUniversalJump* universalJump = [[PVUniversalJump alloc]  initPVUniversalJumpWithPVJumpModel:jumpModel];
            [universalJump jumpVniversalJumpVC];
        }
    }];
    return footerView;
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //每个item也可以调成不同的大小
    CGFloat margin = 50;
    CGFloat cellVMarginAndLeft = PVCellLeftMarginWidth*2+PVCellMarginWidth;
    CGFloat cellHMarginAndLeft = PVCellLeftMarginWidth*2+PVCellMarginWidth*2;
    CGFloat sectionLeftMargin = PVCellLeftMarginWidth*2;
    CGFloat width = (collectionView.sc_width-cellVMarginAndLeft)*0.5;
    CGFloat heigth = width*9/16 + margin;
    
    PVTempletModel* templetModel = self.templetDataSource[indexPath.section];
    NSInteger type = templetModel.modelType.integerValue;
    if (type == 1) {
        width = ScreenWidth;
        heigth = (ScreenWidth-20)*9/16;
    }else if (type == 2){
        width = ScreenWidth;
        heigth = 80;
    }else if (type == 21){
        width = ScreenWidth;
        heigth = 63;
    }else if (type == 4) {//2横(小)3竖图模板
        width = indexPath.item > 1 ? ((collectionView.sc_width-cellHMarginAndLeft)/3) : ((collectionView.sc_width-cellVMarginAndLeft)*0.5);
        heigth = indexPath.item > 1 ? (width*4/3 + margin) :(width*9/16 + margin);
    }else if (type == 5){//6横(小)图模板
        width = (collectionView.sc_width-cellVMarginAndLeft)*0.5;
        heigth = width*9/16 + margin;
    }else if (type == 6){//1横(大)4横(小)图模板
        width = (indexPath.item == 0)  ? (collectionView.sc_width-sectionLeftMargin) : ((collectionView.sc_width-cellVMarginAndLeft)*0.5);
        heigth = width*9/16 + margin;
    }else if (type == 7){//2横(大)图(活动)模板
        width = collectionView.sc_width-sectionLeftMargin;
        heigth = width*9/16 + margin;
    }else if (type == 8){//2横(大)图(非活动)模板
        width = collectionView.sc_width-sectionLeftMargin;
        heigth = width*9/16 + margin;
    }else if (type == 9){//2横(大)图(直播)模板
        width = collectionView.sc_width-sectionLeftMargin;
        heigth = width*9/16;
    }else if (type == 10){//5圆图(明星)模板
        width = (collectionView.sc_width-40)/5;
        heigth = width + 50;
    }else if (type == 11){//画廊模板
        CGFloat tempMargin = 30;
        width = collectionView.sc_width-sectionLeftMargin;
        heigth = width/3*4/3 + tempMargin + 60;
    }else if (type == 12){//1横(大)3竖(小)模板
        width = indexPath.item == 0 ? (collectionView.sc_width-sectionLeftMargin) : ((collectionView.sc_width-cellHMarginAndLeft)/3);
        heigth = indexPath.item == 0 ? (width*9/16 + margin) : (width*4/3 + margin);
    }else if (type == 13){//6竖(小)图模板
        width = (collectionView.sc_width-cellHMarginAndLeft)/3;
        heigth = width*4/3 + margin;
    }else if (type == 14){//3横(小)图模板
        width = collectionView.sc_width-sectionLeftMargin;
        heigth = IPHONE6WH(85);
    }else if (type == 15){//1横(大)2横(小)2文本(排行榜)模板
        width = collectionView.sc_width-sectionLeftMargin;
        CGFloat tempHeight = (indexPath.item == 1 || indexPath.item == 2) ? IPHONE6WH(80) : IPHONE6WH(55) ;
        heigth = indexPath.item == 0 ? (width*9/16) : tempHeight;
    }else if (type == 16){
        heigth = ScreenWidth*70/350;
        width = ScreenWidth;
    }
    return CGSizeMake((int)width, (int)heigth);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    PVTempletModel* templetModel = self.templetDataSource[section];
    NSInteger type = templetModel.modelType.integerValue;
    if (type == 16) {
        return UIEdgeInsetsMake(0,0,0,0);
    }else{
        return UIEdgeInsetsMake(0,PVCellLeftMarginWidth,0,PVCellLeftMarginWidth);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    PVTempletModel* templetModel = self.templetDataSource[section];
    NSInteger type = templetModel.modelType.integerValue;
    CGFloat width = ScreenWidth;
    CGFloat height = 0.01;
    if (type == 1 || type == 2 || type == 21 ||  type == 16){
        return CGSizeMake(width,0.01);
    }
    if (type >= 4  && templetModel.videoTemletModel.modelTitleDataModel.modelTitleType.intValue == 0) {
        return CGSizeMake(width, height);
    }
    if (type == 3){
        height = 43.0;
    }else{
        height = 43.0;
    }
    return CGSizeMake(width,height);
}
//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    PVTempletModel* templetModel = self.templetDataSource[section];
    NSInteger type = templetModel.modelType.integerValue;
    CGFloat width = ScreenWidth;
    CGFloat height = 0.01;
    if (type == 16){
        return CGSizeMake(width,height);
    }
    if (type < 4 || !templetModel.videoTemletModel.modelTitleDataModel) {
        return CGSizeMake(width, height);
    }else{
        if ((!templetModel.videoTemletModel.modelMoreData.modelMore.integerValue && !templetModel.videoTemletModel.hasChangeData.hasChange.integerValue)) {
            height = 20.0f;
            if (templetModel.modelType.intValue == 11) {
                height = 0.0f;
            }
            if (section == (self.templetDataSource.count-1)){
                height = 0.0f;
            }
        }else{
            height = 43.0f;
        }
    }
    return CGSizeMake(width,height);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PVTempletModel* templetModel = self.templetDataSource[indexPath.section];
    if (templetModel.modelType.intValue == 16) {
        [self jumpBannerListModel:self.imageBannerModel];
    }else{
        PVVideoListModel* videoListModel = templetModel.videoTemletModel.videoListModel[indexPath.item];
        [self jumpVideoListModel:videoListModel];
    }
}

-(void)jumpVideoListModel:(PVVideoListModel*)videoListModel{
    PVJumpModel* jumpModel = [[PVJumpModel alloc]  init];
    jumpModel.jumpID = videoListModel.info.type;
    jumpModel.jumpVCID = videoListModel.info.kId;
    jumpModel.jumpUrl = videoListModel.info.jsonUrl;
    jumpModel.jumpTitle = videoListModel.info.name;
    jumpModel.jumpVC = self;
    jumpModel.secondColumnModel=self.secondColumnModel;
    PVUniversalJump* universalJump = [[PVUniversalJump alloc]  initPVUniversalJumpWithPVJumpModel:jumpModel];
    [universalJump jumpVniversalJumpVC];
}

-(void)jumpBannerListModel:(PVBannerModel*)bannerModel{
    PVJumpModel* jumpModel = [[PVJumpModel alloc]  init];
    jumpModel.jumpID = bannerModel.bannerType;
    jumpModel.jumpVCID = bannerModel.bannerId;
    jumpModel.jumpUrl = bannerModel.bannerUrl;
    jumpModel.jumpTitle = bannerModel.bannerTxt;
    jumpModel.jumpVC = self;
    jumpModel.secondColumnModel=self.secondColumnModel;
    PVUniversalJump* universalJump = [[PVUniversalJump alloc]  initPVUniversalJumpWithPVJumpModel:jumpModel];
    [universalJump jumpVniversalJumpVC];
}


// MARK: - ==============懒加载==============
-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        [_containerView addSubview:self.textTemplet];
        _containerView.frame = CGRectMake(0, 0, ScreenWidth,CGRectGetMaxY(self.textTemplet.frame)-8);
    }
    return _containerView;
}
-(PVTextTemplet *)textTemplet{
    if (!_textTemplet) {
        _textTemplet = [[PVTextTemplet alloc]  initWithScrollTexts:self.textDataSource];
        _textTemplet.frame = CGRectMake(0, 0, ScreenWidth, 43);
        PV(pv)
        [_textTemplet setPVTextTempletCallBlock:^(PVBannerModel *bannerModel) {
            [pv jumpBannerListModel:bannerModel];
        }];
    }
    return _textTemplet;
}
-(NSMutableArray *)btnDataSource{
    if (!_btnDataSource) {
        _btnDataSource  = [NSMutableArray array];
    }
    return _btnDataSource;
}
-(NSMutableArray *)imageBtnsDataSource{
    if (!_imageBtnsDataSource) {
        _imageBtnsDataSource = [NSMutableArray array];
    }
    return _imageBtnsDataSource;
}
-(UICollectionView *)templetCollectView{
    if (!_templetCollectView) {
        PVLeftEqualFlowLayout *layOut = [[PVLeftEqualFlowLayout alloc] init];
        self.leftEqualFlowLayout = layOut;
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        layOut.minimumLineSpacing = PVCellMarginWidth;
        layOut.minimumInteritemSpacing = PVCellMarginWidth;
//        CGRect frame = CGRectMake(0, 1, ScreenWidth, self.view.sc_height-8-41);
        _templetCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
        //设置数据源和代理
        _templetCollectView.delegate = self;
        _templetCollectView.dataSource = self;
        _templetCollectView.backgroundColor = [UIColor whiteColor];
        [_templetCollectView registerClass:[PVHeadRecommandCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resuPVHeadRecommandCollectionReusableView];
        [_templetCollectView registerNib:[UINib nibWithNibName:@"PVRecommandReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resuPVRecommandReusableView];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVRecommandCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVRecommandCollectionViewCell];
        [_templetCollectView registerNib:[UINib nibWithNibName:@"PVReCommandFootReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:resuPVReCommandFootReusableView];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVLiveTelevisionCell" bundle:nil] forCellWithReuseIdentifier:resuPVLiveTelevisionCell];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVInteractionLiveCell" bundle:nil] forCellWithReuseIdentifier:resuPVInteractionLiveCell];
        [_templetCollectView registerClass:[PVVideoTemmpletCell class] forCellWithReuseIdentifier:resuPVVideoTemmpletCell];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVRankingListCell" bundle:nil] forCellWithReuseIdentifier:resuPVRankingListCell];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVRankListTwoOrThreeCell" bundle:nil] forCellWithReuseIdentifier:resuPVRankListTwoOrThreeCell];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVRankListfourOrFiveCell" bundle:nil] forCellWithReuseIdentifier:resuPVRankListfourOrFiveCell];
        [_templetCollectView registerClass:[PVStarTempletCell class] forCellWithReuseIdentifier:resuPVStarTempletCell];
        [_templetCollectView registerClass:[PVPictrueTemmpletCell class] forCellWithReuseIdentifier:resuPVPictrueTemmpletCell];
        [_templetCollectView registerClass:[PVBannerCollectionViewCell class] forCellWithReuseIdentifier:resuPVBannerCollectionViewCell];
        _templetCollectView.scrollsToTop = true;

    }
    return _templetCollectView;
}
-(NSMutableArray<PVTempletModel*> *)templetDataSource{
    if (!_templetDataSource) {
        _templetDataSource = [NSMutableArray array];
    }
    return _templetDataSource;
}
-(NSMutableArray *)textDataSource{
    if (!_textDataSource) {
        _textDataSource = [NSMutableArray  array];
    }
    return _textDataSource;
}
-(NSMutableArray *)advImages{
    if (!_advImages) {
        _advImages = [NSMutableArray array];
    }
    return _advImages;
}
@end
