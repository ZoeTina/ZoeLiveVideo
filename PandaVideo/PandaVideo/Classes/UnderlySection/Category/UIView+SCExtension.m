//
//  UIView+SCExtension.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/27.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "UIView+SCExtension.h"

@implementation UIView (SCExtension)

#pragma mark - Frame
- (CGPoint)sc_viewOrigin {
    return self.frame.origin;
}

- (void)setSc_viewOrigin:(CGPoint)sc_viewOrigin {
    CGRect newFrame = self.frame;
    newFrame.origin = sc_viewOrigin;
    self.frame = newFrame;
}

- (CGSize)sc_viewSize {
    return self.frame.size;
}

- (void)setSc_viewSize:(CGSize)sc_viewSize {
    CGRect newFrame = self.frame;
    newFrame.size = sc_viewSize;
    self.frame = newFrame;
}

#pragma mark - Frame Origin
- (CGFloat)sc_x {
    return self.frame.origin.x;
}

- (void)setSc_x:(CGFloat)sc_x {
    CGRect newFrame = self.frame;
    newFrame.origin.x = sc_x;
    self.frame = newFrame;
}

- (CGFloat)sc_y {
    return self.frame.origin.y;
}

- (void)setSc_y:(CGFloat)sc_y {
    CGRect newFrame = self.frame;
    newFrame.origin.y = sc_y;
    self.frame = newFrame;
}

#pragma mark - Frame Size
- (CGFloat)sc_width {
    return self.frame.size.width;
}

- (void)setSc_width:(CGFloat)sc_width {
    CGRect newFrame = self.frame;
    newFrame.size.width = sc_width;
    self.frame = newFrame;
}

- (CGFloat)sc_height {
    return self.frame.size.height;
}

- (void)setSc_height:(CGFloat)sc_height {
    CGRect newFrame = self.frame;
    newFrame.size.height = sc_height;
    self.frame = newFrame;
}

#pragma mark - 截屏
- (UIImage *)sc_capturedImage {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    UIImage *result = nil;
    if ([self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES]) {
        result = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    
    return result;
}

+ (nullable instancetype)sc_viewWithColor:(nonnull UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    return view;
}

- (BOOL)isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

- (void)setBordersWithColor:(UIColor *_Nonnull)color
               cornerRadius:(CGFloat)cornerRadius
                borderWidth:(CGFloat)borderWidth
{
    if (color != nil) {
        self.layer.borderColor = color.CGColor;
    }
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth  = borderWidth;
    self.layer.masksToBounds = YES;
}
@end
