//
//  SCBaseVideoPlayToolController.m
//  VideoDemo
//
//  Created by cara on 17/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseVideoPlayToolController.h"

@interface SCBaseVideoPlayToolController ()

@property (nonatomic, assign)BOOL isShortVideo;
@property (nonatomic, strong)UIView* shortSuperView;
@end

@implementation SCBaseVideoPlayToolController

- (void)viewDidLoad {
    [super viewDidLoad];

}


-(void)dealloc{
    
    
}

-(void)goPlayingPlayVideoModel:(PVPlayVideoModel*)playVideoModel  delegate:(id<VideoPlayerViewDelegate>)delegate{
    AppDelegate* appDelegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    [appDelegate stopBroadCastPlay:false];
    self.videoType = playVideoModel.type;
    self.orientation = UIInterfaceOrientationPortrait;
    self.playView = [[PlayView alloc]  initWithDelegate:delegate playVideoModel:playVideoModel];
    [self.view addSubview:self.playContainerView];
    [self.playContainerView addSubview:self.playView];
    [self.view addSubview:[ZFBrightnessView sharedBrightnessView]];
    CGFloat topMargin = (playVideoModel.type == 3 || playVideoModel.type == 5) ? self.scNavigationBar.sc_height : (kiPhoneX ? 24 : 0);
    [self.playContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view.mas_width).multipliedBy(9/16.0).priority(900);
        make.height.lessThanOrEqualTo(self.view).priority(UILayoutPriorityRequired);
    }];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.playContainerView);
    }];
    [[ZFBrightnessView sharedBrightnessView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(@155);
    }];
}


//播放表格中的段视频
-(void)goTableViewPlayVideoModel:(PVPlayVideoModel*)playVideoModel  delegate:(id<VideoPlayerViewDelegate>)delegate  superView:(UIView*)superView{
    self.isShortVideo = true;
    self.shortSuperView = superView;
    AppDelegate* appDelegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    [appDelegate stopBroadCastPlay:false];
    self.videoType = playVideoModel.type;
    self.orientation = UIInterfaceOrientationPortrait;
    self.playView = [[PlayView alloc]  initWithDelegate:delegate playVideoModel:playVideoModel];
    [superView addSubview:self.playContainerView];
    [self.playContainerView addSubview:self.playView];
    [self.view addSubview:[ZFBrightnessView sharedBrightnessView]];
    
    [self.playContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView);
        make.left.equalTo(superView);
        make.width.equalTo(superView);
        make.height.equalTo(superView.mas_width).multipliedBy(9/16.0).priority(900);
        make.height.lessThanOrEqualTo(superView).priority(UILayoutPriorityRequired);
    }];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.playContainerView);
    }];
    [[ZFBrightnessView sharedBrightnessView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(@155);
    }];
}
#pragma mark XYVideoPlayerViewDelegate

- (void)fullScreenWithPlayerView:(PlayControView *)videoPlayerView  isOrientation:(UIDeviceOrientation)orientation{
    if(orientation == UIDeviceOrientationPortrait){
        [self screenLandscapeChargeScreenPortrait];
        self.orientation = UIDeviceOrientationPortrait;
    }else if (orientation == UIDeviceOrientationLandscapeLeft){
        self.orientation = UIDeviceOrientationLandscapeLeft;
    }else if (orientation == UIDeviceOrientationLandscapeRight){
        self.orientation = UIDeviceOrientationLandscapeRight;
    }
    [self changeDirectionButtonAction];
    
    if (([self.playView.player isPlaying] || self.playView.player.currentPlaybackTime > 0) && !self.playView.playControView.isPilotPattern) {
        [self.playView.playControView startTimerVideoTool];
    }
}

-(void)screenLandscapeChargeScreenPortrait{
    
}

#pragma mark 屏幕旋转
-(void)changeDirectionButtonAction{
    if ( self.orientation != UIInterfaceOrientationPortrait) {//横屏
        if (self.videoType == 3 || self.videoType == 4 || self.videoType == 5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:false];
            self.playView.gifView.backBtn.hidden = false;
        }
        [self toOrientation:self.orientation];
        
//        NSLog(@"---x = %d-- width = %f  -----X = %f",kiPhoneX,CrossScreenWidth,CrossScreenWidth_X);
    }else{//竖屏
//        NSLog(@"-2122--x = %d-- width = %f  -----X = %f",kiPhoneX,CrossScreenWidth,CrossScreenWidth_X);

        if (self.videoType == 3 || self.videoType == 4 || self.videoType == 5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:false];
            self.playView.gifView.backBtn.hidden = true;
        }
        [self toOrientation:UIInterfaceOrientationPortrait];
    }
}

- (void)toOrientation:(UIInterfaceOrientation)orientation{
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) { return; }
    if (orientation != UIInterfaceOrientationPortrait) {
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self.playContainerView removeFromSuperview];
            [[ZFBrightnessView sharedBrightnessView] removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow addSubview:self.playContainerView];
            [self.playContainerView addSubview:[ZFBrightnessView sharedBrightnessView]];
            [self.playContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(CaraScreenH));
                make.height.equalTo(@(CaraScreenW));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
            [[ZFBrightnessView sharedBrightnessView] mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.playContainerView);
                make.width.height.equalTo(@155);
            }];
        }
    }else{
        [self.playContainerView removeFromSuperview];
        [[ZFBrightnessView sharedBrightnessView] removeFromSuperview];
        if(self.isShortVideo){
            [self.shortSuperView addSubview:self.playContainerView];
            [self.playContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.shortSuperView);
            }];
        }else{
            [self.view addSubview:self.playContainerView];
            bool isIphoneX = (self.scNavigationBar.sc_height == 88.0) ? true : false;
            CGFloat topMargin = (self.videoType == 3 || self.videoType == 5) ? self.scNavigationBar.sc_height : (isIphoneX ? 24 : 0);
            [self.playContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(topMargin));
                make.left.right.equalTo(self.view);
                make.height.equalTo(@(CaraScreenH*9/16));
            }];
        }
        [self.view addSubview:[ZFBrightnessView sharedBrightnessView]];
        [[ZFBrightnessView sharedBrightnessView] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo([UIApplication sharedApplication].keyWindow);
            make.width.height.equalTo(@155);
        }];
    }
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    
    // 获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    // 给你的播放视频的view视图设置旋转
    self.playContainerView.transform = CGAffineTransformIdentity;
    self.playContainerView.transform = [self getTransformRotationAngle:orientation];
    // 开始旋转
    [UIView commitAnimations];
}

/**
 * 获取变换的旋转角度
 * @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle:(UIInterfaceOrientation)orientation
{
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}


/** 播放器最外层容器*/
-(UIView *)playContainerView{
    if (!_playContainerView) {
        _playContainerView = [[UIView alloc]  init];
        _playContainerView.backgroundColor = [UIColor blackColor];
    }
    return _playContainerView;
}

-(BOOL)shouldAutorotate{
    return NO;
}
@end
