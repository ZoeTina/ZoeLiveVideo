//
//  LZBaseVideoPlayToolController.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCBaseViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "LZPlayControllerView.h"
#import "UIView+Extension.h"
#import "ZFBrightnessView.h"
#import "LZPlayerView.h"

@interface LZBaseVideoPlayToolController : SCBaseViewController

/** 存放视频view容器 */
@property (nonatomic, strong) UIView *playContainerView;
/** 视频view */
@property (nonatomic, strong) LZPlayerView *playerView;


/** 播放视频 */ 
-(void)startPlaying:(NSURL*)url type:(NSInteger)type  delegate:(id<LZVideoPlayerViewDelegate>)delegate;

//获取屏幕改变事件
- (void)changeDirectionWhenCurrentIsFull:(BOOL)isFull;

@end
