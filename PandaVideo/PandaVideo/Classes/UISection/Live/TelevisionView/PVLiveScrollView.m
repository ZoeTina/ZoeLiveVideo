//
//  PVLiveScrollView.m
//  PandaVideo
//
//  Created by cara on 17/9/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLiveScrollView.h"

@implementation PVLiveScrollView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView * view = [super hitTest:point withEvent:event];
    CGFloat  endContentOffsetX = self.contentOffset.x;
    if (endContentOffsetX == 0 && point.x >= ScreenWidth) {
        self.scrollEnabled = false;
    }else{
        self.scrollEnabled = true;
    }
    return view;
}

@end
