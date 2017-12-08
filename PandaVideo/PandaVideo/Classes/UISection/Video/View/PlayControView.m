//
//  PlayControView.m
//  VideoDemo
//
//  Created by cara on 17/7/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PlayControView.h"
#import "UIView+Extension.h"
#import "PVOrderCenterViewController.h"
#import "UIButton+Gradient.h"

#define CaraScreenH [UIScreen mainScreen].bounds.size.height
#define CaraScreenW [UIScreen mainScreen].bounds.size.width


@interface PlayControView()

/** 视频标题 */
@property (nonatomic, strong)UILabel   *titleNameLabel;
///下一集按钮
@property(nonatomic, strong)UIButton* nextBtn;
@property (nonatomic, assign) NSTimeInterval  lastTime;
///全屏按钮
@property(nonatomic, strong)UIButton* screenBtn;
/** 选集/频道按钮*/
@property (nonatomic, strong)UIButton*  anthologyBtn;
/** 节目单按钮*/
@property (nonatomic, strong)UIButton*  programBtn;
///几秒之后隐藏工具栏的定时器
@property(nonatomic, strong)NSTimer* timer;
/** 锁屏之后隐藏锁屏按钮 */
@property (nonatomic, strong) NSTimer  *lockScreenTimer;
///第几秒了
@property(nonatomic, assign)NSInteger count;
/** 返回按钮 */
@property (nonatomic, strong)UIButton   *backBtn;
/** 更多按钮 */
@property (nonatomic, strong)UIButton   *moreBtn;
/** 分享按钮 */
@property (nonatomic, strong)UIButton   *shareBtn;
/** TV按钮 */
@property (nonatomic, strong)UIButton   *televisionBtn;
/** 更新tv的左边约束 */
@property(nonatomic,strong)MASConstraint *teleVersionConstraint;
/** 弹幕按钮 */
@property (nonatomic, strong)UIButton   *barrageBtn;
/** 发弹幕按钮 */
@property (nonatomic, strong)UIButton   *publishBarrageBtn;
/** 记录上一次的缓冲时间 */
@property (nonatomic, assign)CGFloat   lastBufferTime;
/** 试看label */
@property (nonatomic, strong)UILabel*  lookLabel;
/** 试看点击按钮 */
@property (nonatomic, strong)UIButton* lookBtn;
/** 试看中心提示label */
@property (nonatomic, strong)UILabel*  lookCenterLabel;
/** 试看点击中心按钮 */
@property (nonatomic, strong)UIButton* lookCenterBtn;
/** 试看时间 */
@property (nonatomic, assign)CGFloat videoPilotTime;
/** 记录总时长的20%时间 */
@property (nonatomic, assign)CGFloat recordTelevisionCloudTime;

@end


@implementation PlayControView


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)addDeviceOrientation{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:)   name:UIDeviceOrientationDidChangeNotification  object:nil];
}
-(void)removeDeviceOrientation{
     [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(instancetype)initWithType:(NSInteger)type{
    self = [super init];
    if (self) {
        // 监测设备方向
        [self addDeviceOrientation];
        self.type = type;
        [self initData];
        [self setupUI];
    }
    return self;
}


/**
 *  屏幕方向发生变化会调用这里
 */
-(void)deviceOrientationDidChange:(NSObject*)sender{
    //可以优化
    if (self.lockScreenBtn.selected || ![self isShowingOnKeyWindow])return;
    UIDevice* device = [sender valueForKey:@"object"];
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if ((int)currentOrientation  == device.orientation) {
        return;
    }
    if (device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight || device.orientation == UIDeviceOrientationPortrait){
        [self stopTimerVideoTool:2];
        if ([self.delegate respondsToSelector:@selector(fullScreenWithPlayerView:isOrientation:)]) {
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
            [self.delegate fullScreenWithPlayerView:self isOrientation:device.orientation];
            [self.videoSlider setNeedsDisplay];
        }
    }
}

-(void)initData{
    self.isRotate = false;
    self.videoPilotTime = 300.0;
}

-(void)setupUI{
    
    ///底部控件
    [self addSubview:self.bottomContainerView];
    [self.bottomContainerView addSubview:self.playBtn];
    [self.bottomContainerView addSubview:self.pauseBtn];
    [self.bottomContainerView addSubview:self.nextBtn];
    [self.bottomContainerView addSubview:self.currentTimeLabel];
    [self.bottomContainerView addSubview:self.videoSlider];
    [self.bottomContainerView addSubview:self.totalTimeLabel];
    [self.bottomContainerView addSubview:self.definitionBtn];
    [self.bottomContainerView addSubview:self.anthologyBtn];
    [self.bottomContainerView addSubview:self.programBtn];
    [self.bottomContainerView addSubview:self.screenBtn];
    
    ///顶部控件
    [self addSubview:self.topContainerView];
    [self.topContainerView addSubview:self.moreBtn];
    [self.topContainerView addSubview:self.shareBtn];
    [self.topContainerView addSubview:self.televisionBtn];
    [self.topContainerView addSubview:self.barrageBtn];
    [self.topContainerView addSubview:self.publishBarrageBtn];
    [self.topContainerView addSubview:self.titleNameLabel];
    
    [self addSubview:self.backBtn];
    
    
    if (self.type != 4) {
        [self addSubview:self.lookBtn];
        [self addSubview:self.lookLabel];
        [self addSubview:self.lookCenterBtn];
        [self addSubview:self.lookCenterLabel];
    }
    [self setConstraint];
    if (self.type != 3) {
        [self startTime];
        
    }
    [self closeViewUserInteractionEnabled];
}
-(void)setConstraint{
    
    CGFloat height = 50;
    ///顶部工具栏
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(height));
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(self.topContainerView).offset(0);
        make.width.height.equalTo(@(height+20));
    }];
    [self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(-20);
        make.centerY.equalTo(self.backBtn);
        make.right.equalTo(self.publishBarrageBtn.mas_left).offset(-20);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topContainerView).offset(0);
        make.top.equalTo(self.topContainerView).offset(8);
        make.width.height.equalTo(self.topContainerView.mas_height);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreBtn.mas_left).offset(5);
        make.top.equalTo(self.topContainerView).offset(8);
        make.width.height.equalTo(self.topContainerView.mas_height);
    }];
    [self.televisionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.mas_left).offset(90);
        self.teleVersionConstraint = make.top.equalTo(self.topContainerView).offset(8);
        make.width.height.equalTo(self.topContainerView.mas_height);
    }];
    [self.barrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.televisionBtn.mas_left).offset(5);
        make.top.equalTo(self.topContainerView).offset(8);
        make.width.height.equalTo(self.topContainerView.mas_height);
    }];
    [self.publishBarrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.barrageBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.topContainerView).offset(8);
        make.width.equalTo(@50);
        make.height.equalTo(@(20));
    }];
    
    if (self.type != 4) {
        [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-60);
            make.top.equalTo(@20);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
        [self.lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.lookBtn.mas_left).offset(-8);
            make.centerY.equalTo(self.lookBtn.mas_centerY);
        }];
        [self.lookCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-20);
        }];
        [self.lookCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lookCenterLabel.mas_bottom).offset(18);
            make.centerX.equalTo(self);
            make.width.equalTo(@(119));
            make.height.equalTo(@(32));
        }];
    }
        
    ///底部工具栏
    [self.bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(height));
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomContainerView);
        make.width.height.equalTo(@(height));
    }];
    [self.pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomContainerView);
        make.width.height.equalTo(@(height));
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(-15);
        make.bottom.equalTo(self.bottomContainerView);
        make.width.height.equalTo(@(height));
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nextBtn.mas_right).offset(-45);
        make.bottom.equalTo(self.bottomContainerView).offset(0);
        make.height.equalTo(@(height));
    }];
    [self.screenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.bottomContainerView);
        make.width.height.equalTo(@(height));
    }];
    [self.programBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomContainerView.mas_right).offset(-10);
        make.bottom.equalTo(self.bottomContainerView);
        make.width.height.equalTo(@(height));
    }];
    [self.anthologyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.programBtn.mas_left).offset(5);
        make.bottom.equalTo(self.bottomContainerView);
        make.width.height.equalTo(@(height));
    }];
    [self.definitionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.anthologyBtn.mas_left).offset(5);
        make.bottom.equalTo(self.bottomContainerView);
        make.width.height.equalTo(@(height));
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.definitionBtn.mas_left).offset(105);
        make.bottom.equalTo(self.bottomContainerView).offset(0);
        make.height.equalTo(@(height));
    }];
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(5);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-5);
        make.bottom.equalTo(self.bottomContainerView).offset(0);
        make.height.equalTo(@(height));
    }];
    
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
    NSTimeInterval current = self.player.currentPlaybackTime;
    NSTimeInterval total = self.player.duration;
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
    if (current != self.lastTime) {
        // 更新播放时间
        self.currentTimeLabel.text = [self stringWithTime:current];        
    }
    self.videoSlider.value = current/total;
    self.lastTime = current;
    
    //试播时间
    if (self.videoAuthentication.authenticationType == 6) {
        if(self.player.currentPlaybackTime >= self.videoPilotTime && self.type < 3){
            self.isPilotPattern = true;
        }
    }
//    if ((int)self.player.currentPlaybackTime == (int)self.recordTelevisionCloudTime && self.recordTelevisionCloudTime > 0) {
//        self.televisionCloudView.hidden = false;
//    }else if ((int)self.player.currentPlaybackTime >= (int)self.recordTelevisionCloudTime + 10){
//        self.televisionCloudView.hidden = true;
//    }
    CGFloat bufferTime = self.player.playableDuration;
    if (current > bufferTime) {
        bufferTime = current + 0.01;
    }
    CGFloat tempBufferTime = bufferTime/total;
    if (tempBufferTime <= self.lastBufferTime) return;
    self.videoSlider.middleValue =  tempBufferTime;
    self.lastBufferTime = tempBufferTime;

    
}
-(void)videoPlayOver{//当前视频播放完毕
    [self.link setPaused:true];
    self.currentTimeLabel.text = self.totalTimeLabel.text;
    if (self.type == 1 || self.type == 4 || self.type == 5) {//单集
        [self stopTimerVideoTool:4];
        [self videoPause];
        if (self.lockScreenBtn.selected) {
            [self lockScreenBtnClicked];
        }
        self.replayCenterBtn.hidden = false;
        self.lockScreenBtn.hidden = true;
    }else if (self.type == 2  || self.type == 3){//多集,播放下一集
        if (self.delegate && [self.delegate respondsToSelector:@selector(delegateNextBtnClicked)]) {
            [self.delegate delegateNextBtnClicked];
            NSLog(@"自动播放下一集");
        }
    }
}
-(UILabel *)titleNameLabel{
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc]  init];
        _titleNameLabel.textColor = [UIColor sc_colorWithHex:0xF8FBFF];
        _titleNameLabel.font = [UIFont systemFontOfSize:15];
        _titleNameLabel.hidden = true;
    }
    return _titleNameLabel;
}
-(void)setVideoTitleName:(NSString *)videoTitleName{
    _videoTitleName = videoTitleName;
    self.titleNameLabel.text = videoTitleName;
}
-(UIButton *)lockScreenBtn{
    if (!_lockScreenBtn) {
        _lockScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockScreenBtn setImage:[UIImage imageNamed:@"live_btn_unlock"] forState:UIControlStateNormal];
        [_lockScreenBtn setImage:[UIImage imageNamed:@"live_btn_locked"] forState:UIControlStateSelected];
        [_lockScreenBtn addTarget:self action:@selector(lockScreenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _lockScreenBtn.hidden = true;
    }
    return _lockScreenBtn;
}
-(void)lockScreenBtnClicked{
    self.lockScreenBtn.selected = !self.lockScreenBtn.selected;
    if (self.lockScreenBtn.selected) {
        if(self.timer){
            [self stopTimerVideoTool:5];
            [self startLockScreenTimer];
        }
        self.userInteractionEnabled = false;
        if ([self.playViewDelegate respondsToSelector:@selector(pausePlayVideo)]) {
            [self.playViewDelegate pausePlayVideo];
        }
    }else{
        [self stopTimerVideoTool:5];
        [self startTimerVideoTool];
        self.userInteractionEnabled = true;
        if ([self.playViewDelegate respondsToSelector:@selector(stopPlayVideo)]) {
            [self.playViewDelegate startPlayVideo];
        }
    }
    [self islock];
    //(self.type == 1 || self.type == 2 || self.type == 4)  
    if ( [self.playViewDelegate respondsToSelector:@selector(lockScreen:)]) {
        [self.playViewDelegate lockScreen:self.lockScreenBtn.selected];
    }
}
-(UIView *)topContainerView{
    if (!_topContainerView) {
        _topContainerView = [[UIView alloc]  init];
        _topContainerView.backgroundColor = [UIColor clearColor];
        UIImageView* bgImageView = [[UIImageView alloc]  init];
        bgImageView.image = [UIImage imageNamed:@"live_control_top_paly"];
        [_topContainerView addSubview:bgImageView];
//        if (self.type > 2) {
//            bgImageView.hidden = true;
//        }
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(_topContainerView);
        }];
    }
    return _topContainerView;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"all_btn_back_white"] forState:UIControlStateNormal];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        if(self.type > 2){
            _backBtn.hidden = true;
        }
    }
    return _backBtn;
}
-(void)backBtnClicked{
    if (self.isRotate) {
        [self screenBtnClicked];
        NSLog(@"全屏返回");
    }else if ([self.delegate respondsToSelector:@selector(backToBeforeVC)]){
        [self.delegate backToBeforeVC];
    }
}
-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.hidden = true;
        [_moreBtn setImage:[UIImage imageNamed:@"live_btn_more"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
-(void)moreBtnClicked{
    
    if ([self.delegate respondsToSelector:@selector(delegateMoreBtnClicked)]) {
        [self.delegate delegateMoreBtnClicked];
        NSLog(@"更多");
    }

}
-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.hidden = true;
        [_shareBtn setImage:[UIImage imageNamed:@"live_btn_share"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
-(void)shareBtnClicked{
    if ([self.delegate respondsToSelector:@selector(delegateShareBtnClicked)]) {
        [self.delegate delegateShareBtnClicked];
        NSLog(@"分享");
    }
}
-(UIButton *)televisionBtn{
    if (!_televisionBtn) {
        _televisionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(self.type > 2){
            _televisionBtn.hidden = true;
        }
        [_televisionBtn setImage:[UIImage imageNamed:@"live_btn_project"] forState:UIControlStateNormal];
        [_televisionBtn addTarget:self action:@selector(televisionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _televisionBtn;
}
-(void)televisionBtnClicked{
    if (self.type == 3 || self.type == 5) return;
    self.televisionCloudView.hidden = false;
    if ([self.delegate respondsToSelector:@selector(delegateTeleversionBtnClicked)]) {
        [self.delegate delegateTeleversionBtnClicked];
        NSLog(@"电视");
    }
}

-(UIButton *)lookBtn{
    if (!_lookBtn) {
        _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _lookBtn.titleLabel.textColor = [UIColor whiteColor];
        _lookBtn.clipsToBounds = true;
        _lookBtn.layer.cornerRadius = 5.0f;
        _lookBtn.hidden = true;
        _lookBtn.adjustsImageWhenHighlighted = false;
        [_lookBtn setTitle:@"立即订购" forState:UIControlStateNormal];
        [_lookBtn addTarget:self action:@selector(lookBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        NSArray* colors = @[[UIColor sc_colorWithHex:0xFF842E],[UIColor sc_colorWithHex:0xFFB200]];
        [_lookBtn gradientButtonWithSize:CGSizeMake(80, 30) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
    }
    return _lookBtn;
}
-(UIButton *)lookCenterBtn{
    if (!_lookCenterBtn) {
        _lookCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookCenterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _lookCenterBtn.titleLabel.textColor = [UIColor whiteColor];
        _lookCenterBtn.clipsToBounds = true;
        _lookCenterBtn.layer.cornerRadius = 16.0f;
        _lookCenterBtn.adjustsImageWhenHighlighted = false;
        _lookCenterBtn.hidden = true;
        [_lookCenterBtn setTitle:@"立即订购" forState:UIControlStateNormal];
        [_lookCenterBtn addTarget:self action:@selector(lookBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        NSArray* colors = @[[UIColor sc_colorWithHex:0x2BBCF0],[UIColor sc_colorWithHex:0x00D3E4]];
        [_lookCenterBtn gradientButtonWithSize:CGSizeMake(119, 32) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
    }
    return _lookCenterBtn;
}

-(void)lookBtnClicked{
    if(self.isRotate){//设置为竖屏
        [self screenBtnClicked];
    }
    if ([self.player isPlaying]) {
        [self videoPause];
    }
    PVOrderCenterViewController* vc = [[PVOrderCenterViewController alloc]  init];
    UIViewController* pushVC = (UIViewController*)self.delegate;
    [pushVC.navigationController pushViewController:vc animated:true];
}
-(UILabel *)lookLabel{
    if(!_lookLabel){
        _lookLabel = [[UILabel alloc]  init];
        _lookLabel.textColor = [UIColor whiteColor];
        _lookLabel.font = [UIFont systemFontOfSize:15];
        _lookLabel.hidden = true;
        _lookLabel.text = @"免费试看6分钟";
        _lookLabel.textAlignment = NSTextAlignmentRight;
    }
    return _lookLabel;
}
-(UILabel *)lookCenterLabel{
    if(!_lookCenterLabel){
        _lookCenterLabel = [[UILabel alloc]  init];
        _lookCenterLabel.textColor = [UIColor whiteColor];
        _lookCenterLabel.font = [UIFont systemFontOfSize:15];
        _lookCenterLabel.hidden = true;
        _lookCenterLabel.text = @"熊猫视频付费影片，观看完整版请订购产品包";
        _lookCenterLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lookCenterLabel;
}


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
-(void)barrageBtnClicked{
    self.barrageBtn.selected = !self.barrageBtn.selected;
    if ([self.delegate respondsToSelector:@selector(delegateBarrageBtnClicked:)]) {
        [self.delegate delegateBarrageBtnClicked:self.barrageBtn];
        NSLog(@"弹幕");
    }
}
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
-(void)publishBarrageBtnClicked{
    if ([self.delegate respondsToSelector:@selector(delegatePublishBarrageBtnClicked)]) {
        [self.delegate delegatePublishBarrageBtnClicked];
        NSLog(@"发弹幕");
    }
}
-(UIView *)bottomContainerView{
    if (!_bottomContainerView) {
        _bottomContainerView = [[UIView alloc]  init];
        _bottomContainerView.backgroundColor = [UIColor clearColor];
        UIImageView* bgImageView = [[UIImageView alloc]  init];
        bgImageView.image = [UIImage imageNamed:@"live_control_paly"];
        [_bottomContainerView addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(_bottomContainerView);
        }];
    }
    return _bottomContainerView;
}
-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"live_btn_play"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.hidden = true;
    }
    return _playBtn;
}
///继续播放
-(void)playBtnClicked{
    self.pauseBtn.hidden = false;
    self.playBtn.hidden = true;
    if (![self.player isPlaying]) {
        [self videoPlay];
        [self startTimerVideoTool];
    }
}
-(UIButton *)pauseBtn{
    if (!_pauseBtn) {
        _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseBtn setImage:[UIImage imageNamed:@"live_btn_pause"] forState:UIControlStateNormal];
        [_pauseBtn addTarget:self action:@selector(pauseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseBtn;
}
///暂停播放
-(void)pauseBtnClicked{
    self.pauseBtn.hidden = true;
    self.playBtn.hidden = false;
    [self videoPause];
}

-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.hidden = true;
        [_nextBtn setImage:[UIImage imageNamed:@"live_btn_next"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
-(void)nextBtnClicked{
    if ([self.delegate respondsToSelector:@selector(delegateNextBtnClicked)]) {
        [self.delegate delegateNextBtnClicked];
    }
}
-(UIButton *)screenBtn{
    if (!_screenBtn) {
        _screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_screenBtn setImage:[UIImage imageNamed:@"find_btn_fullscreen"] forState:UIControlStateNormal];
        [_screenBtn addTarget:self action:@selector(screenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenBtn;
}

//旋转
-(void)screenBtnClicked{
    [self stopTimerVideoTool:2];
    if ([self.delegate respondsToSelector:@selector(fullScreenWithPlayerView:isOrientation:)]) {
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
        [self.delegate fullScreenWithPlayerView:self isOrientation:orientation];
        [self.videoSlider setNeedsDisplay];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:false];

}

-(UIButton *)definitionBtn{
    if (!_definitionBtn) {
        _definitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _definitionBtn.hidden = true;
        [_definitionBtn setTitle:@"标清" forState:UIControlStateNormal];
        _definitionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _definitionBtn.titleLabel.textColor = [UIColor whiteColor];
        [_definitionBtn addTarget:self action:@selector(definitionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _definitionBtn;
}
-(void)definitionBtnClicked{
    if ([self.delegate respondsToSelector:@selector(delegateDefinitionBtnClicked)]) {
        [self.delegate delegateDefinitionBtnClicked];
        NSLog(@"清晰度选择");
    }
}
-(UIButton *)anthologyBtn{
    if (!_anthologyBtn) {
        _anthologyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _anthologyBtn.hidden = true;
        NSString* title = @"选集";
        if (self.type == 3 || self.type == 5) {
            title = @"频道";
        }
        [_anthologyBtn setTitle:title forState:UIControlStateNormal];
        _anthologyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _anthologyBtn.titleLabel.textColor = [UIColor whiteColor];
        [_anthologyBtn addTarget:self action:@selector(anthologyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _anthologyBtn;
}
-(void)anthologyBtnClicked{
    if ([self.delegate respondsToSelector:@selector(delegateAnthologyBtnClicked)]) {
        [self.delegate delegateAnthologyBtnClicked];
        NSLog(@"选集");
    }
}
-(UIButton *)programBtn{
    if (!_programBtn) {
        _programBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _programBtn.hidden = true;
        [_programBtn setTitle:@"节目单" forState:UIControlStateNormal];
        _programBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _programBtn.titleLabel.textColor = [UIColor whiteColor];
        [_programBtn addTarget:self action:@selector(programBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _programBtn;
}
-(void)programBtnClicked{
    if ([self.delegate respondsToSelector:@selector(delegateProgramBtnClicked)]) {
        [self.delegate delegateProgramBtnClicked];
        NSLog(@"节目单");
    }
}
-(void)updateScreenConStaint{
    if(self.isRotate){//全屏
        self.titleNameLabel.hidden=self.backBtn.hidden = false;
        [self.televisionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.shareBtn.mas_left).offset(5);
        }];
        //self.publishBarrageBtn.hidden = self.barrageBtn.hidden =
        if (self.type == 4) {
            self.moreBtn.hidden = true;
            self.shareBtn.hidden = true;
        }else{
            self.moreBtn.hidden = false;
            self.shareBtn.hidden = false;
        }
        self.definitionBtn.hidden = false;
        self.screenBtn.hidden = true;
        if (self.type == 1 || self.type == 4) {
            [self.definitionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.anthologyBtn.mas_left).offset(100);
            }];
            [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.definitionBtn.mas_left).offset(-10);
            }];
            [self.currentTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.playBtn.mas_right).offset(-5);
            }];
            self.anthologyBtn.hidden = true;
            self.nextBtn.hidden = true;
        }else if (self.type == 2) {
                [self.anthologyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.programBtn.mas_left).offset(50);
                }];
                [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.definitionBtn.mas_left).offset(-10);
                }];
                [self.currentTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.nextBtn.mas_right).offset(-5);
                }];
                self.anthologyBtn.hidden = false;
                self.nextBtn.hidden = false;
        }else if (self.type == 3 || self.type == 5) {
            self.programBtn.hidden = false;
            [self.currentTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.playBtn.mas_right).offset(-5);
            }];
            self.nextBtn.hidden = true;
            [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.definitionBtn.mas_left).offset(-10);
            }];
            self.anthologyBtn.hidden = false;
           // self.publishBarrageBtn.hidden = self.barrageBtn.hidden = true;
        }
//        if (self.type == 4) {
//            [self.shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.moreBtn.mas_left).offset(55);
//            }];
//        }
    }else{//竖屏
        if(self.barrageBtn.selected){
            [self barrageBtnClicked];
        }
        self.titleNameLabel.hidden = true;
        self.backBtn.hidden = (self.type > 2) ? true : false;
        [self.televisionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.shareBtn.mas_left).offset(90);
        }];
        //self.publishBarrageBtn.hidden = self.barrageBtn.hidden =
        self.shareBtn.hidden = self.moreBtn.hidden = true;
        [self.currentTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nextBtn.mas_right).offset(-45);
        }];
        
        if (self.type == 1 || self.type == 4) {
            [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.definitionBtn.mas_left).offset(10);
            }];
        }else if(self.type == 2){
            [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.definitionBtn.mas_left).offset(60);
            }];
        }else if(self.type == 3 || self.type == 5){
            [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.definitionBtn.mas_left).offset(105);
            }];
        }
//        if (self.type == 4) {
//            [self.shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.moreBtn.mas_left).offset(5);
//            }];
//        }
        self.programBtn.hidden = true;
        self.nextBtn.hidden = true;
        self.screenBtn.hidden = false;
        self.definitionBtn.hidden = self.anthologyBtn.hidden = true;
    }
}

-(UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc]  init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:13];
        _currentTimeLabel.text = @"00:00";
        if (self.type == 3) {
            _currentTimeLabel.hidden = true;
        }else{
            _currentTimeLabel.hidden = false;
        }
    }
    return _currentTimeLabel;
}

-(void)setTotalTime:(CGFloat)totalTime{
    if (self.type == 3)return;
    _totalTime = totalTime;
    self.recordTelevisionCloudTime = 10;
    // duration 总时长
    self.totalTimeLabel.text = [self stringWithTime:totalTime];
}
-(UILabel *)totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]  init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:13];
        _totalTimeLabel.text = @"00:00";
        if (self.type == 3) {
            _totalTimeLabel.hidden = true;
        }else{
            _totalTimeLabel.hidden = false;
        }
    }
    return _totalTimeLabel;
}

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
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_videoSlider addGestureRecognizer:sliderTap];
        UIPanGestureRecognizer*  panGesture = [[UIPanGestureRecognizer alloc]  initWithTarget:self action:@selector(progressSliderValueChanged:)];
        [_videoSlider addGestureRecognizer:panGesture];
        if (self.type == 3) {
            _videoSlider.hidden = true;
        }else{
            _videoSlider.hidden = false;
        }
    }
    return _videoSlider;
}
- (SCButton *)replayCenterBtn{
    if (!_replayCenterBtn) {
        _replayCenterBtn = [SCButton customButtonWithTitlt:@"重播" imageNolmalString:@"find_btn_replay" imageSelectedString:@"find_btn_replay"];
        _replayCenterBtn.hidden = true;
        _replayCenterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_replayCenterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_replayCenterBtn setImage:[UIImage imageNamed:@"find_btn_replay"] forState:UIControlStateNormal];
        [_replayCenterBtn setTitle:@"重播" forState:UIControlStateNormal];
        [_replayCenterBtn addTarget:self action:@selector(replayCenterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _replayCenterBtn.hidden = true;
    }
    return _replayCenterBtn;
}
-(void)replayCenterBtnClick{
    //单集就进行重播
    self.pauseBtn.hidden = false;
    self.playBtn.hidden = true;
    if (![self.player isPlaying]) {
        self.isPilotPattern = false;
        self.player.currentPlaybackTime = 0.1f;
        [self videoPlay];
        [self startTimerVideoTool];
    }
    NSLog(@"重播");
}
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

-(void)flowPlayCenterBtnClick{
    if ([self.playViewDelegate  respondsToSelector:@selector(startGifAnimate)]) {
        [self.playViewDelegate startGifAnimate];
    }
    if (self.player.currentPlaybackTime > 0) {
        [self videoPlay];
    }else{
        [self videoprepareToPlay];
    }
}

- (void)playeCenterBtnClick{
    if (![self.player isPlaying]) {
        [self videoPlay];
        [self startTimerVideoTool];
    }
}
-(PVTelevisionCloudView *)televisionCloudView{
    if (!_televisionCloudView) {
        _televisionCloudView = [[PVTelevisionCloudView alloc]  init];
        _televisionCloudView.hidden = true;
        PV(pv)
        [_televisionCloudView  setPVTelevisionCloudViewCallBlock:^(BOOL isTelevisionCloud) {
            pv.televisionCloudView.hidden = true;
            if (pv.delegate && [pv.delegate respondsToSelector:@selector(delegateTelevisionPlayCloud:)]) {
                [pv.delegate delegateTelevisionPlayCloud:isTelevisionCloud];
            }            
        }];
    }
    return _televisionCloudView;
}


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
//        if (self.player.isPreparedToPlay) {
            self.currentTimeLabel.text = [self stringWithTime:self.player.duration*tapValue];
            // 设置当前播放时间
            self.player.currentPlaybackTime = self.player.duration*self.videoSlider.value;
            [self videoPlay];
            [self startTimerVideoTool];
//        }
    }
}
///视频第一次播放
-(void)videoFirstPlay{
    if (self.type == 4) {
        [self videoprepareToPlay];
    }else{
        self.videoAuthentication.productModel.code = self.playVideoModel.code;
        [self.videoAuthentication playVideoAuthentication];
        NSLog(@"-----鉴权结果----%ld",self.videoAuthentication.authenticationType);
        if (self.type > 2 && self.videoAuthentication.authenticationType == 6) {
            [self stopTimerVideoTool:7];
            if (self.playViewDelegate && [self.playViewDelegate respondsToSelector:@selector(stopGifAnimate)]) {
                [self.playViewDelegate stopGifAnimate];
            }
            self.lookBtn.hidden = self.lookLabel.hidden = true;
            self.lookCenterLabel.hidden = self.lookCenterBtn.hidden = false;
        }else{
            self.lookCenterLabel.hidden = self.lookCenterBtn.hidden = true;
            if (self.videoAuthentication.authenticationType == 3) {//开启正常播放
                self.lookBtn.hidden = self.lookLabel.hidden = true;
                [self videoprepareToPlay];
            }else if (self.videoAuthentication.authenticationType == 4){
                [self hideFlowBtnOrPlayBtnOrRepeatBtn:2];
                if ([self.playViewDelegate  respondsToSelector:@selector(stopPlayVideo)]) {
                    [self.playViewDelegate stopPlayVideo];
                }
            }else if (self.videoAuthentication.authenticationType == 6){//产品订购流程
                self.lookBtn.hidden = self.lookLabel.hidden = false;
                [self videoprepareToPlay];
            }
        }
    }
}

///视频播放
-(void)videoPlay{
    if ([self.playViewDelegate  respondsToSelector:@selector(startPlayVideo)]) {
        [self.playViewDelegate startPlayVideo];
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
    if (!self.timer) {
        [self startTimerVideoTool];
    }
    //self.link.paused = NO;
}
///视频暂停
-(void)videoPause{
    if ([self.playViewDelegate  respondsToSelector:@selector(pausePlayVideo)]) {
        [self.playViewDelegate pausePlayVideo];
    }
    if (!self.isRotate) {
        self.lockScreenBtn.hidden = true;
    }else{
        self.lockScreenBtn.hidden = false;
    }
    self.replayCenterBtn.hidden = true;
    self.pauseBtn.hidden = true;
    self.playBtn.hidden = false;
    if (self.player) {
        [self.player pause];
    }
    [self stopTimerVideoTool:7];
    self.link.paused = true;
}
///视频停止
-(void)videoStop{
    if ([self.playViewDelegate  respondsToSelector:@selector(stopPlayVideo)]) {
        [self.playViewDelegate stopPlayVideo];
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
-(void)startTimerVideoTool{
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(startTimerClicked) userInfo:nil repeats:true];
    [[NSRunLoop  mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
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
-(void)stopTimerVideoTool:(NSInteger)type{
    self.count = 0;
    [self.timer invalidate];
    self.timer = nil;
    [self handleSingleTap:type];
}
//是否播放完毕
-(BOOL)isPlayOver{
    return [self.currentTimeLabel.text isEqualToString:self.totalTimeLabel.text] && ![self.player isPlaying];
}
/**
 *  显示/隐藏底部工具栏
 *
 */
- (void)handleSingleTap:(NSUInteger)type{
    [UIView animateWithDuration:0.5 animations:^{
            if (type == 1) {//正常计时
                self.replayCenterBtn.alpha = self.flowPlayCenterBtn.alpha =  self.lockScreenBtn.alpha = self.topContainerView.alpha = self.bottomContainerView.alpha = (self.bottomContainerView.alpha == 1.0) ? 0.0 : 1.0;
                self.backBtn.alpha = self.isRotate ? self.topContainerView.alpha : 1.0;
            }else if (type == 2){//旋转
                self.replayCenterBtn.alpha = self.flowPlayCenterBtn.alpha = self.lockScreenBtn.alpha = self.topContainerView.alpha = self.bottomContainerView.alpha = self.backBtn.alpha = 1.0;
            }else if (type == 3){//点击
                if (self.lockScreenBtn.selected && self.isRotate) {
                    [self stopLockScreenTimerClicked];
                    self.lockScreenBtn.alpha = (self.lockScreenBtn.alpha == 1.0) ? 0.0 : 1.0;
                    if (self.lockScreenBtn.alpha == 1.0) {
                        [self startLockScreenTimer];
                    }
                    if(self.lockScreenBtn.alpha == 0.0){
                         self.replayCenterBtn.alpha = self.flowPlayCenterBtn.alpha = self.lockScreenBtn.alpha = self.topContainerView.alpha = self.bottomContainerView.alpha = self.backBtn.alpha = 0.0;
                    }
                }else{
                    self.replayCenterBtn.alpha = self.flowPlayCenterBtn.alpha = self.lockScreenBtn.alpha = self.topContainerView.alpha = self.bottomContainerView.alpha = (self.bottomContainerView.alpha == 1.0) ? 0.0 : 1.0;
                    self.backBtn.alpha = self.isRotate ? self.topContainerView.alpha : 1.0;
                }
            }else if (type == 4){//当前视频播放完毕
                self.replayCenterBtn.alpha = self.flowPlayCenterBtn.alpha = self.lockScreenBtn.alpha = self.topContainerView.alpha = self.bottomContainerView.alpha = self.backBtn.alpha =  1.0;
            }else if (type == 5){//锁屏按钮点击
                self.replayCenterBtn.alpha = self.flowPlayCenterBtn.alpha = self.topContainerView.alpha = self.bottomContainerView.alpha = self.lockScreenBtn.selected ? 0.0 : 1.0;
                self.backBtn.alpha = self.isRotate ? self.topContainerView.alpha : 1.0;
            }else if (type == 6){//滑杆点击和拖动事件
                self.replayCenterBtn.alpha = self.flowPlayCenterBtn.alpha =  self.lockScreenBtn.alpha = self.topContainerView.alpha  = self.bottomContainerView.alpha = self.backBtn.alpha = 1.0;
            }else if (type == 7){//视频暂停
                self.replayCenterBtn.alpha = self.flowPlayCenterBtn.alpha = self.lockScreenBtn.alpha = self.topContainerView.alpha  = self.bottomContainerView.alpha = self.backBtn.alpha =  1.0;
            }else if (type == 8){//视频版权
                self.replayCenterBtn.alpha = self.flowPlayCenterBtn.alpha = self.lockScreenBtn.alpha = self.topContainerView.alpha = self.bottomContainerView.alpha = self.backBtn.alpha = 1.0;
            }
            if (self.bottomContainerView.alpha == 0.0 && self.lockScreenBtn.alpha == 0.0 && self.isRotate) {
                [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
            }else if(self.isRotate){
                [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
            }
        
        } completion:^(BOOL finish){
            if(self.type > 2)return;
            //更新试播模式的约束
            if (!self.isRotate && self.bottomContainerView.alpha == 0.0) {
                [self.lookBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self).offset(-10);
                    make.top.equalTo(@20);
                }];
            }else if(!self.isRotate && self.bottomContainerView.alpha == 1.0) {
                [self.lookBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self).offset(-60);
                    make.top.equalTo(@20);
                }];
            }else if(self.isRotate && self.bottomContainerView.alpha == 1.0) {
                [self.lookBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self).offset(-10);
                    make.top.equalTo(self).offset(60);
                }];
            }else if(self.isRotate && self.bottomContainerView.alpha == 0.0) {
                [self.lookBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self).offset(-10);
                    make.top.equalTo(self).offset(25);
                }];
            }
    }];
}
-(void)isHideStatus:(BOOL)isHidden{
    if (!self.isRotate) return;
}
//时间显示转换
- (NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger m = time / 60;
    NSInteger s = (NSInteger)time % 60;
    NSString *stringtime = [NSString stringWithFormat:@"%02ld:%02ld",m, s];
    return stringtime;
}

-(void)islock{
    if (self.isLockBlock) {
        self.isLockBlock(self.lockScreenBtn.selected);
    }
}
-(PVVideoAuthentication *)videoAuthentication{
    if (!_videoAuthentication) {
        PVProductModel*  productModel = [[PVProductModel alloc]  init];
        productModel.payType = 1;
        productModel.provincePlayType = 1;
        productModel.code = self.playVideoModel.code;
        _videoAuthentication = [[PVVideoAuthentication alloc]  initVideoPVProductModel:productModel];
        _videoAuthentication.videoDistrict = self.videoDistrict;
        PV(pv)
        [_videoAuthentication  setPVVideoIsCrossCallBlock:^{
            if (pv.isRotate) {
                [pv screenBtnClicked];
            }
        }];
        [_videoAuthentication setPVVideoAuthenticationCallBlock:^(NSInteger type, BOOL isStop) {
            if (type == 2 && !isStop) {
                [pv videoprepareToPlay];
            }else if (type == 2 && isStop){
                [pv stopTimerVideoTool:7];
                [pv hideFlowBtnOrPlayBtnOrRepeatBtn:2];
                if ([pv.playViewDelegate respondsToSelector:@selector(pauseFirstPlayVideo)]) {
                    [pv.playViewDelegate pauseFirstPlayVideo];
                }
            }
        }];
    }
    return _videoAuthentication;
}

-(void)videoprepareToPlay{
    [self hideFlowBtnOrPlayBtnOrRepeatBtn:4];
    if (![self.player isPlaying]) {
        if ([self.playViewDelegate  respondsToSelector:@selector(startGifAnimate)]) {
            [self.playViewDelegate startGifAnimate];
        }
        if ([self.playViewDelegate  respondsToSelector:@selector(startPlayVideo)]) {
            [self.playViewDelegate startPlayVideo];
        }
        //准备播放
        [self.player prepareToPlay];
        [self startTimerVideoTool];
    }
}

-(void)hideFlowBtnOrPlayBtnOrRepeatBtn:(NSInteger)type{
    if (type == 1) {
        self.replayCenterBtn.hidden = self.flowPlayCenterBtn.hidden = true;
    }else if (type == 2){
        self.flowPlayCenterBtn.hidden = false;
        self.replayCenterBtn.hidden = true;
    }else if (type == 3){
        self.replayCenterBtn.hidden = false;
        self.flowPlayCenterBtn.hidden = true;
    }else if (type == 4){
        self.replayCenterBtn.hidden = self.flowPlayCenterBtn.hidden = true;
    }
}
-(void)setIsPilotPattern:(BOOL)isPilotPattern{
    _isPilotPattern = isPilotPattern;
    if (isPilotPattern) {//试播模式
        [self videoPause];
        [self hideFlowBtnOrPlayBtnOrRepeatBtn:4];
        self.pauseBtn.userInteractionEnabled = self.playBtn.userInteractionEnabled =
        self.lockScreenBtn.userInteractionEnabled =
        self.videoSlider.userInteractionEnabled =
        self.definitionBtn.userInteractionEnabled =
        self.televisionBtn.userInteractionEnabled = false;
        self.lockScreenBtn.selected = (self.isRotate == true) ? false : self.lockScreenBtn.selected;
        if ([self.playViewDelegate respondsToSelector:@selector(stopPlayVideo)]) {
            [self.playViewDelegate stopPlayVideo];
        }
        self.lookCenterLabel.hidden = self.lookCenterBtn.hidden = false;
        self.lookLabel.hidden = self.lookBtn.hidden = true;
    }else{//正常播放模式
        [self videoPlay];
        self.lookCenterLabel.hidden = self.lookCenterBtn.hidden = true;
         self.pauseBtn.userInteractionEnabled = self.playBtn.userInteractionEnabled = self.lockScreenBtn.userInteractionEnabled =
        self.definitionBtn.userInteractionEnabled =
        self.videoSlider.userInteractionEnabled = self.televisionBtn.userInteractionEnabled = true;
    }
}

///还没开始播放就把相关控件关了
-(void)closeViewUserInteractionEnabled{
  self.lockScreenBtn.userInteractionEnabled=self.playBtn.userInteractionEnabled = self.pauseBtn.userInteractionEnabled = self.videoSlider.userInteractionEnabled = false;
}
///开始播放就把相关控件开起了
-(void)openViewUserInteractionEnabled{
    self.lockScreenBtn.userInteractionEnabled=self.playBtn.userInteractionEnabled = self.pauseBtn.userInteractionEnabled = self.videoSlider.userInteractionEnabled = true;
}
@end
