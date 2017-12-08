//
//  UILabel+SCExtension.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/22.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SCExtension)

/// 实例化 UILabel
///
/// @param text text
///
/// @return UILabel 默认字体 14，默认颜色 [UIColor darkGrayColor]，默认对齐方式 Left
+ (nonnull instancetype)sc_labelWithText:(nullable NSString *)text;

/// 实例化 UILabel
///
/// @param text     text
/// @param fontSize fontSize
///
/// @return UILabel 默认颜色 [UIColor darkGrayColor]，默认对齐方式 Left
+ (nonnull instancetype)sc_labelWithText:(nullable NSString *)text fontSize:(CGFloat)fontSize;

/// 实例化 UILabel
///
/// @param text      text
/// @param fontSize  fontSize
/// @param textColor textColor
///
/// @return UILabel 默认对齐方式 Left
+ (nonnull instancetype)sc_labelWithText:(nullable NSString *)text
                                fontSize:(CGFloat)fontSize
                               textColor:(nonnull UIColor *)textColor;

/// 实例化 UILabel
///
/// @param text      text
/// @param fontSize  fontSize
/// @param textColor textColor
/// @param alignment alignment
///
/// @return UILabel
+ (nonnull instancetype)sc_labelWithText:(nullable NSString *)text
                                fontSize:(CGFloat)fontSize
                               textColor:(nonnull UIColor *)textColor
                               alignment:(NSTextAlignment)alignment;
/**
 *  计算UILabel的文字的大小
 *
 *  @param labelwith   最大宽度
 *  @param labelheieht 最大高度
 *
 *  @return 返回文本的大小
 */

-(CGSize)messageBodyLabelwith:(float)labelwith andLabelheight:(float)labelheieht;
/**
 *  计算UILabel的细体文字的大小
 *
 *  @param text        文本
 *  @param fontsize    字体大小
 *  @param labelwith   最大宽度
 *  @param labelheieht 最大高度
 *
 *  @return 返回文本的大小
 */
+(CGSize)messageBodyText:(NSString *)text andSyFontofSize:(float)fontsize andLabelwith:(float)labelwith andLabelheight:(float)labelheieht;
/**
 *  计算UILabel的粗体文字的大小
 *
 *  @param text        文本
 *  @param fontsize    字体大小
 *  @param labelwith   最大宽度
 *  @param labelheieht 最大高度
 *
 *  @return 返回文本的大小
 */
+(CGSize)messageBodyText:(NSString *)text andBoldSystemFontOfSize:(float)fontsize andLabelwith:(float)labelwith andLabelheight:(float)labelheieht;


+ (NSArray *)getSeparatedLinesFromText:(NSString*)labelText  font:(UIFont*)labelFont  frame:(CGRect)labelFrame;

/**
 *  计算UILabel的行间距
 *
 *  @param text        文本
 *  @param height      高度
 *
 *  @return 返回富文本
 */
+ (NSAttributedString*)getLabelParagraph:(NSString*)text  height:(CGFloat)height;

@end
