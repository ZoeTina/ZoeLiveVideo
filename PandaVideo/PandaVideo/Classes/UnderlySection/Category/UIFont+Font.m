//
//  UIFont+Font.m
//  SiChuanFocus
//
//  Created by xiangjf on 2017/6/19.
//  Copyright © 2017年 Zcy. All rights reserved.
//

#import "UIFont+Font.h"

@implementation UIFont (Font)

+ (CGFloat)fontToSize:(CGFloat)fontSize
{
    float widthR = ScreenWidth/375.0;
    float tempFontSize = fontSize;
    widthR > 1 ? (tempFontSize+=1) : (tempFontSize-=1);
    
    return tempFontSize;
}

+ (UIFont*)systemFontOfSizeAdapter:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:[UIFont fontToSize:fontSize]];
}

+ (UIFont*)fontWithName:(NSString *)fontName sizeAdapter:(CGFloat)fontSize
{
    return [UIFont fontWithName:fontName size:[UIFont fontToSize:fontSize]];
}


@end
