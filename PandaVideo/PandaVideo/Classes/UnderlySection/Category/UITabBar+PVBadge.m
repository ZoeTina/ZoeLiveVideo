//
//  UITabBar+PVBadge.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/8.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "UITabBar+PVBadge.h"

#define TabbarItemNums 5.0    //tabbar的数量 如果是5个设置为5.0

@implementation UITabBar (PVBadge)


- (void)showBadgeOnItemIndex:(NSInteger)index {
    [self removeBadgeOnItemIndex:index];
    
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = 100 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    
    CGRect tabbarFrame = self.frame;
    CGFloat percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabbarFrame.size.width);
    CGFloat y = ceilf(0.1 * tabbarFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeView];
}


- (void)hideBadgeOnItemIndex:(NSInteger)index {
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(NSInteger)index {
    for (UIView *subView in self.subviews) {
        if (subView.tag == 100 + index) {
            [subView removeFromSuperview];
        }
    }
}

@end
