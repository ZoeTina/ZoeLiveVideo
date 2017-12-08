//
//  PVDemandCommentModel.h
//  PandaVideo
//
//  Created by cara on 2017/10/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

@class PVUserData,PVReplayList;

@interface PVDemandCommentModel : PVBaseModel

///评论Id
@property(nonatomic, copy)NSString* commentId;
///评论内容
@property(nonatomic, copy)NSString* content;
///发布时间
@property(nonatomic, copy)NSString* date;
@property(nonatomic, copy)NSString* detailDate;
///是否点赞
@property(nonatomic, copy)NSString* isLike;
///是否置顶
@property(nonatomic, copy)NSString* isTop;
///点赞数
@property(nonatomic, copy)NSString* like;
@property(nonatomic, strong)NSMutableArray<PVReplayList*>* replayList;
@property(nonatomic, strong)PVUserData* userData;

@end


@interface PVReplayList : PVBaseModel

@property(nonatomic, copy)NSString* commentId;
@property(nonatomic, copy)NSString* content;
@property(nonatomic, copy)NSString* date;
@property(nonatomic, copy)NSString* like;
@property(nonatomic, copy)NSString* userName;
@property(nonatomic, copy)NSString* nickName;
@property(nonatomic, assign)NSUInteger cellHeight;
@property(nonatomic, strong)PVUserData* userData;

-(void)calculationCellHeight;

@end


@interface PVUserData : PVBaseModel

///用户头像
@property(nonatomic, copy)NSString* userAvatar;
///用户ID
@property(nonatomic, copy)NSString* userId;
///用户名
@property(nonatomic, copy)NSString* userName;
@property(nonatomic, copy)NSString* nickName;

@end

