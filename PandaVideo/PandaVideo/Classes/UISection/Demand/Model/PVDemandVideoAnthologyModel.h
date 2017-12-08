//
//  PVDemandVideoAnthologyModel.h
//  PandaVideo
//
//  Created by cara on 17/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

/*
 "showModel": "展示样式",
 "videoUrl": "http://172.16.17.188:666/Video/2017/09/05/00200002000000030000000000031961.json",
 "videoName": "花千骨04.ts",
 "videoType": "视频跳转类型",
 "horizontalPic": null,
 "verticalPic": "http://f.hiphotos.baidu.com/video/pic/item/9c16fdfaaf51f3ded738a8809eeef01f3b29794f.jpg",
 "videoId": "00200002000000030000000000031961",
 "sort": 4,
 "tag": "最新"
 */

@interface PVDemandVideoAnthologyModel : PVBaseModel

///展示类型
@property(nonatomic, copy)NSString* showModel;
///视频详情地址URL
@property(nonatomic, copy)NSString* videoUrl;
///视频名
@property(nonatomic, copy)NSString* videoName;
///视频跳转类型
@property(nonatomic, copy)NSString* videoType;
///横图
@property(nonatomic, copy)NSString* horizontalPic;
///竖图
@property(nonatomic, copy)NSString* verticalPic;
///视频ID
@property(nonatomic, copy)NSString* videoId;
@property(nonatomic, copy)NSString* code;
///排序
@property(nonatomic, copy)NSString* sort;
///视频状态角标
@property(nonatomic, copy)NSString* tag;
///总集数
@property(nonatomic, copy)NSString* count;
///是否正在播放
@property(nonatomic, assign)BOOL isPlaying;
///收藏时间
@property(nonatomic, copy)NSString* playStopTime;
///播放了多长
@property(nonatomic, copy)NSString* playVideoLength;
///视频总时长
@property(nonatomic, copy)NSString* totalVideoLength;
///请求资源
@property(nonatomic, copy)NSString* jsonUrl;

@end
