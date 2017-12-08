//
//  PVPresentView.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVPresentViewCell.h"

@protocol PVPresentViewDelegate;

@interface PVPresentView : UIView

/** cell高度(默认40) */
@property (nonatomic, assign) CGFloat cellHeight;
/** 礼物动画展示时间(默认3秒) */
@property (nonatomic, assign) NSTimeInterval showTime;
/** 选择的礼物数量 */
@property (nonatomic, assign) NSInteger giftNum;


/** 轨道总数 */
@property (nonatomic, assign, readonly) NSInteger rows;
@property (nonatomic, weak) id<PVPresentViewDelegate> delegate;

/** 获取对应轨道上的cell */
- (__kindof PVPresentViewCell *)cellForRowAtIndex:(NSUInteger)index;
/**
 *  插入送礼消息
 *
 *  @param models 礼物模型数组中的模型必须遵守PVPresentModelAble协议
 *  @param flag   是否需要连乘动画
 */
- (void)insertPresentMessages:(NSArray<id <PVPresentModelAble>> *)models showShakeAnimation:(BOOL)flag giftNum:(NSInteger) giftNum giftTotal:(NSInteger)giftTotal  gifSender:(NSString *)gifSender;
/** 释放相关引用变量 */
- (void)releaseVariable;

@end

@protocol PVPresentViewDelegate <NSObject>

@required

/** 返回自定义cell样式 */
- (PVPresentViewCell *)presentView:(PVPresentView *)presentView cellOfRow:(NSInteger)row;
/**
 *  礼物动画即将展示的时调用，根据礼物消息类型为自定义的cell设置对应的模型数据用于展示
 *
 *  @param cell        用来展示动画的cell
 *  @param model       礼物模型
 */
- (void)presentView:(PVPresentView *)presentView
         configCell:(PVPresentViewCell *)cell
              model:(id<PVPresentModelAble>)model;

@optional

/** cell点击事件 */
- (void)presentView:(PVPresentView *)presentView didSelectedCellOfRowAtIndex:(NSUInteger)index;

/** 一组连乘动画执行完成回调 */
- (void)presentView:(PVPresentView *)presentView animationCompleted:(NSInteger)shakeNumber model:(id<PVPresentModelAble>)model;
@end
