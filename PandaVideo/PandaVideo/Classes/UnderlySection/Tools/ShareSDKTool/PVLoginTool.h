//
//  PVLoginTool.h
//  PandaVideo
//
//  Created by xiangjf on 2017/9/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ThridLoginSuccessBlock)(SSDKUser *userInfo);
typedef void(^ThridLoginFailureBlock)(NSString *errorStr, NSError *error);

@interface PVLoginTool : NSObject


/**
 第三方登陆

 @param platform 登陆类型
 @param success 成功信息
 @param failure 失败信息
 */
+ (void)loginWithPlatform:(SSDKPlatformType)platform successBlock:(ThridLoginSuccessBlock)success failureBlock:(ThridLoginFailureBlock)failure;
@end
