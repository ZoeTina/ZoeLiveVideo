//
//  PVShakeViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVShakeViewController.h"
#import "ShakeOperation.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PVTeleplayListViewController.h"
#import "PVInviteFamilyViewController.h"

#define kDegreesToRadian(x) (M_PI * (x) / 180.0 )
#define kRadianToDegrees(radian) (radian* 180.0 )/(M_PI)

@interface PVShakeViewController () <ShakeOperationDegate,LZPopupViewDelegate>
{
    // NO为结束状态
    BOOL shakState;
}

@property (weak, nonatomic) IBOutlet UIView *shakeContanierView;
@property (weak, nonatomic) IBOutlet UIButton *programBtn;

@property(nonatomic,strong)NSOperationQueue *queue;
//摇一摇model
@property(nonatomic,strong)ShakeOperation *Operation;

@end

@implementation PVShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  initValue];
    
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"摇一摇";    
}

-(void)initValue{
    shakState = NO;
    self.queue =[[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount=1;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    PVInviteFamilyViewController *view = [[PVInviteFamilyViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];

//    NSDictionary *dictionary = @{@"title":@"授权位置",
//                                 @"content":@"打开位置授权，享更多特推影片",
//                                 @"btnText":@"好",
//                                 @"imageBtn":kGetImage(@"guide_img_pop3"),
//                                 @"viewType":@(LZViewTypeLocation)};
 

    
//    NSDictionary *dictionary = @{@"title":@"软件更新",
//                                 @"content":@"·软件更新软件更新软件更新软件更新\n·软新软件更新软件更新\n·软件更新",
//                                 @"btnText":@"好",
//                                 @"imageBtn":kGetImage(@"guide_img_pop2"),
//                                 @"viewType":@(LZViewTypeUpdate)};
 
//    NSDictionary *dictionary = @{@"title":@"开启通知",
//                                 @"content":@"1.活动，好片，精彩内容不错过\n2.红包抢不停",
//                                 @"btnText":@"好",
//                                 @"imageBtn":kGetImage(@"guide_img_pop1"),
//                                 @"viewType":@(LZViewTypeNotice)};

//LZViewTypeLocation:
//    
//LZViewTypeUpdate:
//    
//LZViewTypeNotice:
//    [self presentPopupViewController:dictionary viewType:LZViewTypeLocation];
}

/** 需要弹出的窗口 */
- (void) presentPopupViewController:(NSDictionary *) dictionary viewType:(LZViewType) viewType{
    
    LZMessagePopupViewController *viewController = [[LZMessagePopupViewController alloc] initWithNibName:@"LZMessagePopupViewController" bundle:nil];
    viewController.titleStr  = dictionary[@"title"];
    viewController.messageStr = dictionary[@"content"];
    viewController.btnTxtStr = dictionary[@"btnText"];
    viewController.lzViewType = viewType;
    viewController.imageBtn = dictionary[@"imageBtn"];
    viewController.delegate = self;
    [self presentPopupViewController:viewController animationType:LZPopupViewAnimationSlideTopBottom];
}


- (void)cancelButtonClicked:(LZMessagePopupViewController *)viewController
{
    [self dismissPopupViewControllerWithanimationType:LZPopupViewAnimationFade];
}

- (void)dismissedButtonClicked:(LZMessagePopupViewController *)viewController
{
    [self dismissPopupViewControllerWithanimationType:LZPopupViewAnimationFade];
}

#pragma mark - 摇动

/**
 *  摇动开始
 */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    self.shakeContanierView.hidden = false;
    self.programBtn.hidden = true;
    if (motion == UIEventSubtypeMotionShake) {
        if (shakState) {
            return;
        }
        if (self.Operation) {
            self.Operation.cancelSelf = YES;
            self.Operation.delegate = nil;
            self.Operation = nil;
        }
        for (ShakeOperation *op in self.queue.operations) {
            op.cancelSelf = YES;
            op.delegate = nil;
        }
        [self.queue cancelAllOperations];
    }
}

/**
 *  摇动结束
 */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self ShakeShakeStart];
    }
    
}
/**
 *  摇动取消
 */
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake) return;
//        [self ShakeShakeStart];
}

-(void)ShakeShakeStart{
    if (shakState) {
        return;
    }
    ShakeOperation *op = [[ShakeOperation alloc]init];
    op.cancelSelf = NO;
    op.time = 0.15;
    op.delegate = self;
    [self.queue addOperation:op];
    self.Operation = op;
}

#pragma mark 开始摇一摇  线程的代理
-(void)startShakeAnimate{
    [self.queue cancelAllOperations];
    if (shakState) return;
    [self sharkImgViewStartShark];
}

-(void)sharkImgViewStartShark{
    shakState = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self sharkImgViewTrans:18 withtime:0.6];
    });
}

-(void)sharkImgViewTrans:(float)angle withtime:(float)time{
    __weak __typeof(self)wself = self;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(-angle * (M_PI /180.0f));
    [UIView animateWithDuration:(time/4) animations:^{
        self.shakeContanierView.transform = endAngle;
    } completion:^(BOOL finished) {
        [wself sharkImgViewTrans1:angle withtime:time];
    }];
}
-(void)sharkImgViewTrans1:(float)angle withtime:(float)time{
    __weak __typeof(self)wself = self;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI /180.0f));
    [UIView animateWithDuration:(time/2) animations:^{
        self.shakeContanierView.transform = endAngle;
    } completion:^(BOOL finished) {
        [wself sharkImgViewTrans2:angle withtime:time];
    }];
}
-(void)sharkImgViewTrans2:(float)angle withtime:(float)time{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(0);
    __weak __typeof(self)wself = self;
    [UIView animateWithDuration:(time/4) animations:^{
        self.shakeContanierView.transform = endAngle;
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself EndShakeAnimate];
        });
    }];
}
#pragma mark 结束动画回调事件
-(void)EndShakeAnimate{
    self.shakeContanierView.hidden = true;
    self.programBtn.hidden = false;
    sleep(3);
    shakState = NO;
    ///发送网络请求
   // [self sharkSharkDataNetWorking];

//    if (1) {
//        shakState = NO;
//    }else{
//    }
}
@end
