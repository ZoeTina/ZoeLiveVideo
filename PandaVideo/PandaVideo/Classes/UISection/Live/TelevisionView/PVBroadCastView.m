//
//  PVBroadCastView.m
//  PandaVideo
//
//  Created by cara on 17/7/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBroadCastView.h"
#import "UIButton+Gradient.h"
#import "AppDelegate.h"
#import "PVRegionFlowController.h"
#import "PVOrderCenterViewController.h"

@interface PVBroadCastView()

@property (nonatomic, copy)PVBroadCastViewCallBlock callBlock;

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (nonatomic, assign)BOOL isScanle;
@property (nonatomic, assign)BOOL isScanles;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (nonatomic, assign)CGAffineTransform transform1;
@property (nonatomic, assign)CGAffineTransform transform2;
@property (nonatomic, assign)CGAffineTransform transform3;
@property (nonatomic, assign)CGAffineTransform transform4;

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderLabelCenterYConstraint;

@end


@implementation PVBroadCastView


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWordSatus:) name:NetworkReachabilityStatus object:nil];
    self.flowPlayCenterBtn.hidden = true;
    self.flowPlayCenterBtn.clipsToBounds = true;
    self.flowPlayCenterBtn.layer.cornerRadius = 16.0f;
    NSArray* colors = @[[UIColor sc_colorWithHex:0x00BFF5],[UIColor sc_colorWithHex:0x00D6E7]];
    [self.flowPlayCenterBtn gradientButtonWithSize:CGSizeMake(100, 32) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];

    self.FMPlayOrStopBtn.layer.borderWidth = 1.0f;
    self.FMPlayOrStopBtn.layer.borderColor = [UIColor sc_colorWithHex:0x2AB4E4].CGColor;
    self.FMPlayOrStopBtn.layer.cornerRadius = 18;
    
    self.oneView.clipsToBounds = self.twoView.clipsToBounds = self.threeView.clipsToBounds = self.fourView.clipsToBounds = true;
    self.oneView.layer.cornerRadius = self.fourView.layer.cornerRadius = 4.0f;
    self.twoView.layer.cornerRadius = self.threeView.layer.cornerRadius = 5.0f;
    
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(gestureClicked)];
    self.centerImageView.userInteractionEnabled = true;
    [self.centerImageView addGestureRecognizer:gesture];

    UIImageView* effectImageView = [[UIImageView alloc]  init];
    effectImageView.image = [UIImage imageNamed:@"live_fm_bg"];
    [self insertSubview:effectImageView atIndex:0];
    [effectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];

    UIVibrancyEffect *viBrancyeffect = [UIVibrancyEffect effectForBlurEffect:effect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:viBrancyeffect];

    [effectView.contentView addSubview:vibrancyEffectView];
    [effectImageView addSubview:effectView];

    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    self.orderBtn.clipsToBounds = true;
    self.orderBtn.layer.cornerRadius = 16.0f;
    self.orderBtn.adjustsImageWhenHighlighted = false;
    NSArray* orderBtnColors = @[[UIColor sc_colorWithHex:0x2BBCF0],[UIColor sc_colorWithHex:0x00D3E4]];
    [self.orderBtn gradientButtonWithSize:CGSizeMake(119, 32) colorArray:orderBtnColors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
}
- (IBAction)orderBtnClicked {
    PVOrderCenterViewController* vc = [[PVOrderCenterViewController alloc]  init];
    [self.jumpVC.navigationController pushViewController:vc animated:true];
}

-(void)netWordSatus:(NSNotification*)notification{
    if (![self isShowingOnKeyWindow] || self.hidden)return;
    NSInteger status = ((NSNumber*)notification.userInfo[@"status"]).integerValue;
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (status == AFNetworkReachabilityStatusReachableViaWWAN && [appDelegate.broadCastPlayer isPlaying]) {
        [appDelegate.broadCastPlayer pause];
        self.isDispLayAnimate = false;
        //            pv.centerImageView.userInteractionEnabled = false;
        self.FMPlayOrStopBtn.selected = true;
        PVRegionFlowController* flowVC = [PVRegionFlowController presentPVRegionFlowController:@"非WiFi环境,继续播放将消耗您的数据流量,是否继续播放?" type:2];
        [flowVC setPVRegionFlowControllerCallBlock:^(NSInteger type,BOOL isStop) {
            if (type == 2 && !isStop) {
                self.flowPlayCenterBtn.hidden = true;
                self.isDispLayAnimate = true;
                [appDelegate.broadCastPlayer  play];
                self.FMPlayOrStopBtn.selected = false;
                self.centerImageView.userInteractionEnabled = true;
            }else if (type == 2 && isStop){
                self.flowPlayCenterBtn.hidden = false;
                self.isDispLayAnimate = false;
                [appDelegate.broadCastPlayer pause];
            }
        }];
    }else if (status == AFNetworkReachabilityStatusReachableViaWiFi && appDelegate.broadCastPlayer.currentPlaybackTime > 0.0 && ![appDelegate.broadCastPlayer isPlaying]){
        [appDelegate.broadCastPlayer play];
        self.isDispLayAnimate = true;
        self.centerImageView.userInteractionEnabled = true;
        self.FMPlayOrStopBtn.selected = false;
    }
}

-(void)setIsDispLayAnimate:(BOOL)isDispLayAnimate{
    self.oneView.transform = CGAffineTransformIdentity;
    self.twoView.transform = CGAffineTransformIdentity;
    self.threeView.transform = CGAffineTransformIdentity;
    self.fourView.transform = CGAffineTransformIdentity;
    _isDispLayAnimate = isDispLayAnimate;
    if (isDispLayAnimate) {
        self.isScanle = self.isScanles = false;
        [self startViewAnimate];
        [self startViewAnimates];
    }
}
-(void)startViewAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        [self viewAnimate];
    } completion:^(BOOL finished) {
        if([self isShowingOnKeyWindow] && self.isDispLayAnimate){
            [self startViewAnimate];
        }else{
            _isDispLayAnimate = false;
        }
    }];
}
-(void)startViewAnimates{
    [UIView animateWithDuration:0.5 animations:^{
        [self viewAnimates];
    } completion:^(BOOL finished) {
        if([self isShowingOnKeyWindow] && self.isDispLayAnimate){
            [self startViewAnimates];
        }else{
            _isDispLayAnimate = false;
        }
    }];
}

-(void)setAuthenticationType:(NSInteger)authenticationType{
    _authenticationType = authenticationType;
    if (authenticationType == 2) {
        self.orderLabelCenterYConstraint.constant = 0;
        self.orderBtn.hidden = true;
        self.orderLabel.text = @"此频道紧在四川省内播放";
    }else if (authenticationType == 6){
        self.orderLabelCenterYConstraint.constant = -20;
        self.orderBtn.hidden = false;
        self.orderLabel.text = @"熊猫视频付费影片，观看完整版请订购产品包";
    }
}


-(void)viewAnimate{
    if (!self.isScanle) {
        self.isScanle = true;
        self.oneView.transform = CGAffineTransformScale(self.oneView.transform, 0.5, 0.5);
        self.fourView.transform = CGAffineTransformScale(self.fourView.transform, 0.5, 0.5);
    }else{
        self.isScanle = false;
        self.oneView.transform = CGAffineTransformScale(self.oneView.transform, 2.0, 2.0);
        self.fourView.transform = CGAffineTransformScale(self.fourView.transform, 2.0, 2.0);
    }
}

-(void)viewAnimates{
    if (!self.isScanles) {
        self.isScanles = true;
        self.twoView.transform = CGAffineTransformScale(self.twoView.transform, 0.5, 0.5);
        self.threeView.transform = CGAffineTransformScale(self.threeView.transform, 0.5, 0.5);
    }else{
        self.isScanles = false;
        self.twoView.transform = CGAffineTransformScale(self.twoView.transform, 2.0, 2.0);
        self.threeView.transform = CGAffineTransformScale(self.threeView.transform, 2.0, 2.0);
    }
}

/** 动画执行2 */
-(void)viewAnimate2{
    if (!self.isScanle) {
        self.isScanle = YES;
        self.oneView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.fourView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.twoView.transform = CGAffineTransformMakeScale(0.25, 0.25);
        self.threeView.transform = CGAffineTransformMakeScale(0.25, 0.25);
    }else{
        self.isScanle = NO;
        self.oneView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.fourView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.twoView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.threeView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
}


-(void)setPVBroadCastViewCallBlock:(PVBroadCastViewCallBlock)block{
    self.callBlock = block;
    
}
-(void)gestureClicked{
    self.FMPlayOrStopBtn.selected = !self.FMPlayOrStopBtn.selected;
    if (self.callBlock) {
        self.callBlock(self.FMPlayOrStopBtn.selected);
    }
}
- (IBAction)flowPlayCenterBtnClicked {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.orderView.hidden = true;
    self.flowPlayCenterBtn.hidden = true;
    IJKFFOptions* options = [[IJKFFOptions alloc]  init];
    IJKFFMoviePlayerController* player = [[IJKFFMoviePlayerController alloc] initWithContentURL:appDelegate.playVideoModel.url withOptions:options];
    appDelegate.broadCastPlayer = player;
    if (![player isPlaying]) {
        [player prepareToPlay];
        self.FMPlayOrStopBtn.selected = false;
    }
    self.isDispLayAnimate = true;    
}
@end
