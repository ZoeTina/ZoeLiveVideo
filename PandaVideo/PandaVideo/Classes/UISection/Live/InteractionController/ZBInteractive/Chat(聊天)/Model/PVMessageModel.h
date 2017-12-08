//
//  PVMessageModel.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CellType){
    CellBanType,                  // 禁号
    CellNewChatMessageType,       // 新消息
    CellNewGiftType,              // 礼品
    CellNewUserEnterType,         // 消息进入
    CellDeserveType,              //
};

@class TYTextContainer,PVLiveRoomData,PVMessageData,PVChatList,LZUserData;

@interface PVMessageModel : PVBaseModel

@property (nonatomic,strong)TYTextContainer *textContainer;
@property (nonatomic,copy)NSString *unColoredMsg;
@property (nonatomic,assign)CellType cellType;
@property (nonatomic,strong)NSArray *gift;
@property (nonatomic,copy)NSString *dataString;

- (void)setModel:(NSString*)userID withName:(NSString*)name withIcon:(NSString*)icon withType:(CellType)type withMessage:(NSString*)message;


/** 直播间信息数据Data */
@property (nonatomic, strong) PVMessageData *data;
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, copy) NSString *rs;

@end


@interface PVMessageData : PVBaseModel

/** 直播间人数 */
@property (nonatomic,copy)NSString *userCount;
@property (nonatomic,strong)NSMutableArray<PVChatList *> *chatList;

@end

@interface PVChatList : PVBaseModel

@property (assign, nonatomic) CGSize                        msgSize;
@property (assign, nonatomic) CGSize                        userNameSize;

/** 消息时间 */
@property (nonatomic,copy)NSString *chatDate;
/** 消息ID */
@property (nonatomic,copy)NSString *chatId;
/** 消息内容（类型为点赞时显示点赞数，类型为礼物时为礼物ID */
@property (nonatomic,copy)NSString *chatMsg;
/** 消息类型(0.聊天、1.用户进入、2.送礼、3.红包&活动、4.公告，5.点赞) */
@property (nonatomic,copy)NSString *chatType;
/** 数量（礼物数量，点赞数量） */
@property (nonatomic,copy)NSString *count;
/** 数量（礼物数量，点赞数量） */
@property (nonatomic,copy)NSString *targetNickName;
/** 用户对象*/
@property (nonatomic,strong)LZUserData *userData;

@end

@interface LZUserData : PVBaseModel

/** 头像 */
@property (nonatomic,copy)NSString *avatar;
/** 用户ID */
@property (nonatomic,copy)NSString *userId;
/** 用户名 */
@property (nonatomic,copy)NSString *nickName;

@end
