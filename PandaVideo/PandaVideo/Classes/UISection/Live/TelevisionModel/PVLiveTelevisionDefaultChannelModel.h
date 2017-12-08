//
//  PVLiveTelevisionDefaultChannelModel.h
//  PandaVideo
//
//  Created by cara on 17/9/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVLiveTelevisionCodeRateList.h"
#import "PVLiveTelevisionChanelListModel.h"
/*
 "channelAuthority": "播放权限矩阵",
 "codeRateList": [
 {
 "showName": "流畅",
 "rateFileUrl": "码率M3U8文件名",
 "sort": 1,
 "isDefaultRate": true
 }
 ],
 "channelName": "SCTV-1",
 "programUrl": "http://182.138.102.131:8080/App/Live/tv/schedule/00000001000000050000000000000194_schedule_date.json",
 "channelId": "2a007723-9a7d-4839-abbb-339d5f526a41"
 */


@interface PVLiveTelevisionDefaultChannelModel : PVBaseModel

///	播放权限矩阵
@property(nonatomic, copy)NSString*  channelAuthority;
/// 频道名
@property(nonatomic, copy)NSString*  channelName;
/// 节目单详情地址
@property(nonatomic, copy)NSString*  programUrl;
///	频道ID
@property(nonatomic, copy)NSString*  channelId;
/// 码率信息
@property(nonatomic, strong)NSMutableArray <PVLiveTelevisionCodeRateList*>*  codeRateLists;
///电视台id
@property(nonatomic, copy)NSString* stationId;
///电视台名字
@property(nonatomic, copy)NSString* stationName;
//地区播放范围
@property(nonatomic, copy)NSString* area;
///版权
@property(nonatomic, copy)NSString* copyright;
///产品包
@property(nonatomic, copy)NSString* valiDataCode;
///默认播放的频道
@property(nonatomic, strong)PVLiveTelevisionChanelListModel*  chanelListModel;
///分享链接
@property(nonatomic, copy)NSString* channelShareUrl;

@end



