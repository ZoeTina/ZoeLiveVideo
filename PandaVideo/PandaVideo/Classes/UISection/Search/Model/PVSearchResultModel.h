//
//  PVSearchResultModel.h
//  PandaVideo
//
//  Created by songxf on 2017/11/12.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PVSearchVideoListModel;
@class PVSearchEpisodeListModel;
@class PVSearchEpisodeDataModel;
@class PVSearchVideoTagDataModel,PVTagDataModel;


@interface PVSearchResultModel : NSObject

@property(nonatomic,strong)NSArray <PVSearchVideoListModel *> *videoList;
@end

@interface PVSearchVideoListModel : NSObject

//剧头的code
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSArray <PVSearchEpisodeListModel *> *episodeList;
//是否小屏端资源
@property(nonatomic,assign)BOOL isMoblieSource;
//是否大屏端资源
@property(nonatomic,assign)BOOL isTvSource;
//多级模板类型,1、数字，2、文字，3、图文
@property(nonatomic,assign)NSInteger showModel;
//0：其他类型；1：电影
@property(nonatomic, assign)NSInteger isMovie;
//
@property(nonatomic,strong)PVSearchVideoTagDataModel *tagData;
//
@property(nonatomic,copy)NSString *videoSubTitle;
//
@property(nonatomic,copy)NSString *videoTitle;
//0：单集；1：多集
@property(nonatomic,assign)NSInteger videoType;
//
@property(nonatomic,copy)NSString *videoUrl;
//
@property(nonatomic,copy)NSString *videoVImage;
//演员
@property(nonatomic,copy)NSString* actors;
//地区
@property(nonatomic,copy)NSString* area;
//年份
@property(nonatomic,copy)NSString* year;
//类型
@property(nonatomic,copy)NSString* tagType;


@end

@interface PVSearchEpisodeListModel : NSObject

//总集数
@property(nonatomic,copy)NSString *countDesc;
//更新描述
@property(nonatomic,copy)NSString *sc_description;
//
@property(nonatomic,strong)PVSearchEpisodeDataModel *episodeModel;
@end


@interface PVSearchEpisodeDataModel : NSObject

//剧集的code
@property(nonatomic,copy)NSString *code;
//横图
@property(nonatomic,copy)NSString *horizontalPic;
//剧头code
@property(nonatomic,copy)NSString *parentCode;
//排序
@property(nonatomic,assign)NSInteger sort;
//视频状态角标
@property(nonatomic,copy)NSString *tag;
//竖图
@property(nonatomic,copy)NSString *verticalPic;
//视频名
@property(nonatomic,copy)NSString *videoName;
//视频跳转类型
@property(nonatomic,copy)NSString *videoType;
//视频详情地址URL
@property(nonatomic,copy)NSString *videoUrl;
@end

@interface PVSearchVideoTagDataModel : NSObject

//右下角标
@property(nonatomic,strong)PVTagDataModel *bottomRightCornerModel;
//左上角标
@property(nonatomic,strong)PVTagDataModel *topLeftCornerModel;
//右上角标
@property(nonatomic,strong)PVTagDataModel *topRightCornerModel;

@end

@interface PVTagDataModel : NSObject

@property(nonatomic, copy)NSString*  tagColor;
@property(nonatomic, copy)NSString*  tagName;
@property(nonatomic, copy)NSString*  tagImage;
@property(nonatomic, copy)NSString*  tagType;

@end




