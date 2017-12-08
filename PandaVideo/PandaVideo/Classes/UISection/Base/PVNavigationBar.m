//
//  PVNavigationBar.m
//  PandaVideo
//
//  Created by cara on 2017/9/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVNavigationBar.h"

@implementation PVNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), NAVIGATIONBAR_HEIGHT);
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kNavBarHeight);
    self.backgroundColor = [UIColor whiteColor];
    for (UIView *view in self.subviews) {
        if([NSStringFromClass([view class]) containsString:@"Background"]) {
            view.frame = self.bounds;
        }
        else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
            view.backgroundColor = [UIColor whiteColor];
            CGRect frame = view.frame;
            frame.origin.y = (kScreenHeight == 812.0 ? 44 : 20);
            frame.size.height = self.bounds.size.height - frame.origin.y;
            view.frame = frame;
        }
//        else if ([NSStringFromClass([view class]) containsString:@"UIButton"]){
//            CGRect frame = view.frame;
//            frame.origin.x = (frame.origin.x == 16 ? 0 : (ScreenWidth-(frame.size.width > 40 ? (frame.size.width+5) : frame.size.width)));
//            view.frame = frame;
//        }
    }
}
@end
