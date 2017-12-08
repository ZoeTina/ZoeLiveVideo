//
//  PVBaseWebViewController.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"

@interface PVBaseWebViewController : SCBaseViewController
/**
 导航栏标题
 */
@property (nonatomic, copy) NSString *titleString;
- (instancetype)initWebViewWithUrl:(NSString *)urlString title:(NSString *)title;
@end

