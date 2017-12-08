//
//  UITextField+SCExtension.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/27.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (SCExtension)

/// 实例化 UITextField
///
/// @param placeHolder     占位文本
///
/// @return UITextField
+ (nonnull instancetype)sc_textFieldWithPlaceHolder:(nonnull NSString *)placeHolder;

@end
