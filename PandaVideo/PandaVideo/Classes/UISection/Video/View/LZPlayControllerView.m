//
//  LZPlayControllerView.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "LZPlayControllerView.h"
#import "UIView+Extension.h"
#import "PVSlider.h"
#import "PVVideoToolsView.h"
#import "LZHeartFlyView.h"
#import "PVRegionFlowController.h"

@interface LZPlayControllerView()<LZVideoPlayerViewDelegate,PVShowLiveBottomToolsViewDelegate>
{
    CGFloat height;
}


/** 总播放时间 */
@property (nonatomic, strong) UILabel       *totalTimeLabel;
/** 记录上一次的播放时间 */
@property (nonatomic, assign) NSTimeInterval lastTime;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton      *screenBtn;
/** 几秒之后隐藏工具栏的定时器 */
@property (nonatomic, strong) NSTimer       *timer;
/** 锁屏之后隐藏锁屏按钮 */
@property (nonatomic, strong) NSTimer       *lockScreenTimer;
/** 第几秒了 */
@property (nonatomic, assign) NSInteger     count;
/** 返回按钮 */
@property (nonatomic, strong) UIButton      *backBtn;
/** 更多按钮 */
@property (nonatomic, strong) UIButton      *moreBtn;
/** 分享按钮-横屏分享按钮 */
@property (nonatomic, strong) UIButton      *shareBtn;
/** TV按钮 */
@property (nonatomic, strong) UIButton      *televisionBtn;
/** 更新tv的左边约束 */
@property (nonatomic, strong) MASConstraint *teleVersionConstraint;

/** 发弹幕按钮 */
@property (nonatomic, strong) UIButton      *publishBarrageBtn;
/** 高清按钮 */
@property (nonatomic, strong) UIButton      *clarityBtn;
/** 记录上一次的缓冲时间 */
@property (nonatomic, assign) CGFloat       lastBufferTime;
/** 全屏底部工具栏 */
@property (nonatomic, strong) PVVideoToolsView *videoBottomToolsView;
/** 流量提醒弹窗 */
@property (nonatomic, strong) PVRegionFlowController   *regionFlowController;

@end
@implementation LZPlayControllerView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 释放定时器
    [self stopTime];
}

- (void)hiddenMoreButton{
    self.moreBtn.hidden = YES;
}
-(instancetype)initWithType:(NSInteger)type{
    self = [super init];
    if (self) {
        
        // 监测设备方向
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [kNotificationCenter addObserver:self
                                selector:@selector(deviceOrientationDidChange:)   name:UIDeviceOrientationDidChangeNotification
                                  object:nil];
        height = 50;
        self.type = type;
        [self initData];
        [self initView];
    }
    return self;
}

/**
 *  屏幕方向发生变化会调用这里
 */
-(void)deviceOrientationDidChange:(NSObject*)sender{
    if (self.lockScreenBtn.selected || ![self isShowingOnKeyWindow])return;
    UIDevice* device = [sender valueForKey:@"object"];
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if ((int)currentOrientation == device.orientation) {
        return;
    }
    
    if (device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight || device.orientation == UIDeviceOrientationPortrait){
        [self stopTimerVideoTool:2];
        if ([self.delegate respondsToSelector:@selector(fullScreenWithPlayerViews:isOrientations:)]) {
            if (self.type == 1 && [self isPlayOver]) {
                self.lockScreenBtn.hidden = true;
            }
            if (device.orientation == UIDeviceOrientationPortrait) {
                self.lockScreenBtn.hidden = true;
                self.isRotate = false;
            }else{
                self.lockScreenBtn.hidden = false;
                self.isRotate = true;
            }
            //更新约束,控制横竖屏要显示的按钮
            [self updateScreenConStaint];
            [self.delegate fullScreenWithPlayerViews:self isOrientations:device.orientation];
            [self.videoSlider setNeedsDisplay];
        }
    }
}

-(void)initData{
    // 是否全屏
    self.isRotate = false;
    
    self.backgroundColor = [UIColor redColor];
}

/** 设置UI */
-(void) initView{
    /** 底部容器 */
    [self addSubview:self.bottomContainerView];
    /** 播放 */
    [self.bottomContainerView addSubview:self.playBtn];
    /** 暂停 */
    [self.bottomContainerView addSubview:self.pauseBtn];

    /** 当前时间 */
    [self.bottomContainerView addSubview:self.currentTimeLabel];
    /** 滑块 */
    [self.bottomContainerView addSubview:self.videoSlider];
    /** 总时间 */
    [self.bottomContainerView addSubview:self.totalTimeLabel];
    /** 全屏按钮 */
    [self.bottomContainerView addSubview:self.screenBtn];
    
    /** 顶部容器 */
    [self addSubview:self.topContainerView];
    /** 更多按钮 */
    [self.topContainerView addSubview:self.moreBtn];
    /** 分享按钮 */
    [self.topContainerView addSubview:self.shareBtn];
    /** 电视按钮 */
    [self.topContainerView addSubview:self.televisionBtn];
    /** 清晰度切换按钮 */
    [self.topContainerView addSubview:self.clarityBtn];
    /** 显示弹幕 */
    [self.topContainerView addSubview:self.barrageBtn];
    /** 发送弹幕 */
    [self.topContainerView addSubview:self.publishBarrageBtn];
    /** 返回按钮 */
    [self addSubview:self.backBtn];
    /** 视频标题 */
    [self.topContainerView addSubview:self.titleNameLabel];
    YYLog(@"type - %ld",(long)self.type);

    if (self.type == 1) { // 视频回放
        [self startTime];
    }else if (self.type == 2) { // 直播
        
        [self hideVideoLayout]; // 隐藏
        [self.bottomContainerView addSubview:self.videoBottomToolsView];
    }
    // 设置约束
    [self setConstraint];
    self.lockScreenBtn.hidden = YES;
}

/** 直播竖屏隐藏视频的相关按钮 */
- (void) hideVideoLayout{
    self.playBtn.hidden = YES;
    self.pauseBtn.hidden = YES;
    self.currentTimeLabel.hidden = YES;
    self.videoSlider.hidden = YES;
    self.totalTimeLabel.hidden = YES;
    
    self.lockScreenBtn.hidden = YES;
}


// 设置界面约束
-(void)setConstraint{
    
    ///顶部工具栏
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(height));
    }];
    // 返回按钮
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(self).offset(0);
        make.width.height.equalTo(@70);
    }];
    // 更多按钮
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topContainerView).offset(0);
        make.top.equalTo(self.topContainerView).offset(8);
        make.width.height.equalTo(self.topContainerView.mas_height);
    }];
    // 分享按钮
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topContainerView).offset(0);
        make.top.equalTo(self.topContainerView).offset(8);
        make.width.height.equalTo(self.topContainerView.mas_height);
    }];
    // 电视按钮
    [self.televisionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.mas_left).offset(5);
        self.teleVersionConstraint = make.top.equalTo(self.topContainerView).offset(8);
        make.width.height.equalTo(self.topContainerView.mas_height);
    }];
    // 清晰度按钮
    [self.clarityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.mas_left).offset(10);
        make.top.equalTo(self.topContainerView).offset(8);
        make.width.height.equalTo(self.topContainerView.mas_height);
    }];
    // 视频标题
    [self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(-20);
        make.centerY.equalTo(self.backBtn).offset(3);
        make.right.equalTo(self.clarityBtn.mas_left).offset(-20);
    }];
    // 弹幕按钮
    [self.barrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.clarityBtn.mas_left).offset(5);
        make.top.equalTo(self.topContainerView).offset(8);
        make.width.height.equalTo(self.topContainerView.mas_height);
    }];
    // 发送弹幕按钮
    [self.publishBarrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.barrageBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.topContainerView).offset(8);
        make.width.equalTo(@50);
        make.height.equalTo(@(20));
    }];

    ///底部工具栏
    [self.bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(height));
    }];
    
    if (self.type == LiveInteractiveViewTypeLivePlayer) { // 直播更新此约束
        [self.videoBottomToolsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(@(50));
        }];
    }
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomContainerView);
        make.width.height.equalTo(@(height));
    }];
    [self.pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomContainerView);
        make.width.height.equalTo(@(height));
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(-5);
        make.bottom.equalTo(self.bottomContainerView).offset(0);
        make.height.equalTo(@(height));
    }];
    [self.screenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.bottomContainerView);
        make.width.height.equalTo(@(height));
    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.screenBtn.mas_left).offset(3);
        make.bottom.equalTo(self.bottomContainerView).offset(0);
        make.height.equalTo(@(height));
    }];
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(5);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-10);
        make.bottom.equalTo(self.bottomContainerView).offset(0);
        make.height.equalTo(@(height));
    }];    
}

/** 底部工具栏 */
-(PVVideoToolsView *)videoBottomToolsView{
    if (!_videoBottomToolsView) {
        _videoBottomToolsView = [PVVideoToolsView bottomViewHorizontallyScreen];
//        _videoBottomToolsView.backgroundColor = [UIColor clearColor];
        _videoBottomToolsView.hidden = YES;
    }
    return _videoBottomToolsView;
}

-(void)startTime{
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(upadte)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)stopTime{
    [self.link invalidate];
    self.link = nil;
}

-(void)upadte{
    NSTimeInterval current  = self.player.currentPlaybackTime;
    NSTimeInterval total    = self.player.duration;
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
    if (current != self.lastTime) {
        // 更新播放时间
        self.currentTimeLabel.text = [self stringWithTime:current];
    }
    self.videoSlider.value  = current/total;
    self.lastTime           = current;
    self.lastPlayerTime     = self.lastTime;
    
    CGFloat bufferTime = self.player.playableDuration;
    if (current > bufferTime) {
        bufferTime = current + 0.01;
    }
    CGFloat tempBufferTime = bufferTime/total;
    if (tempBufferTime <= self.lastBufferTime) return;
    self.videoSlider.middleValue =  tempBufferTime;
    self.lastBufferTime = tempBufferTime;
}

/** 当前视频播放完毕 */
-(void)videoPlayOver{
    [self.link setPaused:true];
    self.currentTimeLabel.text = self.totalTimeLabel.text;
    if (self.type == 1 || self.type == 2) {//单集
        [self stopTimerVideoTool:4];
        [self videoPause];
        if (self.lockScreenBtn.selected) {
            [self lockScreenBtnClicked];
        }
        self.replayCenterBtn.hidden = false;
        self.lockScreenBtn.hidden = true;
    }else if (self.type == 3 || self.type == 4){//多集,播放下一集
        YYLog(@"自动播放下一集");
    }
}

-(UILabel *)titleNameLabel{
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc]  init];
        _titleNameLabel.textColor = [UIColor sc_colorWithHex:0xF8FBFF];
        _titleNameLabel.font = [UIFont systemFontOfSize:15];
//        _titleNameLabel.text = @"哈哈哈哈哈\n在线人数123";
        _titleNameLabel.numberOfLines = 2;
        //_titleNameLabel.hidden = true;
    }
    return _titleNameLabel;
}
-(void)setVideoTitleName:(NSString *)videoTitleName{
    _videoTitleName = videoTitleName;
    self.titleNameLabel.text = videoTitleName;
}

/** 锁屏按钮 */
-(UIButton *)lockScreenBtn{
    if (!_lockScreenBtn) {
        _lockScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockScreenBtn setImage:kGetImage(@"live_btn_unlock") forState:UIControlStateNormal];
        [_lockScreenBtn setImage:kGetImage(@"live_btn_locked") forState:UIControlStateSelected];
        [_lockScreenBtn addTarget:self action:@selector(lockScreenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _lockScreenBtn.hidden = true;
    }
    return _lockScreenBtn;
}

/** 锁屏按钮点击事件 */
-(void)lockScreenBtnClicked{
    self.lockScreenBtn.selected = !self.lockScreenBtn.selected;
    if (self.lockScreenBtn.selected) {
        [self stopTimerVideoTool:5];
        [self startLockScreenTimer];
    }else{
        [self stopTimerVideoTool:5];
        [self startTimerVideoTool];
    }
    [self islock];
    if ([self.playerViewDelegate respondsToSelector:@selector(lockScreen:)]) {
        [self.playerViewDelegate lockScreen:self.lockScreenBtn.selected];
    }
}

/** 顶部容器 */
-(UIView *)topContainerView{
    if (!_topContainerView) {
        _topContainerView = [[UIView alloc] init];
        _topContainerView.backgroundColor = [UIColor clearColor];
        UIImageView* bgImageView = [[UIImageView alloc] init];
        bgImageView.image = [UIImage imageNamed:@"live_bg_up"];
        [_topContainerView addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(_topContainerView);
        }];
    }
    return _topContainerView;
}

/** 左上角返回按钮 */
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"all_btn_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked)
           forControlEvents:UIControlEventTouchUpInside];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return _backBtn;
}

/** 返回按钮点击事件 */ 
-(void)backBtnClicked{
    if (self.isRotate) {
        [self screenBtnClicked];
        YYLog(@"全屏返回");
    }else if ([self.delegate respondsToSelector:@selector(backToBeforeVC)]){
        [self.delegate backToBeforeVC];
    }
}

/** 更多按钮 */
-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.hidden = true;
        [_moreBtn setImage:[UIImage imageNamed:@"live_btn_more"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

/** 更多按钮点击事件代理*/
-(void)moreBtnClicked{
    
    if ([self.delegate respondsToSelector:@selector(delegateMoreBtnClicked)]) {
        [self.delegate delegateMoreBtnClicked];
        YYLog(@"更多");
    }
}

/** 分享按钮-横屏分享按钮 */
-(UIButton *)shareBtn{

    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"live_btn_share"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

/** 分享按钮点击事件 */
-(void)shareBtnClicked{
    if (self.isRotate) {
        if ([self.delegate respondsToSelector:@selector(delegateShareBtnClicked)]) {
            [self.delegate delegateShareBtnClicked];
            YYLog(@"横屏分享");
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(delegateVShareBtnClicked)]) {
            [self.delegate delegateVShareBtnClicked];
            YYLog(@"竖屏分享");
        }
    }
}


/** TV按钮 */
-(UIButton *)televisionBtn{
    if (!_televisionBtn) {
        _televisionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_televisionBtn setImage:[UIImage imageNamed:@"live_btn_project"] forState:UIControlStateNormal];
        [_televisionBtn addTarget:self action:@selector(televisionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _televisionBtn.hidden = true;
    }
    return _televisionBtn;
}

/** TV按钮点击事件*/
-(void)televisionBtnClicked{
    if ([self.delegate respondsToSelector:@selector(delegateTeleversionBtnClicked)]) {
        [self.delegate delegateTeleversionBtnClicked];
        YYLog(@"电视");
    }
}

/** 弹幕按钮 */
-(UIButton *)barrageBtn{
    if (!_barrageBtn) {
        _barrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _barrageBtn.hidden = true;
        [_barrageBtn setImage:[UIImage imageNamed:@"live_btn_danmu_off"] forState:UIControlStateNormal];
        [_barrageBtn setImage:[UIImage imageNamed:@"live_btn_danmu_on"] forState:UIControlStateSelected];
        [_barrageBtn addTarget:self action:@selector(barrageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrageBtn;
}

/** 弹幕按钮点击事件 */
-(void)barrageBtnClicked{
    self.barrageBtn.selected = !self.barrageBtn.selected;
    if ([self.delegate respondsToSelector:@selector(delegateBarrageBtnClicked:)]) {
        [self.delegate delegateBarrageBtnClicked:self.barrageBtn];
        YYLog(@"弹幕");
    }
}

/** 发弹幕按钮 */
-(UIButton *)publishBarrageBtn{
    if (!_publishBarrageBtn) {
        _publishBarrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishBarrageBtn.hidden = true;
        [_publishBarrageBtn addTarget:self action:@selector(publishBarrageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_publishBarrageBtn setTitle:@"发弹幕" forState:UIControlStateNormal];
        _publishBarrageBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _publishBarrageBtn.layer.cornerRadius = 10;
        _publishBarrageBtn.layer.borderWidth = 1.0f;
        _publishBarrageBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _publishBarrageBtn;
}

/** 发弹幕按钮点击事件 */
-(void)publishBarrageBtnClicked{
    if ([self.delegate respondsToSelector:@selector(delegatePublishBarrageBtnClicked)]) {
        [self.delegate delegatePublishBarrageBtnClicked];
        YYLog(@"发弹幕");
    }
}

/** 底部容器View */
-(UIView *)bottomContainerView{
    if (!_bottomContainerView) {
        _bottomContainerView = [[UIView alloc] init];
        _bottomContainerView.backgroundColor = [UIColor clearColor];
        UIImageView* bgImageView = [[UIImageView alloc] init];
        bgImageView.image = [UIImage imageNamed:@"live_bg_down"];
        [_bottomContainerView addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(_bottomContainerView);
        }];
    }
    return _bottomContainerView;
}

/** 播放按钮(左下角) */
-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"live_btn_play"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.hidden = true;
    }
    return _playBtn;
}

/** 继续播放(左下角) */
-(void)playBtnClicked{
    YYLog(@"点击播放按钮");
    self.pauseBtn.hidden = false;
    self.playBtn.hidden = true;
    if (![self.player isPlaying]) {
        [self videoPlay];
        [self startTimerVideoTool];
    }
}

/** 暂停按钮 */
-(UIButton *)pauseBtn{
    if (!_pauseBtn) {
        _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseBtn setImage:[UIImage imageNamed:@"live_btn_pause"] forState:UIControlStateNormal];
        [_pauseBtn addTarget:self action:@selector(pauseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseBtn;
}

/** 暂停播放 */
-(void)pauseBtnClicked{
    YYLog(@"点击暂停按钮");
    if (self.type == 1) {
        self.pauseBtn.hidden = true;
        self.playBtn.hidden = false;
    }
   
    [self videoPause];
}

/** 全屏按钮 */
-(UIButton *)screenBtn{
    if (!_screenBtn) {
        _screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_screenBtn setImage:[UIImage imageNamed:@"find_btn_fullscreen"] forState:UIControlStateNormal];
        [_screenBtn addTarget:self action:@selector(screenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenBtn;
}
/** 全屏按钮事件(旋转) */
-(void)screenBtnClicked{
    [self stopTimerVideoTool:2];
    if ([self.delegate respondsToSelector:@selector(fullScreenWithPlayerViews:isOrientations:)]) {
        if (self.type == 1 && [self isPlayOver]) {
            self.lockScreenBtn.hidden = true;
        }else{
            self.lockScreenBtn.hidden = self.isRotate;
        }
        self.isRotate = !self.isRotate;
        
        //更新约束,控制横竖屏要显示的按钮
        [self updateScreenConStaint];
        
        UIDeviceOrientation orientation = UIDeviceOrientationPortrait;
        if (self.isRotate) {
            orientation = UIDeviceOrientationLandscapeLeft;
        }
        [self.delegate fullScreenWithPlayerViews:self isOrientations:orientation];
        [self.videoSlider setNeedsDisplay];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:false];
}

/** 清晰度切换 */
- (UIButton *) clarityBtn{
    if (!_clarityBtn) {
        _clarityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clarityBtn.hidden = true;
        [_clarityBtn setTitle:@"标清" forState:UIControlStateNormal];
        _clarityBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _clarityBtn.titleLabel.textColor = [UIColor whiteColor];
        [_clarityBtn addTarget:self action:@selector(definitionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clarityBtn;
}

/** 清晰度按钮事件 */
-(void)definitionBtnClicked{
    if (self.type != 1) return;
    if ([self.delegate respondsToSelector:@selector(delegateDefinitionBtnClicked)]) {
        [self.delegate delegateDefinitionBtnClicked];
        YYLog(@"清晰度选择");
    }
}


/** 全屏切换 */
-(void)updateScreenConStaint{
    if(self.isRotate){//全屏
    
        self.videoBottomToolsView.hidden = NO;
        self.backBtn.hidden = false;
        [self.televisionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.shareBtn.mas_left).offset(5);
        }];
        self.moreBtn.hidden = true;
        self.publishBarrageBtn.hidden = self.barrageBtn.hidden = self.shareBtn.hidden = false;
        _clarityBtn.hidden = false;

        self.screenBtn.hidden = true;
        if (self.type == LiveInteractiveViewTypeLivePlayer) { // 直播
            [self.shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.moreBtn.mas_left).offset(55);
            }];
            // 隐藏发送弹幕按钮和弹幕按钮开关
            self.publishBarrageBtn.hidden = self.barrageBtn.hidden = true;
        }else if (self.type == LiveInteractiveViewTypeVideoPlayer) { // 回放(预告)
            [self.screenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bottomContainerView.mas_right).offset(40);
            }];
            [self.currentTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.pauseBtn.mas_right).offset(-5);
            }];
            [self.shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.moreBtn).offset(40);
            }];
            self.publishBarrageBtn.hidden = self.barrageBtn.hidden = YES;
        }
        self.lockScreenBtn.alpha = 0.0;
    }else{//竖屏
        if(self.barrageBtn.selected){
            [self barrageBtnClicked];
        }
        self.backBtn.hidden = (self.type > 2) ? true : false;
        self.videoBottomToolsView.hidden = YES;
        self.clarityBtn.hidden = true;
        self.moreBtn.hidden = true;
        self.screenBtn.hidden = false;
        // 分享按钮
        [self.shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.moreBtn.mas_left).offset(50);
            make.top.equalTo(self.topContainerView).offset(8);
            make.width.height.equalTo(self.topContainerView.mas_height);
        }];
        
        if(self.type == LiveInteractiveViewTypeVideoPlayer){    // 视频播放
            // 更新全屏按钮约束
            [self.screenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bottomContainerView.mas_right).offset(0);
            }];
        }else if(self.type == LiveInteractiveViewTypeLivePlayer){   // 直播
            
            // 更新全屏按钮约束
            [self.screenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bottomContainerView).offset(0);
            }];
            [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.screenBtn.mas_left).offset(0);
            }];
        }
    }
}

/** 当前时间 */
-(UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:13];
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

/** 设置总时长 */
-(void)setTotalTime:(CGFloat)totalTime{
    if (self.type == 3)return;
    _totalTime = totalTime;
    // duration 总时长
    self.totalTimeLabel.text = [self stringWithTime:totalTime];
}

/** 总时长Label */
-(UILabel *)totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]  init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:13];
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

/** 进度滑块 */
- (PVSlider *)videoSlider{
    if (!_videoSlider) {
        _videoSlider = [[PVSlider alloc] init];
        _videoSlider.middleValue = 0.0;
        _videoSlider.thumbTintColor = [UIColor magentaColor];
        _videoSlider.minimumTrackTintColor = [UIColor sc_colorWithHex:0x64C4F5];
        _videoSlider.middleTrackTintColor = [UIColor sc_colorWithHex:0x808080];
        _videoSlider.maximumTrackTintColor = [UIColor blackColor];
        [_videoSlider setThumbImage:[UIImage imageNamed:@"live_control_progress"] forState:UIControlStateNormal];
        [_videoSlider setThumbImage:[UIImage imageNamed:@"live_control_progress"] forState:UIControlStateHighlighted];
        if (self.type != 2) {//直播不需要添加手势
            UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
            [_videoSlider addGestureRecognizer:sliderTap];
            
            UIPanGestureRecognizer*  panGesture = [[UIPanGestureRecognizer alloc]  initWithTarget:self action:@selector(progressSliderValueChanged:)];
            [_videoSlider addGestureRecognizer:panGesture];
        }else{
            _videoSlider.userInteractionEnabled = false;
        }
    }
    return _videoSlider;
}
/** 视频的情况下 可以进行重播点击*/
- (SCButton *)replayCenterBtn{
    if (!_replayCenterBtn) {
        _replayCenterBtn = [SCButton customButtonWithTitlt:@"重播" imageNolmalString:@"find_btn_replay" imageSelectedString:@"find_btn_replay"];
        _replayCenterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_replayCenterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_replayCenterBtn setImage:[UIImage imageNamed:@"find_btn_replay"] forState:UIControlStateNormal];
        [_replayCenterBtn setTitle:@"重播" forState:UIControlStateNormal];
        [_replayCenterBtn addTarget:self action:@selector(replayCenterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _replayCenterBtn.hidden = true;
    }
    return _replayCenterBtn;
}

/** 视频的情况下 可以进行重播点击*/
-(void)replayCenterBtnClick{
    //单集就进行重播
    if (self.type == 1) {
        self.pauseBtn.hidden = false;
        self.playBtn.hidden = true;
    }
    if (![self.player isPlaying]) {
        [self videoPlay];
        [self startTimerVideoTool];
    }
    YYLog(@"重播");
}

/** 视频播放 */
- (void)playeCenterBtnClick{
    if (![self.player isPlaying]) {
        [self videoPlay];
        [self startTimerVideoTool];
    }
}

/** 流量播放按钮 */
-(UIButton *)flowPlayCenterBtn{
    if (!_flowPlayCenterBtn) {
        _flowPlayCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flowPlayCenterBtn.backgroundColor = [UIColor sc_colorWithHex:0x00BFF5];
        _flowPlayCenterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_flowPlayCenterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_flowPlayCenterBtn setImage:[UIImage imageNamed:@"live_btn_play"] forState:UIControlStateNormal];
        [_flowPlayCenterBtn setTitle:@" 流量播放" forState:UIControlStateNormal];
        [_flowPlayCenterBtn addTarget:self action:@selector(flowPlayCenterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _flowPlayCenterBtn.clipsToBounds = true;
        _flowPlayCenterBtn.layer.cornerRadius = 18.0f;
        _flowPlayCenterBtn.hidden = true;
    }
    return _flowPlayCenterBtn;
}

/** 流量播放按钮点击事件 */
-(void)flowPlayCenterBtnClick{
    if (self.player.currentPlaybackTime > 0) {
        [self videoPlay];
    }else{
        [self videoprepareToPlay];
    }
}

/** 手势滑动进度并设置播放时间 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap{
    [self stopTimerVideoTool:6];
    UISlider *slider = (UISlider *)tap.view;
    CGPoint point = [tap locationInView:slider];
    CGFloat length = slider.frame.size.width;
    // 视频跳转的value
    CGFloat tapValue = point.x / length;
    self.videoSlider.value = tapValue;
    self.currentTimeLabel.text = [self stringWithTime:self.player.duration*tapValue];
    self.link.paused = true;
    if (self.player.isPreparedToPlay) {
        // 设置当前播放时间
        self.player.currentPlaybackTime = self.player.duration*tapValue;
        [self videoPlay];
        [self startTimerVideoTool];
    }
}

/** 滑块位置 */
-(void)progressSliderValueChanged:(UITapGestureRecognizer *)tap{
    UISlider *slider = (UISlider *)tap.view;
    CGPoint point = [tap locationInView:slider];
    CGFloat length = slider.frame.size.width;
    // 视频跳转的value
    CGFloat tapValue = point.x / length;
    if (tapValue >= 1.0) {
        tapValue = 1.0;
    }else if (tapValue < 0.0){
        tapValue = 0.0;
    }
    self.videoSlider.value = tapValue;
    if (tap.state == UIGestureRecognizerStateBegan ) {
        [self stopTimerVideoTool:6];
        self.link.paused = true;
        self.currentTimeLabel.text = [self stringWithTime:self.player.duration*tapValue];
    }else if (tap.state == UIGestureRecognizerStateChanged){
        self.currentTimeLabel.text = [self stringWithTime:self.player.duration*tapValue];
    }else if (tap.state == UIGestureRecognizerStateEnded){
        if (self.player.isPreparedToPlay) {
            self.currentTimeLabel.text = [self stringWithTime:self.player.duration*tapValue];
            // 设置当前播放时间
            self.player.currentPlaybackTime = self.player.duration*self.videoSlider.value;
            //  [self.gifView startFirstGif];
            [self videoPlay];
            [self startTimerVideoTool];
        }
    }
}


///判断网络情况
-(NSInteger)judgeNetIsWifi{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        return 1;
    }else if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        return 2;
    }else{
        return 3;
    }
}

-(void)setRecordStatus:(AFNetworkReachabilityStatus)recordStatus{
    ///时刻监听到的网络情况
    
    YYLog(@"recordStatus -- %ld",(long)recordStatus);
    _recordStatus = recordStatus;
}

/** 初始播放时候判断当前播放如果为流量则提醒 */
- (void) videoFirstPlayer{
    if (![self.player isPlaying]){
        if ([self judgeNetIsWifi] == 1) {//是wifi，走免费还是试播流程
            [self.regionFlowController dismissViewControllerAnimated:true completion:nil];
            [self videoprepareToPlay];
        }else if ([self judgeNetIsWifi] == 2){//是数据流量,弹对话框
            [self hideFlowBtnOrPlayBtnOrRepeatBtn:2];
            YYLog(@"duration(屏幕的方向)%@",self.isRotate ? @"YES" : @"NO");
            if (!self.isRotate) {
                self.regionFlowController = [PVRegionFlowController presentPVRegionFlowController:@"非WiFi环境，继续播放将消耗您的数据流量,是否继续播放?" type:2];
            }
            
            PV(pv)
            [self.regionFlowController setPVRegionFlowControllerCallBlock:^(NSInteger type, BOOL isStop) {
//                if (type == 2 && !isStop){//2.为数据流量并且继续
////                    pv.authenticationType = 3;
////                    pv.callBlock(type,false);
//                }else if (type == 2 && isStop){//2.为数据流量并且继续
////                    pv.authenticationType = 3;
////                    pv.callBlock(type,true);
//                }
                YYLog(@"type = %ld",type);
                if (type == 2) {
                    [pv videoprepareToPlay];
                }
//                if (type == 2 && !isStop) {
//                    [pv videoprepareToPlay];
//                }else if(type == 2 && isStop){
//                    [pv.playControllerView videoPause];
//                    [pv.playControllerView hideFlowBtnOrPlayBtnOrRepeatBtn:2];
//                    [pv stopPlayVideo];
//                }
            }];
        }else{
            // 没网
            YYLog(@"当前处于没网络");
        }
    }
}

///视频第一次播放
-(void)videoFirstPlay{
    [self videoFirstPlayer];
    [self hideFlowBtnOrPlayBtnOrRepeatBtn:2];
    if ([self.playerViewDelegate respondsToSelector:@selector(stopPlayVideo)]) {
        [self.playerViewDelegate stopPlayVideo];
    }
    
}
-(void)videoprepareToPlay{
    [self hideFlowBtnOrPlayBtnOrRepeatBtn:4];
    if (![self.player isPlaying]) {
        if ([self.playerViewDelegate  respondsToSelector:@selector(startPlayVideo)]) {
            [self.playerViewDelegate startPlayVideo];
        }
        //准备播放
        [self.player prepareToPlay];
        [self startTimerVideoTool];
    }
}


/** 视频播放 */
-(void)videoPlay{
    if ([self.playerViewDelegate  respondsToSelector:@selector(startPlayVideo)]) {
        [self.playerViewDelegate startPlayVideo];
    }
    if (!self.isRotate) {
        self.lockScreenBtn.hidden = true;
    }else{
        self.lockScreenBtn.hidden = false;
    }
    [self hideFlowBtnOrPlayBtnOrRepeatBtn:4];
    self.pauseBtn.hidden = false;
    self.playBtn.hidden = true;
    [self.player play];

}

/** 视频暂停 */
- (void) videoPause{
    if ([self.playerViewDelegate  respondsToSelector:@selector(pausePlayVideo)]) {
        [self.playerViewDelegate pausePlayVideo];
    }
    if (!self.isRotate) {
        self.lockScreenBtn.hidden = true;
    }else{
        self.lockScreenBtn.hidden = false;
    }
    self.replayCenterBtn.hidden = true;
    if (self.type == 1) {
        self.pauseBtn.hidden = true;
        self.playBtn.hidden = false;
    }
   
    if ([self.player isPlaying]) {
        [self.player pause];
    }
    [self stopTimerVideoTool:7];
    self.link.paused = true;
}

/** 视频停止 */
-(void)videoStop{
    if ([self.playerViewDelegate  respondsToSelector:@selector(stopPlayVideo)]) {
        [self.playerViewDelegate stopPlayVideo];
    }
    self.pauseBtn.hidden = true;
    self.playBtn.hidden = false;
    [self.link invalidate];
    self.link = nil;
    if (self.player != nil) {
        [self.player shutdown];
        [self.player stop];
        [self.player.view removeFromSuperview];
        [self removeFromSuperview];
        self.player = nil;
    }
    [self stopTimerVideoTool:4];
}

/** 开始时间工具栏 */
-(void)startTimerVideoTool{
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(startTimerClicked) userInfo:nil repeats:true];
    [[NSRunLoop  mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

/** 开始时间的执行 */
-(void)startTimerClicked{
    if (self.count >= 3) {
        self.count = 0;
        [self stopTimerVideoTool:1];
    }
    self.count ++ ;
}

/** 锁屏按钮开始时间的执行 */
-(void)startLockScreenTimer{
    [self.lockScreenTimer invalidate];
    self.lockScreenTimer = nil;
    self.lockScreenTimer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(startLockScreenTimerClicked) userInfo:nil repeats:false];
    [[NSRunLoop  mainRunLoop] addTimer:self.lockScreenTimer forMode:NSDefaultRunLoopMode];
}

-(void)startLockScreenTimerClicked{
//    if (self.isRotate && self.lockScreenBtn.selected && self.bottomContainerView.alpha == 0.0) {
    if (self.isRotate && self.lockScreenBtn.selected && self.bottomContainerView.alpha == 0.0) {

        self.lockScreenBtn.alpha = 0.0;
        [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
    }
    [self.lockScreenTimer invalidate];
    self.lockScreenTimer = nil;
}

-(void)stopLockScreenTimerClicked{
    [self.lockScreenTimer invalidate];
    self.lockScreenTimer = nil;
}

/** 停止时间的工具栏 */
-(void)stopTimerVideoTool:(NSInteger)type{
    self.count = 0;
    [self.timer invalidate];
    self.timer = nil;
    [self handleSingleTap:type];
}

/** 是否播放完毕 */
-(BOOL)isPlayOver{
    return [self.currentTimeLabel.text isEqualToString:self.totalTimeLabel.text] && ![self.player isPlaying];
}

/** 显示/隐藏底部工具栏 */
- (void)handleSingleTap:(NSUInteger)type{
    [UIView animateWithDuration:0.5 animations:^{
        if (type == 1) {//正常计时
            // 只隐藏顶部工具栏
            self.topContainerView.alpha = (self.topContainerView.alpha == 1.0) ? 0.0 : 1.0;
        }else if (type == 2){//旋转
            self.topContainerView.alpha = 1.0;
        }else if (type == 3){//点击
            if (self.lockScreenBtn.selected && self.isRotate) {
                [self stopLockScreenTimerClicked];
            }else{
                self.topContainerView.alpha = (self.topContainerView.alpha == 1.0) ? 0.0 : 1.0;
            }
        }else if (type == 4){//当前视频播放完毕
            self.topContainerView.alpha = 1.0;
        }else if (type == 5){//锁屏按钮点击
            self.bottomContainerView.alpha = self.topContainerView.alpha = self.lockScreenBtn.selected ? 0.0 : 1.0;
        }else if (type == 6){//滑杆点击和拖动事件
            self.topContainerView.alpha = 1.0;
        }else if (type == 7){//视频暂停
            self.topContainerView.alpha = 1.0;
        }else if (type == 8){//视频版权
            self.topContainerView.alpha = 1.0;
        }
        
        if (self.topContainerView.alpha == 0.0 && self.isRotate) {
            [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
        }else if(self.isRotate){
            [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
        }
        
    } completion:^(BOOL finish){
        
        YYLog(@"865 --- 回调");
    }];
}

/** 显示/隐藏底部工具栏 */
/*- (void)handleSingleTap:(NSUInteger)type{
    [UIView animateWithDuration:0.5 animations:^{
        if (type == 1) {//正常计时
            
            // 隐藏锁屏按钮和底部工具栏
//            self.lockScreenBtn.alpha = self.bottomContainerView.alpha = self.topContainerView.alpha = (self.bottomContainerView.alpha == 1.0) ? 0.0 : 1.0;
            // 只隐藏顶部工具栏
            self.topContainerView.alpha = (self.topContainerView.alpha == 1.0) ? 0.0 : 1.0;
        }else if (type == 2){//旋转
            self.lockScreenBtn.alpha = self.bottomContainerView.alpha = self.topContainerView.alpha = 1.0;
        }else if (type == 3){//点击
            if (self.lockScreenBtn.selected && self.isRotate) {
                [self stopLockScreenTimerClicked];
                self.lockScreenBtn.alpha = (self.lockScreenBtn.alpha == 1.0) ? 0.0 : 1.0;
                if (self.lockScreenBtn.alpha == 1.0) {
                    [self startLockScreenTimer];
                }
            }else{
                self.lockScreenBtn.alpha =self.bottomContainerView.alpha = self.topContainerView.alpha = (self.bottomContainerView.alpha == 1.0) ? 0.0 : 1.0;
            }
        }else if (type == 4){//当前视频播放完毕
            self.lockScreenBtn.alpha = self.bottomContainerView.alpha = self.topContainerView.alpha = 1.0;
        }else if (type == 5){//锁屏按钮点击
            self.bottomContainerView.alpha = self.topContainerView.alpha = self.lockScreenBtn.selected ? 0.0 : 1.0;
        }else if (type == 6){//滑杆点击和拖动事件
            self.lockScreenBtn.alpha =self.bottomContainerView.alpha = self.topContainerView.alpha = 1.0;
        }else if (type == 7){//视频暂停
            self.lockScreenBtn.alpha = self.bottomContainerView.alpha = self.topContainerView.alpha = 1.0;
        }else if (type == 8){//视频版权
            self.lockScreenBtn.alpha = self.bottomContainerView.alpha = self.topContainerView.alpha = 1.0;
        }
        
        if (self.bottomContainerView.alpha == 0.0 && self.lockScreenBtn.alpha == 0.0 && self.isRotate) {
            [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
        }else if(self.isRotate){
            [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
        }
        
    } completion:^(BOOL finish){
    
        YYLog(@"865 --- 回调");
    }];
}*/

-(void)isHideStatus:(BOOL)isHidden{
    if (!self.isRotate) return;
}

/** 时间显示转换 */
- (NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger m = time / 60;
    NSInteger s = (NSInteger)time % 60;
    NSString *stringtime = [NSString stringWithFormat:@"%02ld:%02ld",m, s];
    return stringtime;
}

/** 是否为全屏设置 */
-(void)islock{
    
    if (self.isLockBlock) {
        self.isLockBlock(self.lockScreenBtn.selected);
    }
}

-(void)delegateFullScreenToolsBtnClicked:(UIButton*)btn{
    
    if ([self.delegate respondsToSelector:@selector(delegateFullScreenToolsBtnClicked:)]) {
        [self.delegate delegateFullScreenToolsBtnClicked:btn];
    }
}

/** 全屏播放底部按钮点击事件代理*/
- (void) didShowLiveBottomToolsButtonClick:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(delegateFullScureenBtnClicked:)]) {
        [self.delegate delegateFullScureenBtnClicked:sender];
    }
}

-(void)hideFlowBtnOrPlayBtnOrRepeatBtn:(NSInteger)type{
    if (type == 1) {// 显示中间播放按钮,隐藏重播和流量播放按钮
        self.replayCenterBtn.hidden = self.flowPlayCenterBtn.hidden = true;
    }else if (type == 2){// 显示中间流量播放按钮,隐藏重播和播放按钮
        self.flowPlayCenterBtn.hidden = false;
        self.replayCenterBtn.hidden = true;
    }else if (type == 3){// 显示中间重播按钮,隐藏播放和流量播放按钮
        self.replayCenterBtn.hidden = false;
        self.flowPlayCenterBtn.hidden = true;
    }else if (type == 4){// 隐藏所有按钮
        self.replayCenterBtn.hidden = self.flowPlayCenterBtn.hidden = true;
    }
}

/** 点赞显示❤️ */
-(void)showTheLove:(UIButton *)sender{
    CGFloat _height = self.frame.size.height;
    CGFloat _heartSize = 36;
    LZHeartFlyView* heart = [[LZHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self addSubview:heart];
    CGPoint fountainSource = CGPointMake(sender.x+sender.bounds.size.width/2, _height - _heartSize/2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self];
}

@end
