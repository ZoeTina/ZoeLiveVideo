//
//  PVLiveTelevisionAreaModel.h
//  PandaVideo
//
//  Created by cara on 17/9/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVLiveTelevisionChanelListModel.h"


@interface PVLiveTelevisionAreaModel : PVBaseModel

///是否被选中
@property(nonatomic, assign)BOOL isSelected;
///电视台名
@property(nonatomic, copy)NSString*  stationName;
///电视台ID
@property(nonatomic, copy)NSString*  stationId;
///排序
@property(nonatomic, copy)NSString*  sort;
///频道列表对象
@property(nonatomic, strong)NSMutableArray <PVLiveTelevisionChanelListModel*>* chanelList;
///频道列表是否刷新过
@property(nonatomic, assign)BOOL isRefresh;

@end
