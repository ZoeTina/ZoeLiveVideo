//
//  LZPlayerView.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "LZPlayerView.h"
#import "LZHButton.h"
#import "PlayFastView.h"
#import "PVRegionFlowController.h"
#import "PVGifView.h"

// 图片路径
#define ZFPlayerSrcName(file)               [@"ZFPlayer.bundle" stringByAppendingPathComponent:file]

#define ZFPlayerFrameworkSrcName(file)      [@"Frameworks/ZFPlayer.framework/ZFPlayer.bundle" stringByAppendingPathComponent:file]

#define ZFPlayerImage(file)                 [UIImage imageNamed:ZFPlayerSrcName(file)] ? :[UIImage imageNamed:ZFPlayerFrameworkSrcName(file)]


@interface LZPlayerView() <LZHButtonDelegate,LZVideoPlayerViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak)id<LZVideoPlayerViewDelegate> vc;
/** 调节亮度，声音，进度的手势 */
@property (nonatomic, strong) LZHButton                *button;
/** 开始滑动的点 */
@property (nonatomic, assign) CGPoint                  startPoint;
/** 滑动方向 */
@property (nonatomic, assign) LZDirection              direction;
/** 滑动开始的播放进度 */
@property (nonatomic, assign) CGFloat                  startVideoRate;
@property (nonatomic, strong) UISlider*                volumeViewSlider;
/** 滑动目前要播放的时间进度 */
@property (nonatomic, assign) CGFloat                  currentRate;
/** 快进快退view */
@property (nonatomic, strong) PlayFastView             *fastView;
/** 单击手势 */
@property (nonatomic, strong) UITapGestureRecognizer   *singleTap;
/** 双击手势 */
@property (nonatomic, strong) UITapGestureRecognizer   *doubleTap;
/** 遮盖按钮 */
@property (nonatomic, strong) UIButton                 *coverBtn;
/** 播放失败显示的按钮 */
@property (nonatomic, strong) UIButton                 *faillerCenterBtn;
/** 单集1,多集 2,直播3, 回看4*/
@property (nonatomic, assign) NSInteger                 type;

/** 第一次加载动画 */
@property (nonatomic, strong) PVGifView                *gifView;
/** 播放中加载动画 */
@property (nonatomic, strong) PVGifView                *gifLoadingView;
/** 播放中加载动画 */
@property (nonatomic, strong) PVRegionFlowController   *flowVC;

@end

@implementation LZPlayerView


-(instancetype)initWithDelegate:(id<LZVideoPlayerViewDelegate>)delegate Url:(NSURL*)url  Type:(NSInteger)type{
    self = [super init];
    if (self) {
        self.type = type;
        self.vc = delegate;
        self.url = url;
        [self setupUI];
    }
    return self;
}

-(void)applicationBecomeActive{
    if(![self isShowingOnKeyWindow])return;
    if ([self isShowingOnKeyWindow]) {
        if (![self.player isPlaying]){
            [self.playControllerView videoPlay];
        }
    }else{
        if (self.player) {
            [self.playControllerView videoStop];
        }
    }
}

-(void)applicationEnterBackground{
    if(![self isShowingOnKeyWindow])return;
    if([self.player isPlaying]){
        [self.playControllerView videoPause];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)netWordSatus:(NSNotification*)notification{
    if(![self isShowingOnKeyWindow])return;
    NSInteger status = ((NSNumber*)notification.userInfo[@"status"]).integerValue;
    PV(pv)
    if (status == AFNetworkReachabilityStatusReachableViaWWAN && [pv.player isPlaying]) {
        [pv.playControllerView videoPause];
        [pv.playControllerView hideFlowBtnOrPlayBtnOrRepeatBtn:2];
        if (!pv.playControllerView.isRotate) {
            pv.flowVC = [PVRegionFlowController presentPVRegionFlowController:@"非Wi-Fi环境,继续播放将消耗您的数据流量,是否继续播放?" type:2];
            [pv.flowVC setPVRegionFlowControllerCallBlock:^(NSInteger type,BOOL isStop) {
                if (type == 2 && !isStop) {
                    [pv.playControllerView videoPlay];
                }else if(type == 2 && isStop){
                    [pv.playControllerView videoPause];
                    [pv.playControllerView hideFlowBtnOrPlayBtnOrRepeatBtn:2];
                    [pv stopPlayVideo];
                }
            }];
        }
    }else if (status == AFNetworkReachabilityStatusReachableViaWiFi && pv.player.currentPlaybackTime > 0.0 && ![pv.player isPlaying] && !pv.playControllerView.isPilotPattern){
        [pv.playControllerView videoPlay];
    }
}


-(void)setupUI{
    
    UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
    
    YYLog(@"duration(屏幕的方向) --- %ld",(long)duration);

    [self.playControllerView videoFirstPlay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWordSatus:) name:NetworkReachabilityStatus object:nil];
    
    // app从后台进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    IJKFFOptions* options = [[IJKFFOptions alloc] init];
    [options setPlayerOptionIntValue:5 forKey:@"framedrop"];
    
    // 设置Log信息打印
    [IJKFFMoviePlayerController setLogReport:NO];
    // 设置Log等级
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
    // 检查当前FFmpeg版本是否匹配
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
    [options setPlayerOptionIntValue:5 forKey:@"framedrop"];
    [options setPlayerOptionIntValue:512 forKey:@"vol"];

    // 关闭播放器缓冲
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[self.url absoluteString]] withOptions:options];
    _player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.playControllerView.player = _player;
    UIView *playerview = [self.player view];
    [self addSubview:playerview];
    [self insertSubview:playerview atIndex:0];
    [self addSubview:self.playControllerView];
    
    // 添加自定义的Button到视频画面上 用于手势控制相关
    _button = [[LZHButton alloc] init];
    _button.backgroundColor = [UIColor clearColor];
    _button.touchDelegate = self;
    if (self.type == 1) {
        [self addSubview:_button];
        [_button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playControllerView.topContainerView.mas_bottom);
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.bottom.equalTo(self.playControllerView.bottomContainerView.mas_top);
        }];
    }
    
    /** 快进快退view */
    [self addSubview:self.fastView];
    
    // 把控制层的锁屏按钮放到playView
    [self addSubview:self.playControllerView.lockScreenBtn];
    
    // 中间重播按钮(replayCenterBtn)
    [self addSubview:self.playControllerView.replayCenterBtn];
    // 中间流量播放按钮(flowPlayCenterBtn)
    [self addSubview:self.playControllerView.flowPlayCenterBtn];
    // 播放失败后显示的按钮
    [self addSubview:self.faillerCenterBtn];
    // 添加遮盖
    [self addSubview:self.coverBtn];
    
    /** 第一次加载动画 */
    [self addSubview:self.gifView];
    /** 播放中加载动画 */
    [self addSubview:self.gifLoadingView];
    
    [self setConstraint];
    
    [self.gifView startFirstGif];
    
    // 开启通知
    [self installMovieNotificationObservers];
    
    // 单击的 Recognizer
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.singleTap.numberOfTapsRequired = 1;
    self.singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:self.singleTap];
    
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    self.doubleTap.delegate = self;
    
//    if (self.type == 1) {
    [self addGestureRecognizer:self.doubleTap];
//    }
    
    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
}

/**
 *  显示/隐藏底部工具栏
 *
 */
- (void)handleSingleTap:(UITapGestureRecognizer *)sender{
    if (self.playControllerView.isRotate && self.playControllerView.lockScreenBtn.isSelected) {
        [self.playControllerView stopTimerVideoTool:3];
    }else{
        if (self.playControllerView.topContainerView.alpha == 0.0) {
            [self.playControllerView stopTimerVideoTool:3];
            [self.playControllerView startTimerVideoTool];
        }else{
            [self.playControllerView stopTimerVideoTool:3];
        }
    }

}

/**
 *  双击播放/暂停
 *
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture{
    if ([self.player isPlaying]) {
        [self.playControllerView videoPause];
    }else{
        if (![self.player isPlaying]) {
            [self.playControllerView videoPlay];
        }
    }
}
//切换当前播放的内容
- (void)changeCurrentplayerItemWithVideoModel:(NSString *)URLString{
    //移除当前player的监听
    self.playControllerView.link.paused = true;
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
    [self removeMovieNotificationObservers];
    
    [self.gifView startFirstGif];
    
    IJKFFOptions* options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:5      forKey:@"framedrop"];
    // 设置Log信息打印
    [IJKFFMoviePlayerController setLogReport:NO];
    // 设置Log等级
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
    // 检查当前FFmpeg版本是否匹配
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
    [options setPlayerOptionIntValue:5 forKey:@"framedrop"];
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:URLString] withOptions:nil];
    
    UIView *playerView = [self.player view];
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:playerView];
    [self insertSubview:playerView atIndex:0];
    
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    
    
    [self.player setScalingMode:IJKMPMovieScalingModeAspectFit];
    [self installMovieNotificationObservers];
    self.playControllerView.playBtn.hidden = true;
    self.playControllerView.pauseBtn.hidden = false;
    [self.playControllerView hideFlowBtnOrPlayBtnOrRepeatBtn:4];

    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
    }
    // 由暂停状态切换时候 开启定时器，将暂停按钮状态设置为播放状态
    self.playControllerView.link.paused = NO;
    self.playControllerView.player = self.player;
}

#pragma mark - 控制层的播放状态的代理以及全屏************************************
/** 开始播放 */
-(void)startPlayVideo{
    if (self.playControllerView.lockScreenBtn.selected && self.playControllerView.isRotate) {
        return;
    }
    self.singleTap.enabled = self.doubleTap.enabled = true;
    self.button.hidden = false;
}

/** 播放暂停 */
-(void)pausePlayVideo{
    self.singleTap.enabled =  true;
    if (self.playControllerView.lockScreenBtn.selected && self.playControllerView.isRotate) {
        self.doubleTap.enabled = false;
        self.button.hidden = true;
    }else{
        self.doubleTap.enabled = true;
        self.button.hidden = false;
    }
}

/** 播放停止 */
-(void)stopPlayVideo{
    self.button.hidden = true;
    if (self.type == 1) {
        self.singleTap.enabled = self.doubleTap.enabled = false;
    }
}

/** 锁屏切换 */
-(void)lockScreen:(BOOL)isLock{
    if (self.player) {
        self.button.hidden = isLock;
    }
}

#pragma mark - 自定义Button的代理************************************
#pragma mark - 开始触摸
/*************************************************************************/
- (void)touchesBeganWithPoint:(CGPoint)point {
    if (self.playControllerView.isRotate && self.playControllerView.lockScreenBtn.isSelected) return;
    
    //记录首次触摸坐标
    self.startPoint = point;
    //检测用户是触摸屏幕的左边还是右边，以此判断用户是要调节音量还是亮度，左边是亮度，右边是音量
    if (self.startPoint.x <= self.button.frame.size.width / 2.0) {
        //亮度
        YYLog(@"亮度");
    } else {
        //音/量
        YYLog(@"音量");
    }
    // 方向置为无
    self.direction = LZDirectionNone;
    // 记录当前视频播放的进度
    NSTimeInterval current = self.player.currentPlaybackTime;
    NSTimeInterval total = self.player.duration;
    self.startVideoRate = current/total;
    
}
#pragma mark - 结束触摸
- (void)touchesEndWithPoint:(CGPoint)point {

    if (self.playControllerView.isRotate && self.playControllerView.lockScreenBtn.isSelected) return;
    
    CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    if ((panPoint.x >= -5 && panPoint.x <= 5) && (panPoint.y >= -5 && panPoint.y <= 5)) {
        
        [self handleSingleTap:self.singleTap];
        return;
    }
    
    if (self.direction == LZDirectionLeftOrRight) {
        self.fastView.hidden = true;
        if (self.player.isPreparedToPlay) {
            self.playControllerView.currentTimeLabel.text = [self.playControllerView stringWithTime:self.player.duration*self.currentRate];
            self.player.currentPlaybackTime = self.player.duration*self.currentRate;
            [self.playControllerView videoPlay];
            self.playControllerView.link.paused = NO;
            YYLog(@"设置播放时间");
        }
    } else if (self.direction == LZDirectionUpOrDown){
        
    }
}
#pragma mark - 拖动
- (void)touchesMoveWithPoint:(CGPoint)point {

    if (self.playControllerView.isRotate && self.playControllerView.lockScreenBtn.isSelected) return;
    
    //手指在Button上移动的距离
    CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    //用户滑动的方向
    if (self.direction == LZDirectionNone) {
        if (panPoint.x >= 30 || panPoint.x <= -30) {
            //进度
            self.direction = LZDirectionLeftOrRight;
        } else if (panPoint.y >= 30 || panPoint.y <= -30) {
            //音量和亮度
            self.direction = LZDirectionUpOrDown;
        }
    }
    
    if (self.direction == LZDirectionNone) {
        return;
    } else if (self.direction == LZDirectionUpOrDown) {
        // 音量和亮度
        if (self.startPoint.x <= self.button.frame.size.width / 2.0) {
            CGFloat currentLight = [[UIScreen mainScreen] brightness];
            // 调节亮度
            if (panPoint.y < 0) {
                // 增加亮度
                if(currentLight < 1.0){
                    currentLight = currentLight+0.01;
                }
            } else {
                // 减少亮度
                if(currentLight > 0.0){
                    currentLight = currentLight-0.01;
                }
            }
            [[UIScreen mainScreen] setBrightness: currentLight];
        } else {
            // 音量
            CGFloat currentLight =[self.volumeViewSlider value];
            if (panPoint.y < 0) {
                //增大音量
                if(currentLight < 1.0){
                    currentLight = currentLight+0.01;
                }
            } else {
                //减少音量
                if(currentLight > 0.0){
                    currentLight = currentLight-0.01;
                }
            }
            self.volumeViewSlider.value = currentLight;
        }
    } else if (self.direction == LZDirectionLeftOrRight ) {
        //进度
        CGFloat rate = self.startVideoRate + (panPoint.x / 30.0 / 20.0);
        if (rate > 1) {
            rate = 1;
        } else if (rate < 0) {
            rate = 0;
        }
        if (rate >self.currentRate) {
            //进度
            self.fastView.fastImageView.image = [UIImage imageNamed:@"ZFPlayer_fast_forward"];
            YYLog(@"快进");
        }else if (rate  < self.currentRate){
            self.fastView.fastImageView.image = [UIImage imageNamed:@"ZFPlayer_fast_backward"];
            YYLog(@"快退");
        }
        self.fastView.fastProgressView.progress = rate;
        self.playControllerView.videoSlider.value = rate;
        self.playControllerView.currentTimeLabel.text = [self.playControllerView stringWithTime:self.player.duration*rate];
        self.currentRate = rate;
        NSString *totalTimeStr  = [self.playControllerView stringWithTime:self.player.duration];
        NSString *draggedTime   = [self.playControllerView stringWithTime:self.player.duration*rate];
        NSString *timeStr        = [NSString stringWithFormat:@"%@ | %@", draggedTime, totalTimeStr];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:timeStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor sc_colorWithHex:0x64C4F5]
                              range:NSMakeRange(0, draggedTime.length)];
        self.fastView.fastTimeLabel.attributedText        = attributedStr;
        self.fastView.hidden = false;
        
    }
}

/** 设置约束 */
-(void)setConstraint{
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    
    [self.playControllerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.right.equalTo(self);
    }];
    
    /** 快进快退view */
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
        make.center.equalTo(self);
    }];
    
    /** 遮盖按钮 */
    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.playControllerView.topContainerView.mas_bottom);
    }];
    
    // 锁屏按钮
    [self.playControllerView.lockScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if(kiPhoneX){
            make.left.equalTo(@34);
        }else{
            make.left.equalTo(@10);
        }
        make.width.height.equalTo(@(50));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    // 中间重播按钮
    [self.playControllerView.replayCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.centerX.centerY.equalTo(self);
    }];
    
    // 流量播放按钮
    [self.playControllerView.flowPlayCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(100);
        make.centerX.centerY.equalTo(self);
    }];
    
    [self.faillerCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
    
    /** 第一次加载动画 */
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    /** 播放中加载动画 */
    [self.gifLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@150);
    }];

}
-(LZPlayControllerView *)playControllerView{
    if (!_playControllerView) {
        _playControllerView = [[LZPlayControllerView alloc] initWithType:self.type];
        _playControllerView.backgroundColor = [UIColor clearColor];
        _playControllerView.player = self.player;
        _playControllerView.delegate = self.vc;
        _playControllerView.playerViewDelegate = self;
        __weak typeof(&*self) weakSelf = self;
        _playControllerView.isLockBlock = ^(BOOL isLock){
            if (isLock) {
                weakSelf.doubleTap.enabled = false;
            }else{
                weakSelf.doubleTap.enabled = true;
            }
        };
    }
    return _playControllerView;
}

- (UISlider *)volumeViewSlider{
    if (!_volumeViewSlider) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        UISlider* volumeViewSlider = nil;
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        [volumeViewSlider setValue:1.0f animated:NO];
        [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        _volumeViewSlider = volumeViewSlider;
    }
    return _volumeViewSlider;
}

- (PlayFastView *)fastView{
    if (!_fastView) {
        _fastView  = [[PlayFastView alloc] initWithFrame:CGRectZero];
        _fastView.hidden = true;
    }
    return _fastView;
}

- (UIButton *)coverBtn{
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.titleEdgeInsets = UIEdgeInsetsMake(-25, 0, 0, 0);
        [_coverBtn setTitle:@"由于版权问题,暂时无法观看此视频" forState:UIControlStateNormal];
        _coverBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_coverBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _coverBtn.backgroundColor = [UIColor clearColor];
        _coverBtn.hidden = true;
    }
    return _coverBtn;
}
- (void)setIsCopyRight:(BOOL) isCopyRight{
    _isCopyRight = isCopyRight;
    if (isCopyRight) {
        self.playControllerView.link.paused = true;
        [self.player shutdown];
        [self.player.view removeFromSuperview];
        self.player = nil;
        [self removeMovieNotificationObservers];
        [self.playControllerView stopTimerVideoTool:8];
        self.coverBtn.hidden = false;
    }else{
        self.coverBtn.hidden = true;
    }
}

- (PVGifView *) gifView{
    if (!_gifView) {
        _gifView = [[PVGifView alloc] initType:self.type];
        PV(pv)
        [_gifView setPVGifViewCallBlock:^{
            if (pv.playControllerView.isRotate) {
                [pv.playControllerView screenBtnClicked];
            }else{
                if (pv.playControllerView.delegate && [pv.playControllerView.delegate respondsToSelector:@selector(backToBeforeVC)]) {
                    [pv.playControllerView.delegate backToBeforeVC];
                }
            }
        }];
    }
    return _gifView;
}

- (PVGifView *) gifLoadingView{
    if (!_gifLoadingView) {
        _gifLoadingView = [[PVGifView alloc] initType:10];
        [_gifLoadingView stopFirstGif];
    }
    return _gifLoadingView;
}

- (void) stopGif{
    [self.gifView stopFirstGif];
    [self.gifLoadingView stopFirstGif];
}

- (UIButton *)faillerCenterBtn{
    if (!_faillerCenterBtn) {
        _faillerCenterBtn = [UIButton sc_buttonWithTitle:@"视频加载失败"
                                                fontSize:15.0
                                               textColor:kColorWithRGB(255, 255, 255)];
        _faillerCenterBtn.hidden = YES;
        [_faillerCenterBtn addTarget:self action:@selector(faillerCenterBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faillerCenterBtn;
}

- (void) faillerCenterBtnOnClick{
    
    self.faillerCenterBtn.hidden = YES;
    NSString *lastTimeStr = [NSString stringWithFormat:@"%f",self.playControllerView.lastPlayerTime];
    YYLog(@"视频加载失败。点击重新播放 --- %@",lastTimeStr);
    self.playControllerView.videoSlider.value = self.playControllerView.lastPlayerTime;
    [self.playControllerView videoPlay];
    [kNotificationCenter postNotificationName:@"PVAgainPalyerVideo" object:nil];
}

#pragma Install Notifiacation-------IJK各个通知与观察者------------
- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
}
- (void)removeMovieNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}
#pragma Selector func
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        self.playControllerView.link.paused = NO;
        self.playControllerView.totalTime = self.player.duration;
        [self stopGif];
        YYLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        [self.gifLoadingView startFirstGif];
        YYLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        YYLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}
- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            [self.playControllerView videoPlayOver];
            YYLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            YYLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:   // 播放失败
            YYLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            self.faillerCenterBtn.hidden = NO;
            [self stopGif];
            self.playControllerView.link.paused = NO;
            break;
            
        default:
            YYLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    YYLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
    switch (_player.playbackState) {
            
        case IJKMPMoviePlaybackStateStopped:
            YYLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            [self stopGif];
            self.playControllerView.link.paused = NO;
            YYLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            YYLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            YYLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            YYLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            YYLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (!self.playControllerView.isRotate) {
        return YES;
    }
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
}
@end
