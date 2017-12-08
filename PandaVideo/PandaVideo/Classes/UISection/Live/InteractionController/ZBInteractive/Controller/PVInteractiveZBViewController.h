//
//  PVInteractiveZBViewController.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCBaseViewController.h"
#import "LZBaseVideoPlayToolController.h"
#import "PVInteractionInfoView.h"
#import "LZPlayerView.h"
/** 键盘 */
#import "ChatKeyBoardMacroDefine.h"
#import "ChatKeyBoard.h"

#import "PVVideoMoreView.h"
#import "PVVideoShareView.h"
#import "PVVideoDefinitionView.h"
#import "PVVideoDemandAnthologyController.h"
#import "PVBarrageView.h"
#import "PVVideoMoreView.h"
#import "LZPlayControllerView.h"
// 横屏选择礼物画板
#import "PVFullScreenGiftChoiceView.h"

// 竖屏选择礼物画板
#import "PVSendGiftView.h"
#import "PVPresentView.h"
#import "PVPresentModel.h"
#import "PVGiftCell.h"
#import "PVFullViewController.h"

@interface PVInteractiveZBViewController : LZBaseVideoPlayToolController

- (id)initDictionary:(NSDictionary *) dictionary;

/// 直播或视频显示容器(包含简介)
@property (nonatomic, strong) UIView                *videoContainerView;
/// 直播view容器(播放器view)
@property (nonatomic, strong) LZPlayerView          *playerContainerView;
/// 控制层
@property (nonatomic, strong) LZPlayControllerView  *playerControlView;
/** 聊天键盘 */
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;



/** 更多 */
@property(nonatomic, strong) PVVideoMoreView *videoMoreView;
/** 分享 */
@property(nonatomic, strong) PVVideoShareView *videoShareView;
/** 清晰度 */
@property(nonatomic, strong) PVVideoDefinitionView *videoDefinitionView;
/** 选集 */
@property(nonatomic, strong) PVVideoDemandAnthologyController *videoDemandAnthologyController;
/** 弹幕 */
@property(nonatomic, strong) PVBarrageView *barrageView;
/** 弹幕数据源 */
@property(nonatomic, strong) NSMutableArray  *messagePool;
/** 遮盖 */
@property(nonatomic, strong) UIButton *coverBtn;
/** 全屏暂停提示 */
@property (nonatomic, strong) UILabel       *tipsLabel;

/** 全屏送礼物*/
@property(nonatomic, strong) PVFullScreenGiftChoiceView *fullScreenGiftChoiceView;

//显示连击动画区域(竖屏)
@property (nonatomic, strong) PVPresentView *presentView;
//显示连击动画区域(横屏)
@property (nonatomic, strong) PVPresentView *presentViews;
//礼物数组
@property (nonatomic, strong) NSMutableArray *giftArr;
//礼物数组
@property (nonatomic, strong) NSMutableArray *itemModelArray;
//连击样式视图
@property (nonatomic, strong) PVGIftCell *giftCell;

///请求数据url
@property (nonatomic, copy)NSString* menuUrl;

@end
