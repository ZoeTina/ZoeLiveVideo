//
//  PVDemandViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDemandViewController.h"
#import "PVDemandRecommandTableViewCell.h"
#import "PVDemandTableHeadView.h"
#import "PVDemandTableFootView.h"
#import "PVDemandStarTableViewCell.h"
#import "PVCommentCountTableViewCell.h"
#import "PVCommentTableHeadView.h"
#import "PVCommentTableViewCell.h"
#import "PVCommentFooterTableView.h"
#import "PVToolView.h"
#import "PVFindCommentModel.h"
#import "PVVideoInformationTableViewCell.h"
#import "PVDemandVideoDetailModel.h"
#import "PVDemandAnthologyTableViewCell.h"
#import "PVAnthologyViewController.h"
#import "PVStarViewController.h"
#import "PVStarDetailViewController.h"
#import "PVRecommandVideoController.h"
#import "PVVideoMoreView.h"
#import "PVVideoShareView.h"
#import "PVVideoDefinitionView.h"
#import "PVVideoDemandAnthologyController.h"
#import "BarrageView.h"
#import "BarrageModel.h"
#import "PVBarrageCell.h"
#import "PVDemandVideoDetailModel.h"
#import "PVDemandVideoAnthologyModel.h"
#import "PVDemandCommentModel.h"
#import "PVTelevisionCloudPlayController.h"
#import "PVDemandImagesCell.h"
#import "PVDBManager.h"
#import "PVLoginViewController.h"
#import "PVDemandInfoDetailController.h"
#import "PVUniversalJump.h"
#import "PVShareViewController.h"
#import "PVDemandSystemVideoModel.h"
#import "PVShareTool.h"

#define videoMoreHeight  342*CaraScreenH/1334

#define CellSection  7
#define SectionIndex  6

static NSString* resuPVDemandTableHeadView = @"resuPVDemandTableHeadView";
static NSString* resuPVDemandRecommandTableViewCell = @"resuPVDemandRecommandTableViewCell";
static NSString* resuPVDemandStarTableViewCell = @"resuPVDemandStarTableViewCell";
static NSString* resuPVDemandTableFootView = @"resuPVDemandTableFootView";
static NSString* resuPVCommentCountTableViewCell = @"resuPVCommentCountTableViewCell";
static NSString* resuPVCommentTableHeadView = @"resuPVCommentTableHeadView";
static NSString* resuPVCommentTableViewCell = @"resuPVCommentTableViewCell";
static NSString* resuPVCommentFooterTableView = @"resuPVCommentFooterTableView";
static NSString* resuPVVideoInformationTableViewCell = @"resuPVVideoInformationTableViewCell";
static NSString* resuPVDemandAnthologyTableViewCell = @"resuPVDemandAnthologyTableViewCell";
static NSString* resuPVDemandImagesCell = @"resuPVDemandImagesCell";


@interface PVDemandViewController ()  <UITableViewDataSource,UITableViewDelegate,VideoPlayerViewDelegate,BarrageViewDataSouce, BarrageViewDelegate>

///视频播放容器
@property(nonatomic, strong)UIView* videoContainerView;
///视频信息表格
@property(nonatomic, strong)UITableView* videoTableView;
///评论工具条
@property(nonatomic, strong)PVToolView* toolView;
///评论数据源
@property(nonatomic, strong)NSMutableArray* commentDataSource;
///视频简介数据模型
@property(nonatomic, strong)PVDemandVideoDetailModel* videoDetailModel;
///视频最初模型
@property(nonatomic, strong)PVDemandVideoDetailModel* fristVideoDetailModel;
///处理键盘的遮盖
@property(nonatomic, strong)UIButton* keyBoradCoverBtn;
///选集控制页面
@property(nonatomic, strong)PVAnthologyViewController* anthologyController;
///相关明星页面
@property(nonatomic, strong)PVStarViewController* starViewController;
///推荐页面
@property(nonatomic, strong)PVRecommandVideoController* recommandController;
///更多
@property(nonatomic, strong)PVVideoMoreView* videoMoreView;
///分享
@property(nonatomic, strong)PVVideoShareView* videoShareView;
///清晰度
@property(nonatomic, strong)PVVideoDefinitionView* videoDefinitionView;
///选集
@property(nonatomic, strong)PVVideoDemandAnthologyController* videoDemandAnthologyController;
///电视云控制器
@property(nonatomic, strong)PVTelevisionCloudPlayController* televisionCloudPlayController;
///电视云控制器
@property(nonatomic, strong)PVTelevisionCloudPlayController* crossTelevisionCloudPlayController;
///弹幕
@property(nonatomic, strong)BarrageView* barrageView;
///弹幕数据源
@property(nonatomic, strong)NSMutableArray* barrageDataSource;
///遮盖
@property(nonatomic, strong)UIButton* coverBtn;
///是否更新剧集信息
@property(nonatomic, assign)BOOL isUpdateInfo;
///需要更新的集数
@property(nonatomic, strong)PVDemandVideoAnthologyModel* anthologyModel;
///选集的collectionView
@property(nonatomic, strong)UICollectionView* anthologyCollectionView;
///本控制器返回按钮，而不是播放器上面的按钮
@property(nonatomic, strong)UIButton* backBtn;
///评论的页数
@property(nonatomic, assign)NSInteger page;
///是否在请求评论数据中
@property(nonatomic, assign)BOOL isRequestCommentIng;
///临时变量
@property(nonatomic, strong)NSMutableArray* test1DataSource;
///覆盖黑挡板
@property(nonatomic, strong)UIView* bottomView;
///是否为小编推荐请求
@property(nonatomic, assign)BOOL isXiaoBianRecommendation;
///评论总数
@property(nonatomic, copy)NSString* commentCount;
///记录上一次多集的单集
@property(nonatomic, strong)PVDemandVideoAnthologyModel* recordAnthologyModel;
///剧集展示类型
@property(nonatomic, copy)NSString*  showModelType;
@property(nonatomic, assign)BOOL isShowFive;
///系统推荐视频
@property(nonatomic, strong)NSMutableArray<PVDemandSystemVideoModel*>* systemVideoDataSource;
///选中的评论
@property(nonatomic, strong)PVFindCommentModel *commentMode;
///评论页数
@property(nonatomic, assign)NSInteger commentPage;

@end

@implementation PVDemandViewController

-(void)dealloc{
    [PVNetTool cancelCurrentRequest];
    [self.playView.playControView videoStop];
    self.playView.playControView = nil;
    self.recordAnthologyModel = self.anthologyModel;
    [self commintUserPlayRecord];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTopView.hidden = true;
    self.showModelType = @"1";
    self.page = -1;
    self.commentPage = 1;
//    if (self.continuePlayVideoSecond.length) {
//        self.isScroll = true;
//    }else{
//        self.isScroll = false;
//    }
    [self setupUI];
    [self loadData];
}

-(void)reLoadVCData{
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:false];
    self.scNavigationBar.hidden = true;
    if (self.playView.player.currentPlaybackTime > 0) {
        [self.playView.playControView videoPlay];
    }else{//之后处理
        [self.playView changeCurrentplayerItemWithPlayVideoModel:self.playView.playVideoModel];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:false];
    if (self.playView.player.currentPlaybackTime > 0) {
        [self.playView.playControView videoPause];
    }else if (self.playView.player){
        [self.playView.playControView.player shutdown];
        [self.playView.playControView.player stop];
        [self.playView.playControView.player.view removeFromSuperview];
        self.playView.playControView.player = nil;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.scNavigationBar.hidden = false;
}

-(void)setupUI{
    self.toolView.commentType = 0;
    bool isIphoneX = (self.scNavigationBar.sc_height == 88.0) ? true : false;
    CGFloat y = isIphoneX ? (ScreenWidth*9/16 + 24) : ScreenWidth*9/16;
    self.videoTableView.hidden = self.toolView.hidden = true;
    self.bottomView = [[UIView alloc]  init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.frame = CGRectMake(0, y, ScreenWidth, ScreenHeight-y);
    [self.view insertSubview:self.bottomView belowSubview:self.reminderBtn];
    self.view.backgroundColor = [UIColor blackColor];
    self.reminderBtn.backgroundColor = [UIColor whiteColor];

    self.reminderBtn.frame = CGRectMake(0, y, ScreenWidth, ScreenHeight-y);
    //[self.view addSubview:self.videoContainerView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.videoTableView];
    [self.view addSubview:self.toolView];
    [self.view insertSubview:self.keyBoradCoverBtn belowSubview:self.toolView];
    PV(pv)
    self.videoTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [pv loadMoreComment];
    }];
    
    //获取通知中心
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //注册为被通知者
    [notificationCenter addObserver:self selector:@selector(keyChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

-(void)loadData{
    if (!self.url.length)return;
    [PVNetTool cancelCurrentRequest];
    [PVNetTool getDataWithUrl:self.url success:^(id result) {
        if (result != nil) {
            PVDemandVideoDetailModel* detailModel = [[PVDemandVideoDetailModel alloc]  init];
            [detailModel setValuesForKeysWithDictionary:result];
            self.videoDetailModel = detailModel;
            if (self.videoDetailModel.videoType.integerValue == 0 && [self.view isShowingOnKeyWindow]) {
                [self.videoDetailModel calculationVideoInfoHeight];
                if (self.isXiaoBianRecommendation) {//切换
                    self.isXiaoBianRecommendation = false;
                    [self playNextVideo];
                }else{
                    [self playAnthologyVideo];
                }
            }
            [self loadMoreVideoData];
        }
    } failure:^(NSError *error) {
    }];
}

///切换下一集
-(void)loadUpdateInfo{
    self.isScroll = true;
    [PVNetTool getDataWithUrl:self.anthologyModel.videoUrl success:^(id result) {
        if (result != nil) {
            PVDemandVideoDetailModel* detailModel = [[PVDemandVideoDetailModel alloc]  init];
            [detailModel setValuesForKeysWithDictionary:result];
            self.videoDetailModel = detailModel;
            [self.videoDetailModel calculationVideoInfoHeight];
            //播放下一集
            [self playNextVideo];
            [self.videoTableView reloadData];
        }
    } failure:^(NSError *error) {
    }];
}

-(void)playNextVideo{
    self.videoType = self.videoDetailModel.videoType.integerValue+1;
    [self commintUserPlayRecord];
    PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
    playVideoModel.type = self.videoDetailModel.videoType.integerValue+1;
    playVideoModel.url = [NSURL URLWithString:self.videoDetailModel.videoUrl];
    playVideoModel.videoDistrict = self.fristVideoDetailModel.videoDistrict;
    playVideoModel.code = self.videoDetailModel.validatacode;
    [self.playView changeCurrentplayerItemWithPlayVideoModel:playVideoModel];
    self.playView.playControView.videoTitleName = self.videoDetailModel.videoTitle;
}

-(void)loadMoreComment{
    if (self.commentDataSource.count >= self.commentCount.integerValue) return;
    self.commentPage++;
    NSString* videoCommentUrl = @"getCommentList";
    NSMutableDictionary* videoCommentPramas = [[NSMutableDictionary alloc]  init];
    if ([PVUserModel shared].token.length) {
        [videoCommentPramas setObject:[PVUserModel shared].token forKey:@"token"];
        [videoCommentPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    }else{
        [videoCommentPramas setObject:@"" forKey:@"token"];
        [videoCommentPramas setObject:@"" forKey:@"userId"];
    }
    [videoCommentPramas setObject:self.videoDetailModel.parentCode forKey:@"code"];
    [videoCommentPramas setObject:@(self.commentPage) forKey:@"index"];
    [videoCommentPramas setObject:@"10" forKey:@"pageSize"];

    [PVNetTool postDataWithParams:videoCommentPramas url:videoCommentUrl success:^(id result) {
        [self.videoTableView.mj_footer endRefreshing];
        if (result[@"data"][@"commentList"] && [result[@"data"][@"commentList"] isKindOfClass:[NSArray class]]){
            NSArray* jsonArr = result[@"data"][@"commentList"];
            for (NSDictionary* josnDict in jsonArr) {
                PVFindCommentModel* findCommentModel = [[PVFindCommentModel alloc]  init];
                PVDemandCommentModel* demandCommentModel = [[PVDemandCommentModel alloc]  init];
                [demandCommentModel setValuesForKeysWithDictionary:josnDict];
                findCommentModel.demandCommentModel = demandCommentModel;
                findCommentModel.isShowMoreBtn = true;
                findCommentModel.text = demandCommentModel.content;
                if (demandCommentModel.replayList.count >= 5) {
                    findCommentModel.isShowComment = true;
                }
                [self.commentDataSource addObject:findCommentModel];
            }
            [self.videoTableView reloadData];
        }else{
            self.commentPage--;
        }
    } failure:^(NSError *error) {
        [self.videoTableView.mj_footer endRefreshing];
        self.commentPage--;
    }];
}


///下载更多视频信息
-(void)loadMoreVideoData{
    self.commentPage = 1;
    NSMutableArray* pramas = [NSMutableArray array];
    if (self.videoDetailModel.videoType.integerValue == 1) {
        ///视频列表接口
        PVNetModel* netModel = [[PVNetModel alloc]  initIsGetOrPost:true Url:self.videoDetailModel.videoModelList.videoEpisodeModel.epospdeUrl param:nil];
        netModel.requestType = 1;
        [pramas addObject:netModel];
    }
    
    ///获取视频收藏状态
    if ([PVUserModel shared].token.length) {
        NSString* videoCollectUrl = [NSString stringWithFormat:@"%@/%@",DynamicUrl, @"getFavoriteState"];
        NSMutableDictionary* videoCollectPramas = [[NSMutableDictionary alloc]  init];
        [videoCollectPramas setObject:[PVUserModel shared].token forKey:@"token"];
        [videoCollectPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
        [videoCollectPramas setObject:self.videoDetailModel.parentCode forKey:@"code"];
        PVNetModel* videoCollectModel = [[PVNetModel alloc]  initIsGetOrPost:false Url:videoCollectUrl param:videoCollectPramas];
        videoCollectModel.requestType = 2;
        [pramas addObject:videoCollectModel];
    }
    
    ///广告位
    if (self.videoDetailModel.videoModelList.videoAdvertisedModels.count) {
        PVNetModel* netModel = [[PVNetModel alloc]  initIsGetOrPost:true Url:self.videoDetailModel.videoModelList.videoAdvertisedModels.firstObject.modelUrl param:nil];
        netModel.requestType = 3;
        [pramas addObject:netModel];
    }
    
    ///小编推荐
    if (self.videoDetailModel.videoModelList.videoEditorModel.modelUrl.length) {
        PVNetModel* netModel = [[PVNetModel alloc]  initIsGetOrPost:true Url:self.videoDetailModel.videoModelList.videoEditorModel.modelUrl param:nil];
        [pramas addObject:netModel];
        netModel.requestType = 4;
    }
    
    
    ///系统推荐
    NSString* videoRecommendUrl = [NSString stringWithFormat:@"%@/%@",DynamicUrl, @"getRecommendVideoList"];
    NSMutableDictionary* videoRecommendPramas = [[NSMutableDictionary alloc]  init];
    [videoRecommendPramas setObject:@"" forKey:@"token"];
    [videoRecommendPramas setObject:@"" forKey:@"userId"];
    [videoRecommendPramas setObject:@"" forKey:@"deviceId"];
    [videoRecommendPramas setObject:self.videoDetailModel.parentCode forKey:@"code"];
    PVNetModel* videoRecommendModel = [[PVNetModel alloc]  initIsGetOrPost:false Url:videoRecommendUrl param:videoRecommendPramas];
    videoRecommendModel.requestType = 6;
    [pramas addObject:videoRecommendModel];
    
    ///获取评论列表
    NSString* videoCommentUrl = [NSString stringWithFormat:@"%@/%@",DynamicUrl, @"getCommentList"];
    NSMutableDictionary* videoCommentPramas = [[NSMutableDictionary alloc]  init];
    if ([PVUserModel shared].token.length) {
        [videoCommentPramas setObject:[PVUserModel shared].token forKey:@"token"];
        [videoCommentPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    }else{
        [videoCommentPramas setObject:@"" forKey:@"token"];
        [videoCommentPramas setObject:@"" forKey:@"userId"];
    }
    [videoCommentPramas setObject:self.videoDetailModel.parentCode forKey:@"code"];
    [videoCommentPramas setObject:@"1" forKey:@"index"];
    [videoCommentPramas setObject:@"10" forKey:@"pageSize"];
    PVNetModel* videoCommentModel = [[PVNetModel alloc]  initIsGetOrPost:false Url:videoCommentUrl param:videoCommentPramas];
    [pramas addObject:videoCommentModel];
    
    [PVNetTool getMoreDataWithParams:pramas success:^(id result) {
        if (result != nil) {
            for (int idx=0; idx<pramas.count; idx++) {
                PVNetModel* netModel = pramas[idx];
                NSString* resultKey = [NSString stringWithFormat:@"%d",idx];
                if ([result[resultKey] isKindOfClass:[NSDictionary class]]  && result[resultKey][@"episodeList"] && [result[resultKey][@"episodeList"] isKindOfClass:[NSArray class]]) {
                    if(result[resultKey][@"modelType"]){
                        NSString* modelType = [NSString stringWithFormat:@"%@",result[resultKey][@"modelType"]];
                        if (modelType.integerValue <= 0) {
                            modelType = @"1";
                        }
                        self.showModelType = modelType;
                    }
                    [self.test1DataSource  removeAllObjects];
                    NSArray* jsonArr = (NSArray*)result[resultKey][@"episodeList"];
                    for (NSDictionary* jsonDict in jsonArr) {
                        PVDemandVideoAnthologyModel*  anthologyModel = [[PVDemandVideoAnthologyModel alloc]  init];
                        anthologyModel.count = [NSString stringWithFormat:@"%@",result[resultKey][@"count"]];
                        [anthologyModel setValuesForKeysWithDictionary:jsonDict];
                        [self.test1DataSource addObject:anthologyModel];
                    }
                    self.anthologyModel.isPlaying = false;
                    if (self.code.length) {
                        for (PVDemandVideoAnthologyModel* model in self.test1DataSource) {
                            if ([model.code isEqualToString:self.code]) {
                                self.anthologyModel = model;
                                break;
                            }
                        }
                    }else{
                        self.anthologyModel = self.test1DataSource.firstObject;
                    }
                    self.recordAnthologyModel = self.anthologyModel;
                    self.anthologyModel.isPlaying = true;
                    
                }else if ([result[resultKey] isKindOfClass:[NSDictionary class]] && result[resultKey][@"data"][@"commentList"] && [result[resultKey][@"data"][@"commentList"] isKindOfClass:[NSArray class]]){
                    self.commentCount = [NSString stringWithFormat:@"%@",result[resultKey][@"data"][@"commentTotalNum"]];
                    self.videoDetailModel.commentCount = self.commentCount;
                    NSArray* jsonArr = result[resultKey][@"data"][@"commentList"];
                    
                    [self.commentDataSource removeAllObjects];
                    for (NSDictionary* josnDict in jsonArr) {
                        PVFindCommentModel* findCommentModel = [[PVFindCommentModel alloc]  init];
                        PVDemandCommentModel* demandCommentModel = [[PVDemandCommentModel alloc]  init];
                        [demandCommentModel setValuesForKeysWithDictionary:josnDict];
                        findCommentModel.demandCommentModel = demandCommentModel;
                        findCommentModel.isShowMoreBtn = true;
                        findCommentModel.text = demandCommentModel.content;
                        if (demandCommentModel.replayList.count >= 5) {
                            findCommentModel.isShowComment = true;
                        }
                        [self.commentDataSource addObject:findCommentModel];
                    }
                }else if (result[resultKey] && [result[resultKey] isKindOfClass:[NSArray class]] && netModel.requestType == 4 ){//小编推荐
                    [self.videoDetailModel.videoModelList.videoEditorModel.videoList removeAllObjects];
                    NSArray* jsonArr = result[resultKey];
                    for (NSDictionary* jsonDict in jsonArr) {
                        PVVideoListModel* videoListModel = [[PVVideoListModel alloc]  init];
                        [videoListModel setValuesForKeysWithDictionary:jsonDict];
                        [self.videoDetailModel.videoModelList.videoEditorModel.videoList addObject:videoListModel];
                    }
                }else if (result[resultKey] && [result[resultKey] isKindOfClass:[NSArray class]] && netModel.requestType == 3){//广告
                    NSArray* jsonArr = result[resultKey];
                    [self.videoDetailModel.videoModelList.advertisementModels removeAllObjects];
                    for (NSDictionary* jsonDict in jsonArr) {
                        PVAdvertisementModel* model = [[PVAdvertisementModel alloc]  init];
                        [model setValuesForKeysWithDictionary:jsonDict];
                        [self.videoDetailModel.videoModelList.advertisementModels addObject:model];
                    }
                }else if ([result[resultKey] isKindOfClass:[NSDictionary class]]  && result[resultKey][@"data"] && [result[resultKey][@"data"] isKindOfClass:[NSDictionary class]] && netModel.requestType == 2) {
                    NSString* favoriteState = [NSString stringWithFormat:@"%@",result[resultKey][@"data"][@"favoriteState"]];
                    self.videoDetailModel.favoriteState = favoriteState;
                    NSString* playNum = [NSString stringWithFormat:@"%@",result[resultKey][@"data"][@"playNum"]];
                    self.videoDetailModel.playNum = playNum;
                }
                else if (result[resultKey] && [result[resultKey][@"data"] isKindOfClass:[NSDictionary class]] && netModel.requestType == 6){
                    if (result[resultKey][@"data"][@"videoList"] && [result[resultKey][@"data"][@"videoList"] isKindOfClass:[NSArray class]]) {
                        [self.systemVideoDataSource removeAllObjects];
                        NSArray* jsonArr = result[resultKey][@"data"][@"videoList"];
                        for (NSDictionary* jsonDict in jsonArr) {
                            PVDemandSystemVideoModel*  systemVideoModel = [[PVDemandSystemVideoModel alloc]  init];
                            [systemVideoModel setValuesForKeysWithDictionary:jsonDict];
                            [self.systemVideoDataSource addObject:systemVideoModel];
                        }
                    }
                }
            }
            self.videoTableView.hidden = false;
            if (!self.videoDetailModel.videoComment.integerValue) {
                bool isIphoneX = (self.scNavigationBar.sc_height == 88.0) ? true : false;
                CGFloat y = (isIphoneX ? (ScreenWidth*9/16 + 24) : ScreenWidth*9/16);
                _videoTableView.frame = CGRectMake(0, y, ScreenWidth, ScreenHeight-y-53);
                self.toolView.hidden = false;
            }else{
                bool isIphoneX = (self.scNavigationBar.sc_height == 88.0) ? true : false;
                CGFloat y = (isIphoneX ? (ScreenWidth*9/16 + 24) : ScreenWidth*9/16);
                _videoTableView.frame = CGRectMake(0, y, ScreenWidth, ScreenHeight-y);
                self.toolView.hidden = true;
            }
            self.fristVideoDetailModel = self.videoDetailModel;
            if (self.videoDetailModel.videoType.intValue == 1) {
                ///请求多集下面的剧头
                [self loadMultiSetHeadData];
            }else if (self.videoDetailModel.videoType.integerValue == 0){
                [self.videoTableView reloadData];
            }
        }
    } failure:^(NSArray *errors) {
        NSLog(@"----error-----=%@",errors);
    }];
}

///登陆成功之后刷新数据
-(void)loginSuccessReloadData{
    NSMutableArray* pramas = [NSMutableArray array];
    ///获取视频收藏状态
    if ([PVUserModel shared].token.length) {
        NSString* videoCollectUrl = [NSString stringWithFormat:@"%@/%@",DynamicUrl, @"getFavoriteState"];
        NSMutableDictionary* videoCollectPramas = [[NSMutableDictionary alloc]  init];
        [videoCollectPramas setObject:[PVUserModel shared].token forKey:@"token"];
        [videoCollectPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
        [videoCollectPramas setObject:self.videoDetailModel.parentCode forKey:@"code"];
        PVNetModel* videoCollectModel = [[PVNetModel alloc]  initIsGetOrPost:false Url:videoCollectUrl param:videoCollectPramas];
        videoCollectModel.requestType = 2;
        [pramas addObject:videoCollectModel];
    }
    ///获取评论列表
    NSString* videoCommentUrl = [NSString stringWithFormat:@"%@/%@",DynamicUrl, @"getCommentList"];
    NSMutableDictionary* videoCommentPramas = [[NSMutableDictionary alloc]  init];
    if ([PVUserModel shared].token.length) {
        [videoCommentPramas setObject:[PVUserModel shared].token forKey:@"token"];
        [videoCommentPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    }else{
        [videoCommentPramas setObject:@"" forKey:@"token"];
        [videoCommentPramas setObject:@"" forKey:@"userId"];
    }
    [videoCommentPramas setObject:self.videoDetailModel.parentCode forKey:@"code"];
    [videoCommentPramas setObject:@"0" forKey:@"index"];
    [videoCommentPramas setObject:@"10" forKey:@"pageSize"];
    PVNetModel* videoCommentModel = [[PVNetModel alloc]  initIsGetOrPost:false Url:videoCommentUrl param:videoCommentPramas];
    [pramas addObject:videoCommentModel];
    [PVNetTool getMoreDataWithParams:pramas success:^(id result) {
        if (result != nil) {
            for (int idx=0; idx<pramas.count; idx++) {
                PVNetModel* netModel = pramas[idx];
                NSString* resultKey = [NSString stringWithFormat:@"%d",idx];
               if ([result[resultKey] isKindOfClass:[NSDictionary class]] && result[resultKey][@"data"][@"commentList"] && [result[resultKey][@"data"][@"commentList"] isKindOfClass:[NSArray class]]){
                    self.commentCount = [NSString stringWithFormat:@"%@",result[resultKey][@"data"][@"commentTotalNum"]];
                    self.videoDetailModel.commentCount = self.commentCount;
                    NSArray* jsonArr = result[resultKey][@"data"][@"commentList"];
                    [self.commentDataSource removeAllObjects];
                    for (NSDictionary* josnDict in jsonArr) {
                        PVFindCommentModel* findCommentModel = [[PVFindCommentModel alloc]  init];
                        PVDemandCommentModel* demandCommentModel = [[PVDemandCommentModel alloc]  init];
                        [demandCommentModel setValuesForKeysWithDictionary:josnDict];
                        findCommentModel.demandCommentModel = demandCommentModel;
                        findCommentModel.isShowMoreBtn = true;
                        findCommentModel.text = demandCommentModel.content;
                        if (demandCommentModel.replayList.count >= 5) {
                            findCommentModel.isShowComment = true;
                        }
                        [self.commentDataSource addObject:findCommentModel];
                    }
                }else if ([result[resultKey] isKindOfClass:[NSDictionary class]]  && result[resultKey][@"data"] && [result[resultKey][@"data"] isKindOfClass:[NSDictionary class]] && netModel.requestType == 2) {
                    NSString* favoriteState = [NSString stringWithFormat:@"%@",result[resultKey][@"data"][@"favoriteState"]];
                    self.videoDetailModel.favoriteState = favoriteState;
                    NSString* playNum = [NSString stringWithFormat:@"%@",result[resultKey][@"data"][@"playNum"]];
                    self.videoDetailModel.playNum = playNum;
                    self.fristVideoDetailModel.favoriteState = favoriteState;
                    self.fristVideoDetailModel.playNum = playNum;
                }
            }
            [self.videoTableView reloadData];
        }
    } failure:^(NSArray *errors) {
    }];
}
-(void)loadMultiSetHeadData{
    [PVNetTool getDataWithUrl:self.anthologyModel.videoUrl success:^(id result) {
        if (result != nil) {
            PVDemandVideoDetailModel* detailModel = [[PVDemandVideoDetailModel alloc]  init];
            [detailModel setValuesForKeysWithDictionary:result];
            self.videoDetailModel = detailModel;
            [self.videoDetailModel calculationVideoInfoHeight];
            if ([self.view isShowingOnKeyWindow]) {
                if (self.isXiaoBianRecommendation) {//切换
                    self.isXiaoBianRecommendation = false;
                    [self playNextVideo];
                }else{
                    [self playAnthologyVideo];
                }
//                self.videoType = self.videoDetailModel.videoType.integerValue + 1;
//                PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
//                playVideoModel.type = self.videoDetailModel.videoType.integerValue+1;
//                playVideoModel.url = [NSURL URLWithString:self.videoDetailModel.videoUrl];
//                playVideoModel.videoDistrict = self.fristVideoDetailModel.videoDistrict;
//                playVideoModel.code = self.fristVideoDetailModel.validatacode;
//                [self.playView changeCurrentplayerItemWithPlayVideoModel:playVideoModel];
//                self.playView.playControView.videoTitleName = self.videoDetailModel.videoTitle;
                [self.videoTableView reloadData];
            }
        }
    } failure:^(NSError *error) {
    }];
}

-(void)playAnthologyVideo{

    PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
    playVideoModel.url = [NSURL URLWithString:self.videoDetailModel.videoUrl];
    playVideoModel.type = self.videoDetailModel.videoType.integerValue + 1;
    playVideoModel.videoDistrict = self.videoDetailModel.videoDistrict;
    playVideoModel.code = self.videoDetailModel.validatacode;
    [self goPlayingPlayVideoModel:playVideoModel delegate:self];
    //准备播放
    self.playView.continuePlayVideoStatus = @"0";
    if (self.continuePlayVideoSecond.integerValue > 0) {
        self.playView.continuePlayVideoStatus = @"1";
    }
    [self.playView.playControView videoFirstPlay];
    self.playView.playControView.videoTitleName = self.videoDetailModel.videoTitle;
    [self setupVideoUI];
}


//键盘出来的时候调整tooView的位置
-(void) keyChange:(NSNotification *) notify{
    NSDictionary *dic = notify.userInfo;
    CGRect endKey = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat bottom = kiPhoneX ? 34 : 0;
    CGRect frame = CGRectMake(0, ScreenHeight-self.toolView.sc_height-endKey.size.height, ScreenWidth, self.toolView.sc_height);
    if (endKey.origin.y == ScreenHeight) {
        self.keyBoradCoverBtn.hidden = true;
        frame = CGRectMake(0, ScreenHeight-self.toolView.sc_height-bottom, ScreenWidth, self.toolView.sc_height);
        self.videoTableView.contentInset = UIEdgeInsetsMake(0, 0, self.toolView.sc_height-53, 0);
    }else{
        self.keyBoradCoverBtn.hidden = false;
    }
    //运动时间
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        self.toolView.frame = frame;
        [self.view layoutIfNeeded];
    }];
}

/// MARK:- ====== UITableViewDataSource,UITableViewDelegate ==========

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return CellSection+self.commentDataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {//视频信息
        return 1;
    }else if (section == 1){//广告图
        NSInteger count = self.fristVideoDetailModel.videoModelList.advertisementModels.count;
        return count > 0 ? 1 :0;
    }else if (section == 2){//选集
        if (self.test1DataSource.count == 0) {
            return 0;
        }
        return 1;
    }else if (section == 3){//小便推荐
        return self.fristVideoDetailModel.videoModelList.videoEditorModel.videoList.count <=3 ?  self.fristVideoDetailModel.videoModelList.videoEditorModel.videoList.count : 3 ;
    }else if (section == 4){//系统推荐
        return self.systemVideoDataSource.count <=3 ?  self.systemVideoDataSource.count : 3 ;
    }
    else if (section == 5){//相关明星
        return 0;
    }else if (section == 6){//评论数量
        return 1;
    }else if(section > SectionIndex){//具体评论
        PVFindCommentModel* commentModel = self.commentDataSource[section-CellSection];
        if (commentModel.demandCommentModel.replayList == nil || commentModel.demandCommentModel.replayList.count == 0) {
            return 0;
        }
        if (!commentModel.isShowComment && commentModel.demandCommentModel.replayList.count >= 5 && self.isShowFive) {
            self.isShowFive = false;
            return 5;
        }
        return commentModel.demandCommentModel.replayList.count;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        
    PV(pv)
    if (section == 0 || section == 1 || section == 6 || section == 5) {//视频信息,评论数量,相关明星
        return nil;
    }else if (section == 2 || section == 3 || section == 4){//选集,小便推荐,系统推荐
        PVDemandTableHeadView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resuPVDemandTableHeadView];
        headView.count = self.test1DataSource.count;
        headView.type = section;
        headView.hidden = false;
        if (section == 3 && self.fristVideoDetailModel.videoModelList.videoEditorModel.videoList.count == 0) {
            headView.hidden = true;
        }else if (section == 2 && self.test1DataSource.count == 0) {
            headView.hidden = true;
        }else if (section == 4 && self.systemVideoDataSource.count == 0){
            headView.hidden = true;
        }
        [headView setHeadViewGestureBlock:^{
            if (section == 2) {//选集点击
                pv.anthologyController.view.hidden = false;
                NSInteger index = [pv.test1DataSource indexOfObject:pv.anthologyModel];
                pv.anthologyController.selectedIndex = index;
                pv.anthologyController.anthologyDatasource = pv.test1DataSource;
                [UIView animateWithDuration:0.25f animations:^{
                    pv.anthologyController.view.sc_y = CaraScreenW*9/16;
                }];
            }else if (section == 5){//相关明星点击
                pv.starViewController.view.hidden = false;
                [UIView animateWithDuration:0.25f animations:^{
                    pv.starViewController.view.sc_y = CaraScreenW*9/16;
                }];
            }
        }];
        
        return headView;
    }else if(section > SectionIndex){//具体评论
        PVCommentTableHeadView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resuPVCommentTableHeadView];
        PVFindCommentModel* findCommentModel = self.commentDataSource[section-CellSection];
        headView.commentModel = findCommentModel;
        PV(pv)
        [headView setPraiseBtnClickedBlock:^(UIButton * btn) {
            if (![PVUserModel shared].token.length || ![PVUserModel shared].token) {
                PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
                [loginVC setPVLoginViewControllerLoginSuccess:^{
                    [pv loginSuccessReloadData];
                }];
                [pv.navigationController pushViewController:loginVC animated:true];
            }else{
                NSUInteger likeIndex = findCommentModel.demandCommentModel.like.integerValue;
                if (findCommentModel.demandCommentModel.isLike.intValue) {//取消评论点赞
                    findCommentModel.demandCommentModel.isLike = @"0";
                    if (likeIndex) {
                        likeIndex--;
                    }
                    [pv cancelCommentPraise:true commentId:findCommentModel.demandCommentModel.commentId];
                }else{//评论点赞
                    findCommentModel.demandCommentModel.isLike = @"1";
                    likeIndex++;
                    [pv cancelCommentPraise:false commentId:findCommentModel.demandCommentModel.commentId];
                }
                findCommentModel.demandCommentModel.like = [NSString stringWithFormat:@"%ld",likeIndex];
                [tableView reloadData];
                NSLog(@"点赞");
            }
        }];
        [headView setCommentTableHeadViewTextBlock:^(UIButton * btn) {
            PVFindCommentModel* model = pv.commentDataSource[section-CellSection];
            model.isShowText = btn.selected;
            [tableView reloadData];
            NSLog(@"全文");
        }];
        [headView setCommentTableHeadViewTapGestureBlock:^(PVFindCommentModel *commentModel) {
            pv.commentMode = commentModel;
            pv.toolView.commentType = 1;
            pv.toolView.sendTextView.placehoder = [NSString stringWithFormat:@"回复  %@",commentModel.demandCommentModel.userData.nickName];
            [pv.toolView.sendTextView becomeFirstResponder];
        }];
        return headView;
    }
    return nil;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PV(pv)
    if (indexPath.section == 0) {//视频信息
        PVVideoInformationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVVideoInformationTableViewCell];
        cell.videoDetailModel1 = self.fristVideoDetailModel;
        cell.videoDetailModel = self.videoDetailModel;
        //简介点击事件
        [cell setVideoDetailBtnClickedBlock:^(UIButton *btn) {
            bool isIphoneX = (pv.scNavigationBar.sc_height == 88.0) ? true : false;
            CGFloat y = isIphoneX ? 24 : 0;
            PVDemandInfoDetailController*vc = [[PVDemandInfoDetailController alloc]  init];
            vc.detailModel = pv.videoDetailModel;
            [pv addChildViewController:vc];
            [pv.view addSubview:vc.view];
            vc.view.frame = CGRectMake(0, ScreenHeight, CaraScreenW, CaraScreenH);
            [UIView animateWithDuration:0.25f animations:^{
                vc.view.sc_y = CaraScreenW*9/16 + y;
            }];
            return ;
            if (btn.selected) {//收起
                pv.videoDetailModel.isShowVideoDetail = false;
            }else{//展开
                pv.videoDetailModel.isShowVideoDetail = true;
            }
            [tableView reloadData];
        }];
        //评论点击事件
        [cell setCommentBtnClickedBlock:^(UIButton * btn) {
            NSIndexPath* commentIndexPath = [NSIndexPath indexPathForRow:0 inSection:SectionIndex];
            [tableView scrollToRowAtIndexPath:commentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
        }];
        
        //收藏点击事件
        [cell setCollectBtnClickedBlock:^(UIButton * btn) {
            if (btn.selected) {
                [pv chllectCahceVideo:false];
            }else{
                [pv chllectCahceVideo:true];
            }
            if (![PVUserModel shared].token.length || ![PVUserModel shared].token) {
                PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
                [loginVC setPVLoginViewControllerLoginSuccess:^{
                    [pv loginSuccessReloadData];
                }];
                [pv.navigationController pushViewController:loginVC animated:true];
            }else{
                btn.selected = !btn.selected;
                if (btn.selected) {//进行收藏
                    pv.fristVideoDetailModel.favoriteState = @"0";
                    pv.videoMoreView.isCollect = true;
                    [pv cancelOrConductVideoCollect:true  isScreen:false];
                }else{//取消收藏
                    pv.videoMoreView.isCollect = false;
                    [pv cancelOrConductVideoCollect:false  isScreen:false];
                    pv.fristVideoDetailModel.favoriteState = @"1";
                }
            }
        }];
        
        //囤片点击事件
        [cell setStoreBtnClickedBlock:^(UIButton * btn) {
            [pv.view insertSubview:pv.televisionCloudPlayController.view atIndex:pv.view.subviews.count];
            pv.televisionCloudPlayController.view.hidden = false;
            [UIView animateWithDuration:0.25f animations:^{
                pv.televisionCloudPlayController.view.sc_y = 0;
            }];
        }];
        
        //分享点击事件
        [cell setShareBtnClickedBlock:^(UIButton * btn) {
            PVShareViewController *shareCon = [[PVShareViewController alloc] init];
            PVShareModel *shareModel = [[PVShareModel alloc] init];
            shareModel.sharetitle = pv.videoDetailModel.videoTitle;
            shareModel.h5Url = pv.videoDetailModel.shareH5Url;
            shareModel.videoUrl = pv.videoDetailModel.videoUrl;
            shareModel.imageUrl = pv.videoDetailModel.videoImage;
            shareModel.descriptStr = pv.videoDetailModel.videoSubTitle;
            shareCon.shareModel = shareModel;
            shareCon.modalPresentationStyle = UIModalPresentationCustom;
            [pv.navigationController presentViewController:shareCon animated:NO completion:nil];
        }];
        
        return cell;
    }else if (indexPath.section == 1) {//广告图
        PVDemandImagesCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVDemandImagesCell];
        NSMutableArray* urlsArray = [NSMutableArray array];
        for (PVAdvertisementModel* model in  self.fristVideoDetailModel.videoModelList.advertisementModels) {
            [urlsArray addObject:model.imgUrl];
        }
        cell.urlsArray = urlsArray;
        [cell setPVDemandImagesCellCallBlock:^(NSInteger index) {
            PVAdvertisementModel* advertisementMode = pv.fristVideoDetailModel.videoModelList.advertisementModels[index];
            PVJumpModel* jumpModel = [[PVJumpModel alloc]  init];
            jumpModel.jumpID = advertisementMode.type;
            jumpModel.jumpVCID = advertisementMode.kId;
            jumpModel.jumpUrl = advertisementMode.jumpUrl;
            jumpModel.jumpTitle = advertisementMode.name;
            jumpModel.jumpVC = pv;
            PVUniversalJump* universalJump = [[PVUniversalJump alloc]  initPVUniversalJumpWithPVJumpModel:jumpModel];
            [universalJump jumpVniversalJumpVC];
        }];
        
        return cell;
    }else if (indexPath.section == 2) {//选集
        PVDemandAnthologyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVDemandAnthologyTableViewCell];
        if (self.isScroll) {
            self.isScroll = false;
            cell.isScroll = true;
        }
        [cell setPVDemandAnthologyTableViewCellCallBlock:^(NSInteger index) {
            pv.anthologyModel.isPlaying = false;
            pv.recordAnthologyModel = pv.anthologyModel;
            pv.anthologyModel = pv.test1DataSource[index];
            pv.anthologyModel.isPlaying = true;
            [pv loadUpdateInfo];
        }];
        cell.anthologyDataSource = self.test1DataSource;
        cell.type = self.showModelType.integerValue;
        return cell;
    }else if (indexPath.section == 3) {//小便推荐
        PVDemandRecommandTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVDemandRecommandTableViewCell];
        if (indexPath.row == 2 && self.fristVideoDetailModel.videoModelList.videoEditorModel.videoList.count == 3) {
            cell.isHiddenView = true;
        }else{
            cell.isHiddenView = false;
        }
        cell.videoListModel = self.fristVideoDetailModel.videoModelList.videoEditorModel.videoList[indexPath.row];
        
        return cell;
    }else if (indexPath.section == 4) {//猜你喜欢
        PVDemandRecommandTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVDemandRecommandTableViewCell];
        if (indexPath.row == 2 && self.systemVideoDataSource.count == 3) {
            cell.isHiddenView = true;
        }else{
            cell.isHiddenView = false;
        }
        cell.systemVideoModel = self.systemVideoDataSource[indexPath.row];
        
        return cell;
    }else if (indexPath.section == 5) {//相关明星
        PVDemandStarTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVDemandStarTableViewCell];
        [cell setPVDemandStarTableViewCellBlock:^(NSInteger index) {
            PVStarDetailViewController* vc = [[PVStarDetailViewController alloc]  init];
            [pv.navigationController  pushViewController:vc animated:true];
        }];
        
        return cell;
    }else if (indexPath.section == 6){//评论数量
        PVCommentCountTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVCommentCountTableViewCell];
        if (self.commentCount.integerValue) {
            cell.noDataLabel.hidden = true;
            cell.commentLabel.text = self.commentCount;
        }else{
            cell.noDataLabel.hidden = false;
            cell.commentLabel.text = @"0";
        }
        return cell;
    }else if (indexPath.section > SectionIndex){//具体评论
        PVCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVCommentTableViewCell];
         PVFindCommentModel* findCommentModel =self.commentDataSource[indexPath.section-CellSection];
        if (findCommentModel.demandCommentModel.replayList.count) {
            cell.rePlayList = findCommentModel.demandCommentModel.replayList[indexPath.row];
        }
        return cell;
    }
    return [[UITableViewCell alloc]  init];
    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    PV(pv)
    if (section == 0 || section == 1 || section == 2 || section == 5 ||  section == 6){
        //视频信息, 选集, 相关明星, 评论数量
        return nil;
    }else if (section == 3){//小便推荐
        PVDemandTableFootView* footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resuPVDemandTableFootView];
        footView.type = 1;
        if (self.fristVideoDetailModel.videoModelList.videoEditorModel.videoList.count <= 3) {
            footView.hidden = true;
        }else{
            footView.hidden = false;
        }
        [footView setPVDemandTableFootViewBlock:^{
            pv.recommandController.view.hidden = false;
            pv.recommandController.type = 1;
            pv.recommandController.dataSource = pv.fristVideoDetailModel.videoModelList.videoEditorModel.videoList;
            [pv.recommandController.recommandTableView reloadData];
            [UIView animateWithDuration:0.25f animations:^{
                pv.recommandController.view.sc_y = CaraScreenW*9/16;
            }];
        }];
        return footView;
    }else if (section == 4){//系统推荐
        PVDemandTableFootView* footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resuPVDemandTableFootView];
        footView.type = 1;
        if (self.systemVideoDataSource.count <= 3) {
            footView.hidden = true;
        }else{
            footView.hidden = false;
        }
        [footView setPVDemandTableFootViewBlock:^{
            pv.recommandController.view.hidden = false;
            pv.recommandController.type = 2;
            pv.recommandController.dataSource = pv.systemVideoDataSource;
            [pv.recommandController.recommandTableView reloadData];
            [UIView animateWithDuration:0.25f animations:^{
                pv.recommandController.view.sc_y = CaraScreenW*9/16;
            }];
        }];
        return footView;
    }else if (section > SectionIndex) {//具体评论
        PVCommentFooterTableView* footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resuPVCommentFooterTableView];
        PVFindCommentModel* model = self.commentDataSource[section-CellSection];
        
        footView.commentModel = model;
        ///更多回复点击事件
        [footView setCommentTableFootViewMoreBlock:^(UIButton * btn) {
            PVFindCommentModel* model = pv.commentDataSource[section-CellSection];
            if (model.isShowComment) {
                [pv loadMoreReplayComment:model];
            }else{
                pv.isShowFive = true;
                [tableView reloadData];
                model.isShowComment = true;
            }
        }];
        if (model.demandCommentModel.replayList.count < 5) {
            footView.moreBtn.hidden = true;
        }else{
            footView.moreBtn.hidden = false;
        }
        return footView;
    }
    return  nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section == 6|| section == 5){//视频信息,广告图, 评论数量 ,相关明星
        return 0.01;
    }else if (section == 2){//选集
        return self.test1DataSource.count == 0 ? 0.01 : 35;
    }else if (section == 3){//小便推荐
        if (self.fristVideoDetailModel.videoModelList.videoEditorModel.videoList.count  == 0) {
            return 0.01;
        }
        return 35;
    }else if (section == 4){//系统推荐
        if (self.systemVideoDataSource.count  == 0) {
            return 0.01;
        }
        return 35;
    }else if (section > SectionIndex) {//具体评论
        PVFindCommentModel* commentModel = self.commentDataSource[section-CellSection];
        if (commentModel.isShowText) {
            return commentModel.headFullHeight;
        }
        return commentModel.headHeight;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//视频信息
        return self.videoDetailModel.isShowVideoDetail ?  (90 +self.videoDetailModel.videoInfoHeight) : 90;
    }else if (indexPath.section == 1){//广告图
        return (CrossScreenWidth-30)*70/350+27;
    } else if (indexPath.section == 2){//选集
        if (self.showModelType.intValue == 1) {
            return 85;
        }else if (self.showModelType.intValue == 2){
            return 90;
        }
        CGFloat width = 80;
        width = scanle(135);
        CGFloat  heigth = width*75/135+44;
        return heigth;
    }else if (indexPath.section == 3 || indexPath.section == 4){//小便推荐,系统推荐
        return 100;
    }else if (indexPath.section == 5){//相关明星
        return 0;
    }else if (indexPath.section == 6) {//评论数量
        return 40;
    }else if (indexPath.section > SectionIndex) {//具体评论
        PVFindCommentModel* commentModel = self.commentDataSource[indexPath.section-CellSection];
        PVReplayList* replayList = commentModel.demandCommentModel.replayList[indexPath.row];
        return replayList.cellHeight;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section == 2 || section == 5 || section == 6) {
        //视频信息,广告图, 选集, 相关明星, 评论数量
        return 0.01;
    }else if (section == 3){//小便推荐
        if (self.fristVideoDetailModel.videoModelList.videoEditorModel.videoList.count <= 3) {
            return 0.01;
        }
        return 40;
    }else if (section == 4){//系统推荐
        if (self.systemVideoDataSource.count <= 3) {
            return 0.01;
        }
        return 40;
    }else if (section > SectionIndex){//具体评论
        PVFindCommentModel* model = self.commentDataSource[section-CellSection];
        if (model.demandCommentModel.replayList.count < 5) {
            return 1.0f;
        }
        return 35;
    }
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3){
        PVVideoListModel* videoListModel = self.fristVideoDetailModel.videoModelList.videoEditorModel.videoList[indexPath.row];
        PVJumpModel* jumpModel = [[PVJumpModel alloc]  init];
        jumpModel.jumpID = videoListModel.info.type;
        jumpModel.jumpVCID = videoListModel.info.kId;
        jumpModel.jumpUrl = videoListModel.info.jsonUrl;
        jumpModel.jumpTitle = videoListModel.info.name;
        jumpModel.jumpVC = self;
        PVUniversalJump* universalJump = [[PVUniversalJump alloc]  initPVUniversalJumpWithPVJumpModel:jumpModel];
        [universalJump jumpVniversalJumpVC];
    }else if (indexPath.section == 4){
        PVDemandSystemVideoModel* systemVideoModel =  self.systemVideoDataSource[indexPath.row];
        PVJumpModel* jumpModel = [[PVJumpModel alloc]  init];
        jumpModel.jumpID = @"1";
        jumpModel.jumpUrl = systemVideoModel.videoUrl;
        jumpModel.jumpVC = self;
        PVUniversalJump* universalJump = [[PVUniversalJump alloc]  initPVUniversalJumpWithPVJumpModel:jumpModel];
        [universalJump jumpVniversalJumpVC];
//        NSString* textUrl = @" http://pandafile.sctv.com:42086/content/video/2017/11/11/20000002000000040000000003836285.json";
//        self.videoDetailModel = self.fristVideoDetailModel;
//        self.isXiaoBianRecommendation = true;
//        self.url = textUrl;
//        [self loadData];
    }else if (indexPath.section > SectionIndex){
        PVFindCommentModel* model = self.commentDataSource[indexPath.section-CellSection];
        self.commentMode = model;
        PVReplayList *replayList  = model.demandCommentModel.replayList[indexPath.row];
        model.replayList = replayList;
        self.toolView.commentType = 2;
        self.toolView.sendTextView.placehoder = [NSString stringWithFormat:@"回复  %@",replayList.userName];
        [self.toolView.sendTextView becomeFirstResponder];
    }
}
-(UIView *)videoContainerView{
    if (!_videoContainerView) {
        _videoContainerView = [[UIView  alloc]  init];
        _videoContainerView.hidden = true;
        _videoContainerView.backgroundColor = [UIColor blackColor];
        _videoContainerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*6/19);
        //添加播放器view
    }
    return _videoContainerView;
}
-(UITableView *)videoTableView{
    if (!_videoTableView) {
        _videoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        bool isIphoneX = (self.scNavigationBar.sc_height == 88.0) ? true : false;
        CGFloat y = (isIphoneX ? (ScreenWidth*9/16 + 24) : ScreenWidth*9/16);
        _videoTableView.frame = CGRectMake(0, y, ScreenWidth, ScreenHeight-y-53);
        CGFloat bottomHeight = isIphoneX ? 34 : 0;
        _videoTableView.contentInset = UIEdgeInsetsMake(0, 0, bottomHeight-43, 0);
        _videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_videoTableView registerNib:[UINib nibWithNibName:@"PVVideoInformationTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVVideoInformationTableViewCell];
        [_videoTableView registerClass:[PVDemandAnthologyTableViewCell class] forCellReuseIdentifier:resuPVDemandAnthologyTableViewCell];
        [_videoTableView registerNib:[UINib nibWithNibName:@"PVDemandTableHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:resuPVDemandTableHeadView];
        [_videoTableView registerNib:[UINib nibWithNibName:@"PVDemandRecommandTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVDemandRecommandTableViewCell];        
        [_videoTableView registerClass:[PVDemandStarTableViewCell class] forCellReuseIdentifier:resuPVDemandStarTableViewCell];
        [_videoTableView registerNib:[UINib nibWithNibName:@"PVDemandTableFootView" bundle:nil] forHeaderFooterViewReuseIdentifier:resuPVDemandTableFootView];
        [_videoTableView registerNib:[UINib nibWithNibName:@"PVCommentCountTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVCommentCountTableViewCell];
        [_videoTableView registerNib:[UINib nibWithNibName:@"PVCommentTableHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:resuPVCommentTableHeadView];
        [_videoTableView registerNib:[UINib nibWithNibName:@"PVCommentTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVCommentTableViewCell];
        [_videoTableView registerNib:[UINib nibWithNibName:@"PVCommentFooterTableView" bundle:nil] forHeaderFooterViewReuseIdentifier:resuPVCommentFooterTableView];
        [_videoTableView registerClass:[PVDemandImagesCell  class] forCellReuseIdentifier:resuPVDemandImagesCell];
        _videoTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _videoTableView.dataSource = self;
        _videoTableView.delegate = self;
        _videoTableView.showsVerticalScrollIndicator = false;
        _videoTableView.showsVerticalScrollIndicator = false;
    }
    return _videoTableView;
}
-(NSMutableArray *)commentDataSource{
    if (!_commentDataSource) {
        _commentDataSource = [NSMutableArray array];
    }
    return _commentDataSource;
}
-(PVDemandVideoDetailModel *)videoDetailModel{
    if (!_videoDetailModel) {
        _videoDetailModel = [[PVDemandVideoDetailModel alloc]  init];
        _videoDetailModel.isShowVideoDetail = false;
    }
    return _videoDetailModel;
}
-(PVToolView *)toolView{
    if (!_toolView) {
        _toolView = [[PVToolView alloc]  initWithType:2];
        _toolView.sendTextView.placehoder = @"说点什么....";
        _toolView.commentType = 0;
        bool isIphoneX = (self.scNavigationBar.sc_height == 88.0) ? true : false;
        CGFloat botttomHeight = isIphoneX ? 34 : 0;
        _toolView.frame = CGRectMake(0,ScreenHeight-53-botttomHeight, ScreenWidth, 53);
        PV(pv)
        [_toolView setMyTextBlock:^(NSString *myText) {
            ///判断登陆
            if (![PVUserModel shared].token.length || ![PVUserModel shared].token) {
                PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
                [loginVC setPVLoginViewControllerLoginSuccess:^{
                    [pv loginSuccessReloadData];
                }];
                [pv.navigationController pushViewController:loginVC animated:true];
            }else{
                [pv commintComment:myText];
            }
        }];
        [_toolView setContentSizeBlock:^(CGSize contentSize) {
            [pv changeHeight:contentSize];
        }];
    }
    return _toolView;
}
-(void)changeHeight:(CGSize)contentSize{
    float height = contentSize.height + 18;
    bool isIphoneX = (self.scNavigationBar.sc_height == 88.0) ? true : false;
    CGFloat botttomHeight = isIphoneX ? 34 : 0;
    if (height > 50) {
        [self.toolView.sendTextView flashScrollIndicators];
        static CGFloat maxHeight = 130.0f;
        CGRect frame = self.toolView.sendTextView.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        CGSize size = [self.toolView.sendTextView sizeThatFits:constraintSize];
        if (size.height >= maxHeight){
            size.height = maxHeight;
            self.toolView.sendTextView.scrollEnabled = YES;
        }else{
            self.toolView.sendTextView.scrollEnabled = NO;
        }
        CGFloat tempHeight = ScreenHeight-CGRectGetMaxY(self.toolView.frame);
        self.toolView.frame = CGRectMake(self.toolView.sc_x, ScreenHeight-size.height-20-tempHeight, ScreenWidth, size.height+20);
    }else{
        self.toolView.frame = CGRectMake(0, ScreenHeight-53-botttomHeight,ScreenWidth, 53);
    }
}
-(UIButton *)keyBoradCoverBtn{
    if (!_keyBoradCoverBtn) {
        _keyBoradCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _keyBoradCoverBtn.frame = self.view.bounds;
        _keyBoradCoverBtn.hidden = true;
        _keyBoradCoverBtn.backgroundColor = [UIColor clearColor];
        [_keyBoradCoverBtn addTarget:self action:@selector(keyBoradCoverBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keyBoradCoverBtn;
}
-(void)keyBoradCoverBtnClicked{
    [self.view endEditing:true];
    self.keyBoradCoverBtn.hidden = true;
}
-(PVAnthologyViewController *)anthologyController{
    if (!_anthologyController) {
        PV(pv)
        _anthologyController = [[PVAnthologyViewController alloc]  init];
        _anthologyController.type = self.showModelType.intValue;
        [self addChildViewController:_anthologyController];
        [self.view insertSubview:_anthologyController.view atIndex:self.view.subviews.count];
        _anthologyController.view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-ScreenWidth*9/16);
        _anthologyController.view.hidden = true;
        [_anthologyController setPVAnthologyViewControllerCallBlock:^(NSInteger index) {
            pv.anthologyModel.isPlaying = false;
            pv.recordAnthologyModel = pv.anthologyModel;
            pv.anthologyModel = pv.test1DataSource[index];
            pv.anthologyModel.isPlaying = true;
            [pv loadUpdateInfo];
        }];
    }
    return _anthologyController;
}
-(PVStarViewController *)starViewController{
    if (!_starViewController) {
        _starViewController = [[PVStarViewController alloc]  init];
        [self addChildViewController:_starViewController];
        [self.view insertSubview:_starViewController.view atIndex:self.view.subviews.count];
        _starViewController.view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-CGRectGetMaxY(self.playView.frame));
        _starViewController.view.hidden = true;
    }
    return _starViewController;
}
-(PVRecommandVideoController *)recommandController{
    if (!_recommandController) {
        _recommandController = [[PVRecommandVideoController alloc]  init];
        [self addChildViewController:_recommandController];
        [self.view insertSubview:_recommandController.view atIndex:self.view.subviews.count];
        _recommandController.view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-CGRectGetMaxY(self.playView.frame));
        _recommandController.view.hidden = true;
        PV(pv)
        [_recommandController setPVRecommandVideoControllerCallBlock:^(PVVideoListModel *videoListModel,PVDemandSystemVideoModel* systemVideoModel, NSInteger type) {
            if (type == 1) {
                PVJumpModel* jumpModel = [[PVJumpModel alloc]  init];
                jumpModel.jumpID = videoListModel.info.type;
                jumpModel.jumpVCID = videoListModel.info.kId;
                jumpModel.jumpUrl = videoListModel.info.jsonUrl;
                jumpModel.jumpTitle = videoListModel.info.name;
                jumpModel.jumpVC = pv;
                PVUniversalJump* universalJump = [[PVUniversalJump alloc]  initPVUniversalJumpWithPVJumpModel:jumpModel];
                [universalJump jumpVniversalJumpVC];
            }else{
//                 pv.url = systemVideoModel.videoUrl;
//                 pv.isXiaoBianRecommendation = true;
//                 [pv loadData];
            }
        }];
    }
    return _recommandController;
}
-(PVTelevisionCloudPlayController *)televisionCloudPlayController{
    if (!_televisionCloudPlayController) {
        _televisionCloudPlayController = [[PVTelevisionCloudPlayController alloc]  initIsCross:false];
        [self addChildViewController:_televisionCloudPlayController];
        [self.view insertSubview:_televisionCloudPlayController.view atIndex:self.view.subviews.count];
        _televisionCloudPlayController.view.frame = CGRectMake(0, CrossScreenHeight, CrossScreenWidth, CrossScreenHeight);
        _televisionCloudPlayController.view.hidden = true;
    }
    return _televisionCloudPlayController;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"all_btn_back_white"] forState:UIControlStateNormal];
        bool isIphoneX = (self.scNavigationBar.sc_height == 88.0) ? true : false;
        CGFloat y = isIphoneX ? 34 : 10;
        _backBtn.frame = CGRectMake(0, y-10, 70, 70);
        _backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
        [_backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:true];
}
-(NSMutableArray<PVDemandSystemVideoModel *> *)systemVideoDataSource{
    if (!_systemVideoDataSource) {
        _systemVideoDataSource = [NSMutableArray array];
    }
    return _systemVideoDataSource;
}


#pragma mark - 播放器************************************
-(void)setupVideoUI{
    [self.playContainerView addSubview:self.coverBtn];
    [self.playContainerView addSubview:self.crossTelevisionCloudPlayController.view];
    
    [self.crossTelevisionCloudPlayController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playContainerView.mas_top).offset(0);
        make.bottom.equalTo(self.playContainerView.mas_bottom).offset(0);
        make.right.equalTo(self.playContainerView.mas_right).offset(0);
        make.width.equalTo(@(CaraScreenH*0.5));
    }];
    
//    [self setVideoDemandAnthologyViewConstrints:self.crossTelevisionCloudPlayController.view];
    [self.playContainerView addSubview:self.videoMoreView];
    [self setMoreViewConstrints:self.videoMoreView];
    [self.playContainerView addSubview:self.videoShareView];
    [self setMoreViewConstrints:self.videoShareView];
   // [self.playContainerView addSubview:self.videoDefinitionView];
   // [self setMoreViewConstrints:self.videoDefinitionView];
    [self.playContainerView addSubview:self.videoDemandAnthologyController.view];
    [self setVideoDemandAnthologyViewConstrints:self.videoDemandAnthologyController.view];
   // [self.playView insertSubview:self.barrageView belowSubview:self.playView.playControView];
    /*
    [self.barrageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.playView);
        make.height.equalTo(@106);
        make.top.equalTo(@0);
    }];
     */
    
}
-(void)setMoreViewConstrints:(UIView*)view{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.playContainerView);
        make.right.equalTo(self.playContainerView.mas_right).offset(videoMoreHeight);
        make.width.equalTo(@(videoMoreHeight));
    }];
}
-(void)setVideoDemandAnthologyViewConstrints:(UIView*)view{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.playContainerView);
        make.right.equalTo(self.playContainerView.mas_right).offset(CaraScreenH*0.5);
        make.width.equalTo(@(CaraScreenH*0.5));
    }];
}
#pragma mark - 控制层VideoPlayerViewDelegate************************************
-(void)delegateMoreBtnClicked{
    self.videoMoreView.isCollect = !self.fristVideoDetailModel.favoriteState.integerValue;
    [self showMoreView:self.videoMoreView];
    NSLog(@"更多");
}
-(void)delegateShareBtnClicked{
    [self showMoreView:self.videoShareView];
    NSLog(@"分享");
}
-(void)delegateDefinitionBtnClicked{
   // [self showMoreView:self.videoDefinitionView];
    NSLog(@"清晰度");
}
-(void)delegateAnthologyBtnClicked{
    [self showDemandAnthologyView:self.videoDemandAnthologyController.view];
    NSInteger index = [self.test1DataSource indexOfObject:self.anthologyModel];
    self.videoDemandAnthologyController.index = index;
    self.videoDemandAnthologyController.anthologyDataSource = self.test1DataSource;

    NSLog(@"选集");
}
-(void)delegateBarrageBtnClicked:(UIButton *)btn{
    if (btn.selected) {//开启弹幕
        self.barrageView.hidden = false;
        [self.barrageView insertBarrages:self.barrageDataSource immediatelyShow:YES];
        [self.barrageView resumeAnimation];

    }else{//关闭弹幕
        self.barrageView.hidden = true;
        [self.barrageView pauseAnimation];
    }
    NSLog(@"是否显示弹幕");
}
-(void)delegatePublishBarrageBtnClicked{
    BarrageModel* model = [[BarrageModel alloc]  init];
    model.message = @"周大帅已经加了一条弹幕";
    [self.barrageView insertBarrages:@[model] immediatelyShow:YES];
    NSLog(@"发弹幕");
}
-(void)delegateNextBtnClicked{
    NSInteger index = [self.test1DataSource indexOfObject:self.anthologyModel];
    NSInteger nextIndex = index + 1;
    if (nextIndex < self.test1DataSource.count) {//播放下一集
        self.recordAnthologyModel = self.anthologyModel;
        self.anthologyModel.isPlaying = false;
        self.anthologyModel = self.test1DataSource[nextIndex];
        self.anthologyModel.isPlaying = true;
        [self loadUpdateInfo];
    }
}
-(void)delegateTeleversionBtnClicked{
    NSLog(@"TVTVTVTVTVTT");
}
-(void)delegateTelevisionPlayCloud:(BOOL)isTelevisionCloud{
//    if (self.playView.playControView.isRotate) {
//        [self showDemandAnthologyView:self.crossTelevisionCloudPlayController.view];
//    }else{
//        [self.view insertSubview:self.televisionCloudPlayController.view atIndex:self.view.subviews.count];
//        self.televisionCloudPlayController.view.hidden = false;
//        [UIView animateWithDuration:0.25f animations:^{
//            self.televisionCloudPlayController.view.sc_y = 0;
//        }];
//    }
    PV(pv)
    if (![PVUserModel shared].token.length || ![PVUserModel shared].token) {
        PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
        [loginVC setPVLoginViewControllerLoginSuccess:^{
            [pv loginSuccessReloadData];
        }];
        [self.navigationController pushViewController:loginVC animated:true];
    }else{
        if (!isTelevisionCloud) {
            [self addTelevisionTVCloud];
            NSLog(@"电视");
        }else{
            NSLog(@"电视云");
        }
    }
}
-(void)addTelevisionTVCloud{
    
    NSString* url = @"playVideoForTV";
    NSMutableDictionary* televisionPramas = [[NSMutableDictionary alloc]  init];
    [televisionPramas setObject:@"1" forKey:@"isFrom"];
    [televisionPramas setObject:[PVUserModel shared].userId forKey:@"phone"];
    [televisionPramas setObject:[PVUserModel shared].userId forKey:@"targetPhone"];
    if (self.fristVideoDetailModel.videoType.integerValue == 0) {
        [televisionPramas setObject:self.fristVideoDetailModel.code forKey:@"videoId"];
    }else{
        [televisionPramas setObject:self.anthologyModel.code forKey:@"videoId"];
    }

    [PVNetTool postDataWithParams:televisionPramas url:url success:^(id result) {
        NSString* rsStr = [NSString stringWithFormat:@"%@",result[@"rs"]];
        if ([rsStr isEqualToString:@"200"]) {
            if (self.playView.playControView.isRotate) {
                [self.playView makeToast:@"播放成功" duration:2 position:CSToastPositionCenter];
            }else{
                [MBProgressHUD showSuccess:@"播放成功" toView:self.view];
            }
        }else{
            if (self.playView.playControView.isRotate) {
                [self.playView makeToast:result[@"errorMsg"] duration:2 position:CSToastPositionCenter];
            }else{
                [MBProgressHUD showError:result[@"errorMsg"]  toView:self.view];
            }
        }
    } failure:^(NSError *error) {
        if (self.playView.playControView.isRotate) {
            [self.playView makeToast:@"网络连接失败" duration:2 position:CSToastPositionCenter];
        }else{
            [MBProgressHUD showError:@"网络连接失败"  toView:self.view];
        }
    }];
}

- (void)backToBeforeVC{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - 懒加载************************************
-(PVVideoMoreView *)videoMoreView{
    if (!_videoMoreView) {
        _videoMoreView = [[PVVideoMoreView alloc]  init];
        _videoMoreView.hidden = true;
        PV(pv)
        [_videoMoreView setPVVideoMoreViewCallBlock:^{
            if (pv.videoMoreView.collectBtn.selected) {//取消收藏
                [pv chllectCahceVideo:false];
                if ([PVUserModel shared].token.length) {
                    pv.fristVideoDetailModel.favoriteState = @"1";
                    pv.videoMoreView.collectBtn.selected = false;
                    [pv cancelOrConductVideoCollect:false isScreen:true];
                }else{
                    [pv.playView makeToast:@"请先登录" duration:2 position:CSToastPositionCenter];
                }
            }else{
                [pv chllectCahceVideo:true];
                if ([PVUserModel shared].token.length) {
                    pv.fristVideoDetailModel.favoriteState = @"0";
                    pv.videoMoreView.collectBtn.selected = true;
                    [pv cancelOrConductVideoCollect:true isScreen:true];
                }else{
                    [pv.playView makeToast:@"请先登录" duration:2 position:CSToastPositionCenter];
                }
            }
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [pv.videoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    return _videoMoreView;
}
-(PVVideoShareView *)videoShareView{
    if (!_videoShareView) {
        _videoShareView = [[[NSBundle mainBundle]loadNibNamed:@"PVVideoShareView" owner:self options:nil]objectAtIndex:0];
        _videoShareView.hidden = true;
        PV(pv)
        [_videoShareView setPVVideoShareViewCallBlock:^(NSString *title) {
            PVShareModel *shareModel = [[PVShareModel alloc] init];
            shareModel.sharetitle = pv.videoDetailModel.videoTitle;
            shareModel.h5Url = pv.videoDetailModel.shareH5Url;
            shareModel.videoUrl = pv.videoDetailModel.videoUrl;
            shareModel.imageUrl = pv.videoDetailModel.videoImage;
            shareModel.descriptStr = pv.videoDetailModel.videoSubTitle;
            SSDKPlatformType type = -101;
            if ([title isEqualToString:@"微信"]) {
                type = SSDKPlatformSubTypeWechatSession;
            }else if ([title isEqualToString:@"朋友圈"]){
                type = SSDKPlatformSubTypeWechatTimeline;
            }else if ([title isEqualToString:@"QQ好友"]){
                type = SSDKPlatformSubTypeQQFriend;
            }else if ([title isEqualToString:@"QQ空间"]){
                type = SSDKPlatformSubTypeQZone;
            }else if ([title isEqualToString:@"微博"]){
                type = SSDKPlatformTypeSinaWeibo;
            }else if ([title isEqualToString:@"复制链接"]){
                UIPasteboard *copyStr = [UIPasteboard generalPasteboard];
                copyStr.string = shareModel.videoUrl;
                [pv.playContainerView makeToast:@"链接复制成功" duration:2 position:CSToastPositionCenter];
            }
            if (![title isEqualToString:@"复制链接"]) {
                [PVShareTool shareWithPlatformType:type PVDemandVideoDetailModel:shareModel shareresult:^(NSString *shareResultStr) {                    
                   // [pv.playContainerView makeToast:shareResultStr duration:2 position:CSToastPositionCenter];
                }];
            }
        }];
    }
    return _videoShareView;
}
-(PVVideoDefinitionView *)videoDefinitionView{
    if (!_videoDefinitionView) {
        _videoDefinitionView = [[PVVideoDefinitionView alloc]  init];
        PV(pv)
        [_videoDefinitionView setPVVideoDefinitionViewBlock:^(PVLiveTelevisionChanelListModel *chanelListModel) {
            [pv coverBtnClicked];
        }];
        _videoDefinitionView.hidden = true;
    }
    return _videoDefinitionView;
}
-(PVVideoDemandAnthologyController *)videoDemandAnthologyController{
    if (!_videoDemandAnthologyController) {
        _videoDemandAnthologyController = [[PVVideoDemandAnthologyController alloc]  init];
        _videoDemandAnthologyController.type = self.showModelType.intValue;
        _videoDemandAnthologyController.view.hidden = true;
        PV(pv)
        [_videoDemandAnthologyController setPVVideoDemandAnthologyControllerBlock:^(NSInteger index) {
            [pv coverBtnClicked];
            pv.anthologyModel.isPlaying = false;
            pv.recordAnthologyModel = pv.anthologyModel;
            pv.anthologyModel = pv.test1DataSource[index];
            pv.anthologyModel.isPlaying = true;
            [pv loadUpdateInfo];
        }];
    }
    return _videoDemandAnthologyController;
}
-(PVTelevisionCloudPlayController *)crossTelevisionCloudPlayController{
    if (!_crossTelevisionCloudPlayController) {
        _crossTelevisionCloudPlayController = [[PVTelevisionCloudPlayController alloc]  initIsCross:true];
        _crossTelevisionCloudPlayController.view.hidden = true;
    }
    return _crossTelevisionCloudPlayController;
}
-(BarrageView *)barrageView{
    if (!_barrageView) {
        _barrageView = [[BarrageView alloc]  init];
        _barrageView.dataSouce = self;
        _barrageView.cellHeight = 15;
        _barrageView.speedBaseVlaue = 10;
        _barrageView.userInteractionEnabled = false;
        _barrageView.hidden = true;
        _barrageView.delegate = self;
    }
    return _barrageView;
}
-(NSMutableArray *)barrageDataSource{
    if (!_barrageDataSource) {
        _barrageDataSource = [NSMutableArray array];
        for (int i=0; i<240; i++) {
            NSString* title = @"哈哈哈啊哈哈哈哈哈哈";
            if (i % 2) {
                title = @"哈哈哈啊哈啊哈哈哈哈哈哈啊哈哈哈啊哈哈哈哈哈";
            }
            BarrageModel* model = [[BarrageModel alloc]  init];
            model.message = title;
            [_barrageDataSource addObject:model];
        }
        
    }
    return _barrageDataSource;
}
-(UIButton *)coverBtn{
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.backgroundColor = [UIColor clearColor];
        _coverBtn.hidden = true;
        [_coverBtn addTarget:self action:@selector(coverBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.playContainerView addSubview:_coverBtn];
        [_coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.playContainerView);
        }];
    }
    return _coverBtn;
}

-(void)coverBtnClicked{
    [self closeMoreView:self.videoMoreView];
    [self closeMoreView:self.videoShareView];
   //[self closeMoreView:self.videoDefinitionView];
    [self closeDemandAnthologyView:self.videoDemandAnthologyController.view];
    [self closeDemandAnthologyView:self.crossTelevisionCloudPlayController.view];
}
-(void)screenLandscapeChargeScreenPortrait{
    // self.videoDefinitionView.hidden =
     self.videoMoreView.hidden = self.videoShareView.hidden =  self.videoDemandAnthologyController.view.hidden = true;
    [self coverBtnClicked];
}
-(void)showMoreView:(UIView*)view{
    _coverBtn.hidden = false;
    view.hidden = false;
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playContainerView.mas_right);
    }];
    [UIView animateWithDuration:0.25f animations:^{
        [self.playContainerView layoutIfNeeded];
    }];
}
-(void)showDemandAnthologyView:(UIView*)view{
    _coverBtn.hidden = false;
    view.hidden = false;
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playContainerView.mas_right);
    }];
    [UIView animateWithDuration:0.25f animations:^{
        [self.playContainerView layoutIfNeeded];
    }];
}
-(void)closeMoreView:(UIView*)view{
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(videoMoreHeight));
    }];
    [UIView animateWithDuration:0.2f animations:^{
        [self.playContainerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.coverBtn.hidden = true;
        view.hidden = true;
    }];
}
-(void)closeDemandAnthologyView:(UIView*)view{
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(CaraScreenH*0.5));
    }];
    [UIView animateWithDuration:0.2f animations:^{
        [self.playContainerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.coverBtn.hidden = true;
        view.hidden = true;
    }];
}
#pragma mark - BarrageViewDataSource

- (NSUInteger)numberOfRowsInTableView:(BarrageView *)barrageView
{
    return 4;
}

- (BarrageViewCell *)barrageView:(BarrageView *)barrageView cellForModel:(id<BarrageModelAble>)model
{
    PVBarrageCell *cell = [PVBarrageCell cellWithBarrageView:barrageView];
    cell.model = (BarrageModel *)model;
    return cell;
}

#pragma mark - BarrageViewDelegate

- (void)barrageView:(BarrageView *)barrageView didSelectedCell:(BarrageViewCell *)cell
{
    //    PVBarrageCell *customCell = (PVBarrageCell *)cell;
    //    NSLog(@"你点击了:%@", customCell.model.message);
}

- (void)barrageView:(BarrageView *)barrageView willDisplayCell:(BarrageViewCell *)cell
{
    //    PVBarrageCell *customCell = (PVBarrageCell *)cell;
    //    NSLog(@"%@即将展示", customCell.model.message);
}

- (void)barrageView:(BarrageView *)barrageView didEndDisplayingCell:(BarrageViewCell *)cell
{
    //    PVBarrageCell *customCell = (PVBarrageCell *)cell;
    //    NSLog(@"%@展示完成", customCell.model.message);
}


-(NSMutableArray *)test1DataSource{
    if (!_test1DataSource) {
        _test1DataSource = [NSMutableArray array];
    }
    return _test1DataSource;
}

//取消与进行收藏
-(void)cancelOrConductVideoCollect:(BOOL)isCancel  isScreen:(BOOL)isScreen{
    NSString* url = @"deleteFavorite";
    if (isCancel) {
        url = @"addFavoriteVideo";
    }
    NSString* playOrCollectUrl = [NSString stringWithFormat:@"%@", url];
    NSMutableDictionary* playOrCollectPramas = [[NSMutableDictionary alloc]  init];
    
    [playOrCollectPramas setObject:[PVUserModel shared].token forKey:@"token"];
    [playOrCollectPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    if(!isCancel){
//        NSData *data=[NSJSONSerialization dataWithJSONObject:videoIds options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [playOrCollectPramas setObject:self.fristVideoDetailModel.parentCode forKey:@"codes"];
    }else{
        [playOrCollectPramas setObject:self.fristVideoDetailModel.parentCode forKey:@"code"];
    }
    [PVNetTool postDataWithParams:playOrCollectPramas url:playOrCollectUrl success:^(id result) {
        NSString* errorStr = [NSString stringWithFormat:@"%@",result[@"errorMsg"]];
        if(!isCancel){
            if (!errorStr.length) {
                if (isScreen) {
                    [self.playView makeToast:@"取消收藏" duration:2 position:CSToastPositionCenter];
                }else{
                    [MBProgressHUD showSuccess:@"取消收藏" toView:self.view];
                }
            }else{
                if (isScreen) {
                    [self.playView makeToast:result[@"errorMsg"] duration:2 position:CSToastPositionCenter];
                }else{
                    [MBProgressHUD showError:result[@"errorMsg"]  toView:self.view];
                }
            }
        }else{
            if (!errorStr.length) {
                if (isScreen) {
                    [self.playView makeToast:@"收藏成功" duration:2 position:CSToastPositionCenter];
                }else{
                    [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
                }
            }else{
                if (isScreen) {
                    [self.playView makeToast:result[@"errorMsg"] duration:2 position:CSToastPositionCenter];
                }else{
                    [MBProgressHUD showError:result[@"errorMsg"] toView:self.view];
                }
            }
        }
    } failure:^(NSError *error) {
        if (isScreen) {
            [self.playView makeToast:@"网络连接失败" duration:2 position:CSToastPositionCenter];
        }else{
            [MBProgressHUD showError:@"网络连接失败"  toView:self.view];
        }
    }];
}
//本地收藏
-(void)chllectCahceVideo:(BOOL)isCancel{
    PVDemandVideoAnthologyModel* tempAnthologyModel = nil;
    NSString* time = [NSDate PVDateToStringTime:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeLength = [NSString stringWithFormat:@"%f",[self.playView.player duration]];
    if (self.fristVideoDetailModel.videoType.integerValue == 1) {
        self.anthologyModel.totalVideoLength = timeLength;
        self.anthologyModel.playStopTime = time;
        tempAnthologyModel = self.anthologyModel;
    }else{
        PVDemandVideoAnthologyModel* anthologyModel = [[PVDemandVideoAnthologyModel alloc]  init];
        anthologyModel.totalVideoLength = timeLength;
        anthologyModel.playStopTime = time;
        anthologyModel.code = self.fristVideoDetailModel.code;
        anthologyModel.verticalPic = self.fristVideoDetailModel.videoImage;
        anthologyModel.videoType = self.fristVideoDetailModel.videoType;
        anthologyModel.videoUrl = self.fristVideoDetailModel.videoUrl;
        anthologyModel.videoName = self.fristVideoDetailModel.videoTitle;
        tempAnthologyModel = anthologyModel;
    }
    tempAnthologyModel.jsonUrl = self.url;
    if (isCancel) {
        [[PVDBManager sharedInstance] insertCollectVideoModel:tempAnthologyModel];
    }else{
        [[PVDBManager sharedInstance] deleteCollectVideoModel:tempAnthologyModel];
    }
}


//取消与进行评论点赞
-(void)cancelCommentPraise:(BOOL)isCancel  commentId:(NSString*)commentId{
    NSString* url = @"addCommentLike";
    if (isCancel) {
        url = @"deletLike";
    }
    NSString* playOrCollectUrl = [NSString stringWithFormat:@"%@", url];
    NSMutableDictionary* playOrCollectPramas = [[NSMutableDictionary alloc]  init];
    [playOrCollectPramas setObject:[PVUserModel shared].token forKey:@"token"];
    [playOrCollectPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    [playOrCollectPramas setObject:commentId forKey:@"commentId"];
    [PVNetTool postDataWithParams:playOrCollectPramas url:playOrCollectUrl success:^(id result) {
        
        NSLog(@"result = %@",result);
        
        NSString* errorStr = [NSString stringWithFormat:@"%@",result[@"errorMsg"]];
        if(isCancel){
            if (!errorStr.length) {
                [MBProgressHUD showSuccess:@"取消点赞" toView:self.view];
            }else{
                [MBProgressHUD showError:result[@"errorMsg"]  toView:self.view];
            }
        }else{
            if (!errorStr.length) {
                [MBProgressHUD showSuccess:@"点赞成功" toView:self.view];
            }else{
                [MBProgressHUD showError:result[@"errorMsg"] toView:self.view];
            }
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error = %@",error);

        
        [MBProgressHUD showError:@"网络连接失败"  toView:self.view];
    }];
}
//获取评论回复详情列表
-(void)loadMoreReplayComment:(PVFindCommentModel*)findCommentModel{
    if (self.isRequestCommentIng) return;
    self.isRequestCommentIng = true;
    self.page++;
    NSString* replayCommentUrl = [NSString stringWithFormat:@"%@", @"getCommentReplyList"];
    NSMutableDictionary* replayCommentPramas = [[NSMutableDictionary alloc]  init];
    [replayCommentPramas setObject:findCommentModel.demandCommentModel.commentId forKey:@"commentId"];
    if ([PVUserModel shared].token.length) {
        [replayCommentPramas setObject:[PVUserModel shared].token forKey:@"token"];
        [replayCommentPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    }    
    [replayCommentPramas setObject:@(self.page) forKey:@"index"];
    [replayCommentPramas setObject:@"10" forKey:@"pageSize"];
    
    [PVNetTool postDataWithParams:replayCommentPramas url:replayCommentUrl success:^(id result) {
        if (result[@"data"][@"replayList"] && [result[@"data"][@"replayList"] isKindOfClass:[NSArray class]] ) {
            NSArray* jsonArr = result[@"data"][@"replayList"];
            if (jsonArr.count < 10) {
                findCommentModel.isShowComment = false;
            }else{
                findCommentModel.isShowComment = true;
            }
            for (NSDictionary* jsonDict in jsonArr) {
                PVReplayList* rePlayList = [[PVReplayList alloc]  init];
                [rePlayList setValuesForKeysWithDictionary:jsonDict];
                [rePlayList calculationCellHeight];
                [findCommentModel.demandCommentModel.replayList addObject:rePlayList];
            }
        }else{
            self.page--;
        }
        [self.videoTableView reloadData];
        self.isRequestCommentIng = false;
        NSLog(@"更多回复--result---%@",result);
    } failure:^(NSError *error) {
        self.page--;
        self.isRequestCommentIng = false;
        NSLog(@"更多回复--error---%@",error);
    }];
}
//提交评论
-(void)commintComment:(NSString*)text{
    if (text.length == 0) {
        [MBProgressHUD showError:@"请您输入评论内容" toView:self.view];
        return;
    }
    NSMutableDictionary* sendCommentPramas = [[NSMutableDictionary alloc]  init];
    if (self.toolView.commentType == 1) {
        [sendCommentPramas setObject:self.commentMode.demandCommentModel.commentId forKey:@"targetId"];
    }else if (self.toolView.commentType == 2){
        [sendCommentPramas setObject:self.commentMode.demandCommentModel.commentId forKey:@"targetId"];
      // [sendCommentPramas setObject:self.commentMode.replayList.commentId forKey:@"targetId"];
    }else if (self.toolView.commentType == 0){
        [sendCommentPramas setObject:@"" forKey:@"targetId"];
    }
    self.toolView.commentType = 0;
    self.toolView.sendTextView.text = nil;
    self.toolView.sendTextView.placehoder = @"说点什么...";
    [self coverBtnClicked];
    bool isIphoneX = (self.scNavigationBar.sc_height == 88.0) ? true : false;
    CGFloat botttomHeight = isIphoneX ? 34 : 0;
    self.toolView.frame = CGRectMake(0,ScreenHeight-53-botttomHeight, ScreenWidth, 53);
    NSString* sendComment = @"sendComment";
    [sendCommentPramas setObject:[PVUserModel shared].token forKey:@"token"];
    [sendCommentPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    [sendCommentPramas setObject:self.fristVideoDetailModel.parentCode forKey:@"code"];
    [sendCommentPramas setObject:text forKey:@"content"];
    [PVNetTool postDataWithParams:sendCommentPramas url:sendComment success:^(id result) {
        if (result[@"errorMsg"] != nil && result[@"errorMsg"] != [NSNull null]) {
            [MBProgressHUD showSuccess:@"评论待审核" toView:self.view];
        }else if (result[@"errorMsg"]){
            [MBProgressHUD showError:result[@"errorMsg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接失败" toView:self.view];
    }];
}

//提交观看记录和本地记录
-(void)commintUserPlayRecord{
    NSString* time = [NSDate PVDateToStringTime:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeLength = [NSString stringWithFormat:@"%d",(int)[self.playView.player currentPlaybackTime]];
    if (timeLength.integerValue < 1) return;
    if (self.fristVideoDetailModel.videoType.integerValue == 1) {
        self.recordAnthologyModel.playVideoLength = timeLength;
        self.recordAnthologyModel.playStopTime = time;
        self.recordAnthologyModel.jsonUrl = self.url;
        [[PVDBManager sharedInstance] insertVisitVideoModel:self.recordAnthologyModel];
    }else{
        PVDemandVideoAnthologyModel* anthologyModel = [[PVDemandVideoAnthologyModel alloc]  init];
        anthologyModel.playVideoLength = timeLength;
        anthologyModel.playStopTime = time;
        anthologyModel.code = self.fristVideoDetailModel.code;
        anthologyModel.verticalPic = self.fristVideoDetailModel.videoImage;
        anthologyModel.videoType = self.fristVideoDetailModel.videoType;
        anthologyModel.videoUrl = self.fristVideoDetailModel.videoUrl;
        anthologyModel.jsonUrl = self.url;
        anthologyModel.videoName = self.fristVideoDetailModel.videoTitle;
        [[PVDBManager sharedInstance] insertVisitVideoModel:anthologyModel];
    }
    if (![PVUserModel shared].token.length) {
        return;
    }
    NSString* code = @"";
    if (self.fristVideoDetailModel.videoType.integerValue == 1) {
        code = self.recordAnthologyModel.code;
    }else{
        code = self.fristVideoDetailModel.code;
    }
    NSString* recordPlay = @"setUserPlayRecord";    
    NSMutableDictionary* recordPlayPramas = [[NSMutableDictionary alloc]  init];
    [recordPlayPramas setObject:[PVUserModel shared].token forKey:@"token"];
    [recordPlayPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    if (code.length == 0) {
        return;
    }
    [recordPlayPramas setObject:code forKey:@"code"];
    [recordPlayPramas setObject:timeLength forKey:@"playLength"];
    [recordPlayPramas setObject:time forKey:@"time"];
    [PVNetTool postDataWithParams:recordPlayPramas url:recordPlay success:^(id result) {
    } failure:^(NSError *error) {
    }];
}
@end
