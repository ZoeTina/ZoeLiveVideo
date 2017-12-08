//
//  UIButton+SCExtension.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/18.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SCExtension)

#pragma mark - 分类中所有的字体都适用的默认字体，自定义字体可添加

/// 实例化 UIButton
///
/// @param title           title
/// @param fontSize        fontSize
/// @param textColor       textColor
///
/// @return UIButton
+ (nonnull instancetype)sc_buttonWithTitle:(nullable NSString *)title
                                  fontSize:(CGFloat)fontSize
                                 textColor:(nonnull UIColor *)textColor;

/// 实例化 UIButton
///
/// @param title             title
/// @param fontSize          fonSize
/// @param normalColor       normalColor
/// @param highlightedColor  highlightedColor
///
/// @return UIButton
+ (nonnull instancetype)sc_buttonWithTitle:(nullable NSString *)title
                                  fontSize:(CGFloat)fontSize
                               normalColor:(nonnull UIColor *)normalColor
                          highlightedColor:(nonnull UIColor *)highlightedColor;

/// 实例化 UIButton
///
/// @param attributedText  attributedText
///
/// @return UIButton
+ (nonnull instancetype)sc_buttonWithAttributedText:(nullable NSAttributedString *)attributedText;

/// 实例化 UIButton
///
/// @param imageName       imageName
/// @param highlightSuffix highlightSuffix
///
/// @return UIButton
+ (nonnull instancetype)sc_buttonWithImageName:(nullable NSString *)imageName
                               highlightSuffix:(nullable NSString *)highlightSuffix;


/// 实例化 UIButton
///
/// @param imageName       imageName
/// @param backImageName   backImageName
///
/// @return UIButton
+ (nonnull instancetype)sc_buttonWithImageName:(nullable NSString *)imageName
                                 backImageName:(nullable NSString *)backImageName;

/// 实例化 UIButton
///
/// @param imageName       imageName
/// @param backImageName   backImageName
/// @param highlightSuffix highlightSuffix
///
/// @return UIButton
+ (nonnull instancetype)sc_buttonWithImageName:(nullable NSString *)imageName
                                 backImageName:(nullable NSString *)backImageName
                               highlightSuffix:(nullable NSString *)highlightSuffix;

/// 实例化 UIButton
///
/// @param title           title
/// @param fontSize        fontSize
/// @param textColor       textColor
/// @param imageName       imageName
/// @param backImageName   backImageName
/// @param highlightSuffix highlightSuffix
///
/// @return UIButton
+ (nonnull instancetype)sc_buttonWithTitle:(nullable NSString *)title
                                  fontSize:(CGFloat)fontSize
                                 textColor:(nonnull UIColor *)textColor
                                 imageName:(nullable NSString *)imageName
                             backImageName:(nullable NSString *)backImageName
                           highlightSuffix:(nullable NSString *)highlightSuffix;

/// 实例化 UIButton
///
/// @param attributedText  attributedText
/// @param imageName       imageName
/// @param backImageName   backImageName
/// @param highlightSuffix highlightSuffix
///
/// @return UIButton
+ (nonnull instancetype)sc_buttonWithAttributedText:(nullable NSAttributedString *)attributedText
                                          imageName:(nullable NSString *)imageName
                                      backImageName:(nullable NSString *)backImageName
                                    highlightSuffix:(nullable NSString *)highlightSuffix;
@end
