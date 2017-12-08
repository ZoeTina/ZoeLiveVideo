//
//  PVUserGuideView.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUserGuideView.h"

@interface PVUserGuideView ()

/** 阴影视图 */
@property (nonatomic, weak) UIView *shadowView;
@end

@implementation PVUserGuideView

- (void)createUserGuide:(NSString *)imageName{
    //GCD延迟动画模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //创建阴影
        UIView *shadowView = [[UIView alloc] init];
        //设置位置尺寸
        shadowView.frame = YYScreenBounds;
        //设置背景
        shadowView.backgroundColor = [UIColor blackColor];
        //设置透明度
        shadowView.alpha = 0.7;
        //添加到window时为了全局覆盖,包括导航栏,让界面控件全都不可用,
        [[UIApplication sharedApplication].keyWindow addSubview:shadowView];
        
        //赋值
        _shadowView = shadowView;
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:YYScreenBounds];
        imageView.image = kGetImage(imageName);
        imageView.userInteractionEnabled = YES;
        [_shadowView addSubview:imageView];
        _shadowView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [imageView addGestureRecognizer:singleTap];
    });
}

- (void) handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    UIView * view = gestureRecognizer.view;
    [_shadowView removeFromSuperview];
    [view removeGestureRecognizer:gestureRecognizer];
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstCouponBoard_iPhone"];
}

@end
