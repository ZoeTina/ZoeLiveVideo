//
//  PVDemandVideoDetailModel.h
//  PandaVideo
//
//  Created by cara on 17/8/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVVideoListModel.h"
#import "PVAdvertisementModel.h"


@class PVVideoModelList,PVVideoEpisodeModel,PVVideoEditorModel,PVVideoDescription;

@interface PVDemandVideoDetailModel : PVBaseModel

@property(nonatomic, assign)BOOL isShowVideoDetail;

///评论数量
@property(nonatomic, copy)NSString* commentCount;
@property(nonatomic, copy)NSString* authenticate;
@property(nonatomic, copy)NSString* mediacode;
@property(nonatomic, copy)NSString* mediaid;
@property(nonatomic, copy)NSString* videoTitle;
@property(nonatomic, copy)NSString* shareH5Url;
@property(nonatomic, copy)NSString* moviecode;
@property(nonatomic, copy)NSString* programcode;
@property(nonatomic, copy)NSString* videoUrl;
@property(nonatomic, copy)NSString* videoSubTitle;
@property(nonatomic, copy)NSString* videoImage;
@property(nonatomic, copy)NSString* parentCode;
@property(nonatomic, copy)NSString* code;
@property(nonatomic, copy)NSString* validatacode;
///0=单集；1=多集
@property(nonatomic, copy)NSString* videoType;
@property(nonatomic, copy)NSString* guid;
@property(nonatomic, strong)PVVideoModelList* videoModelList;
@property(nonatomic, strong)PVVideoDescription* videoDescription;
@property(nonatomic, assign)CGFloat videoInfoHeight;
///产品包鉴权
@property(nonatomic, copy)NSString*  authenticationState;
///视频评论限制（0、可评论，1、不能评论）
@property(nonatomic, copy)NSString*   videoComment;
///视频区域限制(1=省内, 2=全国)
@property(nonatomic, copy)NSString*   videoDistrict;
///收藏状态（0、已收藏，1,未收藏）
@property(nonatomic, copy)NSString*  favoriteState;
///影片观看次数
@property(nonatomic, copy)NSString*      playNum;

///计算视频简介高度
-(void)calculationVideoInfoHeight;

@end


@interface PVVideoModelList : PVBaseModel

@property(nonatomic, strong)PVVideoEpisodeModel* videoEpisodeModel;
///小编推荐位
@property(nonatomic, strong)PVVideoEditorModel* videoEditorModel;
///广告位
@property(nonatomic, strong)NSMutableArray<PVVideoEditorModel*>* videoAdvertisedModels;
///广告数据源
@property(nonatomic, strong)NSMutableArray<PVAdvertisementModel*>* advertisementModels;

@end

@interface PVVideoEpisodeModel : PVBaseModel

@property(nonatomic, copy)NSString* epospdeUrl;
@property(nonatomic, copy)NSString* kDescription;
@property(nonatomic, copy)NSString* countDesc;
@property(nonatomic, copy)NSString* modelType;

@end


@interface PVVideoEditorModel : PVBaseModel

@property(nonatomic, copy)NSString* modelName;
@property(nonatomic, copy)NSString* modelUrl;
@property(nonatomic, strong)NSMutableArray<PVVideoListModel*>*  videoList;

@end

@interface PVVideoDescription : PVBaseModel

@property(nonatomic, copy)NSString* area;
@property(nonatomic, copy)NSString* actors;
@property(nonatomic, copy)NSString* year;
@property(nonatomic, copy)NSString* rank;
@property(nonatomic, copy)NSString* updateMsg;
@property(nonatomic, copy)NSString* type;

@end

