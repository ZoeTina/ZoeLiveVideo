//
//  NSObject+LZToast.h
//  SEZB
//
//  Created by 寕小陌 on 2016/12/15.
//  Copyright © 2016年 寜小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

//上下左右距离
#define TOAST_TEXT_MARGIN_TOP_BOTTOM  7.0f
#define TOAST_TEXT_MARGIN_LEFT_RIGHT  10.0f
//默认toast位置Y
#define TOAST_POSITION_Y   (YYScreenHeight-80.0f)

//字体
#define TOAST_TEXT_FONTSIZE         16.0f
//动画时间
#define TOAST_ANIMATION_DURATION    1.8f
//显示和消失时间
#define TOAST_ANI_STARTEND_DURATION 2.0f

@interface NSObject (LZToast)

- (void)lz_make:(NSString*)text duration:(CGFloat)duration backgroundColor:(UIColor*)color position:(CGPoint)point;

- (void)lz_make:(NSString*)text duration:(CGFloat)duration position:(CGPoint)point;

- (void)lz_make:(NSString*)text;

@end
