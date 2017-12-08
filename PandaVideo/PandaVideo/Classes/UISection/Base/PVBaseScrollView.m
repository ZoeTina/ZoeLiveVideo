//
//  PVBaseScrollView.m
//  PandaVideo
//
//  Created by cara on 17/8/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseScrollView.h"

@implementation PVBaseScrollView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView * view = [super hitTest:point withEvent:event];
    CGFloat  endContentOffsetX = self.contentOffset.x;
    if (endContentOffsetX == 0 && point.x <= 25) {
        self.scrollEnabled = false;
    }else{
        self.scrollEnabled = true;
    }
    return view;
}
@end