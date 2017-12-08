//
//  UIButton+SCExtension.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/18.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "UIButton+SCExtension.h"

@implementation UIButton (SCExtension)

+ (instancetype)sc_buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    NSAttributedString *attributedText = [[NSAttributedString alloc]
                                          initWithString:title
                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                                       NSForegroundColorAttributeName: textColor}];
    
    return [self sc_buttonWithAttributedText:attributedText];
}

+ (instancetype)sc_buttonWithTitle:(NSString *)title
                          fontSize:(CGFloat)fontSize
                       normalColor:(UIColor *)normalColor
                  highlightedColor:(UIColor *)highlightedColor {
    
    NSAttributedString *attributedText = [[NSAttributedString alloc]
                                          initWithString:title
                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    
    UIButton *button = [[UIButton alloc] init];
    [button setAttributedTitle:attributedText forState:UIControlStateNormal];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    
    [button sizeToFit];
    
    return button;
}

+ (instancetype)sc_buttonWithAttributedText:(NSAttributedString *)attributedText {
    return [self sc_buttonWithAttributedText:attributedText imageName:nil backImageName:nil highlightSuffix:nil];
}

+ (instancetype)sc_buttonWithImageName:(NSString *)imageName highlightSuffix:(NSString *)highlightSuffix {
    
    return [self sc_buttonWithAttributedText:nil imageName:imageName backImageName:nil highlightSuffix:highlightSuffix];
}

+ (instancetype)sc_buttonWithImageName:(NSString *)imageName
                         backImageName:(NSString *)backImageName {
    
    UIButton *button = [[self alloc] init];
    
    if (imageName != nil) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (backImageName != nil) {
        [button setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
    }
    
    [button sizeToFit];
    
    return button;
}

+ (instancetype)sc_buttonWithImageName:(NSString *)imageName backImageName:(NSString *)backImageName highlightSuffix:(NSString *)highlightSuffix {
    
    return [self sc_buttonWithAttributedText:nil imageName:imageName backImageName:backImageName highlightSuffix:highlightSuffix];
}

+ (instancetype)sc_buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor imageName:(NSString *)imageName backImageName:(NSString *)backImageName highlightSuffix:(NSString *)highlightSuffix {
    
    NSAttributedString *attributedText = [[NSAttributedString alloc]
                                          initWithString:title
                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                                       NSForegroundColorAttributeName: textColor}];
    
    return [self sc_buttonWithAttributedText:attributedText imageName:imageName backImageName:backImageName highlightSuffix:highlightSuffix];
}

+ (instancetype)sc_buttonWithAttributedText:(NSAttributedString *)attributedText imageName:(NSString *)imageName backImageName:(NSString *)backImageName highlightSuffix:(NSString *)highlightSuffix {
    
    UIButton *button = [[self alloc] init];
    
    [button setAttributedTitle:attributedText forState:UIControlStateNormal];
    
    if (imageName != nil) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        NSString *highlightedImageName = [imageName stringByAppendingString:highlightSuffix];
        [button setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    }
    
    if (backImageName != nil) {
        [button setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
        
        NSString *highlightedImageName = [backImageName stringByAppendingString:highlightSuffix];
        [button setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    }
    
    [button sizeToFit];
    
    return button;
}

@end
