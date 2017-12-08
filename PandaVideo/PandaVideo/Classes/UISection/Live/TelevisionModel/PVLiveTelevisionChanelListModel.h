//
//  PVLiveTelevisionChanelListModel.h
//  PandaVideo
//
//  Created by cara on 17/9/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVLiveTelevisionCodeRateList.h"
#import "PVLiveTelevisionProGramModel.h"

/*
 programDateUrl": "http://182.138.102.131:8080/App/Live/tv/schedule/00000001000000050000000000000194_schedule_date.json",
 "channelShareUrl": "频道分享URL",
 "lookbackUrl": "http://101.207.176.15/sdlive/cctv13/index.m3u8",
 "codeRateList": [
 
 {
 "showName": "流畅",
 "rateFileUrl": "码率M3U8文件名",
 "sort": 1,
 "isDefaultRate": true
 }
 ],
 "liveUrl": "http://101.207.176.15/hdlive/sctv1/index.m3u8",
 "channelName": "SCTV-1",
 "channelType": 0,
 "sort": null,
 "channelLogo": "",
 "channelTag": "频道标签",
 "channelId": "2a007723-9a7d-4839-abbb-339d5f526a41"
 
 */

@class PVLiveTelevisionBackProgramInfoModel;

@interface PVLiveTelevisionChanelListModel : PVBaseModel

///电视台id
@property(nonatomic, copy)NSString*  stationId;
///频道ID
@property(nonatomic, copy)NSString*  channelId;
///频道图标
@property(nonatomic, copy)NSString*  channelLogo;
///频道名字
@property(nonatomic, copy)NSString*  channelName;
///频道分享URL
@property(nonatomic, copy)NSString*  channelShareUrl;
///频道标签
@property(nonatomic, copy)NSString*  channelTag;
///频道类型
@property(nonatomic, copy)NSString*  channelType;
///直播地址
@property(nonatomic, copy)NSString*  liveUrl;
///回看地址
@property(nonatomic, copy)NSString*  lookbackUrl;
///节目单日期详情URL
@property(nonatomic, copy)NSString*  programDateUrl;
@property(nonatomic, copy)NSString*  programUrl;
///排序
@property(nonatomic, copy)NSString*  sort;
///是否被收藏
@property(nonatomic, assign)BOOL isCollect;
///码率列表对象
@property(nonatomic, strong)NSMutableArray<PVLiveTelevisionCodeRateList*>* codeRateLists;
///频道下对应的节目单url
@property(nonatomic, strong)NSMutableArray<PVLiveTelevisionProGramModel*>* programs;
///找出要现在正在播放的节目单
@property(nonatomic, strong)PVLiveTelevisionProGramModel* nowProGramModel;
///找出要显示该频道正在播放的节目单
@property(nonatomic, strong)PVLiveTelevisionDetailProGramModel*nowDetailProGramModel;
///是否被选中
@property(nonatomic, assign)BOOL isSelected;
///地区播放范围
@property(nonatomic, copy)NSString* area;
///版权
@property(nonatomic, copy)NSString* copyright;
///产品包类型
@property(nonatomic, copy)NSString* valiDataCode;


///跳转过来的回看节目单模型
@property(nonatomic, strong)PVLiveTelevisionBackProgramInfoModel* backProgramInfoModel;

@end


@interface PVLiveTelevisionBackProgramInfoModel : PVBaseModel

@property(nonatomic, copy)NSString*  copyright;
@property(nonatomic, copy)NSString*  programCode;
@property(nonatomic, copy)NSString*  jsonUrl;
@property(nonatomic, copy)NSString*  showTime;
@property(nonatomic, copy)NSString*  objectType;
@property(nonatomic, copy)NSString*  duration;
@property(nonatomic, copy)NSString*  programName;
@property(nonatomic, copy)NSString*  genre;
@property(nonatomic, copy)NSString*  startTime;
@property(nonatomic, copy)NSString*  kId;
@property(nonatomic, copy)NSString*  channelId;
@property(nonatomic, copy)NSString*  scheduleId;
@property(nonatomic, copy)NSString*  startDate;
@property(nonatomic, copy)NSString*  channelCode;
@property(nonatomic, copy)NSString*  status;

@end
