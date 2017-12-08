//
//  PlayView.h
//  VideoDemo
//
//  Created by cara on 17/7/19.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "PlayControView.h"
#import "PVGifView.h"

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};


typedef NS_ENUM(NSInteger,DScreenDirection) {
    DScreenDirectionHorizontal,//横屏
    DScreenDirectionVertical,  //竖屏
};

@interface PlayView : UIView


@property (atomic, strong) NSURL *url;
@property (nonatomic, strong)PlayControView* playControView;
@property (atomic, retain) id <IJKMediaPlayback> player;
@property (nonatomic, assign) DScreenDirection      screenDirection;
//第一次加载动画
@property (nonatomic, strong)PVGifView* gifView;
//版权问题
@property(nonatomic, assign)BOOL isCopyRight;
///是否为续播
@property(nonatomic, copy)NSString* continuePlayVideoStatus;
/** 播放资源model*/
@property (nonatomic, strong)PVPlayVideoModel* playVideoModel;

-(instancetype)initWithDelegate:(id<VideoPlayerViewDelegate>)delegate playVideoModel:(PVPlayVideoModel*)playVideoModel;
//切换当前播放的内容
- (void)changeCurrentplayerItemWithPlayVideoModel:(PVPlayVideoModel*)playVideoModel;

@end
