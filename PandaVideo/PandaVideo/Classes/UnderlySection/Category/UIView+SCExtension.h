//
//  UIView+SCExtension.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/27.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SCExtension)

#pragma mark - Frame
/// 视图原点
@property (nonatomic) CGPoint sc_viewOrigin;
/// 视图尺寸
@property (nonatomic) CGSize sc_viewSize;

#pragma mark - Frame Origin
/// frame 原点 x 值
@property (nonatomic) CGFloat sc_x;
/// frame 原点 y 值
@property (nonatomic) CGFloat sc_y;

#pragma mark - Frame Size
/// frame 尺寸 width
@property (nonatomic) CGFloat sc_width;
/// frame 尺寸 height
@property (nonatomic) CGFloat sc_height;

#pragma mark - /***** wowtv's resentment  截屏 *****/
/// 当前视图内容生成的图像
@property (nonatomic, readonly, nullable)UIImage *sc_capturedImage;

//生成一个UIView 
+ (nullable instancetype)sc_viewWithColor:(nonnull UIColor *)color;

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

/**
 *  1.设置边框
 */
- (void)setBordersWithColor:(UIColor *_Nonnull)color
               cornerRadius:(CGFloat)cornerRadius
                borderWidth:(CGFloat)borderWidth;
@end
