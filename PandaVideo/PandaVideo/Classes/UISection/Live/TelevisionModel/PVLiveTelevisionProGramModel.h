//
//  PVLiveTelevisionProGramModel.h
//  PandaVideo
//
//  Created by cara on 17/9/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVDBManager.h"

@class PVLiveTelevisionDetailProGramModel;

@interface PVLiveTelevisionProGramModel : PVBaseModel

///节目单日期
@property(nonatomic, copy)NSString* date;
///日期类型(1:今天,2:昨天,3:明天)
@property(nonatomic, assign)NSInteger type;
///日期对应的周末制度
@property(nonatomic, copy)NSString* dateString;
/// programUrl
@property(nonatomic, copy)NSString* programUrl;
///是否选中
@property(nonatomic, assign)BOOL isSelected;
///所有节目单
@property(nonatomic, strong)NSMutableArray<PVLiveTelevisionDetailProGramModel*>* programs;
///是否刷新了
@property(nonatomic, assign)BOOL isRefresh;

///查看今天预约状态
-(void)selectTodayProgramAppointMentStatus;


@end


@interface PVLiveTelevisionDetailProGramModel : PVBaseModel

/*
 "duration": 63200,
 "programName": "英超第14轮:曼城-切尔西",
 "isValid": true,
 "startTime": "01:20:00",
 "programId": "0a007723-9a7d-4839-abbb-339d5f526a42"
 */

///节目名称
@property(nonatomic, copy)NSString* programName;
///是否有效
@property(nonatomic, copy)NSString* isValid;
///开始时间
@property(nonatomic, copy)NSString* startTime;
///显示正确的格式时间
@property(nonatomic, copy)NSString* startTimeFottmar;
///节目时长
@property(nonatomic, copy)NSString* duration;
///programId
@property(nonatomic, copy)NSString* programId;
///type (1:回看, 2:播放中, 3:正在直播, 4:今天还没有播放的节目)
@property(nonatomic, assign)NSInteger type;
///是否正在直播
@property(nonatomic, assign)BOOL isPlaying;
///是否预约(1.已预约,2:没有预约)
@property(nonatomic, copy)NSString* appointMentStatus;
@property(nonatomic, assign)NSTimeInterval difinationStartTime;

///计算节目单时间
-(void)calculationProgramTime:(NSString*)dateStr;
//预约-通知
- (void)sureLocalNotification;
//取消预约-通知
- (void)cancelLocalNotificationWithKey:(NSString *)key;

@end
