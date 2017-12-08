//
//  PVInteractiveZBViewController.m
//  PandaVideo
//
//  Created by 寕小陌 on 2017/8/15.
//  Copyright © 2017年 寕小陌. All rights reserved.
//
#import "IQKeyboardManager.h"
#import "PVInteractiveZBViewController.h"
#import "PVInteractiveZBViewController+GiftAnnimation.h"
#import "PVInteractionInfoView.h"                   // 简介工具栏
#import "PVInterractionChatViewController.h"        // 聊天室
#import "PVInterractionCurrentListViewController.h" // 本场榜
#import "PVInterractionTotalListViewController.h"   // 总榜单
#import "PVBottomToolsView.h"                       // 底部工具栏
#import "PVLiveStreamActivityViewController.h"      // 红包活动(H5)
#import "NSTimer+Extension.h"

#import "PVIntroduceViewController.h"               // 弹出简介
#import "LZOptionSelectView.h"                      // 快捷聊天
#import "LZHeartFlyView.h"                          // 点赞动画
#import "PVGiftGivingViewController.h"              // 选择礼物
#import "PVShowShareView.h"                         // 分享

#import "LZVideoPlayBackModel.h"                    // 视频回放Model

#import "PVBarrageView.h"
#import "PVBarrageItemView.h"
#import "PVPresentModelAble.h"

/** 键盘 */
#import "ChatKeyBoardMacroDefine.h"
#import "ChatKeyBoard.h"
#import "PVBaseScrollView.h"

#import "PVPopoverView.h"

/** GIF 播放 */
#import "YYImage.h"
#import <sys/sysctl.h>

#import "PVIntroduceModel.h"
#import "PVGiftsListModel.h"
#import "PVMessageModel.h"
#import "PVShareViewController.h"

#import "PVLoginViewController.h"
//充值
#import "PVMoneyViewController.h"
#import "PVTipsPopoverView.h"
#import "PVShareTool.h"

#define videoMoreHeight  342*YYScreenHeight/1334
@interface PVInteractiveZBViewController ()<UIScrollViewDelegate,PVShowToolsViewDelegate,ChatKeyBoardDelegate,UITextFieldDelegate,PVBarrageViewDataSource, LZVideoPlayerViewDelegate,UIGestureRecognizerDelegate,LZSendGiftDelegate,PVPresentViewDelegate,LZSendGiftGivingDelegate,PVPresentViewDelegate>
{
    CGFloat _heartSize;         // 心形大小
    NSMutableArray *listArray;  // 快捷聊天数组
    NSMutableArray *fullListArray;
}
@property(nonatomic, assign) CGFloat                    difference;
@property (nonatomic, strong) NSTimer       *timerVote;
/** 倒计时活动执行 */
@property (nonatomic, strong) NSTimer       *timer;

@property (nonatomic, strong) PVGiftList    *giftList;
/// 横屏活动是否显示
@property (nonatomic, assign) BOOL          fullShowVote;
/// 是否有活动
@property (nonatomic, assign) BOOL          isVote;

@property (nonatomic, strong) PVFullViewController *fullViewController;
@property (nonatomic, strong) PVLiveStreamActivityViewController *activityView;

/// 显示直播标题 简介的Button
@property (nonatomic, strong) UIButton              *infoViewbtn;
/// 活动按钮
@property (nonatomic, strong) UIButton              *live_btn_vote;
/// 倒计时文字
@property (nonatomic, strong) UILabel               *live_label_vote;
/// 横屏活动倒计时View
@property (nonatomic, strong) UIView                *live_view_vote_full;
/// 活动按钮
@property (nonatomic, strong) UIButton              *live_btn_vote_full;
/// 倒计时文字
@property (nonatomic, strong) UILabel               *live_label_vote_full;
/// 右上角回看
@property (nonatomic, strong) UIView                *live_view_backSee;
@property (nonatomic, strong) UIButton              *live_btn_backSee;
@property (nonatomic, strong) UILabel               *live_label_backSee;
/// H5Url
@property (nonatomic, copy) NSString                *H5URLString;

/// 显示直播信息的view
@property (nonatomic, strong) PVInteractionInfoView *infoView;

/** 直播互动下半部分界面 */
@property (nonatomic, strong) UIView        *titleView;
@property (nonatomic, strong) UIButton      *selectedBtn;
@property (nonatomic, strong) UIView        *selectedView;
@property (nonatomic, strong) PVBaseScrollView  *contentView;
/** 底部工具栏 */
@property (nonatomic, strong) PVBottomToolsView *bottomToolsView;
/** 分享 */
@property (nonatomic, strong) PVShowShareView   *showShareView;

/** 弹出简介 */
@property (nonatomic, strong) PVIntroduceViewController *introduceView;
@property (nonatomic, strong) PVGiftGivingViewController *giftGivingView;
/** 竖屏播放GIF的背景View */
@property (nonatomic, strong) UIView *gifBoxView;
/** 横屏播放GIF的背景View */
@property (nonatomic, strong) UIView *fullGifBoxView;
/** 竖屏播放GIF的背景View2 */
@property (nonatomic, strong) UIView *gifBoxViews;
/** 横屏播放GIF的背景View2 */
@property (nonatomic, strong) UIView *fullGifBoxViews;

/** 视频类型(1:直播 2:回放) */
@property (nonatomic, copy) NSString *videoType;
@property (nonatomic, copy) NSString *videoUrl;
/// 直播标题
@property (nonatomic, copy) NSString *liveTitle;
/// 在线人数
@property (nonatomic, copy) NSString *liveCount;

@property (nonatomic, strong) LZOptionSelectView *cellView;
@property (nonatomic, strong) LZOptionSelectView *fullScreenCellView;

@property (nonatomic, assign) CGFloat           width;
@property (nonatomic, assign) CGFloat           height;

@property (nonatomic, strong) UIButton          *coverBgBtn;
@property (nonatomic, strong) UIButton          *coverFullBgBtn;
@property (nonatomic, strong) PVIntroduceModel  *introduceModel;
@property (nonatomic, copy)     NSString        *parentId;
/** 直播ID */
@property (nonatomic, copy)     NSString        *liveId;
/** token */
@property (nonatomic, copy)     NSString        *token;
/** 用户ID */
@property (nonatomic, copy)     NSString        *userId;
/** 累加点赞数量 */
@property (nonatomic, assign)   NSInteger       praiseCount;
@property (nonatomic, copy)     NSString        *liveUrl;

/** 是否为自己发送的弹幕(默认为NO) */
@property (nonatomic, assign)   BOOL            isSelfDanmu;
/** 礼物数据模型 */
@property (nonatomic, strong)   PVGiftsListModel    *lzListModel;
/** 弹幕的View */
@property (nonatomic, strong)   PVBarrageView       *lzBarrageView;

/// 返回按钮，当无播放器时
@property (nonatomic, strong) UIButton * backButton;

@property(nonatomic,assign)BOOL isNeedNewsRequest;

/// 当前点赞个数
@property(nonatomic,assign) NSInteger dianzanIndex;


@end

@implementation PVInteractiveZBViewController


-(void)dealloc{
    if (self.playerView.player) {
        [self.playerView.playControllerView videoStop];
    }
    
    [self removeTimer];
    [kNotificationCenter removeObserver:self];
}


- (id)initDictionary:(NSDictionary *)dictionary{

    if ( self = [super init] ){
        _videoType  = dictionary[@"videoType"];
        _videoUrl   = dictionary[@"videoUrl"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelfDanmu = NO;
    self.isNeedNewsRequest = YES;
//    // 默认余额为0;
//    self.balance = 0;
}

- (void) setBaseOperation{
    
    // 执行动画
    [kNotificationCenter addObserver:self selector:@selector(informPerformAnimation:) name:@"informPerformAnimation" object:nil];
    // 弹幕类型处理
    [kNotificationCenter addObserver:self selector:@selector(initiateBarrage:) name:@"initiateBarrage" object:nil];

    // 注册通知
    [kNotificationCenter addObserver:self
                            selector:@selector(palyerVideo)
                                name:@"PVAgainPalyerVideo"
                              object:nil];
}



/** 获取直播信息数据 */
- (void) loadData{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        // 获取礼物数据
        [self getGiftsList];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
        });
        
    });
    
    YYLog(@"--- %@",_menuUrl);
    [PVNetTool getDataWithUrl:_menuUrl success:^(id result) {
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            PVIntroduceModel *introduceModel = [[PVIntroduceModel alloc] init];
            [introduceModel setValuesForKeysWithDictionary:result];
            self.introduceModel = introduceModel;
            self.liveId = self.introduceModel.liveId;
            self.parentId = self.introduceModel.parentId;
            self.infoView.titleLabel.text = self.introduceModel.organizationName;

            [self palyerVideo];
       
            [self initUIView];
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 竖屏遮盖键盘 */
- (UIButton *)coverBgBtn{
    if (_coverBgBtn == nil) {
        _coverBgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CrossScreenWidth, CrossScreenHeight)];
        _coverBgBtn.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_coverBgBtn];
        _coverBgBtn.hidden = YES;
        // 监听手势 点击 背景关闭键盘
        [_coverBgBtn addTarget:self action:@selector(closeDismissKeyboard)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBgBtn;
}


/** 全屏遮盖键盘 */
- (UIButton *)coverFullBgBtn{
    if (_coverFullBgBtn == nil) {
        _coverFullBgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CrossScreenHeight, CrossScreenWidth)];
        _coverFullBgBtn.backgroundColor = [UIColor clearColor];
        [self.playContainerView addSubview:_coverFullBgBtn];
        _coverFullBgBtn.hidden = NO;
        // 监听手势 点击 背景关闭键盘
        [_coverFullBgBtn addTarget:self action:@selector(closeDismissKeyboard)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverFullBgBtn;
}

- (UIView *)fullGifBoxView{
    if (_fullGifBoxView == nil) {
        
        _fullGifBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CrossScreenWidth, CrossScreenHeight)];
        _fullGifBoxView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        YYImage *image = [YYImage imageNamed:@"兰博基尼_横屏_透明"];
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, YYScreenWidth, YYScreenHeight);
//        imageView.animationRepeatCount = 1; // 设置动画次数 0 表示无限(默认为0)
        imageView.backgroundColor = [UIColor clearColor];
        [imageView addObserver:self forKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew context:nil];
        [_fullGifBoxView addSubview:imageView];
        UITapGestureRecognizer *oneFingerTwoTaps =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerTwoTaps)];
        [_fullGifBoxView addGestureRecognizer:oneFingerTwoTaps];
        
    }
    return _fullGifBoxView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isKindOfClass:[YYAnimatedImageView class]]) {
        YYAnimatedImageView * imageView = (YYAnimatedImageView *)object;
        if (imageView.currentAnimatedImageIndex >= 124) {
            [self removeAnimote];
        }
    }
}

- (UIView *)fullGifBoxViews{
    if (_fullGifBoxViews == nil) {
        YYImage *image = [YYImage imageNamed:@"游艇_横屏_透明"];
        _fullGifBoxViews = [[UIView alloc] initWithFrame:CGRectZero];
        _fullGifBoxViews.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        [imageView addObserver:self forKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew context:nil];
//        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//        imageView.animationRepeatCount = 1; // 设置动画次数 0 表示无限(默认为0)
        imageView.backgroundColor = [UIColor clearColor];
        [_fullGifBoxViews addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(_fullGifBoxViews);
        }];
        UITapGestureRecognizer *oneFingerTwoTaps =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerTwoTaps)];
        [_fullGifBoxViews addGestureRecognizer:oneFingerTwoTaps];
        
    }
    return _fullGifBoxViews;
}

- (UIView *)gifBoxView{
    if (_gifBoxView == nil) {
        _gifBoxView = [[UIView alloc] initWithFrame:self.view.bounds];
        _gifBoxView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        YYImage *image = [YYImage imageNamed:@"兰博基尼_竖屏_透明"];
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        [imageView addObserver:self forKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew context:nil];
        imageView.frame = self.view.bounds;
//        imageView.animationDuration = 5; // 设置动画次数 0 表示无限(默认为0)
        imageView.backgroundColor = [UIColor clearColor];
        [_gifBoxView addSubview:imageView];
        UITapGestureRecognizer *oneFingerTwoTaps =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerTwoTaps)];
        [_gifBoxView addGestureRecognizer:oneFingerTwoTaps];
    }
    return _gifBoxView;
}

- (UIView *)gifBoxViews{
    if (_gifBoxViews == nil) {
        _gifBoxViews = [[UIView alloc] initWithFrame:self.view.bounds];
        _gifBoxViews.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        YYImage *image = [YYImage imageNamed:@"游艇_竖屏_透明"];
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        imageView.frame = self.view.bounds;
//        imageView.animationRepeatCount = 1; // 设置动画次数 0 表示无限(默认为0)
        imageView.backgroundColor = [UIColor clearColor];
        [imageView addObserver:self forKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew context:nil];
        [_gifBoxViews addSubview:imageView];
        UITapGestureRecognizer *oneFingerTwoTaps =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerTwoTaps)];
        [_gifBoxViews addGestureRecognizer:oneFingerTwoTaps];
    }
    return _gifBoxViews;
}

- (void) oneFingerTwoTaps{

    [self.fullGifBoxView removeFromSuperview];
    [self.gifBoxView removeFromSuperview];
    [self.fullGifBoxViews removeFromSuperview];
    [self.gifBoxViews removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)isSimulator {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *model = [NSString stringWithUTF8String:machine];
    free(machine);
    return [model isEqualToString:@"x86_64"] || [model isEqualToString:@"i386"];
}

-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.backgroundColor = [UIColor whiteColor];
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowFace = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"快来和小伙伴一起畅聊吧~";
        [self.view addSubview:_chatKeyBoard];
    }
    return _chatKeyBoard;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self closeDismissKeyboard];
}

// 点击View 关闭键盘
- (void)closeDismissKeyboard {
    self.coverFullBgBtn.hidden = YES;
    // endComment
    self.coverBgBtn.hidden = YES;
    [self.chatKeyBoard keyboardDownForComment];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 不适用工具条
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    // 设置点击背景收回键盘。
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enable = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _cellView = [[LZOptionSelectView alloc] initOptionView];
    _fullScreenCellView = [[LZOptionSelectView alloc] initOptionView];
    _fullScreenCellView.backColor = [UIColor blackColor];
    _fullScreenCellView.alpha = 0.7;
    if (!self.isNeedNewsRequest) {
        return;
    }
    _liveId     = @"41";
    
    if (kUserInfo.isLogin) {
        _token      = kUserInfo.token;
        _userId     = kUserInfo.userId;
    }else{
        
        _token      = @"lzTest";
        _userId     = @"lzTest";
    }
    _praiseCount = 0;
    [self loadData];
   
    _heartSize = 36;
    _width = self.view.frame.size.width;
    _height = self.view.frame.size.height;
    // 添加通知
    [self setBaseOperation];
    [self.view addSubview:self.videoContainerView];
    
    [self getBalance];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.scNavigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (self.playerView.player) {
        [self.playerView.playControllerView videoPause];
    }
    // 移除定时器
    [[PVInterractionChatViewController alloc] removeTimer];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    // 启用IQ工具条
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    // 启用IQ
    [IQKeyboardManager sharedManager].enable = YES;
    self.presentView.hidden = YES;
    self.presentViews.hidden = YES;

    [super viewWillDisappear:animated];
    self.scNavigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.isNeedNewsRequest = NO;
}

/** 初始化UI */
-(void)initUIView{
    self.view.backgroundColor = kColorWithRGB(0, 0, 0);
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.contentView];
    
    // 添加礼物动画显示(竖屏)
    [self.view addSubview:self.presentView];
    [self createContentView];
    
    // 设置底部工具栏
    [self.view addSubview:self.bottomToolsView];
    // 默认不是横屏
    self.fullShowVote = NO;
    self.isVote     = NO;
    // 注册通知(当播视频播放失败的时候重新播放)
    [kNotificationCenter addObserver:self
                            selector:@selector(palyerVideo)
                                name:@"PVAgainPalyerVideo"
                              object:nil];
}

/** 根据URL播放第视频或者直播 */
- (void)palyerVideo{
    YYLog(@"_videoUrl -- %@",_introduceModel.liveUrl);
//        NSString *urlString = @"http://baobab.wdjcdn.com/1457546796853_5976_854x480.mp4";
//    NSString *URLString = @"http://101.207.176.15/sdlive/sctv1/3.m3u8";
    self.liveUrl = self.introduceModel.liveUrl;
    /** 直播状态(0：预告；1：直播；2：回看)*/
    if ([self.introduceModel.liveState isEqualToString:@"0"]) {
        self.bottomToolsView.textlabel.text = @"预告不支持互动，请关注我们的直播哦~";
        self.live_view_backSee.hidden = NO;
        self.live_label_backSee.text = @"预告";
        [self.live_btn_backSee setImage:kGetImage(@"live_icon_notice") forState:UIControlStateNormal];
        [self getRequest:self.introduceModel.review.reviewUrl];
    } else if([self.introduceModel.liveState isEqualToString:@"1"]){
        // 替换URL
        for (CodeRateList *object in self.introduceModel.codeRateList) {
            if (object.isDefaultRate.boolValue) {
                self.liveUrl = [self.liveUrl stringByReplacingOccurrencesOfString:@"index.m3u8" withString:object.rateFileUrl];
                break;
            }
        }
        [self startPlaying:[NSURL URLWithString:self.liveUrl] type:2 delegate:self];
        self.bottomToolsView.toolsBottomView.hidden = NO;
        self.bottomToolsView.videoBottomView.hidden = YES;
    }else if ([self.introduceModel.liveState isEqualToString:@"2"]) {
        self.live_view_backSee.hidden = NO;
        self.live_label_backSee.text = @"回看";
        [self.live_btn_backSee setImage:kGetImage(@"live_icon_replay") forState:UIControlStateNormal];
        self.bottomToolsView.textlabel.text = @"回看不支持互动，请关注我们的直播哦~";
        [self getRequest:self.introduceModel.review.reviewUrl];
    }
    [self.playerView.playControllerView videoFirstPlayer];
    
    
    NSString *str = self.introduceModel.liveTitle;
    /** 直播状态(0：预告；1：直播；2：回看)*/
    if ([self.introduceModel.liveState isEqualToString:@"1"]) {
        if (str.length && self.introduceModel.liveAudienceCount.length) {
            str = [NSString stringWithFormat:@"%@\n在线人数%@",str,self.introduceModel.liveAudienceCount];
        }
    }
    self.playerView.playControllerView.videoTitleName = str;
    [self setupVideoUI];
}


- (void) getRequest:(NSString *)URLString{
    [PVNetTool getDataWithUrl:URLString success:^(id result) {
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            
            self.bottomToolsView.toolsBottomView.hidden = YES;
            self.bottomToolsView.videoBottomView.hidden = NO;
            YYLog(@"result -- %@",result[@"liveType"]);
            YYLog(@"result--url -- %@",result[@"videoJson"][@"url"]);
//            self.liveUrl = result[@"videoJson"][@"url"];
            self.liveUrl = result[@"videoUrl"];
//            NSString *URLString = @"http://baobab.wdjcdn.com/1457546796853_5976_854x480.mp4";
//            self.liveUrl = URLString;
            [self startPlaying:[NSURL URLWithString:self.liveUrl] type:1 delegate:self];
            [self.playerView.playControllerView videoFirstPlayer];
            [self setupVideoUI];
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)backClick:(UIButton *)button{

    YYLog(@"返回互动直播首页");
}
- (void)backToBeforeVC{
    [self.navigationController popViewControllerAnimated:true];
}

- (void) live_btn_voteOnClick:(UIButton *)sender{
    YYLog(@"投票活动");
    
    // 竖屏播放GIF的背景View
//    [self.view insertSubview:self.gifBoxView aboveSubview:self.view];
    if (self.playerView.playControllerView.isRotate) {
        [self.playerView.playControllerView screenBtnClicked];
    }
    [self showActivityView];
}

- (void) bgClickEvent:(UITapGestureRecognizer *)gesture
{
    [self.chatKeyBoard keyboardDownForComment];
}

#pragma mark - 播放器************************************
-(void)setupVideoUI{//isRotate

    // 播放器右上角(回看/预告)
    [self.playContainerView addSubview:self.live_view_backSee];
    [self.live_view_backSee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@25);
        make.right.equalTo(@(-20));
        make.height.equalTo(@20);
        make.width.equalTo(@60);
    }];
    
    [self.live_view_backSee addSubview:self.live_label_backSee];
    [self.live_label_backSee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.height.equalTo(@20);
        make.width.equalTo(@40);
        make.centerY.equalTo(self.live_view_backSee);
    }];
    
    [self.live_view_backSee addSubview:self.live_btn_backSee];
    [self.live_btn_backSee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.live_label_backSee).with.offset(-5);
        make.height.equalTo(@8);
        make.width.equalTo(@8);
        make.centerY.equalTo(self.live_label_backSee);
    }];
    
    [self.playContainerView addSubview:self.coverBtn];      /** 遮盖 */
    [self.playContainerView addSubview:self.videoMoreView]; /** 视频更多的View */
    [self setMoreViewConstrints:self.videoMoreView];        /** 视频更多的约束 */
    [self.playContainerView addSubview:self.videoShareView];/** 分享的View */
    [self setMoreViewConstrints:self.videoShareView];       /** 分享的View的约束 */
    [self.playContainerView addSubview:self.videoDefinitionView];   /** 标清 */
    [self setMoreViewConstrints:self.videoDefinitionView];          /** 标清的约束 */
    
    [self.playContainerView addSubview:self.fullScreenGiftChoiceView];/** 全屏送礼物的View */
    [self setFullScreenGiftChoiceViewConstrints:self.fullScreenGiftChoiceView];/** 约束 */
    
    // 添加礼物动画显示(横屏)
    [self.playContainerView addSubview:self.presentViews];
    [self setFullScreenPresentViewsConstrints:self.presentViews];/** 约束 */

    [self.playContainerView addSubview:self.videoDemandAnthologyController.view];
    [self setVideoDemandAnthologyViewConstrints:self.videoDemandAnthologyController.view];
    
    // 横屏活动View
    [self.playContainerView addSubview:self.live_view_vote_full];
    [self.live_view_vote_full mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.height.equalTo(@100);
        make.width.equalTo(@60);
        make.centerY.equalTo(self.playContainerView);
    }];
    
    // 横屏活动按钮
    [self.live_view_vote_full addSubview:self.live_btn_vote_full];
    [self.live_btn_vote_full mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.height.width.equalTo(@60);
    }];
    
    // 横屏活动文字
    [self.live_view_vote_full addSubview:self.live_label_vote_full];
    [self.live_label_vote_full mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.live_btn_vote_full.mas_bottom);
        make.centerX.equalTo(self.live_btn_vote_full);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    
    [self.playContainerView addSubview:self.barrageView];   /** 弹幕 */
    [self.barrageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.playContainerView);
        make.height.equalTo(@106);
        make.top.equalTo(@0);
    }];
    
    [self.barrageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.playContainerView);
        make.height.equalTo(@106);
        make.top.equalTo(@0);
    }];
    [self.playContainerView addSubview:self.tipsLabel];       // 暂停提示
    // 全屏暂停提示
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(35);
        make.centerY.centerX.equalTo(self.playContainerView);
    }];
    // 播放器最外层
    [self.playerContainerView addSubview:self.playContainerView];
    [self.playerView.playControllerView hiddenMoreButton];
}

/** 直播互动容器(最外层-Box)  **/
-(UIView *)videoContainerView{
    if (!_videoContainerView) {
        _videoContainerView = [[UIView alloc] init];
        _videoContainerView.frame = CGRectMake(0, lz_kiPhoneX(0), kScreenWidth, AUTOLAYOUTSIZE(252));
        _videoContainerView.backgroundColor = kColorWithRGB(0, 0, 0);
        [self.videoContainerView addSubview:self.playerContainerView];
        [_videoContainerView addSubview:self.infoView];
        [_videoContainerView addSubview:self.backButton];
        
    }
    return _videoContainerView;
}

/** 直播或视频容器最外层  */
-(LZPlayerView *)playerContainerView{
    if (!_playerContainerView) {
        _playerContainerView = [[LZPlayerView alloc] init];
        _playerContainerView.frame = CGRectMake(0, 0, kScreenWidth, AUTOLAYOUTSIZE(211));
        _playerContainerView.backgroundColor = kColorWithRGB(0, 0, 0);
    }
    return _playerContainerView;
}

/** 简介部分  */
- (PVInteractionInfoView *) infoView{
    
    if (!_infoView) {
        CGFloat y = CGRectGetMaxY(self.playerContainerView.frame);
        CGRect frame = CGRectMake(0, y, kScreenWidth, AUTOLAYOUTSIZE(252)-CGRectGetMaxY(self.playerContainerView.frame));
        _infoView = [[PVInteractionInfoView alloc] initWithFrame:frame];
        _infoView.backgroundColor = [UIColor whiteColor];
        [_infoView addSubview:self.infoViewbtn];
    }
    
    return _infoView;
}

/** 简介部分  */
- (PVLiveStreamActivityViewController *) activityView{
    
    if (!_activityView) {
        _activityView = [[PVLiveStreamActivityViewController alloc] init];
        _activityView.currentHeigh = kScreenHeight - CGRectGetMaxY(self.playerView.frame);
        _activityView.view.backgroundColor = [UIColor whiteColor];
        [self addChildViewController:_activityView];
        [self.view insertSubview:_activityView.view atIndex:self.view.subviews.count];
        CGFloat y = CGRectGetMaxY(self.videoContainerView.frame);
        if (kiPhoneX) {
            _activityView.view.frame = CGRectMake(0, lz_kiPhoneX(y), kScreenWidth, kScreenHeight-y);
        }else{
            _activityView.view.frame = CGRectMake(0, lz_kiPhoneX(y), kScreenWidth, kScreenHeight-y+50);
        }
        _activityView.view.hidden = true;
    }
    
    return _activityView;
}

/** 栏目切换 */
-(UIView *)titleView{
    if (!_titleView) {
        
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = kColorWithRGB(255, 255, 255);
        _titleView.sc_height = AUTOLAYOUTSIZE(41);
        CGFloat lz_y = CGRectGetMaxY(self.videoContainerView.frame);
        _titleView.frame = CGRectMake(0, lz_y , kScreenWidth, _titleView.sc_height);
        
        CGFloat btnW = 50, btnH = 35, btnY = (_titleView.sc_height-35)/2;
        
        NSInteger pageCount = 0;
        /** parentId 直播类型(1.系列直播(有值)，2.单场直播(没值)) */
        if (![self.introduceModel.parentId isEqualToString:@""]) {
            pageCount = 3;
        }else {
            pageCount = 2;
        }
        // 聊天栏
        CGRect chatFrame = CGRectMake((kScreenWidth-pageCount*btnW-2*20)/2, btnY, btnW, btnH);
        UIButton *chatBtn = [self buttonWithTitle:@"聊天" action:@selector(columnBtnClickedChat:) frame:chatFrame];
        self.selectedBtn = chatBtn;
        self.selectedBtn.selected = true;
        [_titleView addSubview:chatBtn];
        
        // 本场榜栏
        CGRect currentFrame = CGRectMake(CGRectGetMaxX(chatBtn.frame)+20, btnY, btnW, btnH);
        UIButton *currentBtn = [self buttonWithTitle:@"本场榜" action:@selector(columnBtnClickedBC:) frame:currentFrame];
        [_titleView addSubview:currentBtn];
        
        //    self.introduceModel.liveType  是否需要显示总榜
        /** 直播类型(1.系列直播，2.单场直播) */
        if(![self.introduceModel.parentId isEqualToString:@""]){
            // 总榜栏
            CGRect totalFrame = CGRectMake(CGRectGetMaxX(currentBtn.frame)+20, btnY, btnW, btnH);
            UIButton *totalBtn = [self buttonWithTitle:@"总榜" action:@selector(columnBtnClickedZB:) frame:totalFrame];
            [_titleView addSubview:totalBtn];
        }
        
        CGFloat s_y = _titleView.sc_height-3;
        self.selectedView.frame = CGRectMake(self.selectedBtn.sc_x, s_y, self.selectedBtn.sc_width-10, 2);
        self.selectedView.center = CGPointMake(self.selectedBtn.center.x, self.selectedView.center.y);
        [_titleView addSubview:self.selectedView];
        
        // 分割线
        UIView *lv = [[UIView alloc] init];
        lv.frame = CGRectMake(0, 0, kScreenWidth, AUTOLAYOUTSIZE(0.5));
        lv.backgroundColor = kColorWithRGB(215, 215, 215);
        [_titleView addSubview:lv];

        // 分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, _titleView.sc_height-AUTOLAYOUTSIZE(1), kScreenWidth, AUTOLAYOUTSIZE(.5));
        lineView.backgroundColor = [UIColor sc_colorWithRed:215 green:215 blue:215];
        [_titleView addSubview:lineView];
    }
    return _titleView;
}

///创建contentView上面的子view
-(void)createContentView{

    NSDictionary *dictionary = @{@"liveId": _liveId};
    //  聊天室
    PVInterractionChatViewController *chatVC = [[PVInterractionChatViewController alloc] initDictionary:dictionary];
    [self addChildViewController:chatVC];
    //  本场榜
    PVInterractionCurrentListViewController *currentVC = [[PVInterractionCurrentListViewController alloc]  initDictionary:dictionary];
    [self addChildViewController:currentVC];
    // 总榜
    NSDictionary *dict = @{@"parentId": _parentId};

    PVInterractionTotalListViewController *totalVC = [[PVInterractionTotalListViewController alloc] initDictionary:dict];
    [self addChildViewController:totalVC];
    
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count*kScreenWidth, 0);
    [self scrollViewDidEndDecelerating:self.contentView];
    
    //点赞动画处理
    PV(weakSelf);
    chatVC.dianzanBlock = ^(NSInteger total) {
        weakSelf.dianzanIndex = 0;
        NSTimer *timer =[NSTimer timerWithTimeInterval:0.1 target:weakSelf selector:@selector(timerSelector:) userInfo:@{@"total":[NSNumber numberWithInteger:total]} repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    };
    //在线人数处理
    chatVC.zaiXianRenshuBlock = ^(NSInteger total) {
        if ([weakSelf.introduceModel.liveState isEqualToString:@"1"]) {
        NSString * totalPeople = [NSString stringWithFormat:@"%ld",total + weakSelf.introduceModel.liveAudienceCount.integerValue];
        weakSelf.playerView.playControllerView.videoTitleName = [NSString stringWithFormat:@"%@\n在线人数%@",weakSelf.introduceModel.liveTitle,totalPeople];
        }
    };
}

- (void)timerSelector:(NSTimer *)timer{
    self.dianzanIndex = self.dianzanIndex + 1;
    NSInteger total = MIN([[timer.userInfo objectForKey:@"total"] integerValue], 50);
    if (self.playerView.playControllerView.isRotate) {
        [self showTheLoveSenderX:CrossScreenHeight - 20 - 13  SenderWidth:20 View:self.playContainerView Height:_height];
       
    }else{
         [self showTheLove:self.bottomToolsView.liveBtnLike View:self.view Height:_height];
        
    }
    if (self.dianzanIndex >= total) {
        [timer invalidate];
    }
}
/** 选中的下划线 */
-(UIView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[UIView alloc] init];
        _selectedView.backgroundColor = [UIColor sc_colorWithHex:0x00B6E9];
    }
    return _selectedView;
}

/** 页面切换的ScrollView */
-(PVBaseScrollView *)contentView{
    if (!_contentView) {
        if (!_contentView) {
            _contentView = [[PVBaseScrollView alloc] init];
            _contentView.showsHorizontalScrollIndicator = NO;
            _contentView.scrollsToTop = false;
            _contentView.backgroundColor = kColorWithRGB(242, 242, 242);
            _contentView.delegate = self;
            _contentView.pagingEnabled = YES;
            _contentView.bounces = NO;
            CGFloat h = kScreenHeight-CGRectGetMaxY(_titleView.frame)-50;
            CGFloat lz_h = kiPhoneX ? h-34 : h;
            _contentView.frame = CGRectMake(0, CGRectGetMaxY(_titleView.frame), ScreenWidth, lz_h);
            _contentView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        }
    }
    return _contentView;
}

/** 底部工具栏 */
-(PVBottomToolsView *)bottomToolsView{
    if (!_bottomToolsView) {
        _bottomToolsView = [PVBottomToolsView bottomView];
        _bottomToolsView.toolsBottomView.hidden = YES;
        _bottomToolsView.videoBottomView.hidden = YES;
        _bottomToolsView.frame = CGRectMake(0, lz_kiPhoneXB(50), ScreenWidth, 50);
//        _bottomToolsView.backgroundColor = kColorWithRGB(215, 215, 215);
        _bottomToolsView.delegate = self;
    }
    return _bottomToolsView;
}


/** 介绍区域 */
-(PVIntroduceViewController *)introduceView{
    if (!_introduceView) {
        _introduceView = [[PVIntroduceViewController alloc] initIntroduceModel:self.introduceModel];
        _introduceView.currentHeigh = kScreenHeight - CGRectGetMaxY(self.playerView.frame);
        _introduceView.view.backgroundColor = [UIColor whiteColor];
        [self addChildViewController:_introduceView];
        [self.view insertSubview:_introduceView.view atIndex:self.view.subviews.count];
        CGFloat y = CGRectGetMaxY(self.videoContainerView.frame);
        if (kiPhoneX) {
            _introduceView.view.frame = CGRectMake(0, lz_kiPhoneX(y), kScreenWidth, kScreenHeight-y);
        }else{
            _introduceView.view.frame = CGRectMake(0, lz_kiPhoneX(y), kScreenWidth, kScreenHeight-y+50 );
        }
        _introduceView.view.hidden = true;
    }
    return _introduceView;
}

/** 选择礼物 */
-(PVGiftGivingViewController *)giftGivingView{
    if (!_giftGivingView) {
        NSDictionary *dictionary = @{@"liveId":_liveId,@"token":_token,@"userId":_userId};
        _giftGivingView = [[PVGiftGivingViewController alloc] initWithDictionary:dictionary];
        _giftGivingView.parentLiveId = self.parentId;
        _giftGivingView.delegate = self;
        [self addChildViewController:_giftGivingView];
        [self.view insertSubview:_giftGivingView.view atIndex:self.view.subviews.count];
        CGFloat y = CGRectGetMaxY(self.playerContainerView.frame);
        if (kiPhoneX) {
            _giftGivingView.view.frame = CGRectMake(0, lz_kiPhoneX(y), kScreenWidth, kScreenHeight-y-34-34);
            _giftGivingView.currentViewHeight = kScreenHeight-y-34-34;
        }else{
            _giftGivingView.view.frame = CGRectMake(0, lz_kiPhoneX(y), kScreenWidth, kScreenHeight-y);
            _giftGivingView.currentViewHeight = kScreenHeight-y;
        }
        _giftGivingView.view.hidden = true;
    }
    return _giftGivingView;
}

/** 群聊界面 */
-(void)columnBtnClickedChat:(UIButton*) button{
    [self selectedToggleBtn:button];
    [self.contentView setContentOffset:CGPointMake(0, 0) animated:false];
    [self scrollViewDidEndDecelerating:self.contentView];
}

/** 本场榜 */
-(void)columnBtnClickedBC:(UIButton*)button{
    [self selectedToggleBtn:button];
    [self.contentView setContentOffset:CGPointMake(ScreenWidth, 0) animated:false];
    [self scrollViewDidEndDecelerating:self.contentView];
}
/** 总榜 */
-(void)columnBtnClickedZB:(UIButton*)button{
    [self selectedToggleBtn:button];
    [self.contentView setContentOffset:CGPointMake(ScreenWidth*2, 0) animated:false];
    [self scrollViewDidEndDecelerating:self.contentView];
}
/**
 *  选择切换的按钮
 *
 *  @param button 当前按钮
 */
-(void)selectedToggleBtn:(UIButton*)button{
    
    if (self.selectedBtn == button) return;
    self.selectedBtn.selected = false;
    self.selectedBtn = button;
    self.selectedBtn.selected = true;
    [UIView animateWithDuration:0.25f animations:^{
        self.selectedView.center = CGPointMake(self.selectedBtn.center.x, self.selectedView.center.y);
    }];
}


/**
 *  创建公用按钮
 *
 *  @param title 标题
 *  @param frame 框架
 *  @return 返回创建好的按钮
 */
-(UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action frame:(CGRect)frame{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor sc_colorWithHex:0x000000] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor sc_colorWithHex:0x00B6E9] forState:UIControlStateSelected];
    button.frame = frame;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/** 显示简介按钮 */
-(UIButton *)infoViewbtn{
    if (!_infoViewbtn) {
        _infoViewbtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100, 0, 100, self.infoView.sc_height)];
        _infoViewbtn.backgroundColor = [UIColor clearColor];
        [_infoViewbtn addTarget:self action:@selector(infoViewbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _infoViewbtn;
}


/**
 *  显示简介
 *
 *  @param sender 按钮
 */
-(void)infoViewbtnClick:(UIButton *) sender{
    PV(LZ)
    YYLog(@"显示简介");
    LZ.introduceView.view.hidden = false;
    [UIView animateWithDuration:0.25f animations:^{
        LZ.introduceView.view.sc_y = lz_kiPhoneX(CGRectGetMaxY(LZ.playerContainerView.frame));
    }];
}

- (void)showActivityView{
    PV(LZ)
    YYLog(@"显示简介");
    LZ.activityView.view.hidden = false;
    self.activityView.URLString = _H5URLString;
    [UIView animateWithDuration:0.25f animations:^{
        LZ.activityView.view.sc_y = lz_kiPhoneX(CGRectGetMaxY(LZ.playerContainerView.frame));
    }];
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setContentChildView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self setContentChildView];
}

-(void)setContentChildView{
    NSInteger index = (int) (self.contentView.contentOffset.x / kScreenWidth);
    UIViewController* vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index*kScreenWidth, 0, kScreenWidth, self.contentView.sc_height);
    [self.contentView addSubview:vc.view];
    [self selectedToggleBtn:self.titleView.subviews[index]];
}


/**
 *  底部工具栏功能实现
 *  竖屏点击
 *  @param sender 对应按钮
 */
- (void) didShowToolsButtonClick:(UIButton *) sender{
    
    NSInteger tag = sender.tag;
    switch (tag) {
        case 100:
            {
                YYLog(@"bottomToolsView y %f",self.bottomToolsView.sc_y);
                YYLog(@"留言");
                if (![PVUserModel shared].isLogin) {
                    PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
                    self.isNeedNewsRequest = NO;
                    [self.navigationController pushViewController:loginVC animated:true];
                    return;
                }
                self.coverBgBtn.hidden = NO;
                [self.chatKeyBoard keyboardUpforComment];
            }
            break;
        case 101:
            /** 发送快捷消息*/
            YYLog(@"快速留言");
            listArray = [NSMutableArray array];
            [self listArray:sender];
            break;
        case 102:
            
            YYLog(@"连麦");
            listArray = [NSMutableArray array];
            [self listArray:sender];
            break;
        case 103:
            {
                YYLog(@"送礼物");
                // 展示时礼物画板
                [self showChooseGiftClick:sender];
                [self.giftGivingView getBalance];
                // 执行赠送操作的Block
                PV(LZ);
                LZ.giftGivingView.giftClick = ^(NSInteger tag, NSInteger giftCount) {

                    NSInteger idx = tag + 100;
                    [LZ startGiftAnimalWithTag:idx giftCount:giftCount  gifSender:[PVUserModel shared].baseInfo.nickName showType:1];
                };
                LZ.giftGivingView.jumpReturnCallBlock = ^{
                    [LZ gotoRecharge];
                };
            }
            break;
        case 104:
            if (![PVUserModel shared].isLogin) {
                PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
                self.isNeedNewsRequest = NO;
                [self.navigationController pushViewController:loginVC animated:true];
                return;
            }
            // 点赞-需要先判断是否登录
                YYLog(@"点赞");
                [self pointPraiseRequest];
                [self showTheLove:sender View:self.view Height:_height];
            break;
        default:
            break;
    }
}


//开启动画
//showType 1 竖屏  2 全屏
- (void)startGiftAnimalWithTag:(NSInteger) tag  giftCount:(NSInteger) giftCount  gifSender:(NSString *)gifSender  showType:(NSInteger)showType{
    if (showType == 1) {
        _presentView.hidden = NO;
    }else{
      self.presentViews.hidden = NO;
    }
    
    NSInteger total = 0;        // 仅用于执行多少次动画
    NSInteger lastCount = 0;    // 礼物数量
    // 判断礼物数量小于10则执行giftCount的次数、否则就只是执行10次
    if (giftCount<=10) {
        total = giftCount;
        lastCount = 1;
    }else {
        total = 10;
        lastCount = giftCount - 9;
    }
    for (int i=0; i<total; i++) {
        
        // 执行动画操作
        [self chooseGiftOnClick:tag presentView:(showType == 1) ? self.presentView : self.presentViews  giftNum:lastCount+i giftTotal:total gifSender:gifSender];
    }
    // 执行全屏动画
    if (tag == 107 || tag == 108) {
        [self showeEpecialAnimation:showType giftIdx:tag];
    }
}

-(PVGiftList *)giftList{
    if (!_giftList) {
        _giftList = [[PVGiftList alloc] init];
    }
    return _giftList;
}

- (void) keyboardUpClick:(UIButton *) sender{
    [self.chatKeyBoard keyboardDownForComment];
}

- (PVFullViewController *)fullViewController{
    if (!_fullViewController) {
        _fullViewController = [[PVFullViewController alloc] init];
        _fullViewController.view.hidden = YES;
        [self addChildViewController:_fullViewController];
        [self.view insertSubview:_fullViewController.view atIndex:0];
    }
    return _fullViewController;
}

//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}

/**
 *  底部工具栏功能实现
 *  横屏点击
 *  @param sender 对应按钮
 **/
-(void)delegateFullScureenBtnClicked:(UIButton *) sender{
    
    YYLog(@"delegateFullScureenBtnClicked -- 全屏 --- %ld",sender.tag);
    
    NSInteger tag = sender.tag;
    switch (tag) {
        case 101:
            {
//                self.fullViewController.view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
//                self.fullViewController.view.hidden = NO;
                // 获取到当前状态条的方向
//                UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
//                YYLog(@"currentOrientation -- %ld",(long)currentOrientation);
//                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                app.shouldChangeOrientation = YES;
//                PVFullViewController * VC = [[PVFullViewController alloc] init];
//                [self.playContainerView addSubview: VC.view];
//                [UIView animateWithDuration:0.25f animations:^{
//                    self.fullViewController.view.y = 0;
//                }];
//                [self.navigationController presentViewController:VC animated:YES completion:nil];
//                self.coverFullBgBtn.hidden = NO;
//                [self.chatKeyBoard keyboardUpforComment];
                if (self.playerView.playControllerView.isRotate) {
                    [self.playerView.playControllerView screenBtnClicked];
                    if (![PVUserModel shared].isLogin) {
                        PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
                        self.isNeedNewsRequest = NO;
                        [self.navigationController pushViewController:loginVC animated:true];
                        return;
                    }
                    self.coverBgBtn.hidden = NO;
                    [self.chatKeyBoard keyboardUpforComment];
                }
            }
            break;
        case 102:
            {
                /** 发送快捷消息*/
                YYLog(@"快速留言");
                
//                CGAffineTransform transform = CGAffineTransformMakeRotation(-90 * M_PI/180.0);
//                [self.fullScreenCellView setTransform:transform];
                
                fullListArray = [NSMutableArray array];
                [self fullScreenlistArray:sender];
            }
            break;
        case 103:
            
            YYLog(@"弹幕");
            sender.selected = !sender.selected;
            if (sender.selected) {//开启弹幕lzBarrageView
                self.barrageView.hidden = false;
                [self.barrageView startBarrage];
                [sender setImage:kGetImage(@"live_btn_danmu2_on") forState:UIControlStateSelected];
            }else{
                //关闭弹幕
                self.barrageView.hidden = true;
                // 停止弹幕
                [self.barrageView stopBarrage];
                // 清空弹幕数据池
                [self.messagePool removeAllObjects];
                [sender setImage:kGetImage(@"live_btn_danmu2_off") forState:UIControlStateNormal];

            }
            break;
        case 104:
            
            YYLog(@"全屏连麦");
            break;
        case 105:
            {
                YYLog(@"全屏送礼物");
//                PV(pv);
//                self.fullScreenGiftChoiceView.jumpCallBackBlcok = ^(NSInteger idx) {
//                    if (idx==1) {
//                        // 充值跳转
//                    }else if (idx==2){
//                        // 跳转登录
//                        PVLoginViewController *loginVC = [[PVLoginViewController alloc] init];
//                        [pv.navigationController pushViewController:loginVC animated:YES];
//                    }
//                };
                [self.fullScreenGiftChoiceView getBalance];
                [self showMoreView:self.fullScreenGiftChoiceView];
            }
            break;
        case 106:
            
            YYLog(@"点赞");
            [self pointPraiseRequest];
            [self showTheLove:sender View:self.playContainerView Height:_width];
            break;
        default:
            break;
    }
}

#pragma mark - PVBarrageViewDataSource
- (UIView<PVBarrageItemProtocol> *)itemForBarrage:(PVBarrageView *)barrage {
    NSString *title = [self.messagePool firstObject];
    if (title) {
        [self.messagePool removeObjectAtIndex:0];
        
        PVBarrageItemView *item = (PVBarrageItemView *)[barrage dequeueReusableItem];
        if (!item) {
            item = [[PVBarrageItemView alloc] init];
        }
        item.speed = 80;
        BOOL highSpeed = (arc4random_uniform((int32_t)time(NULL)) % 100) < 30;
        if (highSpeed) {
            item.speed = 120;
        }
        item.isSelfDanmu = self.isSelfDanmu;
        item.detail = title;
        return item;
    }
    return nil;
}

/*********************************************/
-(void)sendGiftButtonOnClick:(UIButton *)sender{
    YYLog(@"暂时没使用这个代理");
}
/**
 *  返回自定义cell样式
 */
- (PVPresentViewCell *)presentView:(PVPresentView *)presentView cellOfRow:(NSInteger)row{

    return [[PVGIftCell alloc] initWithRow:row];
}
/**
 *  礼物动画即将展示的时调用，根据礼物消息类型为自定义的cell设置对应的模型数据用于展示
 *
 *  @param cell        用来展示动画的cell
 *  @param model       礼物模型
 */
- (void)presentView:(PVPresentView *)presentView
         configCell:(PVPresentViewCell *)cell
              model:(id<PVPresentModelAble>)model{
    
    YYLog(@"礼物动画即将展示的时调用 -- ");
    PVGIftCell *giftcell = (PVGIftCell *)cell;
    giftcell.presentmodel = model;
}

/**
 *  cell点击事件
 */
- (void)presentView:(PVPresentView *)presentView didSelectedCellOfRowAtIndex:(NSUInteger)index{
    presentView.hidden = YES;
    //GIftCell *cell = [presentView cellForRowAtIndex:index];
}


/**
 一组连乘动画执行完成回调
 */
- (void)presentView:(PVPresentView *)presentView animationCompleted:(NSInteger)shakeNumber model:(id<PVPresentModelAble>)model{
    
}

#pragma 加载动画
- (PVPresentView *)presentView{
    if (!_presentView) {
        _presentView  = [[PVPresentView alloc]init];
        _presentView.delegate = self;
        _presentView.frame = CGRectMake(0,(self.view.sc_height-140)/2, CGRectGetWidth(self.view.frame)/2, 160);
        _presentView.cellHeight = 46;
        _presentView.showTime   = 3;
        _presentView.delegate = self;
        _presentView.hidden = YES;
        _presentView.userInteractionEnabled = NO;
        _presentView.backgroundColor = [UIColor clearColor];
    }
    return _presentView;
}

#pragma 加载动画-- 横屏
- (PVPresentView *)presentViews{
    if (!_presentViews) {
        _presentViews  = [[PVPresentView alloc]init];
        _presentViews.delegate = self;
        _presentViews.cellHeight = 46;
        _presentViews.showTime   = 3;
        _presentViews.delegate = self;
        _presentViews.hidden = YES;
        _presentViews.backgroundColor = [UIColor clearColor];
    }
    return _presentViews;
}

/** 全屏暂停的提示 */
- (UILabel *) tipsLabel{
    
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.backgroundColor = kColorWithRGBA(0, 0, 0, 0.7);
        _tipsLabel.layer.cornerRadius = 8;
        _tipsLabel.clipsToBounds = YES;
        _tipsLabel.text = @"已暂停";
        _tipsLabel.hidden = YES;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _tipsLabel;
}

#pragma mark ================== 竖屏活动倒计时按钮=====================
- (UIButton *)live_btn_vote{
    if (!_live_btn_vote) {
        // 活动投票按钮
        UIButton *live_btn_vote = [[UIButton alloc] init];
        live_btn_vote.frame = CGRectMake(YYScreenWidth - 60 - 10, YYScreenHeight - 60 - 179, 60, 60);
        [live_btn_vote setImage:kGetImage(@"live_btn_vote") forState:UIControlStateNormal];
        [live_btn_vote setImage:kGetImage(@"live_btn_vote") forState:UIControlStateHighlighted];
        [live_btn_vote addTarget:self action:@selector(live_btn_voteOnClick:) forControlEvents:UIControlEventTouchUpInside];
        live_btn_vote.hidden = YES;
        _live_btn_vote = live_btn_vote;
        [self.view insertSubview:self.live_btn_vote atIndex:10];
    }
    return _live_btn_vote;
}

- (UILabel *)live_label_vote{
    if (!_live_label_vote) {
        CGFloat y=CGRectGetMaxY(self.live_btn_vote.frame);
        _live_label_vote = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 60 - 10, y, 60, 30)];
        _live_label_vote.frame = CGRectMake(kScreenWidth - 60 - 10, y, 60, 40);
        _live_label_vote.numberOfLines = 2;
        _live_label_vote.hidden = YES;
        _live_label_vote.textColor = kColorWithRGB(128, 128, 128);
        _live_label_vote.font = font(13);
        _live_label_vote.textAlignment = NSTextAlignmentCenter;
        [self.view insertSubview:self.live_label_vote atIndex:12];
    }
    return _live_label_vote;
}

#pragma mark ================== 横屏活动倒计时按钮=====================
/// 横屏活动
- (UIView *)live_view_vote_full{
    if (!_live_view_vote_full) {
        _live_view_vote_full = [[UIView alloc] init];
        _live_view_vote_full.backgroundColor = [UIColor clearColor];
        _live_view_vote_full.hidden = YES;
    }
    return _live_view_vote_full;
}
/// 横屏活动倒计时按钮
- (UIButton *)live_btn_vote_full{
    if (!_live_btn_vote_full) {
        _live_btn_vote_full = [[UIButton alloc] init];
        [_live_btn_vote_full setImage:kGetImage(@"live_btn_vote") forState:UIControlStateNormal];
        [_live_btn_vote_full setImage:kGetImage(@"live_btn_vote") forState:UIControlStateHighlighted];
        [_live_btn_vote_full addTarget:self action:@selector(live_btn_voteOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _live_btn_vote_full;
}
/// 横屏活动倒计时文字
- (UILabel *)live_label_vote_full{
    if (!_live_label_vote_full) {
        _live_label_vote_full = [[UILabel alloc] init];
        _live_label_vote_full.textColor = kColorWithRGB(255, 255, 255);
        _live_label_vote_full.textAlignment = NSTextAlignmentCenter;
        _live_label_vote_full.font = font(13);
        _live_label_vote_full.numberOfLines = 2;
    }
    return _live_label_vote_full;
}

/// 横竖屏回看/直播标志(外层View)
- (UIView *)live_view_backSee{
    if (!_live_view_backSee) {
        _live_view_backSee = [[UIView alloc] init];
        _live_view_backSee.backgroundColor = [UIColor clearColor];
        _live_view_backSee.hidden = YES;
        _live_view_backSee.userInteractionEnabled = NO;
    }
    return _live_view_backSee;
}

/// 横竖屏回看/直播标志(小圆点)
- (UIButton *)live_btn_backSee{
    if (!_live_btn_backSee) {
        _live_btn_backSee = [[UIButton alloc] init];
    }
    return _live_btn_backSee;
}
/// 横竖屏回看/直播标志(文字)
- (UILabel *)live_label_backSee{
    if (!_live_label_backSee) {
        _live_label_backSee = [[UILabel alloc] init];
        _live_label_backSee.textColor = kColorWithRGB(255, 255, 255);
        _live_label_backSee.textAlignment = NSTextAlignmentCenter;
        _live_label_backSee.font = font(11);
    }
    return _live_label_backSee;
}

#pragma mark ------------------- 收到消息处理 -------------------
/** 收到消息处理 */
- (void)initiateBarrage:(NSNotification *)notification{
    
    PVChatList *dialog = notification.userInfo[@"dialog"];
//    dialog.chatType = @"3";
    // 消息类型(0.聊天、1.用户进入、2.送礼、3.红包&活动、4.公告，5.点赞)
    switch (dialog.chatType.integerValue) {
        case 0:
        {
            [self.messagePool addObject:dialog.chatMsg];
//            NSDictionary *dict = @{@"message":dialog.chatMsg};
//            [kNotificationCenter postNotificationName:@"receptionMessage" object:nil userInfo:dict];
        }
            break;
        case 1:
            // 用户进入
        {
           
//            // 点赞（竖屏）
//            LZHeartFlyView *heart = [[LZHeartFlyView alloc] initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
//            [self.view addSubview:heart];
//            //[currentView insertSubview:heart atIndex:100];
//            CGFloat h = lz_kiPhoneX(0);
//            CGPoint fountainSource = CGPointMake(kScreenWidth-18-13, _height - _heartSize/2.0 - 10 - h);
//            heart.center = fountainSource;
//            [heart animateInView:self.view];
        }
            break;
        case 2:
            // 收到送礼消息。展示相关动画
            //////////
        {
            self.presentView.hidden = NO;
            // 执行动画操作
            [self verticalScreenInformPerformAnimation:dialog];
        }
            break;
        case 3:
            {
                // 红包&活动
                NSArray *array = (NSArray *)[Utils dictionaryWithJsonString:dialog.chatMsg];
                for (int i=0;i<array.count;i++) {
                    NSString *startTime = array[i][@"startTime"];
                    NSString *endTime = array[i][@"endTime"];
                    _H5URLString = array[i][@"H5Url"];
                    if (self.live_label_vote.hidden) {
//                        startTime = @"2017-11-29 15:00:00";
//                        endTime = @"2017-11-29 18:59:00";
                        if ((startTime.length < 1) || (endTime.length < 1)) {
                            return;
                        }
                        BOOL sj = [Utils judgeTimeByStartTime:startTime endTime:endTime];
                        if (sj) {
                            self.fullShowVote = YES;
                            self.isVote = YES;
                            [self changeDirectionWhenCurrentIsFull:YES];
                            self.live_btn_vote.hidden = NO;
                            self.live_label_vote.hidden = NO;
                            YYLog(@"在当前时间范围内 --%@",[Utils getCurrentTime]);
                            NSString *time = [Utils dateTimeDifferenceWithStartTime:[Utils getCurrentTime] endTime:endTime];
                            NSString *timeStr = [NSString stringWithFormat:@"倒计时 \n %@秒",time];
                            self.live_label_vote.text = timeStr;
                            self.live_label_vote_full.text = timeStr;
                            PV(weakSelf);
                            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
                                NSInteger secondi=0;
                                NSArray *strArr = [weakSelf.live_label_vote.text componentsSeparatedByString:@"\n"];
                                NSArray *strArr1 = [strArr[1] componentsSeparatedByString:@"秒"];
                                NSString *timeStr = strArr1[0];
                                if (timeStr.length!=1) {
                                    NSArray *minutes = [timeStr componentsSeparatedByString:@":"];
                                    NSString *second1 = [minutes sc_safeObjectAtIndex:0];
                                    NSString *second2 = [minutes sc_safeObjectAtIndex:1];
                                    NSInteger seconds = second1.integerValue*60;
                                    secondi = seconds+second2.integerValue;
                                    YYLog(@"secondi -- %ld",secondi);
                                }
                                NSInteger currentSecond = secondi - 1;
                                NSString *timeStr1 = [NSString stringWithFormat:@"%ld:%ld",currentSecond/60,currentSecond%60];
                                NSString *handlingTimeStr = [NSString stringWithFormat:@"倒计时 \n %@秒",timeStr1];
                                weakSelf.live_label_vote.text = handlingTimeStr;
                                weakSelf.live_label_vote_full.text = handlingTimeStr;
                            } repeats:YES];
                            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                        }else{
                            self.isVote = NO;
                            YYLog(@"当前时间不在活动时间范围内j");
                            self.live_view_vote_full.hidden = YES;
                        }
                        
                    }
                    YYLog(@"array --- %@",array);
                }
            }
            break;
        case 4:
            // 公告
            break;
        case 5:
            {
//                for (int i=0; i<dialog.count.integerValue; i++) {
//                    // 点赞（竖屏）
//                    LZHeartFlyView *heart = [[LZHeartFlyView alloc] initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
//                    [self.view addSubview:heart];
//                    //[currentView insertSubview:heart atIndex:100];
//                    CGFloat h = lz_kiPhoneX(0);
//                    CGPoint fountainSource = CGPointMake(kScreenWidth+18-13, _height - _heartSize/2.0 - 10 - h);
//                    heart.center = fountainSource;
//                    [heart animateInView:self.view];
//                }
            }
            break;
        default:
            break;
    }
}

/** 竖屏收到礼物执行动画 */
- (void)verticalScreenInformPerformAnimation:(PVChatList *)chatList{

    NSInteger idx = 0;
    switch (chatList.chatMsg.integerValue) {
            /********（一）普通档礼物：表达喜欢情绪  静态呈现********/
        case 1001:
                idx = 100;
            break;
        case 1002:
                idx = 101;
            break;
        case 1003:
                idx = 102;
            break;
        case 1004:
                idx = 103;
            break;
            /********（二）中档礼物：表达吐槽情绪 gif呈现********/
        case 2001:
                idx = 104;
            break;
        case 2002:
                idx = 105;
            break;
        case 2003:
                idx = 106;
            break;
            /********（三）高档礼物：土豪专区  全屏动效呈现********/
        case 3001:
                idx = 107;
            break;
        case 3002:
                idx = 108;
            break;
        default:
            break;
    }
    
    [self startGiftAnimalWithTag:idx giftCount:chatList.count.integerValue gifSender:chatList.userData.nickName showType: self.playerView.playControllerView.isRotate ? 2 : 1];
}

// 参数类型是NSNotification///// 横屏选择礼物执行动画
- (void)informPerformAnimation:(NSNotification *)notification{
    self.fullScreenGiftChoiceView.hidden = YES;
    NSString *idx = notification.userInfo[@"reuse"];
    NSString *count = notification.userInfo[@"count"];
    NSString *nickName = notification.userInfo[@"userNickName"];
    [self startGiftAnimalWithTag:idx.integerValue giftCount:count.integerValue gifSender:nickName showType:2];
    
//    YYLog(@"接受到通知执行送礼的动画--- %@",idx);
//    [self chooseGiftOnClick:idx.integerValue presentView:self.presentViews giftNum:20 giftTotal:10];
//    // 执行全屏动画
//    if (idx == 107 || idx == 108) {
//        [self showeEpecialAnimation:2 giftIdx:idx];
//    }
//    [self executionAnimation:idx.integerValue];
}

// 收到通知执行动画(横屏礼物数量)
//- (void) executionAnimation:(NSInteger)idx{
//    // 执行基本动画
//    [self chooseGiftOnClick:idx presentView:self.presentViews giftNum:20 giftTotal:10];
//    // 执行全屏动画
//    if (idx == 107 || idx == 108) {
//        [self showeEpecialAnimation:2 giftIdx:idx];
//    }
//}

/**
 *  执行横竖屏全屏动画
 *
 *  @param type 1.竖屏标识 2.横屏标识
 *  @param idx 礼物下标
 */
- (void)showeEpecialAnimation:(NSInteger) type giftIdx:(NSInteger) idx{
//    [self startTimer];
    if (type == 1) {
        // 竖屏播放GIF的背景View(兰博基尼<View> 游艇<Views>)
        if (idx == 107) { //兰博基尼
            [self.view insertSubview:self.gifBoxView aboveSubview:self.view];
        }else{          //豪华游艇
            [self.view insertSubview:self.gifBoxViews aboveSubview:self.view];
        }
    }else{
        if (idx == 107) { //兰博基尼
            [self.playContainerView insertSubview:self.fullGifBoxView aboveSubview:self.playContainerView];
        }else{          //豪华游艇
            [self.playContainerView insertSubview:self.fullGifBoxViews aboveSubview:self.playContainerView];
            [self.fullGifBoxViews mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(self.playContainerView);
            }];
        }
    }
}

-(void)removeAnimote{
    if (self.gifBoxViews) {
        YYAnimatedImageView* imageView = self.gifBoxViews.subviews.firstObject;
        [imageView stopAnimating];
        [imageView.layer removeAllAnimations];
        imageView = nil;
        [self.gifBoxView removeFromSuperview];
        self.gifBoxView  = nil;
    }
    if (self.fullGifBoxView) {
        YYAnimatedImageView* imageView = self.fullGifBoxView.subviews.firstObject;
        [imageView stopAnimating];
        [imageView.layer removeAllAnimations];
        imageView = nil;
        [self.fullGifBoxView removeFromSuperview];
        self.fullGifBoxView  = nil;
    }
    if (self.fullGifBoxViews) {
        YYAnimatedImageView* imageView = self.fullGifBoxViews.subviews.firstObject;
        [imageView stopAnimating];
        [imageView.layer removeAllAnimations];
        imageView = nil;
        [self.fullGifBoxViews removeFromSuperview];
        self.fullGifBoxViews  = nil;
    }
}

/**********************************************/

- (void) delegateFullScreenToolsBtnClicked:(UIButton *)btn{
    
    YYLog(@"delegateFullScreenToolsBtnClicked -- %ld",(long)btn.tag);
}

/** 设置快捷回复聊天 */
- (void)listArray:(UIButton *)sender {
    if (listArray.count) {
        return;
    }
    NSArray *array ;
    if (sender.tag == 101) {
        array =@[@"1",@"撒花 ★\(￣▽￣)/★ ",@"开口跪",@"膜拜，膝盖收好",@"心动表白",@"6的飞起",@"疯狂打call"];

    }else if (sender.tag == 102){
        array = @[@"2",@"正在和对方连麦..."];

    }
    for (NSInteger i = 0; i < array.count; i++) {
        [listArray addObject:[NSString stringWithFormat:@"%@",array[i]]];
    }
    
    
    if (listArray.count>0) {
        [self setDefaultCell];
        _cellView.vhShow = NO;
        _cellView.optionType = LZOptionSelectViewTypeArrow;
        
        if (kiPhoneX) {
            [_cellView showTapPoint:CGPointMake(sender.x+sender.width/2, _height-lz_kiPhoneXB(55))
                          viewWidth:150
                          direction:LZOptionSelectViewTop];
        }else{
            [_cellView showTapPoint:CGPointMake(sender.x+sender.width/2, _height-55)
                          viewWidth:150
                          direction:LZOptionSelectViewTop];
        }
    }else{
        Toast(@"没有快捷消息内容");
    }
}

/** 设置快捷回复聊天 */
- (void)fullScreenlistArray:(UIButton *)sender {

    NSArray *array =@[@"撒花 ★\(￣▽￣)/★ ",@"开口跪",@"膜拜，膝盖收好",@"心动表白",@"6的飞起",@"疯狂打call"];
    
    for (NSInteger i = 0; i < array.count; i++) {
        [fullListArray addObject:[NSString stringWithFormat:@"%@",array[i]]];
    }
    if (fullListArray.count>0) {
        [self setDefaultFullScreenCell];
        self.fullScreenCellView.vhShow = NO;
        self.fullScreenCellView.optionType = LZOptionSelectViewTypeArrow;

        if (kiPhoneX) {
            [_fullScreenCellView showHoTapPoint:CGPointMake(sender.x+sender.width/2, CrossScreenWidth-lz_kiPhoneXB(55))
                                      viewWidth:150
                                      direction:LZOptionSelectViewTop
             fatherView:self.playContainerView];
            
        }else{
            [_fullScreenCellView showHoTapPoint:CGPointMake(sender.x+sender.width/2, CrossScreenWidth - 55)
                                      viewWidth:150
                                      direction:LZOptionSelectViewTop fatherView:self.playContainerView];
        }
        
    }else{
        Toast(@"没有快捷消息内容");
    }
}

/** 设置Cell(竖屏) */
- (void)setDefaultCell {
    WEAK(weaklistArray, listArray);
    WEAK(weakSelf, self);
    _cellView.sc_height = 150;
    _cellView.canEdit = NO;
    _cellView.isScrollEnabled = NO;
    [_cellView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PopupTableViewCell"];
    _cellView.cell = ^(NSIndexPath *indexPath){
        UITableViewCell *cell = [weakSelf.cellView dequeueReusableCellWithIdentifier:@"PopupTableViewCell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",weaklistArray[indexPath.row+1]];
        cell.textLabel.textColor = [UIColor sc_colorWithRed:42 green:180 blue:228];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        return cell;
    };
    _cellView.optionCellHeight = ^{
        return 35.f;
    };
    _cellView.rowNumber = ^(){
        return (NSInteger)weaklistArray.count;
    };
    _cellView.selectedOption = ^(NSIndexPath *indexPath){
        
        // 用于判断是竖屏快捷聊天、竖屏连麦、横屏快捷聊天的内容
        NSString *idxFlag = [weaklistArray objectAtIndex:0];
        // 获取显示的内容
        NSString *message = [weaklistArray objectAtIndex:indexPath.row+1];
        
        if ([idxFlag isEqualToString:@"1"]) {
            // 快捷回复(竖屏)
            // 添加快捷消息到弹幕池
            if (![PVUserModel shared].isLogin) {
                PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
                weakSelf.isNeedNewsRequest = NO;
                [weakSelf.navigationController pushViewController:loginVC animated:true];
                return;
            }
//            [weakSelf.messagePool addObject:message];
            NSDictionary *dict = @{@"message":message};
            [kNotificationCenter postNotificationName:@"receptionMessage" object:nil userInfo:dict];
        }else if([idxFlag isEqualToString:@"2"]){
            // 连麦
            // 暂时不做
        }
        YYLog(@"message --- %@",message);
    };
}

/** 设置Cell(横屏) */
- (void)setDefaultFullScreenCell {
    WEAK(weaklistArray, fullListArray);
    WEAK(weakSelf, self);
//    float cellHeight = 150/fullListArray.count;

    _fullScreenCellView.canEdit = NO;
    _fullScreenCellView.isScrollEnabled = NO;
    [_fullScreenCellView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PopupTableViewCell"];
    _fullScreenCellView.cell = ^(NSIndexPath *indexPath){
        UITableViewCell *cell = [weakSelf.fullScreenCellView dequeueReusableCellWithIdentifier:@"PopupTableViewCell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",weaklistArray[indexPath.row]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        return cell;
    };
    _fullScreenCellView.optionCellHeight = ^{
        return 35.0f;
    };
    _fullScreenCellView.rowNumber = ^(){
        return (NSInteger)weaklistArray.count;
    };
    _fullScreenCellView.selectedOption = ^(NSIndexPath *indexPath){
        if (![PVUserModel shared].isLogin) {
            [weakSelf changeDirectionWhenCurrentIsFull:YES];
            [weakSelf.playerView.playControllerView screenBtnClicked];
            PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
            weakSelf.isNeedNewsRequest = NO;
            [weakSelf.navigationController pushViewController:loginVC animated:true];
            return;
        }
        weakSelf.isSelfDanmu = YES;
        // 获取显示的内容
        NSString *message = [weaklistArray objectAtIndex:indexPath.row];
        // 快捷回复(横屏)
        // 添加快捷消息到弹幕池
        [weakSelf.messagePool addObject:message];
        NSDictionary *dict = @{@"message":message};
        [kNotificationCenter postNotificationName:@"receptionMessage" object:nil userInfo:dict];
        YYLog(@"message --- %@",message);
    };
}

/**
 *  点赞显示❤️
 *
 *  @param sender 当前点击的按钮
 *  @param currentView 需要显示到的View
 */
-(void)showTheLove:(UIButton *)sender View:(UIView *) currentView Height:(CGFloat) height{
    LZHeartFlyView* heart = [[LZHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
//    [self.view addSubview:heart];
    [currentView insertSubview:heart atIndex:100];
    CGFloat h = lz_kiPhoneX(0);
    CGPoint fountainSource = CGPointMake(sender.x+sender.width/2, height - _heartSize/2.0 - 10 - h);
    heart.center = fountainSource;
    [heart animateInView:currentView];
}

-(void)showTheLoveSenderX:(CGFloat)senderX SenderWidth:(CGFloat)senderWidth  View:(UIView *) currentView Height:(CGFloat) height{
    LZHeartFlyView* heart = [[LZHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    //    [self.view addSubview:heart];
    [currentView insertSubview:heart atIndex:100];
    CGFloat h = lz_kiPhoneX(0);
    CGPoint fountainSource = CGPointMake(senderX+senderWidth/2, CrossScreenHeight_X - _heartSize/2.0 - 10 - h - 10);
    heart.center = fountainSource;
    [heart animateInView:currentView];
}

/** 发送礼物的代理 */
- (void) sendGiftOnClick{

}

/** 选择礼物 */
- (void) showChooseGiftClick:(UIButton *)sender{

    PV(LZ)
    YYLog(@"显示礼物选择");
//    LZ.giftGivingView.lzListModel = self.lzListModel;
    LZ.giftGivingView.view.hidden = false;
    [UIView animateWithDuration:0.25f animations:^{
        LZ.giftGivingView.view.sc_y = lz_kiPhoneX(CGRectGetMaxY(LZ.playerContainerView.frame));
    }];
}

/** 点击返回按钮 */
- (void)zf_playerAction{
    [self.navigationController popViewControllerAnimated:true];
}



//---------------------------------------------------------------------------------------------------------------------------------------------
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
        make.right.equalTo(self.playContainerView.mas_right).offset(YYScreenHeight*0.5);
        make.width.equalTo(@(YYScreenHeight*0.5));
    }];
}
-(void)setFullScreenGiftChoiceViewConstrints:(UIView*)view{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.playContainerView);
        make.right.equalTo(self.playContainerView.mas_right).offset(YYScreenWidth*0.8);
        make.width.equalTo(@(YYScreenWidth*0.8));
    }];
}

-(void) setFullScreenPresentViewsConstrints:(UIView*)view{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.playContainerView.mas_left).offset(0);
        make.centerY.equalTo(self.playContainerView);
        make.height.equalTo(@160);
        CGFloat width = CGRectGetWidth(self.view.frame)/2;
        make.width.equalTo(@(width));
    }];
}

#pragma mark - 控制层VideoPlayerViewDelegate************************************
-(void)delegateMoreBtnClicked{
    [self showMoreView:self.videoMoreView];
    YYLog(@"更多");
}
-(void)delegateShareBtnClicked{
    [self showMoreView:self.videoShareView];
    YYLog(@"分享");
}
-(void)delegateVShareBtnClicked{
    YYLog(@"分享竖屏");
    //之前代码
//    _showShareView = [[PVShowShareView alloc]init];
////    _showShareView.delegate = self;
//    [_showShareView showInView:[UIApplication sharedApplication].keyWindow];
    
    PVShareViewController *shareCon = [[PVShareViewController alloc] init];
    PVShareModel *shareModel = [[PVShareModel alloc] init];
    shareModel.sharetitle = self.introduceModel.liveTitle;
    shareModel.h5Url = self.introduceModel.shareH5Url;
    shareModel.videoUrl = self.introduceModel.liveUrl;
    shareModel.imageUrl = self.introduceModel.logoUrl;
    shareCon.shareModel = shareModel;
    
    shareCon.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:shareCon animated:NO completion:nil];
    
}
-(void)delegateDefinitionBtnClicked{
    
    self.videoDefinitionView.introduceModel = self.introduceModel;
    [self showMoreView:self.videoDefinitionView];
    YYLog(@"清晰度");
}

-(void)delegateAnthologyBtnClicked{
    [self showDemandAnthologyView:self.videoDemandAnthologyController.view];
    YYLog(@"选集");
}
-(void)delegateBarrageBtnClicked:(UIButton *)btn{
    if (btn.selected) {//开启弹幕
        self.barrageView.hidden = false;
    }else{//关闭弹幕
        self.barrageView.hidden = true;
    }
    YYLog(@"是否显示弹幕");
}

#pragma mark - 懒加载************************************
/** 视频更多的View */
-(PVVideoMoreView *)videoMoreView{
    if (!_videoMoreView) {
        _videoMoreView = [[PVVideoMoreView alloc]  init];
        _videoMoreView.hidden = true;
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
            shareModel.sharetitle = pv.introduceModel.liveTitle;
            shareModel.h5Url = pv.introduceModel.shareH5Url;
            shareModel.videoUrl = pv.introduceModel.liveUrl;
            shareModel.imageUrl = pv.introduceModel.logoUrl;
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
        _videoDefinitionView.hidden = true;
        PV(pv)
        [_videoDefinitionView setPVIntroduceViewBlock:^(PVIntroduceModel *introduceModel) {
            if ([introduceModel.liveState isEqualToString:@"1"]) {

                for (CodeRateList* codeRateList in introduceModel.codeRateList) {
                    if (codeRateList.isSelected) {//播放视频
                        NSString* liveUrl = pv.introduceModel.liveUrl;
                        NSString* url = [liveUrl stringByReplacingOccurrencesOfString:@"index.m3u8" withString:codeRateList.rateFileUrl];
                       
                        YYLog(@"url == %@",url);
                        [pv.playerView changeCurrentplayerItemWithVideoModel:url];
                        break;
                    }
                }
            }
        }];
    }
    return _videoDefinitionView;
}
-(PVVideoDemandAnthologyController *)videoDemandAnthologyController{
    if (!_videoDemandAnthologyController) {
        _videoDemandAnthologyController = [[PVVideoDemandAnthologyController alloc]  init];
        _videoDemandAnthologyController.type = 1;
        _videoDemandAnthologyController.view.hidden = true;
    }
    return _videoDemandAnthologyController;
}

- (PVFullScreenGiftChoiceView *) fullScreenGiftChoiceView{
   
    if (!_fullScreenGiftChoiceView) {
        _fullScreenGiftChoiceView = [[[NSBundle mainBundle]loadNibNamed:@"PVFullScreenGiftChoiceView" owner:self options:nil]objectAtIndex:0];
        _fullScreenGiftChoiceView.listModel = self.lzListModel;
        _fullScreenGiftChoiceView.hidden = true;
        _fullScreenGiftChoiceView.liveId = self.liveId;
         PV(weakSelf);
        //充值
        _fullScreenGiftChoiceView.rechargeBlock = ^{
            if (weakSelf.playerView.playControllerView.isRotate) {
//                [weakSelf changeDirectionWhenCurrentIsFull:YES];
                [weakSelf.playerView.playControllerView screenBtnClicked];
            }
            [weakSelf gotoRecharge];
        };
        //赠送
        _fullScreenGiftChoiceView.zengsongBlock = ^(NSInteger reuse, BOOL isHaveMoney) {
            [weakSelf zengsongWithReuse:reuse isHaveMoney:isHaveMoney];
        };
    }
    return _fullScreenGiftChoiceView;
}




//去充值
- (void)gotoRecharge{
    if (![PVUserModel shared].isLogin) {
        PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
        self.isNeedNewsRequest = NO;
        [self.navigationController pushViewController:loginVC animated:true];
        return;
    }
    PVMoneyViewController* vc = [[PVMoneyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//赠送
- (void)zengsongWithReuse:(NSInteger)reuse  isHaveMoney:(BOOL)isHaveMoney{
    if (![PVUserModel shared].isLogin) {
        [self changeDirectionWhenCurrentIsFull:YES];
        [self.playerView.playControllerView screenBtnClicked];
        PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
        self.isNeedNewsRequest = NO;
        [self.navigationController pushViewController:loginVC animated:true];
        return;
    }
    PV(weakSelf);
    if (isHaveMoney) {
        [self.fullScreenGiftChoiceView requestPresentGift:reuse];
        return;
    }
    PVTipsPopoverView * showTipsView = [[NSBundle mainBundle] loadNibNamed:@"PVTipsPopoverView" owner:nil options:nil ].lastObject;
    [showTipsView showNoWindowInView:self.playContainerView];
    __block PVTipsPopoverView * weakShowTipsView = showTipsView;
    showTipsView.jumpCallBlock = ^(NSInteger idx) {
        if (idx == 2) {
            if (weakSelf.playerView.playControllerView.isRotate) {
                [weakSelf changeDirectionWhenCurrentIsFull:YES];
                [weakSelf.playerView.playControllerView screenBtnClicked];
            }
            [weakSelf gotoRecharge];
        }
        [weakShowTipsView.coverView removeFromSuperview];
        weakShowTipsView.coverView = nil;
        [weakShowTipsView removeFromSuperview];
        weakShowTipsView = nil;
    };

}
/** 弹幕 */
- (PVBarrageView *)barrageView{
    if (!_barrageView) {
        _barrageView = [[PVBarrageView alloc] init];
        _barrageView.dataSource = self;
        _barrageView.playSubQueueMaxCount = 4;
        _barrageView.hidden = YES;
        _barrageView.userInteractionEnabled = NO;
        _barrageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        _barrageView.barrageAverageSpeed = 80;
    }
    return _barrageView;
}

/** 遮盖 */
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
    if (self.fullScreenGiftChoiceView.popoverView) {
        [self.fullScreenGiftChoiceView.popoverView removeFromSuperview];
        self.fullScreenGiftChoiceView.popoverView = nil;
        return;
    }
    [self.chatKeyBoard keyboardDownForComment];
    [self closeMoreView:self.videoMoreView];
    [self closeMoreView:self.videoShareView];
    [self closeMoreView:self.fullScreenGiftChoiceView];
    [self closeMoreView:self.videoDefinitionView];
    [self closeDemandAnthologyView:self.videoDemandAnthologyController.view];
}

//获取屏幕改变事件
- (void)changeDirectionWhenCurrentIsFull:(BOOL)isFull{
    if (isFull) {
        if (self.fullScreenGiftChoiceView.popoverView) {
            [self.fullScreenGiftChoiceView.popoverView removeFromSuperview];
            self.fullScreenGiftChoiceView.popoverView = nil;
        }
        if (self.fullScreenCellView.superview) {
            [self.fullScreenCellView dismiss];
            
        }
        [self closeMoreView:self.videoMoreView];
        [self closeMoreView:self.videoShareView];
        [self closeMoreView:self.fullScreenGiftChoiceView];
        [self closeMoreView:self.videoDefinitionView];
        [self closeDemandAnthologyView:self.videoDemandAnthologyController.view];
        [self oneFingerTwoTaps];
        if (!self.presentViews.hidden) {
            self.presentViews.hidden = YES;
            self.presentView.hidden = NO;
        }
        
        if (self.fullShowVote) {
            self.fullShowVote = NO;
            self.live_view_vote_full.hidden = YES;
        }
    }else{
        if (!self.fullShowVote) {
            self.fullShowVote = YES;
            if (self.isVote) {
                self.live_view_vote_full.hidden = NO;
            }else{
                self.live_view_vote_full.hidden = YES;
            }
        }
    }
    [self.chatKeyBoard keyboardDownForComment];
}

/** 左上角返回按钮 */
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 70, 70);
        _backButton.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
        [_backButton setImage:[UIImage imageNamed:@"all_btn_back_white"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backToBeforeVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
/**
 *  显示更多层
 *
 *  @param view view
 */
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
        make.right.equalTo(@(YYScreenHeight*0.5));
    }];
    [UIView animateWithDuration:0.2f animations:^{
        [self.playContainerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.coverBtn.hidden = true;
        view.hidden = true;
    }];
}

#pragma mark ---- 发送消息和弹幕--
/** 发送聊天信息 */
- (void)chatKeyBoardSendText:(NSString *)message{

    self.isSelfDanmu = YES;
    YYLog(@"text -- %@",message);
    if (message.length>=30) {
        
        Toast(@"评论输入的文字上限为30个中文字");
    }else{
        
        // 添加弹幕
        [self.messagePool addObject:message];
        // 关闭键盘
        [self.chatKeyBoard keyboardDownForComment];
        // 发送通知
        NSDictionary *dict = @{@"message":message};
        [kNotificationCenter postNotificationName:@"receptionMessage" object:nil userInfo:dict];
    }
}

#pragma -----------点赞接口-----------
- (void) pointPraiseRequest{
    
    _praiseCount = _praiseCount+1;
    YYLog(@"_praiseCount -- %ld",(long)_praiseCount);
    // 点赞接口调用
    if (_praiseCount==1 || _praiseCount==30) {
        
        /**
         *  count   点赞数     string
         *  liveId  直播ID    string
         *  token   令牌      string
         *  userId
         */
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:@(self.praiseCount) forKey:@"count"];
        [dictionary setValue:self.liveId forKey:@"liveId"];
        [dictionary setValue:kUserInfo.token forKey:@"token"];
        [dictionary setValue:kUserInfo.userId forKey:@"userId"];
        YYLog(@"点赞接口调用Dict -- %@",dictionary);
        [PVNetTool postDataWithParams:dictionary url:@"addLike" success:^(id responseObject) {

            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {

                    // 点赞成功后恢复点赞数
                    _praiseCount = 0;
                    YYLog(@"responseObject --%@",responseObject);
                }else{
                    YYLog(@"点赞--rs---不等于200");
                }
            }
        } failure:^(NSError *error) {
            YYLog(@"error -- %@",error);
        }];
    }
}

#pragma -----------获取礼物模型数据-----------
/** 获取礼物模型数据 */
- (void) getGiftsList{
    PV(weakSelf);
    [PVNetTool getWithURLString:@"getGiftsList" parameter:nil success:^(id responseObject){
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([[responseObject pv_objectForKey:@"rs"] integerValue]==200) {
                
                PVGiftsListModel *listModel = [[PVGiftsListModel alloc] init];
                [listModel setValuesForKeysWithDictionary:responseObject];
                weakSelf.lzListModel = listModel;
                
                YYLog(@"根据直播基本信息中的 礼物URL获取---responseObject --%@",responseObject);
                // 根据直播基本信息中的 礼物URL获取
                [weakSelf.itemModelArray removeAllObjects];
                for (int i=0; i<[weakSelf.lzListModel.data.giftList count]; i++) {
                    [weakSelf.itemModelArray addObject:weakSelf.lzListModel.data.giftList[i]];
                }
            }
        }else{
            YYLog(@"礼物模板数据没有-");
        }
    } failure:^(NSError *error) {
        YYLog(@"error -- %@",error);
        
    }];
}


/** 获取账户余额-金币(动态) */
- (void)getBalance {

    NSDictionary *dict = @{@"platform":@(1),@"token":_token, @"userId":_userId};
    [PVNetTool postDataHaveTokenWithParams:dict url:@"/getPandaBalance" success:^(id responseObject) {
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                PVIntroduceMoneyModel *moneyModel = [PVIntroduceMoneyModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [PVUserModel shared].pandaAccount.balance = moneyModel.balance.integerValue;
            }else{
                
//                NSString *tips = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errorMsg"]];
//                Toast(tips);
            }
        }
    } failure:^(NSError *error) {
        YYLog(@"error--%@",error);
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        YYLog(@"tokenErrorInfo--%@",tokenErrorInfo);
    }];
}

-(NSMutableArray *)itemModelArray{
    
    if (!_itemModelArray) {
        _itemModelArray = [[NSMutableArray alloc] init];
    }
    return _itemModelArray;
}

-(NSMutableArray *)messagePool{
    
    if (!_messagePool) {
        _messagePool = [[NSMutableArray alloc] init];
    }
    return _messagePool;
}

//MARK: - 取消定时器
- (void)removeTimer
{
    if (_timerVote) {
        [_timerVote invalidate];
        _timerVote = nil;
    }
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end

