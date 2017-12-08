//
//  UIBarButtonItem+SCExtension.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/29.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SCExtension)

/// 实例化UIBarButtonItem
+ (instancetype)sc_itemWithTitle:(NSString *)title
                        fontSize:(CGFloat)fontSize
                     normalColor:(UIColor *)normalColor
                highlightedColor:(UIColor *)highlightedColor
                          target:(id)target
                          action:(SEL)action;

@end
