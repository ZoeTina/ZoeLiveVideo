//
//  PVFindHomeModel.h
//  PandaVideo
//
//  Created by cara on 17/7/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVVideoListModel.h"

@class AuthorData;

@interface PVFindHomeModel : PVBaseModel

@property(nonatomic, assign)BOOL isPlayVideo;
@property(nonatomic, assign)BOOL  isHiddenPlayBtn;
@property(nonatomic, strong)PVVideoListModel* videoListModel;
@property(nonatomic, assign)CGFloat cellHeight;
@property(nonatomic, assign)CGFloat cellDetailHeight;
@property(nonatomic, copy)NSString* publishTimeStr;
@property(nonatomic, copy)NSString* videoTime;
@property(nonatomic, copy)NSString* userIcon;

@property(nonatomic, strong)AuthorData* authorData;
@property(nonatomic, copy)NSString* code;
@property(nonatomic, copy)NSString* commentCount;
@property(nonatomic, copy)NSString* date;
@property(nonatomic, copy)NSString* image;
@property(nonatomic, copy)NSString* isUp;
@property(nonatomic, copy)NSString* length;
@property(nonatomic, copy)NSString* shareH5Url;
@property(nonatomic, copy)NSString* subTitle;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* upCount;
@property(nonatomic, copy)NSString* videoUrl;
@property(nonatomic, copy)NSString* playVideoUrl;

@end



@interface AuthorData : PVBaseModel

@property(nonatomic, copy)NSString* authorCode;
@property(nonatomic, copy)NSString* info;
@property(nonatomic, copy)NSString* logo;
@property(nonatomic, copy)NSString* name;

@end
