//
//  LZBaseVideoPlayToolController.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "LZBaseVideoPlayToolController.h"

@interface LZBaseVideoPlayToolController ()

@property (nonatomic, assign) NSInteger                 type;
@property (nonatomic, assign) BOOL                      isShortVideo;
@property (nonatomic, strong) UIView                    *shortSuperView;
@property (nonatomic, assign) UIInterfaceOrientation    orientation;

@end

@implementation LZBaseVideoPlayToolController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.scNavigationBar.hidden = YES;
}

-(void)dealloc{
    
    
}

-(void)startPlaying:(NSURL*)url type:(NSInteger)type delegate:(id<LZVideoPlayerViewDelegate>)delegate{
    
    // 停止广播
    AppDelegate* appDelegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    [appDelegate stopBroadCastPlay:false];
    
    self.type = type;
    self.orientation = UIInterfaceOrientationPortrait;
    self.playerView = [[LZPlayerView alloc] initWithDelegate:delegate Url:url Type:type];
//    self.playerView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.playContainerView];
    [self.playContainerView addSubview:self.playerView];

    [self.view addSubview:[ZFBrightnessView sharedBrightnessView]];
    
    CGFloat topMargin = (type == 3 || type == 5) ? self.scNavigationBar.sc_height : lz_kiPhoneX(0);
    YYLog(@"topMargin -- %f",topMargin);
//    self.playContainerView.backgroundColor = [UIColor cyanColor];
    [self.playContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(lz_kiPhoneX(0)));
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view.mas_width).multipliedBy(9/16.0).priority(900);
        make.height.lessThanOrEqualTo(self.view).priority(UILayoutPriorityRequired);
    }];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.playContainerView);
    }];
    [[ZFBrightnessView sharedBrightnessView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(@155);
    }];
}
#pragma mark XYVideoPlayerViewDelegate
- (void)fullScreenWithPlayerViews:(LZPlayControllerView *)videoPlayerView isOrientations:(UIDeviceOrientation)orientation{
    
    if(orientation == UIDeviceOrientationPortrait){
        self.orientation = UIDeviceOrientationPortrait;
    }else if (orientation == UIDeviceOrientationLandscapeLeft){
        self.orientation = UIDeviceOrientationLandscapeLeft;
    }else if (orientation == UIDeviceOrientationLandscapeRight){
        self.orientation = UIDeviceOrientationLandscapeRight;
    }
    [self changeDirectionButtonAction];
    
    if ([self.playerView.player isPlaying] || self.playerView.player.currentPlaybackTime > 0) {
        [self.playerView.playControllerView startTimerVideoTool];
    }

}

#pragma mark 屏幕旋转
-(void)changeDirectionButtonAction{
    
    YYLog(@"self.orientation -- %ld",(long)self.orientation);
    if (self.orientation != UIInterfaceOrientationPortrait) {//横屏
        if (self.type == 1 || self.type == 2) {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        }
        [self toOrientation:self.orientation];
    }else{//竖屏
        if (self.type == 1 || self.type == 2) {
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        }
        [self toOrientation:UIInterfaceOrientationPortrait];
    }
}

//获取屏幕改变事件
- (void)changeDirectionWhenCurrentIsFull:(BOOL)isFull{}

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
                make.width.equalTo(@(YYScreenHeight));
                make.height.equalTo(@(YYScreenWidth));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
            [[ZFBrightnessView sharedBrightnessView] mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.playContainerView);
                make.width.height.equalTo(@155);
            }];
        }
          [self changeDirectionWhenCurrentIsFull:NO];
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
//            CGFloat topMargin = (self.type == 1 || self.type == 2) ? 0 : 0;
            bool isIphoneX = (self.scNavigationBar.sc_height == 88.0) ? true : false;
            CGFloat topMargin = (self.type == 3 || self.type == 5) ? self.scNavigationBar.sc_height : (isIphoneX ? 24 : 0);

            [self.playContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(topMargin));
                make.left.right.equalTo(self.view);
                make.height.equalTo(@(YYScreenHeight*9/16));
            }];
        }
        [self.view addSubview:[ZFBrightnessView sharedBrightnessView]];
        [[ZFBrightnessView sharedBrightnessView] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo([UIApplication sharedApplication].keyWindow);
            make.width.height.equalTo(@155);
        }];
         [self changeDirectionWhenCurrentIsFull:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
