//
//  AFSessionManager.h
//  AFNetworkingDemo
//
//  Created by xiangjf on 2017/6/13.
//  Copyright © 2017年 Zcy. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSInteger, ResposeStyle) {
    Json,
    Xml,
    Data
};

typedef NS_ENUM(NSInteger, RequestStyle) {
    RequestJson,
    RequestString,
    RequestDefault
};

@interface AFSessionManager : AFHTTPSessionManager

+ (AFSessionManager *)shareInstance;

@end
