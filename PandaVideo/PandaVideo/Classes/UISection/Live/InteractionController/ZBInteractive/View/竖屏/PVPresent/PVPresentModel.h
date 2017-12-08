//
//  PVPresentModel.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVPresentModelAble.h"

/** 显示送礼物的动画  Model */

@interface PVPresentModel : PVBaseModel<PVPresentModelAble>

/** 礼物ID */
@property (assign, nonatomic) NSInteger giftId;
/** 礼物发送者 */
@property (copy, nonatomic) NSString *sender;
/** 礼物名称 */
@property (copy, nonatomic) NSString *giftName;
/** 礼物图标 */
@property (copy, nonatomic) NSString *icon;
/** 礼物图片名称 */
@property (copy, nonatomic) NSString *giftImageName;
/** 礼物数量 */
@property (assign, nonatomic) NSInteger giftNumber;

/** 送礼物 */

/**
 送礼物

 @param sender 礼物发送者
 @param giftId 礼物ID
 @param giftName 礼物名称
 @param icon 礼物图片
 @param giftImageName 礼物图片名称
 @return 返回对象
 */
+ (instancetype)modelWithSender:(NSString *)sender
                         giftId:(NSInteger )giftId
                       giftName:(NSString *)giftName
                           icon:(NSString *)icon
                  giftImageName:(NSString *)giftImageName;

@end
