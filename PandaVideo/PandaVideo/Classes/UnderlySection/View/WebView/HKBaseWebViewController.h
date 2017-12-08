//
//  HKBaseWebViewController.h
//  HKBicycle
//
//  Created by macy on 17/3/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKBaseViewController.h"
@class HKActivityCenterModel;

@interface HKBaseWebViewController : HKBaseViewController

@property (nonatomic, assign) BOOL hiddenToolbar; //是否隐藏toolbar 默认隐藏
@property (nonatomic, assign) BOOL showShareIcon; // 是否显示分享
@property (nonatomic, strong) HKActivityCenterModel *model;

/**
 * 导航栏标题
 */
@property (nonatomic, copy) NSString *titleString;

/**
 * 初始化
 */
- (instancetype)initWebViewWithURL:(NSString*)urlString;

- (void)showShareview;

@end
