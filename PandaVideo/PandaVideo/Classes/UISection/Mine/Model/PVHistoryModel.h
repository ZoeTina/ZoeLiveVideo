//
//  PVHistoryModel.h
//  PandaVideo
//
//  Created by cara on 17/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

@class PVHistoryModel;

@interface PVHistoryListModel : PVBaseModel

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSArray <PVHistoryModel *> *historyList;

@end

@interface PVHistoryModel : PVBaseModel

///是否要删除
@property(nonatomic, assign)BOOL isDelete;

@property (nonatomic, copy) NSString *time; //收藏时间
@property (nonatomic, assign) NSInteger playLength; //记录播放时长
@property (nonatomic, copy) NSString *title; //    视频标题
@property (nonatomic, copy) NSString *code; //视频Id
@property (nonatomic, assign) NSInteger videoType; //0：单集 1：多集
@property (nonatomic, copy) NSString *videoUrl; //视频详情URL
@property (nonatomic, copy) NSString *icon; //封面
@property (nonatomic, copy) NSString *jsonUrl; //资源URL
@property (nonatomic, copy) NSString *length; //视频时长
@end
