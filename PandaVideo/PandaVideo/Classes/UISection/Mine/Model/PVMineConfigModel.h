//
//  PVMineConfigModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/16.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVMineConfigModel : NSObject

@property (nonatomic, assign) BOOL isFirstLogin;

//2G/3G/4G网络下播放提醒
@property (nonatomic, assign) BOOL netPlayTips;

//2G/3G/4G流量上传
@property (nonatomic, assign) BOOL netUploadingTips;

//2G/3G/4G流量缓存
@property (nonatomic, assign) BOOL netCacheTips;

//热门推送
@property (nonatomic, assign) BOOL postTips;

+ (instancetype)shared;
- (void)dump;
- (void)load;
@end
