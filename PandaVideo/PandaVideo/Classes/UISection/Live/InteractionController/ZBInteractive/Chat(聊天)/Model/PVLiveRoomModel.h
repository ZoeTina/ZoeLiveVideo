//
//  PVLiveRoomModel.h
//  PandaVideo
//
//  Created by Ensem on 2017/11/2.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

@class PVLiveRoomData;
@interface PVLiveRoomModel : PVBaseModel
/** 直播间信息数据Data */
@property (nonatomic,strong) PVLiveRoomData *liveRoomData;
/** 错误消息 */
@property (nonatomic,copy) NSString *errorMsg;
@property (nonatomic,copy) NSString *rs;

@end

@interface PVLiveRoomData : PVBaseModel

/** 最后一次消息ID */
@property (nonatomic,copy)NSString *lastMsgId;

@end
