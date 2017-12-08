//
//  PlayView.m
//  VideoDemo
//
//  Created by cara on 17/7/19.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PlayView.h"
#import "LZHButton.h"
#import "PlayFastView.h"
#import "PVRegionFlowController.h"
#import "PVVideoPilotView.h"
#import <AVFoundation/AVFoundation.h>

// 图片路径
#define ZFPlayerSrcName(file)               [@"ZFPlayer.bundle" stringByAppendingPathComponent:file]

#define ZFPlayerFrameworkSrcName(file)      [@"Frameworks/ZFPlayer.framework/ZFPlayer.bundle" stringByAppendingPathComponent:file]

#define ZFPlayerImage(file)                 [UIImage imageNamed:ZFPlayerSrcName(file)] ? :[UIImage imageNamed:ZFPlayerFrameworkSrcName(file)]

#define CaraScreenH [UIScreen mainScreen].bounds.size.height
#define CaraScreenW [UIScreen mainScreen].bounds.size.width


@interface PlayView() <LZHButtonDelegate,VideoPlayerViewDelegate>

@property (nonatomic, weak)id<VideoPlayerViewDelegate> vc;
///调节亮度，声音，进度的手势
@property (strong, nonatomic) LZHButton                *button;
//开始滑动的点
@property (assign, nonatomic) CGPoint                  startPoint;
//滑动方向
@property (assign, nonatomic) Direction                direction;
//滑动开始的播放进度
@property (assign, nonatomic) CGFloat                  startVideoRate;
@property (nonatomic, strong) UISlider*                volumeViewSlider;
//滑动目前要播放的时间进度
@property (assign, nonatomic) CGFloat                  currentRate;
//快进快退view
@property (nonatomic, strong) PlayFastView*            fastView;
//单机手势
@property (nonatomic, strong)UITapGestureRecognizer*  singleTap;
//双机手势
@property (nonatomic, strong)UITapGestureRecognizer*  doubleTap;
/** 遮盖按钮 */
@property (nonatomic, strong)UIButton   *coverBtn;
/** 单集1,多集 2,直播3, 回看4*/
@property (nonatomic, assign)NSInteger  type;
//播放中加载动画
@property (nonatomic, strong)PVGifView* gifLoadingView;
//试播模式view
@property (nonatomic, strong)PVVideoPilotView* videoPilotView;
///视频播放范围
@property (nonatomic, copy)NSString* videoDistrict;



@end

@implementation PlayView


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

-(instancetype)initWithDelegate:(id<VideoPlayerViewDelegate>)delegate playVideoModel:(PVPlayVideoModel*)playVideoModel{
    self = [super init];
    if (self) {
        self.playVideoModel = playVideoModel;
        self.type = playVideoModel.type;
        self.vc = delegate;
        self.url = playVideoModel.url;
        self.videoDistrict = playVideoModel.videoDistrict;
        [self setupUI];
    }
    return self;
}

-(void)netWordSatus:(NSNotification*)notification{
    if(![self isShowingOnKeyWindow])return;
    NSInteger status = ((NSNumber*)notification.userInfo[@"status"]).integerValue;
    if(status == AFNetworkReachabilityStatusReachableViaWWAN && [self.player isPlaying]) {
        [self.playControView videoPause];
        [self.playControView hideFlowBtnOrPlayBtnOrRepeatBtn:2];
        if (!self.playControView.isRotate) {
            PVRegionFlowController* flowVC = [PVRegionFlowController presentPVRegionFlowController:@"非WiFi环境,继续播放将消耗您的数据流量,是否继续播放?" type:2];
            [flowVC setPVRegionFlowControllerCallBlock:^(NSInteger type,BOOL isStop) {
                if (type == 2 && !isStop) {
                    [self.playControView videoPlay];
                }else if (type == 2 && isStop){
                    [self.playControView videoPause];
                    [self stopGif];
                    [self.playControView hideFlowBtnOrPlayBtnOrRepeatBtn:2];
                    [self stopPlayVideo];
                }
            }];
        }
    }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
        if (self.player.currentPlaybackTime > 0.0 && ![self.player isPlaying] && !self.playControView.isPilotPattern) {
            [self.playControView videoPlay];
        }else{
            [self changeCurrentplayerItemWithPlayVideoModel:self.playVideoModel];
        }
    }
}


-(void)applicationBecomeActive{
    if(![self isShowingOnKeyWindow])return;
    [self.playControView addDeviceOrientation];
    if(self.type == 3 || self.type == 5){
        [self changeCurrentplayerItemWithPlayVideoModel:self.playVideoModel];
        return;
    }
    if ([self isShowingOnKeyWindow]) {
        if (![self.player isPlaying]){
            if (self.playControView.videoAuthentication.authenticationType == 1 && [self.playControView.videoAuthentication judgeLoactionJurisdiction]) {
                [self.playControView videoFirstPlay];
            }else{
                if (self.player) {
                    [self.playControView videoPlay];
                }else{
                    [self changeCurrentplayerItemWithPlayVideoModel:self.playVideoModel];
                }
            }
        }
    }else{
        if (self.player) {
            [self.playControView videoStop];
        }
    }
}
-(void)applicationEnterBackground{
    if(![self isShowingOnKeyWindow])return;
    [self.playControView removeDeviceOrientation];
    if(self.type == 3 || self.type == 5){
        //移除当前player的监听
        self.playControView.link.paused = true;
        [self.player shutdown];
        [self.player.view removeFromSuperview];
        self.player = nil;
        return;
    }
    if(self.player.currentPlaybackTime > 0.0){
        [self.playControView videoPause];
    }else{
        self.playControView.link.paused = true;
        [self.player shutdown];
        [self.player.view removeFromSuperview];
        self.player = nil;
    }
}

-(void)setupUI{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWordSatus:) name:NetworkReachabilityStatus object:nil];
    // app从后台进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    self.backgroundColor = [UIColor blackColor];
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
    
    //关闭播放器缓冲
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[self.url absoluteString]] withOptions:options];
    _player.scalingMode = IJKMPMovieScalingModeAspectFit;
    UIView *playerview = [self.player view];
    [self addSubview:playerview];
    [self insertSubview:playerview atIndex:0];
    [self addSubview:self.playControView];
    
    //添加自定义的Button到视频画面上 用于手势控制相关
    
    _button = [[LZHButton alloc]init];
    _button.touchDelegate = self;
    [self addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playControView.topContainerView.mas_bottom);
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self.playControView.bottomContainerView.mas_top);
    }];
    ///把控制层的锁屏按钮放到playView
    [self addSubview:self.playControView.lockScreenBtn];
    ///锁屏按钮
    [self.playControView.lockScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if(kiPhoneX){
            make.left.equalTo(@34);
        }else{
            make.left.equalTo(@10);
        }
        make.width.height.equalTo(@(50));
        make.centerY.equalTo(self.mas_centerY);
    }];
    ///中间控件
    [self addSubview:self.playControView.replayCenterBtn];
    [self addSubview:self.playControView.flowPlayCenterBtn];
    ///中间按钮
    [self.playControView.replayCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.centerX.centerY.equalTo(self);
    }];
    [self.playControView.flowPlayCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(100);
        make.centerX.centerY.equalTo(self);
    }];

    ///电视云
    [self addSubview:self.playControView.televisionCloudView];
    [self.playControView.televisionCloudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    
    //添加遮盖
    [self addSubview:self.coverBtn];
    
    //添加gif
    [self addSubview:self.gifView];
    [self addSubview:self.gifLoadingView];
    
    [self  setConstraint];
    
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
    [self addGestureRecognizer:self.doubleTap];

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
    if(self.playControView.isPilotPattern)return;
    if (self.playControView.isRotate && self.playControView.lockScreenBtn.isSelected) {
        [self.playControView stopTimerVideoTool:3];
    }else{
        if (self.playControView.bottomContainerView.alpha == 0.0) {
            [self.playControView stopTimerVideoTool:3];
            [self.playControView startTimerVideoTool];
        }else{
            [self.playControView stopTimerVideoTool:3];
        }
    }
}
/**
 *  双击播放/暂停
 *
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture{
    if(self.playControView.isPilotPattern)return;
    if ([self.player isPlaying]) {
        [self.playControView videoPause];
    }else{
        if (![self.player isPlaying]) {
            [self.playControView videoPlay];
        }
    }
}
//切换当前播放的内容
- (void)changeCurrentplayerItemWithPlayVideoModel:(PVPlayVideoModel*)playVideoModel{
    self.playVideoModel = playVideoModel;
    self.playControView.playVideoModel = playVideoModel;
    self.type = playVideoModel.type;
    self.playControView.type = playVideoModel.type;
    //移除当前player的监听
    self.playControView.link.paused = true;
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
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:playVideoModel.url withOptions:options];
    self.playControView.player = self.player;
    UIView *playerView = [self.player view];
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:playerView];
    [self insertSubview:playerView atIndex:0];
    _player.scalingMode = IJKMPMovieScalingModeAspectFit;
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];

    [self installMovieNotificationObservers];
    self.playControView.playBtn.hidden = true;
    self.playControView.pauseBtn.hidden = false;
    [self.playControView hideFlowBtnOrPlayBtnOrRepeatBtn:4];
    self.playControView.videoDistrict = self.videoDistrict;
    self.playControView.currentTimeLabel.text = @"00:00";
    self.playControView.totalTimeLabel.text = @"00:00";
    self.playControView.videoSlider.value = 0;
    if (![self.player isPlaying]) {
        if (self.type != 3 && self.type < 5) {
            self.playControView.isPilotPattern = false ;
        }
        if(self.type == 3){
            self.playControView.videoSlider.hidden = true;
            self.playControView.currentTimeLabel.hidden = true;
            self.playControView.totalTimeLabel.hidden =true;
            [self.playControView stopTime];
        }else{
            self.playControView.videoSlider.hidden = false;
            self.playControView.currentTimeLabel.hidden = false;
            self.playControView.totalTimeLabel.hidden = false;
            if (!self.playControView.link) {
                [self.playControView startTime];
            }
        }
        [self.playControView closeViewUserInteractionEnabled];
        [self.playControView videoFirstPlay];
        if (self.type != 3) {
            [self.playControView startTimerVideoTool];
        }
    }
    //由暂停状态切换时候 开启定时器，将暂停按钮状态设置为播放状态
    self.playControView.link.paused = NO;
    self.playControView.player = self.player;
}

#pragma mark - 控制层的播放状态的代理以及全屏************************************
-(void)startPlayVideo{
    if (self.playControView.lockScreenBtn.selected && self.playControView.isRotate) {
        return;
    }
    self.singleTap.enabled = self.doubleTap.enabled = true;
    self.button.hidden = false;
}
-(void)pausePlayVideo{
    self.singleTap.enabled = true;
    if (self.playControView.lockScreenBtn.selected && self.playControView.isRotate) {
        self.doubleTap.enabled = false;
        self.button.hidden = true;
    }else{
        self.doubleTap.enabled = true;
        self.button.hidden = false;
    }
}
-(void)stopPlayVideo{
    self.button.hidden = true;
    self.singleTap.enabled = self.doubleTap.enabled = false;
}
-(void)lockScreen:(BOOL)isLock{
    if (self.player) {
        self.button.hidden = isLock;
    }
}
-(void)pauseFirstPlayVideo{
    [self.gifView stopFirstGif];
}
#pragma mark - 自定义Button的代理************************************
#pragma mark - 开始触摸
/*************************************************************************/
- (void)touchesBeganWithPoint:(CGPoint)point {
    if (self.playControView.isRotate && self.playControView.lockScreenBtn.isSelected) return;
    //记录首次触摸坐标
    self.startPoint = point;
    //检测用户是触摸屏幕的左边还是右边，以此判断用户是要调节音量还是亮度，左边是亮度，右边是音量
    if (self.startPoint.x <= self.button.frame.size.width / 2.0) {
        //亮度
        NSLog(@"亮度");
        
    } else {
        //音/量
        NSLog(@"音量");
    }
    //方向置为无
    self.direction = DirectionNone;
    //记录当前视频播放的进度
    NSTimeInterval current = self.player.currentPlaybackTime;
    NSTimeInterval total = self.player.duration;
    self.startVideoRate = current/total;
    
}
#pragma mark - 结束触摸
- (void)touchesEndWithPoint:(CGPoint)point {
    if (self.playControView.isRotate && self.playControView.lockScreenBtn.isSelected) return;
    CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    if ((panPoint.x >= -5 && panPoint.x <= 5) && (panPoint.y >= -5 && panPoint.y <= 5)) {
        
        [self handleSingleTap:self.singleTap];
        return;
    }
    
    if (self.direction == DirectionLeftOrRight) {
        if(self.type == 3)return;
        self.fastView.hidden = true;
        if (self.player.isPreparedToPlay) {
            self.playControView.currentTimeLabel.text = [self.playControView stringWithTime:self.player.duration*self.currentRate];
            self.player.currentPlaybackTime = self.player.duration*self.currentRate;
            [self.playControView videoPlay];
            self.playControView.link.paused = NO;
            NSLog(@"设置播放时间");
        }
    }
    else if (self.direction == DirectionUpOrDown){
        
    }
}
#pragma mark - 拖动
- (void)touchesMoveWithPoint:(CGPoint)point {
    if (self.playControView.isRotate && self.playControView.lockScreenBtn.isSelected) return;
    
    //手指在Button上移动的距离
    CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    //用户滑动的方向
    if (self.direction == DirectionNone) {
        if (panPoint.x >= 30 || panPoint.x <= -30) {
            //进度
            self.direction = DirectionLeftOrRight;
        } else if (panPoint.y >= 30 || panPoint.y <= -30) {
            //音量和亮度
            self.direction = DirectionUpOrDown;
        }
    }
    
    if (self.direction == DirectionNone) {
        return;
    } else if (self.direction == DirectionUpOrDown) {
        //音量和亮度
        if (self.startPoint.x <= self.button.frame.size.width / 2.0) {
            CGFloat currentLight = [[UIScreen mainScreen] brightness];
            //调节亮度
            if (panPoint.y < 0) {
                //增加亮度
                if(currentLight < 1.0){
                    currentLight = currentLight+0.01;
                }
            } else {
                //减少亮度
                if(currentLight > 0.0){
                    currentLight = currentLight-0.01;
                }
            }
            [[UIScreen mainScreen] setBrightness: currentLight];
            
        } else {
            //音量
            CGFloat currentLight = [[AVAudioSession sharedInstance] outputVolume];
            NSLog(@"currentLigh11111 = %f",currentLight);

            
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
            
            NSLog(@"currentLight222222 = %f",currentLight);
            
            
            self.volumeViewSlider.value = currentLight;
        }
    } else if (self.direction == DirectionLeftOrRight ) {
        if(self.type == 3)return;
        self.playControView.link.paused = true;
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
            NSLog(@"快进");
        }else if (rate  < self.currentRate){
            self.fastView.fastImageView.image = [UIImage imageNamed:@"ZFPlayer_fast_backward"];
            NSLog(@"快退");
        }
        self.fastView.fastProgressView.progress = rate;
        self.playControView.videoSlider.value = rate;
        self.playControView.currentTimeLabel.text = [self.playControView stringWithTime:self.player.duration*rate];
        self.currentRate = rate;
        NSString *totalTimeStr  = [self.playControView stringWithTime:self.player.duration];
        NSString *draggedTime   = [self.playControView stringWithTime:self.player.duration*rate];
        NSString *timeStr        = [NSString stringWithFormat:@"%@ | %@", draggedTime, totalTimeStr];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:timeStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor sc_colorWithHex:0x64C4F5]
                              range:NSMakeRange(0, draggedTime.length)];
        self.fastView.fastTimeLabel.attributedText        = attributedStr;
        self.fastView.hidden = false;
        
    }
}

-(void)setConstraint{
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    
    [self.playControView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.right.equalTo(self);
    }];
    
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
        make.center.equalTo(self);
    }];
    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.playControView.topContainerView.mas_bottom);
    }];
    
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.gifLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@150);
    }];
}
-(PlayControView *)playControView{
    if (!_playControView) {
        _playControView = [[PlayControView alloc]  initWithType:self.type];
        _playControView.playVideoModel = self.playVideoModel;
        _playControView.backgroundColor = [UIColor clearColor];
        _playControView.player = self.player;
        _playControView.delegate = self.vc;
        _playControView.playViewDelegate = self;
        _playControView.videoDistrict = self.videoDistrict;
        __weak typeof(&*self) weakSelf = self;
        _playControView.isLockBlock = ^(BOOL isLock){
            if (isLock) {
                weakSelf.doubleTap.enabled=false;
            }else{
                weakSelf.doubleTap.enabled=true;
            }
        };
    }
    return _playControView;
}
-(UISlider *)volumeViewSlider{
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
        [self addSubview:_fastView];
    }
    return _fastView;
}
-(UIButton *)coverBtn{
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
-(void)setIsCopyRight:(BOOL)isCopyRight{
    _isCopyRight = isCopyRight;
    if (isCopyRight) {
        self.playControView.link.paused = true;
        [self.player shutdown];
        [self.player.view removeFromSuperview];
        self.player = nil;
        [self removeMovieNotificationObservers];
        [self.playControView stopTimerVideoTool:8];
        self.coverBtn.hidden = false;
    }else{
        self.coverBtn.hidden = true;
    }
}

-(PVGifView *)gifView{
    if (!_gifView) {
        _gifView = [[PVGifView alloc]  initType:self.type];
        if (self.type > 2 && !self.playControView.isRotate) {
            _gifView.backBtn.hidden = true;
        }else{
            _gifView.backBtn.hidden = false;
        }
        PV(pv)
        [_gifView setPVGifViewCallBlock:^{
            if (pv.playControView.isRotate) {
                [pv.playControView screenBtnClicked];
            }else{
                if (pv.playControView.delegate && [pv.playControView.delegate respondsToSelector:@selector(backToBeforeVC)]) {
                    [pv.playControView.delegate backToBeforeVC];
                }
            }
        }];
    }
    return _gifView;
}
-(PVGifView *)gifLoadingView{
    if (!_gifLoadingView) {
        _gifLoadingView = [[PVGifView alloc]  initType:10];
        [_gifLoadingView stopFirstGif];
    }
    return _gifLoadingView;
}
-(void)stopGif{
    [self.gifView stopFirstGif];
    [self.gifLoadingView stopFirstGif];
}
-(PVVideoPilotView *)videoPilotView{
    if (!_videoPilotView) {
        _videoPilotView = [[PVVideoPilotView alloc]  init];
        _videoPilotView.hidden = true;
    }
    return _videoPilotView;
}
-(void)startGifAnimate{
    if (self.player.currentPlaybackTime > 0) {
        [self.gifLoadingView startFirstGif];
    }else{
        [self.gifView startFirstGif];
    }
}
-(void)stopGifAnimate{
    [self stopGif];
    [self stopPlayVideo];
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
        if (self.continuePlayVideoStatus.integerValue == 1) {
            self.continuePlayVideoStatus = @"0";
            [self.playControView videoPause];
           // self.playControView.player.currentPlaybackTime = self.playVideoModel.;
            [self.playControView videoPlay];
            //31131
            self.playControView.link.paused = NO;
            self.playControView.totalTime = self.player.duration;
            [self stopGif];
            [self.playControView openViewUserInteractionEnabled];
        }else{
            self.playControView.link.paused = NO;
            self.playControView.totalTime = self.player.duration;
            [self stopGif];
            [self.playControView openViewUserInteractionEnabled];
        }
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        [self.gifLoadingView  startFirstGif];
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}
- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            [self.playControView videoPlayOver];
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            [self stopGif];
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            [self stopGif];
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}
- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
    switch (_player.playbackState) {
            
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            [self stopGif];
            self.playControView.link.paused = NO;
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            [self stopGif];
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking ", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}
@end
