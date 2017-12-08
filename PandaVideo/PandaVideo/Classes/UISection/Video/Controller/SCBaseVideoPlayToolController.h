//
//  SCBaseVideoPlayToolController.h
//  VideoDemo
//
//  Created by cara on 17/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "PlayControView.h"
#import "UIView+Extension.h"
#import "ZFBrightnessView.h"
#import "PlayView.h"
#import "SCBaseViewController.h"

#define CaraScreenH [UIScreen mainScreen].bounds.size.height
#define CaraScreenW [UIScreen mainScreen].bounds.size.width

@interface SCBaseVideoPlayToolController : SCBaseViewController

@property (nonatomic, assign)NSInteger videoType;
///存放视频view容器
@property (nonatomic, strong)UIView* playContainerView;
///视频view
@property (nonatomic, strong)PlayView* playView;
///横屏还是竖屏
@property (nonatomic, assign)UIInterfaceOrientation  orientation;

///切换横竖屏
-(void)changeDirectionButtonAction;

// 播放视频
-(void)goPlayingPlayVideoModel:(PVPlayVideoModel*)playVideoModel  delegate:(id<VideoPlayerViewDelegate>)delegate;

//播放表格中的段视频
-(void)goTableViewPlayVideoModel:(PVPlayVideoModel*)playVideoModel  delegate:(id<VideoPlayerViewDelegate>)delegate  superView:(UIView*)superView;

//有横屏变成竖屏
-(void)screenLandscapeChargeScreenPortrait;

@end
