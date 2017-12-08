//
//  PVFindCommentModel.h
//  PandaVideo
//
//  Created by cara on 17/8/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVDemandCommentModel.h"

@interface PVFindCommentModel : PVBaseModel

///正文
@property(nonatomic, copy) NSString* text;
///头部四条正文高度
@property(nonatomic, assign)CGFloat  headHeight;
///头部全部正文高度
@property(nonatomic, assign)CGFloat  headFullHeight;
///是否需要显示全文按钮
@property(nonatomic, assign)BOOL isShowFullBtn;
///是否需要展开正文
@property(nonatomic, assign)BOOL isShowText;
///是否需要显示展开更多
@property(nonatomic, assign)BOOL isShowMoreBtn;
///是否需要展开评论
@property(nonatomic, assign)BOOL isShowComment;
///评论的数据
@property(nonatomic, strong)PVDemandCommentModel* demandCommentModel;
///回复评论
@property(nonatomic, strong)PVReplayList* replayList;

@end
