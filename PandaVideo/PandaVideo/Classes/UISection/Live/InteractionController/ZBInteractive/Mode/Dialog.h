//
//  Dialog.h
//  SEZB
//
//  Created by 寕小陌 on 2017/2/3.
//  Copyright © 2017年 寜小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NSContentType) {
    NS_CONTENT_TYPE_CHAT,//默认从0开始
    NS_CONTENT_TYPE_QA_QUESTION,
    NS_CONTENT_TYPE_QA_ANSWER,
};

@interface Dialog : NSObject

/**
 *  对话数组
 *  time      NSInteger 对话时间
 *  content   NSString  内容
 *  username  NSString  用户名
 *  viewerId  NSString  观看者ID
 *  dataType  NSString  (@"1" 自己,@"2" 别人)
 */

/**
 *  问答数组
 *  time      NSInteger 对话时间
 *  content   NSString  内容
 *  username  NSString  用户名
 *  encryptId NSString  问答ID
 *  dataType  NSString  (@"1" 提问,@"2" 回答)
 */

@property(nonatomic,strong) NSString        *content;   // 内容
@property(nonatomic,strong) NSString        *username;  // 用户名
@property(nonatomic,strong) NSString        *viewerId;  // 观看者ID
@property(nonatomic,strong) NSString        *encryptId; // (@"1" 提问,@"2" 回答)
@property(nonatomic,assign) BOOL            isPublicChat;// 公聊还是私聊
@property(nonatomic,strong) NSString        *avatar;

@property(nonatomic,assign) NSContentType   dataType;   // 自己还是别人

@property (assign, nonatomic) CGSize                        msgSize;
@property (assign, nonatomic) CGSize                        userNameSize;

@end
