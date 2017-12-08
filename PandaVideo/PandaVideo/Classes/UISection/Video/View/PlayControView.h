//
//  PlayControView.h
//  VideoDemo
//
//  Created by cara on 17/7/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "PVVideoAuthentication.h"
#import "PVSlider.h"
#import "SCButton.h"
#import "PVTelevisionCloudView.h"
#import "PVPlayVideoModel.h"

typedef void(^IsLockBlock)(BOOL);

@class PlayControView;

@protocol VideoPlayerViewDelegate <NSObject>

@optional

//全屏切换
- (void)fullScreenWithPlayerView:(PlayControView *)videoPlayerView  isOrientation:(UIDeviceOrientation)orientation;
//开始播放
-(void)startPlayVideo;
//播放暂停
-(void)pausePlayVideo;
//播放停止
-(void)stopPlayVideo;
//4g暂停
-(void)pauseFirstPlayVideo;
//锁屏切换
-(void)lockScreen:(BOOL)isLock;
//返回
- (void)backToBeforeVC;
//发弹幕
-(void)delegatePublishBarrageBtnClicked;
//弹幕
-(void)delegateBarrageBtnClicked:(UIButton*)btn;
//电视
-(void)delegateTeleversionBtnClicked;
//分享
-(void)delegateShareBtnClicked;
//更多
-(void)delegateMoreBtnClicked;
//下一集
-(void)delegateNextBtnClicked;
//清晰度
-(void)delegateDefinitionBtnClicked;
//选集,频道
-(void)delegateAnthologyBtnClicked;
//节目单
-(void)delegateProgramBtnClicked;
///电视云
-(void)delegateTelevisionPlayCloud:(BOOL)isTelevisionCloud;
///开启gif动画
-(void)startGifAnimate;
///停止gif动画
-(void)stopGifAnimate;

@end


@interface PlayControView : UIView

@property (nonatomic, weak) id<VideoPlayerViewDelegate>delegate;
@property (nonatomic, weak) id<VideoPlayerViewDelegate>playViewDelegate;
@property (atomic, weak) id <IJKMediaPlayback> player;
///进度条
@property(nonatomic, strong)PVSlider* videoSlider;
/** 清晰度按钮*/
@property (nonatomic, strong)UIButton*  definitionBtn;
///当前播放时间
@property(nonatomic, strong)UILabel* currentTimeLabel;
///总播放时间
@property(nonatomic, strong)UILabel* totalTimeLabel;
///暂停按钮
@property(nonatomic, strong)UIButton* pauseBtn;
///播放按钮
@property(nonatomic, strong)UIButton* playBtn;
///当前播放时间
@property (nonatomic, assign)CGFloat currentTime;
///总时长
@property (nonatomic, assign)CGFloat totalTime;
///是否全屏
@property (assign, nonatomic) BOOL isRotate;
///定时器更新label
@property (nonatomic, strong) CADisplayLink            *link;
///是否锁屏
@property (nonatomic, copy)IsLockBlock isLockBlock;
///底部工具栏容器
@property(nonatomic, strong)UIView* bottomContainerView;
///顶部工具栏容器
@property(nonatomic, strong)UIView* topContainerView;
/** 锁屏按钮 */
@property (nonatomic, strong)UIButton   *lockScreenBtn;
/** 重播按钮 */
@property (nonatomic, strong)SCButton   *replayCenterBtn;
/** 流量播放按钮 */
@property (nonatomic, strong)UIButton   *flowPlayCenterBtn;
/** 单集1,多集 2,直播3, 短视频4,回看5*/
@property (nonatomic, assign)NSInteger  type;
/** 授权工具类 */
@property(nonatomic, strong)PVVideoAuthentication* videoAuthentication;
/** 当前播放的视频标题 */
@property(nonatomic, copy)NSString* videoTitleName;
/** 当前播放是否为播放模式 */
@property(nonatomic, assign)BOOL  isPilotPattern;
/** 电视云view */
@property(nonatomic, strong)PVTelevisionCloudView*   televisionCloudView;
/** 地方范围播放 */
@property(nonatomic, copy)NSString*  videoDistrict;
/** 地方范围播放 */
@property(nonatomic, strong)PVPlayVideoModel* playVideoModel;

///控制层定时器
-(void)startTime;
///停止定时器
-(void)stopTime;
///视频第一次播放
-(void)videoFirstPlay;
///视频播放
-(void)videoPlay;
///视频暂停
-(void)videoPause;
///视频停止
-(void)videoStop;
///工具条记时开始
-(void)startTimerVideoTool;
///工具条记时结束
-(void)stopTimerVideoTool:(NSInteger)type;
///当前视频播放完毕
-(void)videoPlayOver;
///控制中心按钮的显示
-(void)hideFlowBtnOrPlayBtnOrRepeatBtn:(NSInteger)type;
//时间显示转换
- (NSString *)stringWithTime:(NSTimeInterval)time;
//旋转
-(void)screenBtnClicked;
///还没开始播放就把相关控件关了
-(void)closeViewUserInteractionEnabled;
///开始播放就把相关控件开起了
-(void)openViewUserInteractionEnabled;
///监听设备横向
-(void)addDeviceOrientation;
///移除设备监听
-(void)removeDeviceOrientation;
///全屏返回
-(void)backBtnClicked;

-(instancetype)initWithType:(NSInteger)type;

@end
