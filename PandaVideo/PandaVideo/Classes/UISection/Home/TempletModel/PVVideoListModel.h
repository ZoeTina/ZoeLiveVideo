//
//  PVVideoListModel.h
//  PandaVideo
//
//  Created by cara on 17/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVLiveTelevisionChanelListModel.h"

@class Info,Expand,ConerModel;

@interface PVVideoListModel : PVBaseModel

@property(nonatomic,copy)NSString* isUsingOrigin;
@property(nonatomic,copy)NSString* appIsUsing;
@property(nonatomic,copy)NSString* sort;
@property(nonatomic,copy)NSString* createTime;
@property(nonatomic, strong)Info*  info;
@property(nonatomic, copy)NSString*  showType;
@property(nonatomic, copy)NSString*  currentIndex;
@property(nonatomic, copy)NSString*  pageAllIndex;
@end

@interface  Info : PVBaseModel

@property(nonatomic, copy)NSString*  playArea;
@property(nonatomic, copy)NSString*  product;
@property(nonatomic, copy)NSString*  code;
@property(nonatomic, copy)NSString*  jsonUrl;
@property(nonatomic, copy)NSString*  name;
@property(nonatomic, copy)NSString*  kId;
@property(nonatomic, copy)NSString*  type;
@property(nonatomic, strong)Expand* expand;
///模板14频道模型
@property(nonatomic, strong)PVLiveTelevisionChanelListModel* ChanelListModel;

@end


@interface  Expand : PVBaseModel

@property(nonatomic, copy)NSString*  liveDate;
@property(nonatomic, strong)ConerModel* topLeftCornerModel;
@property(nonatomic, strong)ConerModel* topRightCornerModel;
@property(nonatomic, strong)ConerModel* bottomRightCornerModel;
@property(nonatomic, copy)NSString*  contentId;
@property(nonatomic, copy)NSString*  actEndTime;
@property(nonatomic, copy)NSString*  subhead;
@property(nonatomic, copy)NSString*  synopsis;
@property(nonatomic, copy)NSString*  title;
@property(nonatomic, copy)NSString*  actStartTime;
@property(nonatomic, copy)NSString*  liveCount;
@property(nonatomic, copy)NSString*  advertiseImageL;
@property(nonatomic, copy)NSString*  advertiseImageH;
@property(nonatomic, copy)NSString*  liveStatus;
@property(nonatomic, copy)NSString*  startTime;

@end

@interface  ConerModel : PVBaseModel

@property(nonatomic, copy)NSString*  tagName;
@property(nonatomic, copy)NSString*  tagColor;
@property(nonatomic, copy)NSString*  tagType;
@property(nonatomic, copy)NSString*  tagImage;

@end
