//
//  UIBarButtonItem+SCExtension.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/29.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "UIBarButtonItem+SCExtension.h"

@implementation UIBarButtonItem (SCExtension)

+ (instancetype)sc_itemWithTitle:(NSString *)title
                        fontSize:(CGFloat)fontSize
                     normalColor:(UIColor *)normalColor
                highlightedColor:(UIColor *)highlightedColor
                          target:(id)target
                          action:(SEL)action {
    
    UIButton *button = [UIButton sc_buttonWithTitle:title fontSize:fontSize normalColor:normalColor highlightedColor:highlightedColor];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

@end
