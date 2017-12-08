//
//  PVAnimFooterRefresh.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVAnimFooterRefresh.h"

@implementation PVAnimFooterRefresh

- (instancetype)init
{
    if (self = [super init]) {
        
        // 设置普通状态的动画图片
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=46; i++) {
            NSString * addStr = i > 9 ? @"下拉加载_000" : @"下拉加载_0000";
            NSString    *str        = [NSString stringWithFormat:@"%@%zd",addStr,i];
            UIImage     *orignImage = [UIImage imageNamed:str];
            UIImage     *image      = [self scaleToSize:orignImage size:CGSizeMake(IPHONE6WH(70), IPHONE6WH(50))];
            [idleImages addObject:image];
        }
        self.stateLabel.hidden = YES;
        self.refreshingTitleHidden = YES;
        
//        // 设置普通状态的动画图片
//        [self setImages:idleImages forState:MJRefreshStateIdle];
//        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//        [self setImages:idleImages forState:MJRefreshStatePulling];
//        // 设置正在刷新状态的动画图片
//        [self setImages:idleImages forState:MJRefreshStateRefreshing];
    }
    return self;
}
// 压缩图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
