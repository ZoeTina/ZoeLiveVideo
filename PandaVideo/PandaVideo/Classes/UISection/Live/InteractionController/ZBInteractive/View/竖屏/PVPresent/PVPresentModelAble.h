//
//  PVPresentModelAble.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  礼物模型必须遵守的协议
 */
@protocol PVPresentModelAble <NSObject>

@required

/** 发送者 */
@property (copy, nonatomic) NSString *sender;
/** 礼物名 */
@property (copy, nonatomic) NSString *giftName;

@optional

/**
 * 需要展示的礼物连乘数 默认为0
 *
 * @discussion  用于解决当前礼物消息消息正在展示时，
                新加入到聊天室的人看到的礼物消息不是重1开始，
                如果要使用消息体中必须包含当前礼物个数
 */
@property (assign, nonatomic) NSInteger giftNumber;

//礼物显示总次数（最多十次）
@property (nonatomic,assign)NSInteger giftTotal;
@end
