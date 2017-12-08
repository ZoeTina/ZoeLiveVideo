//
//  PVTeleplaylistModel.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PVSecondColumnVideoList,PVSecondColumnInfo,PVSecondColumnExpand;
@interface PVTeleplaylistModel : PVBaseModel

/** 直播间信息数据Data */
@property (nonatomic,strong) NSMutableArray<PVSecondColumnVideoList*> *videoList;
/** 错误消息 */
@property (nonatomic,assign) NSInteger *showType;
@property (nonatomic,assign) NSInteger *currentIndex;
@property (nonatomic,assign) NSInteger *pageAllIndex;

@end

@interface PVSecondColumnVideoList : PVBaseModel
@property (nonatomic,copy) NSString *isUsingOrigin;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *appIsUsing;
@property (nonatomic,strong) PVSecondColumnInfo *info;
@property (nonatomic,assign) NSInteger *playArea;
@property (nonatomic,assign) NSInteger *product;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *jsonUrl;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *tid;
@property (nonatomic,assign) NSInteger *type;

@end

@interface PVSecondColumnInfo : NSObject
@property (nonatomic,strong) PVSecondColumnExpand *expand;
@property (nonatomic,copy) NSString *playArea;
@property (nonatomic,copy) NSString *product;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *jsonUrl;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *tid;
@property (nonatomic,copy) NSString *type;

@end

@interface PVSecondColumnExpand : PVBaseModel

@property (nonatomic,copy) NSString *liveDate;
@property (nonatomic,copy) NSString *topLeftCorner;
@property (nonatomic,copy) NSString *bottomRightCorner;
@property (nonatomic,copy) NSString *contentId;
@property (nonatomic,copy) NSString *actEndTime;
@property (nonatomic,copy) NSString *subhead;
@property (nonatomic,copy) NSString *synopsis;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *selectColor;
@property (nonatomic,copy) NSString *actStartTime;
@property (nonatomic,copy) NSString *liveCount;
@property (nonatomic,copy) NSString *advertiseImageL;
@property (nonatomic,copy) NSString *topRightCorner;
@property (nonatomic,copy) NSString *advertiseImageH;
@property (nonatomic,copy) NSString *liveStatus;

@end


@interface PVChoiceSecondColumnModels : PVBaseModel


@property (nonatomic,copy) NSString *modelId;
@property (nonatomic,copy) NSString *modelCode;
@property (nonatomic,copy) NSString *modelType;
@property (nonatomic,copy) NSString *modelUrl;

@end
