//
//  PVProgressHUDView.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVProgressHUD : NSObject
+ (instancetype)shared;
- (void)showHudInView:(UIView *)view;
- (void)hideHudInView:(UIView *)view;
- (void)showHudInWindow:(UIView *)view;
- (void)hideHudInWindow:(UIView *)view;
@end
