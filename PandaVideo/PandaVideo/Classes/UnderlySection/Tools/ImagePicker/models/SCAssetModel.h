//
//  SCAssetModel.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/7/29.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVUGCModel.h"

typedef NS_ENUM(NSUInteger, AssetModelMediaType) {
    AssetModelMediaTypePhoto = 0,
    AssetModelMediaTypeLivePhoto,
    AssetModelMediaTypePhotoGif,
    AssetModelMediaTypeVideo,
    AssetModelMediaTypeAudio,
};

@class PHAsset;
@interface SCAssetModel : NSObject

/** 图像、视频对象 */
@property (nonatomic, strong) PHAsset *asset;
/** 资源对象的选中状态，默认为NO */
@property (nonatomic, assign) BOOL isSelected;
/** 资源选中顺序 */
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) AssetModelMediaType type;
/** 媒体资源时长 */
@property (nonatomic, copy) NSString *timeLength;

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *videoTitle;
@property (nonatomic, copy) NSString *videoCorverImage;
@property (nonatomic, copy) NSString *videoDescTitle;
@property (nonatomic, strong) UIImage *corverImage;
@property (nonatomic, strong) NSData *corverImageData;
@property (nonatomic, strong) PVUGCVideoInfo *videoInfo;
@property (nonatomic, strong) NSData *videoInfoData;
@property (nonatomic, copy) NSString *assetInentifier;

@property (nonatomic, assign) BOOL isDelete;

/** 视频上传状态， 0:压缩中，1:压缩失败，2:上传中，3:封面图上传失败，4.封面图上传成功，视频上传失败 5:视频上传成功，但是其他视频信息上传失败,6:上传成功*/
@property (nonatomic, copy) NSString *videoPublishState;
/**
 * 使用一个PHAsset实例，初始化一个照片模型
 */
+ (instancetype)modelWithAsset:(PHAsset *)asset
                          type:(AssetModelMediaType)type;

+ (instancetype)modelWithAsset:(PHAsset *)asset
                          type:(AssetModelMediaType)type
                    timeLength:(NSString *)timeLength;

@end

//按照日期分类
@interface SCAssetListModel : NSObject

@property(nonatomic,strong)NSString *createDate;
@property(nonatomic,strong)NSArray *modelArray;
@end

@class PHFetchResult;
@interface SCAlbumModel : NSObject

/** 相册名称 */
@property (nonatomic, strong) NSString *name;
/** 相册中容纳照片数量 */
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) PHFetchResult *result;

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSArray *selectedModels;
@property (nonatomic, assign) NSUInteger selectedCount;

@end
