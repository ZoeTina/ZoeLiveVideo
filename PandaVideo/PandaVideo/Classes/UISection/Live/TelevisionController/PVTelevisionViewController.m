//
//  PVTelevisionViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTelevisionViewController.h"
#import "PVLiveInfoView.h"
#import "PVProGramViewController.h"
#import "PVChannelViewController.h"
#import "PVVideoMoreView.h"
#import "PVVideoShareView.h"
#import "PVVideoDefinitionView.h"
#import "PVVideoProgramViewController.h"
#import "PVVideoChannelViewController.h"
#import "PVLiveTelevisionDefaultChannelModel.h"
#import "PVLiveTelevisionProGramModel.h"
#import "PVShareViewController.h"
#import "PVShareTool.h"

#define videoMoreHeight  342*CaraScreenH/1334

@interface PVTelevisionViewController () <VideoPlayerViewDelegate>

///直播显示图容器
@property(nonatomic, strong)UIView* liveContainerView;
///直播view容器
@property(nonatomic, strong)UIView* livePlayContainerView;
///显示直播信息的view
@property(nonatomic, strong)PVLiveInfoView* liveInfoView;
///频道view
@property(nonatomic, strong)PVChannelViewController*  channelViewController;
///节目单view
@property(nonatomic, strong)PVProGramViewController*  proGramViewController;
///更多
@property(nonatomic, strong)PVVideoMoreView* videoMoreView;
///分享
@property(nonatomic, strong)PVVideoShareView* videoShareView;
///清晰度
@property(nonatomic, strong)PVVideoDefinitionView* videoDefinitionView;
//直播频道
@property(nonatomic, strong)PVVideoChannelViewController* videoChannelViewController;
//直播节目单
@property(nonatomic, strong)PVVideoProgramViewController* videoProgramViewController;
///遮盖
@property(nonatomic, strong)UIButton* coverBtn;
///广播
@property(nonatomic, strong)AppDelegate* appDelegate;
///用来控制显示播放视频还是广播
@property(nonatomic, assign)BOOL isDisplayVideo;
///默认播放频道
@property(nonatomic, strong)PVLiveTelevisionDefaultChannelModel* defaultChannelModel;
///正在播放的url
@property(nonatomic, copy)NSString* playingUrl;
///定时器记录是否今天已经over
@property(nonatomic, strong)NSTimer* timer;
///版权view
@property(nonatomic, strong)UIButton* copyRightBtn;

@end

@implementation PVTelevisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reminderBtn.hidden = true;
}

-(void)startTime{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timeClicked) userInfo:nil repeats:true];
}
///处理零点
-(void)timeClicked{
    NSString* todayString = [NSDate PVDateToStringTime:[NSDate date] format:@"YYYY-MM-dd"];
    todayString = [NSString stringWithFormat:@"%@ 23:59:59",todayString];
    double todayTime = [NSDate PVDateToTimeStamp:[NSDate PVDateStringToDate:todayString formatter:@"YYYY-MM-dd HH:mm:ss"] format:@"YYYY-MM-dd HH:mm:ss"];
    double  nowTime = [NSDate PVDateToTimeStamp:[NSDate date] format:@"YYYY-MM-dd HH:mm:ss"];
    if (nowTime >= todayTime) {
        [self stopTime];
        NSLog(@"更新节目单");
        for (PVLiveTelevisionDetailProGramModel* tempDetailProGramModel in self.proGramViewController.defaultProGramModel.programs) {
            tempDetailProGramModel.type = 1;
        }
        if (self.proGramViewController.defaultProGramModel.type == 1 && self.proGramViewController.defaultDetailProGramModel.type == 2 && self.proGramViewController.defaultDetailProGramModel.isPlaying) {
            self.proGramViewController.defaultProGramModel.isSelected = false;
            self.proGramViewController.defaultProGramModel = self.proGramViewController.timeDataSource.firstObject;
            self.proGramViewController.defaultProGramModel.isSelected = true;
            self.proGramViewController.defaultDetailProGramModel.type = 1;
            self.proGramViewController.defaultDetailProGramModel.isPlaying = false;
            PVLiveTelevisionDetailProGramModel* detailProGramModel = self.proGramViewController.defaultProGramModel.programs.firstObject;
            detailProGramModel.type = 2;
            detailProGramModel.isPlaying = true;
            self.proGramViewController.defaultDetailProGramModel = detailProGramModel;
        }
        for (PVLiveTelevisionProGramModel*tempProGramModel in self.proGramViewController.timeDataSource) {
            if (tempProGramModel.type == 1) {
                tempProGramModel.type = 2;
            }else if (tempProGramModel.type == 2){
                tempProGramModel.type = 10;
            }else if (tempProGramModel.type == 3){
                tempProGramModel.type = 1;
            }
        }
       [self.proGramViewController setDisplayTime];
        
        ///刷新
        [self reloadProGramAndTime];
        [self reloadCrossPprogramAndTime];
    }
//    NSLog(@"todayString = %@-----todayTime = %f------nowTime = %f----",todayString,todayTime,nowTime);
}
-(void)stopTime{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)setDefaultChannelModel:(PVLiveTelevisionDefaultChannelModel *)defaultChannelModel{
    _defaultChannelModel = defaultChannelModel;
//    self.liveInfoView.titleLabel.text = [NSString stringWithFormat:@"    %@",defaultChannelModel.channelName];
}

-(void)setUrl:(NSString *)url{
    _url = url;
    [PVNetTool getDataWithUrl:url success:^(id result) {
        if (result) {
            [self setupUI];
            if (result[@"defaultChannel"]) {
                PVLiveTelevisionDefaultChannelModel* defaultChannelModel = [[PVLiveTelevisionDefaultChannelModel alloc]  init];
                [defaultChannelModel setValuesForKeysWithDictionary:result[@"defaultChannel"]];
                PVLiveTelevisionChanelListModel*  chanelListModel = [[PVLiveTelevisionChanelListModel alloc]  init];
                [chanelListModel setValuesForKeysWithDictionary:result[@"defaultChannel"]];
                defaultChannelModel.chanelListModel = chanelListModel;
                self.defaultChannelModel = defaultChannelModel;
                self.channelViewController.defaultChannelModel = self.defaultChannelModel;
                self.channelViewController.selectedChanelListModel = defaultChannelModel.chanelListModel;

                if(self.jumpType.intValue == 1){
                    ///跳转过来滴
                    [self loadJumpData:self.jumpUrl];
                }else{
                    ///播放默认的频道
                    [self playFirstVideo:self.defaultChannelModel.chanelListModel];
                    ///发送默认频道的请求
                    self.proGramViewController.url = defaultChannelModel.programUrl;
                }
         
            }
            if (result[@"channelUrl"]) {
                self.channelViewController.url = result[@"channelUrl"];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"---error----=%@-",error);
    }];
}

-(void)setJumpUrl:(NSString *)jumpUrl{    
    _jumpUrl  = jumpUrl;
    if (self.jumpType.intValue == 1) return;
    if (jumpUrl.length) {
        [self loadJumpData:jumpUrl];
    }
}
-(void)loadJumpData:(NSString*)jumpUrl{
    [PVNetTool getDataWithUrl:jumpUrl success:^(id result) {
        if (result && result[@"channelInfo"]) {
            PVLiveTelevisionChanelListModel* tempChanelListModel = [[PVLiveTelevisionChanelListModel alloc]  init];
            [tempChanelListModel setValuesForKeysWithDictionary:result[@"channelInfo"]];
            if (tempChanelListModel.backProgramInfoModel) {
                PVLiveTelevisionProGramModel* proGramModel = [[PVLiveTelevisionProGramModel alloc]  init];
                proGramModel.date = tempChanelListModel.backProgramInfoModel.startDate;
                proGramModel.type = 2;
                proGramModel.isSelected = true;
                self.proGramViewController.defaultProGramModel = proGramModel;
                PVLiveTelevisionDetailProGramModel* detailProGramModel = [[PVLiveTelevisionDetailProGramModel alloc]  init];
                detailProGramModel.startTime = tempChanelListModel.backProgramInfoModel.startTime;
                detailProGramModel.duration = tempChanelListModel.backProgramInfoModel.duration;
                detailProGramModel.programId = tempChanelListModel.backProgramInfoModel.programCode;
                detailProGramModel.type = 2;
                self.proGramViewController.defaultDetailProGramModel = detailProGramModel;
            }
            if (self.jumpType.intValue == 1) {//新生成的对象
                self.defaultChannelModel.channelId = tempChanelListModel.channelId;
                self.defaultChannelModel.stationId = tempChanelListModel.stationId;
                self.defaultChannelModel.channelName = tempChanelListModel.channelName;
                self.defaultChannelModel.chanelListModel = tempChanelListModel;
                self.channelViewController.selectedChanelListModel = tempChanelListModel;
                self.channelViewController.defaultChannelModel = self.defaultChannelModel;
                if (tempChanelListModel.backProgramInfoModel) {
                    ///播放默认的回看节目单
                    [self playFirstBackProgram:tempChanelListModel];
                }else{
                    ///播放默认的频道
                    [self playFirstVideo:self.defaultChannelModel.chanelListModel];
                }
                ///发送默认频道的请求
                self.proGramViewController.url = tempChanelListModel.programUrl;
                
            }else{//已经有对象
                for (PVLiveTelevisionAreaModel* areaModel in self.channelViewController.channelDataSource) {
                    if ([areaModel.stationId isEqualToString:tempChanelListModel.stationId]) {
                        self.channelViewController.selectedAreaModel.isSelected = false;
                        self.channelViewController.selectedAreaModel = areaModel;
                        self.channelViewController.selectedAreaModel.isSelected = true;
                        break;
                    }
                }
                if (self.channelViewController.selectedAreaModel.chanelList.count > 0) {
                    for (PVLiveTelevisionChanelListModel* chanelListModel in self.channelViewController.selectedAreaModel.chanelList) {
                        if ([chanelListModel.channelId isEqualToString:tempChanelListModel.channelId]) {
                        self.channelViewController.selectedChanelListModel.isSelected = false;
                            self.channelViewController.selectedChanelListModel = chanelListModel;
                        self.channelViewController.selectedChanelListModel.isSelected = true;
                            //频道切换数据源
                            [self reloadChannelAndArea];
                            if (tempChanelListModel.backProgramInfoModel) {
                                ///播放默认的回看节目单
                                [self playFirstBackProgram:tempChanelListModel];
                                ///发送默认频道的请求
                            }else{
                                [self chargeData:chanelListModel];
                            }
                            break;
                        }
                    }
                    
                    //找回看的日期
                    if (tempChanelListModel.backProgramInfoModel) {
                        if(self.channelViewController.selectedChanelListModel.programs.count == 0) {
                            ///发送默认频道的请求
                            self.proGramViewController.url = self.channelViewController.selectedChanelListModel.programDateUrl;
                        }else{
                            for (PVLiveTelevisionProGramModel* proGramModel in self.channelViewController.selectedChanelListModel.programs) {
                                NSString* yearStr = [proGramModel.date stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                if ([yearStr isEqualToString:tempChanelListModel.backProgramInfoModel.startDate]) {
                               
                                    for (PVLiveTelevisionProGramModel* tempProGramModel in self.proGramViewController.disPlayDataSource) {
                                        tempProGramModel.isSelected = false;
                                    }
                                self.proGramViewController.defaultProGramModel.isSelected = false;
                                    self.proGramViewController.defaultProGramModel = proGramModel;
                                self.proGramViewController.defaultProGramModel.isSelected = true;
                                    [self.proGramViewController.timeDataSource removeAllObjects];
                                    [self.proGramViewController.timeDataSource addObjectsFromArray:self.channelViewController.selectedChanelListModel.programs];
                                    [self.proGramViewController setDisplayTime];
                                    [self.proGramViewController.timeTableView reloadData];
                                    break;
                                }
                            }
                            if (self.proGramViewController.defaultProGramModel.programs.count) {
                                for (PVLiveTelevisionDetailProGramModel* detailProGramModel in self.proGramViewController.defaultProGramModel.programs) {
                                    if ([detailProGramModel.programId isEqualToString:tempChanelListModel.backProgramInfoModel.programCode]) {
                                        [self.proGramViewController.defaultDetailProGramModel calculationProgramTime:tempChanelListModel.backProgramInfoModel.startDate];
                                        detailProGramModel.type = 2;
                                        self.proGramViewController.defaultDetailProGramModel = detailProGramModel;
                                        [self.proGramViewController.proGramTableView reloadData];
                                        break;
                                    }
                                }
                            }else{
                                [self.proGramViewController.proGramTableView.mj_header beginRefreshing];
                            }
                        }
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"---error----=%@-",error);
    }];
}




-(void)playFirstVideo:(PVLiveTelevisionChanelListModel*)chanelListModel{
    self.liveInfoView.titleLabel.text = [NSString stringWithFormat:@"    %@",chanelListModel.channelName];
    //播放默认频道
    if (chanelListModel.channelType.intValue == 1) {//广播1
        for (PVLiveTelevisionCodeRateList* codeRateList in chanelListModel.codeRateLists) {
            if (codeRateList.isSelected) {//播放广播
                NSString* backUrl = chanelListModel.liveUrl;
                NSString* url = [backUrl stringByReplacingOccurrencesOfString:@"index.m3u8" withString:codeRateList.rateFileUrl];
                self.playingUrl = url;
                self.isDisplayVideo = false;
                break;
            }
        }
    }else{//视频
        for (PVLiveTelevisionCodeRateList* codeRateList in chanelListModel.codeRateLists) {
            if (codeRateList.isSelected) {//播放视频
                NSString* backUrl = chanelListModel.liveUrl;
                NSString* url = [backUrl stringByReplacingOccurrencesOfString:@"index.m3u8" withString:codeRateList.rateFileUrl];
                self.playingUrl = url;
                [self.playView.playControView.definitionBtn setTitle:codeRateList.showName forState:UIControlStateNormal];
                self.isDisplayVideo = true;
                break;
            }
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.playingUrl.length) {
        if (self.isDisplayVideo) {
            self.typePage = 0;
        }
        /*
        else if (![self.appDelegate.broadCastPlayer isPlaying] &&             self.broadCastContainerView.authenticationType == 3){
            [self.appDelegate playBroadCast:self.appDelegate.playVideoModel];
            if (!self.broadCastContainerView.isDispLayAnimate) {
                self.broadCastContainerView.isDispLayAnimate = true;
            }
        }*/
        else if ([self.appDelegate.broadCastPlayer isPlaying] &&             self.broadCastContainerView.authenticationType == 3){
            if (!self.broadCastContainerView.isDispLayAnimate) {
                self.broadCastContainerView.isDispLayAnimate = true;
            }
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.broadCastContainerView.isDispLayAnimate = false;
    [self stopPlayVideo];
}

-(void)setIsDisplayVideo:(BOOL)isDisplayVideo{
    _isDisplayVideo = isDisplayVideo;
    [self stopPlayVideo];
    if (self.playingUrl.length == 0) return;
    if (isDisplayVideo) {
        self.broadCastContainerView.hidden = true;
        [self.appDelegate stopBroadCastPlay:true];
        self.typePage = 0;
    }else{
        if (self.playView.playControView.player != nil) {
            [self.playView.playControView videoStop];
            [self.playView removeFromSuperview];
            self.playView = nil;
            [self.playContainerView removeFromSuperview];
            self.playContainerView = nil;
        }
        self.broadCastContainerView.hidden = false;
        if ([self.appDelegate.broadCastPlayer isPlaying]) {
            self.broadCastContainerView.FMPlayOrStopBtn.selected = false;
           // self.broadCastContainerView.isDispLayAnimate = true;
        }else{
            self.broadCastContainerView.FMPlayOrStopBtn.selected = true;
           // self.broadCastContainerView.isDispLayAnimate = false;
        }
        if (!self.appDelegate.broadCastPlayer && ![self.appDelegate.broadCastPlayer isPlaying]) {
            self.copyRightBtn.hidden = true;
            //生成model
            PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
            playVideoModel.url = [NSURL URLWithString:self.playingUrl];
            playVideoModel.copyright = self.channelViewController.selectedChanelListModel.copyright;
            playVideoModel.videoDistrict = self.channelViewController.selectedChanelListModel.area;
            playVideoModel.code = self.channelViewController.selectedChanelListModel.valiDataCode;
            [self.appDelegate playBroadCast:playVideoModel];
            self.broadCastContainerView.FMPlayOrStopBtn.selected = false;
           // self.broadCastContainerView.isDispLayAnimate = true;
        }
    }
}
-(void)stopPlayVideo{
    if (self.playView.playControView.isRotate) {
        [self.playView.playControView backBtnClicked];
    }
    if (self.playView.playControView.player != nil) {
        [self.playView.playControView videoStop];
    }
    [self.playView removeFromSuperview];
    self.playView = nil;
    [self.playContainerView removeFromSuperview];
    self.playContainerView = nil;
}
-(void)setTypePage:(NSInteger)typePage{
    _typePage = typePage;
    if (self.playingUrl.length == 0) return;
    UIScrollView* contentView = (UIScrollView*)[self.view superview];
    if (typePage == 0 && [self.appDelegate.broadCastPlayer isPlaying]) {
        if (!self.broadCastContainerView.isDispLayAnimate) {
            self.broadCastContainerView.isDispLayAnimate = true;
        }
    }else if (typePage == 1){
        self.broadCastContainerView.isDispLayAnimate = false;
    }
    if (contentView.contentOffset.x == 0 && typePage == 0 && ![self.playContainerView.subviews containsObject:self.playView] && self.isDisplayVideo) {
        if (![self.playView.player isPlaying] && [self.view isShowingOnKeyWindow]) {
            PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
            playVideoModel.url = [NSURL URLWithString:self.playingUrl];
            if (self.proGramViewController.defaultDetailProGramModel.isPlaying || !self.proGramViewController.defaultDetailProGramModel) {
                playVideoModel.type = 3;
            }else{
                playVideoModel.type = 5;
            }
            playVideoModel.copyright = self.channelViewController.selectedChanelListModel.copyright;
            playVideoModel.videoDistrict = self.channelViewController.selectedChanelListModel.area;
            playVideoModel.code = self.channelViewController.selectedChanelListModel.valiDataCode;
            if (playVideoModel.copyright.integerValue == 1) {
                [self stopPlayVideo];
                self.copyRightBtn.hidden = false;
                return;
            }else{
                self.copyRightBtn.hidden = true;
            }
            [self goPlayingPlayVideoModel:playVideoModel delegate:self];
            [self setupVideoUI];
            [self.playView.playControView videoFirstPlay];
            self.playView.playControView.videoTitleName =  self.channelViewController.selectedChanelListModel.channelName;
        }
    }else if (contentView.contentOffset.x == ScreenWidth  && typePage == 1){
        if (self.playView.playControView.player != nil) {
            [self.playView.playControView videoStop];
            [self.playView removeFromSuperview];
            self.playView = nil;
            [self.playContainerView removeFromSuperview];
            self.playContainerView = nil;
        }
    }
}
-(void)setupUI{
    _isDisplayVideo = true;
    self.appDelegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    self.view.backgroundColor = [UIColor sc_colorWithHex:0xD7D7D7];
    [self.view addSubview:self.liveContainerView];
    self.proGramViewController.view.hidden = true;
    self.channelViewController.view.hidden = false;
}
-(UIView *)liveContainerView{
    if (!_liveContainerView) {
        _liveContainerView = [[UIView alloc]  init];
        _liveContainerView.frame = CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenWidth*9/16+40);
        _liveContainerView.backgroundColor = [UIColor whiteColor];
        [_liveContainerView addSubview:self.livePlayContainerView];
        [_liveContainerView addSubview:self.broadCastContainerView];
        [_liveContainerView addSubview:self.liveInfoView];
    }
    return _liveContainerView;
}
-(UIView *)livePlayContainerView{
    if (!_livePlayContainerView) {
        _livePlayContainerView = [[UIView alloc]  init];
        _livePlayContainerView.frame = CGRectMake(0, 0, ScreenWidth, IPHONE6WH(ScreenWidth*9/16));
        _livePlayContainerView.backgroundColor = [UIColor blackColor];
    }
    return _livePlayContainerView;
}
-(PVLiveInfoView *)liveInfoView{
    if (!_liveInfoView) {
        CGRect frame = CGRectMake(0, ScreenWidth*9/16, ScreenWidth, 40);
        _liveInfoView = [[PVLiveInfoView alloc]  initWithFrame:frame];
        _liveInfoView.backgroundColor = [UIColor whiteColor];
        ///各种点击事件
        PV(pv)
        [_liveInfoView setProgramBtnClickedBlock:^(UIButton* proGramBtn) {
            pv.proGramViewController.view.hidden = proGramBtn.selected;
            pv.channelViewController.view.hidden = !proGramBtn.selected;
        }];
        [_liveInfoView setScreenBtnClickedBlock:^{
            NSLog(@"投屏");
        }];
        [_liveInfoView setShakeBtnClickedBlock:^{
            NSLog(@"分享");
            PVShareViewController *con = [[PVShareViewController alloc] init];
            PVShareModel *shareModel = [[PVShareModel alloc] init];
            shareModel.imageUrl =  pv.channelViewController.selectedChanelListModel.channelLogo;
            shareModel.sharetitle = pv.channelViewController.selectedChanelListModel.channelName;
            shareModel.h5Url = pv.channelViewController.selectedChanelListModel.channelShareUrl;
//            shareModel.descriptStr = self.findHomeModel.subTitle;
            con.shareModel = shareModel;
            con.modalPresentationStyle = UIModalPresentationCustom;
            [pv.navigationController presentViewController:con animated:NO completion:nil];
        }];
    }
    return _liveInfoView;
}
-(PVChannelViewController *)channelViewController{
    if(!_channelViewController){
        _channelViewController  = [[PVChannelViewController alloc]  init];
        _channelViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.liveContainerView.frame), ScreenWidth, self.view.sc_height-CGRectGetMaxY(self.liveContainerView.frame));
        [self addChildViewController:_channelViewController];
        [self.view addSubview:_channelViewController.view];
        PV(pv)
        [_channelViewController setPVChannelViewControllerCallBlock:^(PVLiveTelevisionChanelListModel *chanelListModel) {
            [pv chargeData:chanelListModel];
        }];
    }
    return _channelViewController;
}
-(PVProGramViewController *)proGramViewController{
    if(!_proGramViewController){
        _proGramViewController  = [[PVProGramViewController alloc]  init];
        _proGramViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.liveContainerView.frame), ScreenWidth, self.view.sc_height-CGRectGetMaxY(self.liveContainerView.frame));
        [self addChildViewController:_proGramViewController];
        [self.view addSubview:_proGramViewController.view];
        PV(pv)
        [_proGramViewController setPVPlayProGramCallBlock:^(PVLiveTelevisionDetailProGramModel *defaultDetailProGramModel) {
            [pv chargeproGram:defaultDetailProGramModel yearDate:nil];
            defaultDetailProGramModel.type = 2;
            [pv.proGramViewController.proGramTableView reloadData];
        }];
    }
    return _proGramViewController;
}
#pragma mark - 播放器************************************
-(void)setupVideoUI{
    [self.playContainerView addSubview:self.coverBtn];
    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.playContainerView);
    }];    
    [self.playContainerView addSubview:self.videoMoreView];
    [self setMoreViewConstrints:self.videoMoreView];
    [self.playContainerView addSubview:self.videoShareView];
    [self setMoreViewConstrints:self.videoShareView];
    [self.playContainerView addSubview:self.videoDefinitionView];
    [self setMoreViewConstrints:self.videoDefinitionView];
    [self.playContainerView addSubview:self.videoProgramViewController.view];
    [self seTVideoProgramViewConstrints:self.videoProgramViewController.view];
    [self.playContainerView addSubview:self.videoChannelViewController.view];
    [self seTVideoProgramViewConstrints:self.videoChannelViewController.view];
}

-(void)setMoreViewConstrints:(UIView*)view{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.playContainerView);
        make.right.equalTo(self.playContainerView.mas_right).offset(videoMoreHeight);
        make.width.equalTo(@(videoMoreHeight));
    }];
}
-(void)seTVideoProgramViewConstrints:(UIView*)view{
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.playContainerView);
    make.right.equalTo(self.playContainerView.mas_right).offset(CaraScreenH*0.5);
        make.width.equalTo(@(CaraScreenH*0.5));
    }];
}
#pragma mark - 控制层VideoPlayerViewDelegate************************************
-(void)delegateMoreBtnClicked{
    self.videoMoreView.isCollect = self.channelViewController.selectedChanelListModel.isCollect;
    [self showMoreView:self.videoMoreView];
    NSLog(@"更多");
}
-(void)delegateShareBtnClicked{
    [self showMoreView:self.videoShareView];
    NSLog(@"分享");
}
-(void)delegateDefinitionBtnClicked{
    self.videoDefinitionView.chanelListModel = self.channelViewController.selectedChanelListModel;
    [self showMoreView:self.videoDefinitionView];
    NSLog(@"清晰度");
}
-(void)delegateAnthologyBtnClicked{
    self.videoChannelViewController.selectedAreaModel = self.channelViewController.selectedAreaModel;
    self.videoChannelViewController.selectedChanelListModel = self.channelViewController.selectedChanelListModel;
    self.videoChannelViewController.defaultChannelModel = self.channelViewController.defaultChannelModel;
    [self.videoChannelViewController.timeDataSource removeAllObjects];
    [self.videoChannelViewController.timeDataSource addObjectsFromArray:self.channelViewController.channelDataSource];
    //切换横屏频道数据
    [self reloadCrossChannelAndArea];
    [self showMoreView:self.videoChannelViewController.view];
    NSLog(@"频道");
}

///切换频道数据源
-(void)reloadCrossChannelAndArea{
    [self.videoChannelViewController.timeTableView reloadData];
    if (self.videoChannelViewController.selectedAreaModel) {
        NSInteger index = [self.videoChannelViewController.timeDataSource indexOfObject:self.videoChannelViewController.selectedAreaModel];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.videoChannelViewController.timeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    }
    [self.videoChannelViewController.proGramTableView reloadData];
    if (self.videoChannelViewController.selectedChanelListModel) {
        NSInteger index = [self.videoChannelViewController.selectedAreaModel.chanelList indexOfObject:self.videoChannelViewController.selectedChanelListModel];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.videoChannelViewController.proGramTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    }
}

-(void)delegateProgramBtnClicked{
    //切换横屏节目单
    [self reloadCrossPprogramAndTime];
    [self showMoreView:self.videoProgramViewController.view];
    NSLog(@"节目单");
}

-(void)reloadCrossPprogramAndTime{
    self.videoProgramViewController.defaultProGramModel = self.proGramViewController.defaultProGramModel;
    self.videoProgramViewController.defaultDetailProGramModel = self.proGramViewController.defaultDetailProGramModel;
    [self.videoProgramViewController.timeDataSource removeAllObjects];
    [self.videoProgramViewController.timeDataSource addObjectsFromArray:self.proGramViewController.disPlayDataSource];
    [self.videoProgramViewController.timeTableView reloadData];
    if (self.proGramViewController.defaultProGramModel) {
        NSInteger index = [self.proGramViewController.disPlayDataSource indexOfObject:self.proGramViewController.defaultProGramModel];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.videoProgramViewController.timeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    }
    [self.videoProgramViewController.proGramTableView reloadData];
    if (self.proGramViewController.defaultDetailProGramModel) {
        NSInteger index = [self.proGramViewController.defaultProGramModel.programs indexOfObject:self.proGramViewController.defaultDetailProGramModel];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.videoProgramViewController.proGramTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    }
}
-(void)delegateNextBtnClicked{
    if(self.proGramViewController.defaultDetailProGramModel.isPlaying && self.proGramViewController.defaultDetailProGramModel.type == 2) {
        //播放下一个
        self.proGramViewController.defaultDetailProGramModel.isPlaying = false;
        self.proGramViewController.defaultDetailProGramModel.type = 1;
        NSInteger index = [self.proGramViewController.defaultProGramModel.programs indexOfObject:self.proGramViewController.defaultDetailProGramModel];
        NSInteger count = self.proGramViewController.defaultProGramModel.programs.count-1;
        if (index < count) {//去下一个节目单
            self.proGramViewController.defaultDetailProGramModel = self.proGramViewController.defaultProGramModel.programs[index+1];
            self.proGramViewController.defaultDetailProGramModel.isPlaying = true;
            self.proGramViewController.defaultDetailProGramModel.type = 2;
        }else if (index == count){//今天播放完毕，更新明天节目单数据
            PVLiveTelevisionProGramModel*  tempProGramModel = nil;
            for (PVLiveTelevisionProGramModel* proGramModel in self.proGramViewController.timeDataSource) {
                if (proGramModel.type == 3) {
                    proGramModel.type = 1;
                    proGramModel.isSelected = true;
                    tempProGramModel = proGramModel;
                    continue;
                }else if (proGramModel.type == 2){
                    proGramModel.type = 10;
                    continue;
                }
            }
            self.proGramViewController.defaultProGramModel.isSelected = false;
            self.proGramViewController.defaultProGramModel.type = 2;
            self.proGramViewController.defaultProGramModel = tempProGramModel;
            self.proGramViewController.defaultDetailProGramModel = tempProGramModel.programs.firstObject;
            self.proGramViewController.defaultDetailProGramModel.type = 2;
            self.proGramViewController.defaultDetailProGramModel.isPlaying = true;
        }
        //切换节目单
        [self reloadCrossPprogramAndTime];
        [self reloadProGramAndTime];
        NSLog(@"下一集直播");
    }
}
#pragma mark - 懒加载************************************
-(PVVideoMoreView *)videoMoreView{
    if (!_videoMoreView) {
        _videoMoreView = [[PVVideoMoreView alloc]  init];
        _videoMoreView.hidden = true;
        PV(pv)
        [_videoMoreView setPVVideoMoreViewCallBlock:^{
            pv.videoMoreView.collectBtn.selected = !pv.videoMoreView.collectBtn.selected;
            if (!pv.channelViewController.selectedChanelListModel.isCollect) {//进行收藏
                pv.channelViewController.selectedChanelListModel.isCollect = true;
                [[PVDBManager sharedInstance]  insertLiveChannelModel:pv.channelViewController.selectedChanelListModel];
                [pv.playView makeToast:@"收藏成功" duration:2 position:CSToastPositionCenter];
            }else{
                pv.channelViewController.selectedChanelListModel.isCollect = false;
                [[PVDBManager sharedInstance] deleteLiveChannelModel:pv.channelViewController.selectedChanelListModel];
                [pv.playView makeToast:@"取消成功" duration:2 position:CSToastPositionCenter];
            }
            for (PVLiveTelevisionAreaModel* areaModel in pv.channelViewController.channelDataSource) {
                for (PVLiveTelevisionChanelListModel* tempChanelListModel in areaModel.chanelList) {
                    if ([tempChanelListModel.channelId isEqualToString:pv.channelViewController.selectedChanelListModel.channelId]) {
                        tempChanelListModel.isCollect =  pv.channelViewController.selectedChanelListModel.isCollect;
                        break;
                    }
                }
            }
            PVLiveTelevisionAreaModel* areaModel = pv.channelViewController.channelDataSource.firstObject;
            if ([areaModel.stationId isEqualToString:@"-11"]) {
                [pv.channelViewController.channelDataSource removeObject:areaModel];
            }
            [pv.channelViewController loadLocalCollectionData];
            [pv.channelViewController.channelDetailTableView reloadData];
            [pv.channelViewController.channelTableView reloadData];
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
            shareModel.imageUrl =  pv.channelViewController.selectedChanelListModel.channelLogo;
            shareModel.sharetitle = pv.channelViewController.selectedChanelListModel.channelName;
            shareModel.h5Url = pv.channelViewController.selectedChanelListModel.channelShareUrl;
//            shareModel.descriptStr = pv.videoDetailModel.videoSubTitle;
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
                    //[pv.playContainerView makeToast:shareResultStr duration:2 position:CSToastPositionCenter];
                }];
            }
        }];
        
    }
    return _videoShareView;
}
-(PVVideoDefinitionView *)videoDefinitionView{
    if (!_videoDefinitionView) {
        _videoDefinitionView = [[PVVideoDefinitionView alloc]  init];
        _videoDefinitionView.hidden = true;
        PV(pv)
        [_videoDefinitionView setPVVideoDefinitionViewBlock:^(PVLiveTelevisionChanelListModel *chanelListModel) {
            [pv.proGramViewController.defaultDetailProGramModel calculationProgramTime:pv.proGramViewController.defaultProGramModel.date];
            [pv coverBtnClicked];
            for (PVLiveTelevisionCodeRateList* codeRateList in chanelListModel.codeRateLists) {
                if (codeRateList.isSelected) {//播放视频
                    NSString* backUrl = @"";
                    if (pv.proGramViewController.defaultDetailProGramModel.isPlaying || !pv.proGramViewController.defaultDetailProGramModel) {//取直播地址
                        backUrl = chanelListModel.liveUrl;
                    }else if (pv.proGramViewController.defaultDetailProGramModel.type == 1){//取回看地址
                        backUrl = chanelListModel.lookbackUrl;
                    }
                    NSString* url = [backUrl stringByReplacingOccurrencesOfString:@"index.m3u8" withString:codeRateList.rateFileUrl];
                    if (pv.proGramViewController.defaultDetailProGramModel.type == 1) {
                        url = [self playBackUrl:pv.proGramViewController.defaultDetailProGramModel url:url isDefination:true yearDate:nil];
                    }
                    pv.proGramViewController.defaultDetailProGramModel.type = 2;
                    pv.playingUrl = url;
                    NSInteger typeIndex = 3;
                    if(pv.proGramViewController.defaultDetailProGramModel.isPlaying)
                    {
                        typeIndex = 3;
                    }
                    pv.videoType = typeIndex;
                    PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];                    if(pv.proGramViewController.defaultDetailProGramModel.isPlaying){
                        playVideoModel.type = 3;
                    }else{
                        playVideoModel.type = 5;
                    }
                    
                    playVideoModel.url = [NSURL URLWithString:pv.playingUrl];
                    playVideoModel.copyright = pv.channelViewController.selectedChanelListModel.copyright;
                    playVideoModel.videoDistrict = pv.channelViewController.selectedChanelListModel.area;
                    playVideoModel.code = pv.channelViewController.selectedChanelListModel.valiDataCode;
                    [pv.playView.playControView.definitionBtn setTitle:codeRateList.showName forState:UIControlStateNormal];
                    if (playVideoModel.copyright.integerValue == 1) {
                        [pv stopPlayVideo];
                        pv.copyRightBtn.hidden = false;
                        return;
                    }else{
                        pv.copyRightBtn.hidden = true;
                    }
                    [pv.playView changeCurrentplayerItemWithPlayVideoModel:playVideoModel];
                    pv.playView.playControView.videoTitleName =  pv.channelViewController.selectedChanelListModel.channelName;
                    break;
            }
            }
        }];
    }
    return _videoDefinitionView;
}
-(PVVideoChannelViewController *)videoChannelViewController{
    if (!_videoChannelViewController) {
        _videoChannelViewController = [[PVVideoChannelViewController alloc]  init];
        _videoChannelViewController.view.hidden = true;
        PV(pv)
        [_videoChannelViewController setPVVideoChannelViewControllerCallBlock:^(PVLiveTelevisionDefaultChannelModel *defaultChannelModel, PVLiveTelevisionAreaModel *selectedAreaModel, PVLiveTelevisionChanelListModel *selectedChanelListModel) {
            [pv coverBtnClicked];
            pv.channelViewController.defaultChannelModel = defaultChannelModel;
            pv.channelViewController.selectedAreaModel = selectedAreaModel;
            pv.channelViewController.selectedChanelListModel = selectedChanelListModel;
            //频道切换数据源
            [pv reloadChannelAndArea];
            pv.videoMoreView.isCollect = pv.channelViewController.selectedChanelListModel.isCollect;
            [pv chargeData:selectedChanelListModel];
        }];
    }
    return _videoChannelViewController;
}

///切换频道数据源
-(void)reloadChannelAndArea{
    [self.channelViewController.channelTableView reloadData];
    if (self.channelViewController.selectedAreaModel) {
        NSInteger index = [self.channelViewController.channelDataSource indexOfObject:self.channelViewController.selectedAreaModel];
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.channelViewController.channelTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    }
    [self.channelViewController.channelDetailTableView reloadData];
    if (self.channelViewController.selectedChanelListModel) {
        NSInteger index = [self.channelViewController.selectedAreaModel.chanelList indexOfObject:self.channelViewController.selectedChanelListModel];
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.channelViewController.channelDetailTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    }
}

//切换频道
-(void)chargeData:(PVLiveTelevisionChanelListModel*)chanelListModel{
    PV(pv)
    pv.liveInfoView.titleLabel.text = [NSString stringWithFormat:@"    %@",chanelListModel.channelName];
    ///切换节目单数据源
    pv.proGramViewController.defaultProGramModel.isSelected = false;
    if (pv.proGramViewController.defaultDetailProGramModel.isPlaying) {
        pv.proGramViewController.defaultDetailProGramModel.type = 3;
    }else{
        pv.proGramViewController.defaultDetailProGramModel.type = 1;
    }
    pv.proGramViewController.defaultProGramModel = nil;
    pv.proGramViewController.defaultDetailProGramModel = nil;
    [pv.proGramViewController.timeDataSource removeAllObjects];
    [pv.proGramViewController.timeDataSource addObjectsFromArray:chanelListModel.programs];
    [pv.proGramViewController setDisplayTime];
    if (chanelListModel.programs.count == 0) {
        pv.proGramViewController.url = chanelListModel.programDateUrl;
    }
    for (PVLiveTelevisionProGramModel* proGramModel in chanelListModel.programs) {
        if(proGramModel.type == 1){
            proGramModel.isSelected = true;
            pv.proGramViewController.defaultProGramModel = proGramModel;
            for (PVLiveTelevisionDetailProGramModel* detailProGramModel in proGramModel.programs) {
                if (detailProGramModel.isPlaying) {
                    detailProGramModel.type = 2;
                    pv.proGramViewController.defaultDetailProGramModel = detailProGramModel;
                    break;
                }
            }
            break;
        }
    }
    //切换节目单
    [self reloadProGramAndTime];

    //播放当前频道直播视频
    if (chanelListModel.channelType.intValue == 1) {//广播1
        pv.orientation = UIInterfaceOrientationPortrait;
        [[UIApplication sharedApplication] setStatusBarHidden:false];
        [pv changeDirectionButtonAction];
        for (PVLiveTelevisionCodeRateList* codeRateList in chanelListModel.codeRateLists) {
            if (codeRateList.isSelected) {//播放广播
                NSString* backUrl = chanelListModel.liveUrl;
                NSString* url = [backUrl stringByReplacingOccurrencesOfString:@"index.m3u8" withString:codeRateList.rateFileUrl];
                pv.playingUrl = url;
                if([pv.appDelegate.broadCastPlayer isPlaying]){//切换广播
                    if (pv.appDelegate.broadCastPlayer != nil) {
                        [pv.appDelegate.broadCastPlayer shutdown];
                        [pv.appDelegate.broadCastPlayer stop];
                        pv.appDelegate.broadCastPlayer = nil;
                    }
                    pv.copyRightBtn.hidden = true;
                    //生成model
                    PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
                    playVideoModel.url = [NSURL URLWithString:pv.playingUrl];
                    playVideoModel.copyright = pv.channelViewController.selectedChanelListModel.copyright;
                    playVideoModel.videoDistrict = pv.channelViewController.selectedChanelListModel.area;
                    playVideoModel.code = pv.channelViewController.selectedChanelListModel.valiDataCode;
                    [pv.appDelegate changeBroadCast:playVideoModel];
                }else{
                    pv.isDisplayVideo = false;
                }
                break;
            }
        }
    }else{//视频
            self.broadCastContainerView.hidden = true;
            [self.appDelegate stopBroadCastPlay:true];
            for (PVLiveTelevisionCodeRateList* codeRateList in chanelListModel.codeRateLists) {
                if (codeRateList.isSelected) {//播放视频
                    NSString* backUrl = chanelListModel.liveUrl;
                    NSString* url = [backUrl stringByReplacingOccurrencesOfString:@"index.m3u8" withString:codeRateList.rateFileUrl];
                    pv.playingUrl = url;
                    [pv.playView.playControView.definitionBtn setTitle:codeRateList.showName forState:UIControlStateNormal];
                    if (pv.playView) {
                        PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
                        playVideoModel.type = 3;
                        playVideoModel.url = [NSURL URLWithString:pv.playingUrl];
                        playVideoModel.copyright = pv.channelViewController.selectedChanelListModel.copyright;
                        playVideoModel.videoDistrict = pv.channelViewController.selectedChanelListModel.area;
                        playVideoModel.code = pv.channelViewController.selectedChanelListModel.valiDataCode;
                        if (playVideoModel.copyright.integerValue == 1) {
                            [pv stopPlayVideo];
                            pv.copyRightBtn.hidden = false;
                            return;
                        }else{
                            pv.copyRightBtn.hidden = true;
                            [pv.playView changeCurrentplayerItemWithPlayVideoModel:playVideoModel];
                            pv.playView.playControView.videoTitleName =  pv.channelViewController.selectedChanelListModel.channelName;
                        }
                    }else{
                        pv.isDisplayVideo = true;
                    }
                    break;
                }
            }
        }
}


-(void)playFirstBackProgram:(PVLiveTelevisionChanelListModel*)chanelListModel{
    self.liveInfoView.titleLabel.text = [NSString stringWithFormat:@"    %@",chanelListModel.channelName];
    PVLiveTelevisionDetailProGramModel*playDetailProGramModel = [[PVLiveTelevisionDetailProGramModel alloc]  init];
    playDetailProGramModel.duration = chanelListModel.backProgramInfoModel.duration;
    playDetailProGramModel.startTime = chanelListModel.backProgramInfoModel.startTime;
    playDetailProGramModel.type = 1;
    [self chargeproGram:playDetailProGramModel yearDate:chanelListModel.backProgramInfoModel.startDate];
}


//切换节目单
-(void)chargeproGram:(PVLiveTelevisionDetailProGramModel*)playDetailProGramModel  yearDate:(NSString*)yearDate{
    PV(pv)
    PVLiveTelevisionChanelListModel*chanelListModel = self.channelViewController.selectedChanelListModel;
    if (chanelListModel.channelType.intValue == 1) {//广播1
        self.orientation = UIInterfaceOrientationPortrait;
        [[UIApplication sharedApplication] setStatusBarHidden:false];
        [self changeDirectionButtonAction];
        for (PVLiveTelevisionCodeRateList* codeRateList in chanelListModel.codeRateLists) {
            if (codeRateList.isSelected) {//播放广播
                NSString* backUrl = @"";
                if (playDetailProGramModel.type == 3) {//取直播地址
                    backUrl = chanelListModel.liveUrl;
                }else if (playDetailProGramModel.type == 1){//取回看地址
                    backUrl = chanelListModel.lookbackUrl;
                }
                NSString* url = [backUrl stringByReplacingOccurrencesOfString:@"index.m3u8" withString:codeRateList.rateFileUrl];
                if (playDetailProGramModel.type == 1) {
                    url = [self playBackUrl:playDetailProGramModel url:url isDefination:false yearDate:yearDate];
                }
                pv.playingUrl = url;
                pv.isDisplayVideo = false;
                break;
            }
        }
    }else{//视频
        self.broadCastContainerView.hidden = true;
        [self.appDelegate stopBroadCastPlay:true];
        for (PVLiveTelevisionCodeRateList* codeRateList in chanelListModel.codeRateLists) {
            if (codeRateList.isSelected) {//播放视频
                NSString* backUrl = @"";
                if (playDetailProGramModel.type == 3) {//取直播地址
                    backUrl = chanelListModel.liveUrl;
                }else if (playDetailProGramModel.type == 1){//取回看地址
                    backUrl = chanelListModel.lookbackUrl;
                }
                NSString* url = [backUrl stringByReplacingOccurrencesOfString:@"index.m3u8" withString:codeRateList.rateFileUrl];
                
                if (playDetailProGramModel.type == 1) {
                    url = [self playBackUrl:playDetailProGramModel url:url isDefination:false yearDate:yearDate];
                }
                pv.playingUrl = url;
                [pv.playView.playControView.definitionBtn setTitle:codeRateList.showName forState:UIControlStateNormal];
                if (pv.playView) {
                    PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
                    if (playDetailProGramModel.isPlaying) {
                        playVideoModel.type = 3;
                    }else{
                        playVideoModel.type = 5;
                    }
                    playVideoModel.url = [NSURL URLWithString:pv.playingUrl];
                    playVideoModel.copyright = pv.channelViewController.selectedChanelListModel.copyright;
                    playVideoModel.videoDistrict = pv.channelViewController.selectedChanelListModel.area;
                    playVideoModel.code = pv.channelViewController.selectedChanelListModel.valiDataCode;
                    if (playVideoModel.copyright.integerValue == 1) {
                        [pv stopPlayVideo];
                        pv.copyRightBtn.hidden = false;
                        return;
                    }else{
                        pv.copyRightBtn.hidden = true;
                        [pv.playView changeCurrentplayerItemWithPlayVideoModel:playVideoModel];
                        pv.playView.playControView.videoTitleName =  pv.channelViewController.selectedChanelListModel.channelName;
                    }
                }else{
                    if (yearDate) {
                        if (![pv.playView.player isPlaying] && [pv.view isShowingOnKeyWindow]) {
                            PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
                            playVideoModel.url = [NSURL URLWithString:pv.playingUrl];
                            playVideoModel.type = 5;
                            playVideoModel.copyright = pv.channelViewController.selectedChanelListModel.copyright;
                            playVideoModel.videoDistrict = pv.channelViewController.selectedChanelListModel.area;
                            playVideoModel.code = pv.channelViewController.selectedChanelListModel.valiDataCode;
                            if (playVideoModel.copyright.integerValue == 1) {
                                [pv stopPlayVideo];
                                pv.copyRightBtn.hidden = false;
                                return;
                            }else{
                                pv.copyRightBtn.hidden = true;
                            }
                            [pv goPlayingPlayVideoModel:playVideoModel delegate:self];
                            [pv setupVideoUI];
                            [pv.playView.playControView videoFirstPlay];
                            pv.playView.playControView.videoTitleName =  pv.channelViewController.selectedChanelListModel.channelName;
                        }
                    }else{
                        pv.isDisplayVideo = true;
                    }
                }
                break;
            }
        }
    }
}
-(NSString*)playBackUrl:(PVLiveTelevisionDetailProGramModel*)playDetailProGramModel  url:(NSString*)url  isDefination:(BOOL)isDefination  yearDate:(NSString*)yearDate{
    
    NSString* yearStr = [self.proGramViewController.defaultProGramModel.date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (yearDate.length) {
        yearStr = yearDate;
    }
    
    NSString* startTime = [NSString stringWithFormat:@"%@%@",yearStr,playDetailProGramModel.startTime];
    NSDate* startTimeDate = [NSDate PVDateStringToDate:startTime formatter:@"YYYYMMddHHmmss"];
    NSTimeInterval startTimeIndex = [NSDate PVDateToTimeStamp:startTimeDate format:@"YYYYMMddHHmmss"];
    
    if (isDefination) {//换清晰度
        if (playDetailProGramModel.difinationStartTime < startTimeIndex) {
            playDetailProGramModel.difinationStartTime += startTimeIndex;
        }
        startTimeIndex = playDetailProGramModel.difinationStartTime + self.playView.player.currentPlaybackTime;
        playDetailProGramModel.difinationStartTime = startTimeIndex;
        NSDate* startDate = [NSDate PVTimeStampToData:startTimeIndex format:@"YYYYMMddHHmmss"];
        startTime = [NSDate PVDateToStringTime:startDate format:@"YYYYMMddHHmmss"];
    }else{
        NSString* startTime = [NSString stringWithFormat:@"%@ %@",yearStr,playDetailProGramModel.startTime];
        NSDate* startTimeDate = [NSDate PVDateStringToDate:startTime formatter:@"YYYYMMdd HHmmss"];
        NSTimeInterval startTimeIndex = [NSDate PVDateToTimeStamp:startTimeDate format:@"YYYYMMdd HHmmss"];
        playDetailProGramModel.difinationStartTime = startTimeIndex;
    }
    NSTimeInterval endTimeIndex = [NSDate PVDateToTimeStamp:startTimeDate format:@"YYYYMMddHHmmss"] + playDetailProGramModel.duration.doubleValue;
    NSDate* endTDate = [NSDate PVTimeStampToData:endTimeIndex format:@"YYYYMMddHHmmss"];
    NSString* endTime = [NSDate PVDateToStringTime:endTDate format:@"YYYYMMddHHmmss"];
    url = [url stringByReplacingOccurrencesOfString:@"{StartTime}" withString:startTime];
    url = [url stringByReplacingOccurrencesOfString:@"{EndTime}" withString:endTime];
    return url;
}


-(void)reloadProGramAndTime{
    [self.proGramViewController.timeTableView reloadData];
    if (self.proGramViewController.defaultProGramModel) {
        NSInteger index = [self.proGramViewController.timeDataSource indexOfObject:self.proGramViewController.defaultProGramModel];
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.proGramViewController.timeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    }
    [self.proGramViewController.proGramTableView reloadData];
    if (self.proGramViewController.defaultDetailProGramModel) {
        NSInteger index = [self.proGramViewController.defaultProGramModel.programs indexOfObject:self.proGramViewController.defaultDetailProGramModel];
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.proGramViewController.proGramTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    }
}

-(PVVideoProgramViewController *)videoProgramViewController{
    if (!_videoProgramViewController) {
        _videoProgramViewController = [[PVVideoProgramViewController alloc]  init];
        _videoProgramViewController.view.hidden = true;
        PV(pv)
        [_videoProgramViewController setPVVideoProgramViewControllerCallBlock:^(PVLiveTelevisionProGramModel *defaultProGramModel, PVLiveTelevisionDetailProGramModel *defaultDetailProGramModel) {
            [pv coverBtnClicked];
            pv.proGramViewController.defaultProGramModel = defaultProGramModel;
            pv.proGramViewController.defaultDetailProGramModel = defaultDetailProGramModel;
            ///切换节目单
            [pv reloadProGramAndTime];
            [pv chargeproGram:defaultDetailProGramModel yearDate:nil];
            defaultDetailProGramModel.type = 2;
            [pv.videoProgramViewController.proGramTableView reloadData];
        }];
        [_videoProgramViewController setPVVideoProgramViewControllerRealDataCallBlock:^{
            [pv.proGramViewController.proGramTableView reloadData];
        }];
    }
    return _videoProgramViewController;
}
-(UIButton *)coverBtn{
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.backgroundColor = [UIColor clearColor];
        _coverBtn.hidden = true;
        [_coverBtn addTarget:self action:@selector(coverBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}

-(void)coverBtnClicked{
    [self closeMoreView:self.videoMoreView];
    [self closeMoreView:self.videoShareView];
    [self closeMoreView:self.videoDefinitionView];
    [self closeProGramView:self.videoChannelViewController.view];
    [self closeProGramView:self.videoProgramViewController.view];
}
-(void)screenLandscapeChargeScreenPortrait{
    self.videoMoreView.hidden = self.videoShareView.hidden =    self.videoDefinitionView.hidden = self.videoProgramViewController.view.hidden =  self.videoChannelViewController.view.hidden = true;
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
-(void)closeProGramView:(UIView*)view{
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

#pragma mark - **************广播************
-(PVBroadCastView *)broadCastContainerView{
    if (!_broadCastContainerView) {
        _broadCastContainerView =  [[NSBundle mainBundle] loadNibNamed:@"PVBroadCastView" owner:nil options:nil].lastObject;
        _broadCastContainerView.frame = CGRectMake(0, 0, ScreenWidth, IPHONE6WH(ScreenWidth*9/16));
        _broadCastContainerView.hidden = true;
        _broadCastContainerView.jumpVC = self;
        PV(pv)
        [_broadCastContainerView  setPVBroadCastViewCallBlock:^(BOOL isSelected) {
            if (isSelected) {
                [pv.appDelegate stopBroadCastPlay:true];
            }else{
                pv.copyRightBtn.hidden = true;
                //生成model
                PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
                playVideoModel.url = [NSURL URLWithString:pv.playingUrl];
                playVideoModel.copyright = pv.channelViewController.selectedChanelListModel.copyright;
                playVideoModel.videoDistrict = pv.channelViewController.selectedChanelListModel.area;
                playVideoModel.code = pv.channelViewController.selectedChanelListModel.valiDataCode;
                [pv.appDelegate playBroadCast:playVideoModel];
            }
        }];
    }
    return _broadCastContainerView;
}
-(void)hidebroaCast:(BOOL)isHidden{
    if (isHidden) {
        self.broadCastContainerView.FMPlayOrStopBtn.selected = true;
    }else{
        self.broadCastContainerView.FMPlayOrStopBtn.selected = false;
    }
}

-(UIButton *)copyRightBtn{
    if (!_copyRightBtn) {
        _copyRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_copyRightBtn setTitle:@"由于版权问题,暂时无法观看此视频" forState:UIControlStateNormal];
        _copyRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_copyRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _copyRightBtn.backgroundColor = [UIColor blackColor];
        _copyRightBtn.hidden = true;
        _copyRightBtn.frame = CGRectMake(0, kNavBarHeight, ScreenWidth, IPHONE6WH(ScreenWidth*9/16));
        [self.view addSubview:_copyRightBtn];
    }
    return _copyRightBtn;
}
@end
