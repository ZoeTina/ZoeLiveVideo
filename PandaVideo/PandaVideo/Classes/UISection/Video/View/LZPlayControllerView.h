//
//  LZPlayControllerView.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "PVSlider.h"
#import "SCButton.h"

// 横屏选择礼物画板
//#import "PVSendGiftView.h"
#import "PVPresentView.h"
#import "PVGiftsListModel.h"
#import "PVGiftCell.h"

typedef enum {
    
    LiveInteractiveViewTypeVideoPlayer  = 1, // 视频播放
    LiveInteractiveViewTypeLivePlayer   = 2, // 直播视频
}LiveInteractiveShowView;

typedef void(^IsLockBlock)(BOOL);

@class LZPlayControllerView;

@protocol LZVideoPlayerViewDelegate <NSObject>

@optional

/** 全屏切换 */
- (void) fullScreenWithPlayerViews:(LZPlayControllerView *)videoPlayerView isOrientations:(UIDeviceOrientation)orientation;

/** 开始播放 */
-(void) startPlayVideo;
/** 播放暂停 */
-(void) pausePlayVideo;
/** 播放停止 */
-(void) stopPlayVideo;
/** 锁屏切换 */
-(void) lockScreen:(BOOL)isLock;
/** 返回事件 */
- (void) backToBeforeVC;
/** 发弹幕  */
-(void) delegatePublishBarrageBtnClicked;
/** 弹幕    */
-(void) delegateBarrageBtnClicked:(UIButton*)btn;
/** 分享(横屏) */
-(void) delegateShareBtnClicked;
/** 分享(竖屏) */
-(void) delegateVShareBtnClicked;
/** 电视 */
-(void) delegateTeleversionBtnClicked;
/** 更多 */
-(void) delegateMoreBtnClicked;
/** 清晰度 */
-(void) delegateDefinitionBtnClicked;


/** 全屏选择礼物按钮 */
-(void)delegateFullScureenBtnClicked:(UIButton *)btn;


/** 点赞 */
-(void)delegateFullScreenToolsBtnClicked:(UIButton*)btn;

@end

@interface LZPlayControllerView : UIView

@property (nonatomic, weak) id<LZVideoPlayerViewDelegate>delegate;
@property (nonatomic, weak) id<LZVideoPlayerViewDelegate>playerViewDelegate;
@property (atomic, weak) id <IJKMediaPlayback> player;

/** 进度条 */
@property (nonatomic, strong) PVSlider          *videoSlider;
/** 当前播放时间 */
@property (nonatomic, strong) UILabel           *currentTimeLabel;
/** 暂停按钮 */
@property (nonatomic, strong) UIButton          *pauseBtn;
/** 播放按钮 */
@property (nonatomic, strong) UIButton          *playBtn;
/** 当前播放时间 */
@property (nonatomic, assign) CGFloat           currentTime;
/** 总时长 */
@property (nonatomic, assign) CGFloat           totalTime;
/** 是否全屏 */
@property (nonatomic, assign) BOOL              isRotate;
/** 定时器更新label */
@property (nonatomic, strong) CADisplayLink     *link;
/** 是否锁屏 */
@property (nonatomic, copy)   IsLockBlock       isLockBlock;
/** 底部工具栏容器(视频) */
@property (nonatomic, strong) UIView            *bottomContainerView;
/** 顶部工具栏容器(视频) */
@property (nonatomic, strong) UIView            *topContainerView;
/** 锁屏按钮 */
@property (nonatomic, strong) UIButton          *lockScreenBtn;
/** 回看1, 直播2 */
@property (nonatomic, assign) NSInteger         type;
/** 重播按钮 */
@property (nonatomic, strong) SCButton          *replayCenterBtn;
/** 流量播放按钮 */
@property (nonatomic, strong) UIButton          *flowPlayCenterBtn;
/** 记录上一次的播放时间 */
@property (nonatomic, assign) NSTimeInterval    lastPlayerTime;
///记录上次网络的状况
@property (nonatomic, assign)AFNetworkReachabilityStatus recordStatus;
/** 当前播放的视频标题 */
@property (nonatomic, copy)NSString *videoTitleName;
/** 当前播放是否为播放模式 */
@property (nonatomic, assign) BOOL  isPilotPattern;
/** 视频标题 */
@property (nonatomic, strong)UILabel   *titleNameLabel;
/** 弹幕按钮 */
@property (nonatomic, strong) UIButton  *barrageBtn;

/** 视频第一次播放 */
-(void)videoFirstPlayer;
-(void)videoFirstPlay;
/** 视频播放 */
- (void) videoPlay;
/** 视频暂停 */
- (void) videoPause;
/** 视频停止 */
- (void) videoStop;
/** 工具条记时开始 */
- (void) startTimerVideoTool;
/** 工具条记时结束 */
- (void) stopTimerVideoTool:(NSInteger)type;
/** 当前视频播放完毕 */
- (void) videoPlayOver;
/** 控制中心按钮的显示 */
- (void) hideFlowBtnOrPlayBtnOrRepeatBtn:(NSInteger)type;
/** 旋转 */
- (void) screenBtnClicked;
/** 时间显示转换 */
- (NSString *) stringWithTime:(NSTimeInterval)time;

- (instancetype) initWithType:(NSInteger)type;

- (void)hiddenMoreButton;
//显示连击动画区域
@property (nonatomic, strong) PVPresentView *presentViews;
//礼物数组
@property (nonatomic, strong) NSMutableArray *giftArr;
//礼物数组
@property (nonatomic, strong) NSMutableArray *itemModelArray;
//连击样式视图
@property (nonatomic, strong) PVGIftCell *giftCell;

/** 礼物模型 */
@property(nonatomic,strong) PVGiftsListModel *lzListModel;

@end
