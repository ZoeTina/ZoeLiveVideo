//
//  UIFont+Font.h
//  SiChuanFocus
//
//  Created by xiangjf on 2017/6/19.
//  Copyright © 2017年 Zcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Font)

/**
 * 根据屏幕适配文字大小 规则: 以6为基础, 设备小一号减一号字体，设备大一号加一号字体
 */
+ (UIFont*)systemFontOfSizeAdapter:(CGFloat)fontSize;

+ (UIFont *)fontWithName:(NSString *)fontName sizeAdapter:(CGFloat)fontSize;

@end
