//
//  UITabBar+PVBadge.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/8.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (PVBadge)


/**
 显示小红点

 @param index item
 */
- (void)showBadgeOnItemIndex:(NSInteger)index;


/**
 隐藏小红点

 @param index item
 */
- (void)hideBadgeOnItemIndex:(NSInteger)index;

@end
