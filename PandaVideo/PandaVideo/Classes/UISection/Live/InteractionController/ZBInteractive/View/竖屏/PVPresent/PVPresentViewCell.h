//
//  PVPresentViewCell.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVPresentModelAble.h"

//动画状态
typedef NS_ENUM(NSUInteger, AnimationState) {
    AnimationStateNone = 0,
    AnimationStateShowing,
    AnimationStateShaking,
    AnimationStateShaked,
    AnimationStateHiding
};

@protocol PVPresentViewCellDelegate;

@interface PVPresentViewCell : UIView

@property (weak, nonatomic) id<PVPresentViewCellDelegate> delegate;

/** 记录礼物连乘数 */
@property (nonatomic, assign) NSInteger giftNum;
/**
 *  cell展示时间
 */
@property (assign, nonatomic)NSTimeInterval showTime;
/**
 *  轨道编号
 */
@property (assign, nonatomic, readonly) NSInteger row;
/**
 *  cell当前的动画状态
 */
@property (assign, nonatomic, readonly) AnimationState state;
/**
 *  礼物发送者
 */
@property (copy, nonatomic, readonly) NSString *sender;
/**
 *  礼物名
 */
@property (copy, nonatomic, readonly) NSString *giftName;
/**
 当前礼物模型
 */
@property (strong, nonatomic, readonly) id<PVPresentModelAble> gitfModel;

- (instancetype)initWithRow:(NSInteger)row;
/**
 *  显示cell动画
 *
 *  @param model      礼物模型
 *  @param flag       是否带连乘动画
 *  @param prepare    准备动画回调
 *  @param completion 动画完成回调
 */
- (void)showAnimationWithModel:(id<PVPresentModelAble> )model
            showShakeAnimation:(BOOL)flag
                       prepare:(void (^)(void))prepare
                    completion:(void (^)(BOOL flag))completion;
/**
 *  连乘动画
 *
 *  @param number 连乘次数
 */
- (void)shakeAnimationWithNumber:(NSInteger)number;
/**
 *  隐藏cell动画
 *
 *  @param flag 是否带有连城动画
 */
- (void)hiddenAnimationOfShowShake:(BOOL)flag;
/**
 *  释放引用变量
 */
- (void)releaseVariable;

@end

//供子类重写的接口
@interface PVPresentViewCell (OverWrite)

/**
 *  自定义展示动画
 *
 *  @param flag 是否带有连乘动画
 */
- (void)customDisplayAnimationOfShowShakeAnimation:(BOOL)flag;
/**
 *  自定义隐藏动画
 *
 *  @param flag 是否带有连乘动画
 */
- (void)customHideAnimationOfShowShakeAnimation:(BOOL)flag;

@end

@interface PVPresentLable : UILabel

/**
 *  数字描边颜色
 */
@property (strong, nonatomic) UIColor *borderColor;
/**
 *  开始连乘动画
 *
 *  @param interval    动画时间
 *  @param completion  动画完成回调
 */
- (void)startAnimationDuration:(NSTimeInterval)interval
                    completion:(void (^)(BOOL finish))completion;

@end

@protocol PVPresentViewCellDelegate <NSObject>

@optional
/**
 *  一组动画组完成回调
 *
 *  @param flag   是否带连乘动画
 *  @param number 最终连乘数，如果flag为NO number就为0
 */
- (void)presentViewCell:(PVPresentViewCell *)cell
     showShakeAnimation:(BOOL)flag
            shakeNumber:(NSInteger)number;

@end
