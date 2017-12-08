//
//  PVBarrageView.h
//  PandaVideo
//
//  Created by Ensem on 2017/11/9.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PVBarrageProtocol.h"
@class UIView;

typedef NS_ENUM(NSUInteger, PVBarrageAnimationState) {
    PVBarrageAnimationState_stop,
    PVBarrageAnimationState_playing,
    PVBarrageAnimationState_pause,
};

@class PVBarrageView;

@protocol PVBarrageViewDataSource <NSObject>
@required
/** 提供弹幕视图源 */
- (UIView<PVBarrageItemProtocol> *)itemForBarrage:(PVBarrageView *)barrage;

@end

@interface PVBarrageView : UIView

/** 弹幕的行数，默认为1，开始以后，数量可以增加，但不能减少 */
@property (nonatomic, assign) NSUInteger playSubQueueMaxCount;

/** 弹幕的距离 default=16 */
@property (nonatomic, assign) NSUInteger barrageDistance;

/* 弹幕的平均速度，当旋转屏幕时，所有的正在播放的弹幕会设置成这个速度，避免出现重叠 */
@property (nonatomic, assign) CGFloat barrageAverageSpeed;
/** 数据源 */
@property (nonatomic, weak) NSObject<PVBarrageViewDataSource> *dataSource;

#pragma mark play control

/** 弹幕播放状态 */
@property (nonatomic, readonly) PVBarrageAnimationState state;

/** 开始弹幕 */
- (BOOL)startBarrage;
/** 暂停 */
- (BOOL)pauseBarrage;
/** 继续; 重新开始 */
- (BOOL)resumeBarrage;
/** 停止 */
- (BOOL)stopBarrage;

#pragma mark - item control

/** 获取可重用的弹幕 */
- (UIView<PVBarrageItemProtocol> *)dequeueReusableItem;

@end
