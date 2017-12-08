//
//  AppDefine.h
//  SiChuanFocus
//
//  Created by xiangjf on 2017/6/14.
//  Copyright © 2017年 Zcy. All rights reserved.
//

#ifndef AppDefine_h
#define AppDefine_h

#ifdef DEBUG
#define SCLog(log, ...) NSLog(@"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(log), ##__VA_ARGS__])
#else
#define SCLog(log, ...)
#endif


#ifdef DEBUG
static NSString * const PurchaseURL=@"https://sandbox.itunes.apple.com/verifyReceipt"; //debug
#else
static NSString * const PurchaseURL=@"https://buy.itunes.apple.com/verifyReceipt";  //其他
#endif

////////// QQ分享功能Key /////////////
#define kQQAppId  @"1105999352"
#define kQQAppKey @"eqb84UMcbFWN4JIZ"

////////// 微信分享/支付Key //////////
#define kWechatAppId   @"wx5b82aaeaa773d563"
#define kWechatAppSecret @"a5aecff64f3fd006cf1377f12819fc39"

///////// 新浪微博分享Key ///////////
#define kSinaAppKey @"1842787284"
#define kSinaRedirectURI    @"http://www.sina.com"

//////// 讯飞语音
#define kXunfeiAppId @"59410963"

#define kPanda_BuglyAppId @"d3a94d98f4"


///////// 极光推送 ///////////
#define kJGtAppKey   @"8d6d370d13e362563130a273"
#define kJGAppSecret @"475bc9e9ce20ce6f9e174d5e"


#define kPanda_ProfuctId_3 @"pandaVideo_VIP_3"
#define kPanda_ProfuctId_6 @"pandaVideo_VIP_6"
#define kpanda_ProductId_1 @"pandaVideo_VIP_0.01"

//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"

#endif /* AppDefine_h */
