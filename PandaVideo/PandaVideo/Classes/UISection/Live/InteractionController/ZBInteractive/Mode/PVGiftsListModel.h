//
//  PVGiftsListModel.h
//  PandaVideo
//
//  Created by Ensem on 2017/11/6.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVPresentModelAble.h"

@class PVGiftList,PVGiftListData;
@interface PVGiftsListModel : PVBaseModel

@property(nonatomic, copy) NSString *rs;
@property(nonatomic, strong) PVGiftListData *data;
@property(nonatomic, copy) NSString *errorMsg;

@end

@interface PVGiftListData : PVBaseModel

@property(nonatomic, strong) NSMutableArray<PVGiftList *> *giftList;

@end

@interface PVGiftList : PVBaseModel<PVPresentModelAble>

/** 发送者 */
@property (copy, nonatomic) NSString *sender;
/** 礼物名 */
@property (copy, nonatomic) NSString *giftName;
/** 礼物图片名称 */
@property (copy, nonatomic) NSString *giftImageName;
/** 礼物数量 */
@property (assign, nonatomic) NSInteger giftNumber;
@property (nonatomic, assign) NSInteger giftTotal;

@property (nonatomic, assign) NSInteger giftId;
/** 图片地址 */
@property (nonatomic, copy) NSString *imageUrl;
/** 描述 */
@property (nonatomic, copy) NSString *descr;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 虚拟币价格 */
@property (nonatomic, copy) NSString *price;
/** 等级 */
@property (nonatomic, copy) NSString *level;
/** 来源平台 */
@property (nonatomic, copy) NSString *src;
/** 类型，目前只能是live */
@property (nonatomic, copy) NSString *liveType;

@end
