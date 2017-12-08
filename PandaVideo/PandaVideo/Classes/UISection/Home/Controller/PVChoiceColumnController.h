//
//  PVChoiceColumnController.h
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"
#import "PVTempletModel.h"

@interface PVChoiceColumnController : SCBaseViewController

///是否隐藏了标题栏
@property(nonatomic, assign)BOOL isHiddenTitleView;
///静态url
@property(nonatomic, copy)NSString* url;
///导航栏标题
@property(nonatomic, copy)NSString* navTitle;
///用来标示是1:精选(活动)跳转,2:互动直播首页,3:活动直播首页
@property(nonatomic, assign)NSInteger navType;
///数据源
@property(nonatomic, strong)NSMutableArray<PVTempletModel*>*   templetDataSource;
///二级栏目默认model
@property(nonatomic, strong)PVChoiceSecondColumnModel* secondColumnModel;

@end
