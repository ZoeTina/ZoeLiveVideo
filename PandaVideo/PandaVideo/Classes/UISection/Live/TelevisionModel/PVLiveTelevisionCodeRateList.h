//
//  PVLiveTelevisionCodeRateList.h
//  PandaVideo
//
//  Created by cara on 17/9/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

@interface PVLiveTelevisionCodeRateList : PVBaseModel

///码率显示名
@property(nonatomic, copy)NSString*  showName;
///码率文件名
@property(nonatomic, copy)NSString*  rateFileUrl;
///排序
@property(nonatomic, copy)NSString*  sort;
///是否默认播放
@property(nonatomic, copy)NSString*  isDefaultRate;
///是否选中
@property(nonatomic, assign)BOOL isSelected;

@end
