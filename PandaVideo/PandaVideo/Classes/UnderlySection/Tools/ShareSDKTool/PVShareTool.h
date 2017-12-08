//
//  PVShareTool.h
//  PandaVideo
//
//  Created by xiangjf on 2017/9/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVShareViewController.h"

typedef void(^ShareResultStrBlock)(NSString *shareResultStr);
@interface PVShareTool : NSObject


/**
 第三方分享

 @param platform 分享平台
 @param shareModel 分享model
 @param resultBlock 分享结果，只有一个作为提示信息的字符串
 */
+ (void)shareWithPlatformType:(SSDKPlatformType)platform PVDemandVideoDetailModel:(PVShareModel *)shareModel shareresult:(ShareResultStrBlock)resultBlock;

@end
