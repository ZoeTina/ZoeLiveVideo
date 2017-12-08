//
//  SCImageManager.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/7/29.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "SCAssetModel.h"

@class SCAlbumModel, SCAssetModel;
@protocol SCImagePickerControllerDelegate;
@interface SCImageManager : NSObject

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;

+ (instancetype)manager NS_SWIFT_NAME(default());
+ (void)deallocManager;

@property (assign, nonatomic) id<SCImagePickerControllerDelegate> pickerDelegate;

/// 调整照片方向
@property (nonatomic, assign) BOOL shouldFixOrientation;

/// 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;

/// 导出图片的宽度，默认828像素宽
@property (nonatomic, assign) CGFloat photoWidth;

/// SCPhotoPickerController中的照片collectionView
@property (nonatomic, assign) NSInteger columnNumber;

/// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

/// 最小可选中的图片宽度，默认是0，小于这个宽度的图片不可选中
@property (nonatomic, assign) NSInteger minPhotoWidthSelectable;
@property (nonatomic, assign) NSInteger minPhotoHeightSelectable;
@property (nonatomic, assign) BOOL hideWhenCanNotSelect;

/// 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized;
+ (NSInteger)authorizationStatus;
- (void)requestAuthorizationWithCompletion:(void (^)(void))completion;

/// 获得相册/相册数组
- (void)getCameraRollAlbum:(BOOL)allowPickingVideo
         allowPickingImage:(BOOL)allowPickingImage
                completion:(void (^)(SCAlbumModel *model))completion;

- (void)getAllAlbums:(BOOL)allowPickingVideo
   allowPickingImage:(BOOL)allowPickingImage
          completion:(void (^)(NSArray<SCAlbumModel *> *models))completion;

/// 获得Asset数组
- (void)getAssetsFromFetchResult:(PHFetchResult *)result
               allowPickingVideo:(BOOL)allowPickingVideo
               allowPickingImage:(BOOL)allowPickingImage
                      completion:(void (^)(NSArray<SCAssetModel *> *models))completion;

- (void)getAssetFromFetchResult:(PHFetchResult *)result
                        atIndex:(NSInteger)index
              allowPickingVideo:(BOOL)allowPickingVideo
              allowPickingImage:(BOOL)allowPickingImage
                     completion:(void (^)(SCAssetModel *model))completion;

/// 获得照片
- (void)getPostImageWithAlbumModel:(SCAlbumModel *)model
                        completion:(void (^)(UIImage *postImage))completion;

- (int32_t)getPhotoWithAsset:(PHAsset *)asset
                  completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;

- (int32_t)getPhotoWithAsset:(PHAsset *)asset
                  photoWidth:(CGFloat)photoWidth
                  completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;

- (int32_t)getPhotoWithAsset:(PHAsset *)asset
                  completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion
             progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler
        networkAccessAllowed:(BOOL)networkAccessAllowed;

- (int32_t)getPhotoWithAsset:(PHAsset *)asset
                  photoWidth:(CGFloat)photoWidth
                  completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion
             progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler
        networkAccessAllowed:(BOOL)networkAccessAllowed;

/// 获取原图

/// 如下两个方法completion会调多次，先返回缩略图，再返回原图，如果info[PHImageResultIsDegradedKey] 为 YES，则表明当前返回的是缩略图，否则是原图。
- (void)getOriginalPhotoWithAsset:(PHAsset *)asset
                       completion:(void (^)(UIImage *photo,NSDictionary *info))completion;

- (void)getOriginalPhotoWithAsset:(PHAsset *)asset
                    newCompletion:(void (^)(UIImage *photo,NSDictionary *info, BOOL isDegraded))completion;

// 该方法中，completion只会走一次
- (void)getOriginalPhotoDataWithAsset:(PHAsset *)asset
                           completion:(void (^)(NSData *data,NSDictionary *info, BOOL isDegraded))completion;

/// 保存照片
- (void)savePhotoWithImage:(UIImage *)image
                completion:(void (^)(NSError *error))completion;

- (void)savePhotoWithImage:(UIImage *)image
                  location:(CLLocation *)location
                completion:(void (^)(NSError *error))completion;

/// 保存视频
- (void)saveVideoWithData:(NSData *)videoData
                 location:(CLLocation *)location
               completion:(void (^)(NSError *error))completion;

/// 获得视频
- (void)getVideoWithAsset:(PHAsset *)asset
               completion:(void (^)(AVPlayerItem * playerItem, NSDictionary * info))completion;

- (void)getVideoWithAsset:(PHAsset *)asset
          progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler
               completion:(void (^)(AVPlayerItem *, NSDictionary *))completion;

/// 导出视频
- (void)getVideoOutputPathWithAsset:(PHAsset *)asset createTime:(NSString *)createTime publishTime:(NSString *)publishTime
                         completion:(void (^)(NSData *videoData))completion;

/// 获得一组照片的大小
- (void)getPhotosBytesWithArray:(NSArray *)photos
                     completion:(void (^)(NSString *totalBytes))completion;

/// 判断一个assets数组是否包含这个asset
- (BOOL)isAssetsArray:(NSArray *)assets containAsset:(PHAsset *)asset;

- (NSString *)getAssetIdentifier:(PHAsset *)asset;
- (BOOL)isCameraRollAlbum:(NSString *)albumName;

/// 检查照片大小是否满足最小要求
- (BOOL)isPhotoSelectableWithAsset:(PHAsset *)asset;
- (CGSize)photoSizeWithAsset:(PHAsset *)asset;

/// 修正图片转向
- (UIImage *)fixOrientation:(UIImage *)aImage;

/// 获取asset的资源类型
- (AssetModelMediaType)getAssetType:(PHAsset *)asset;

//获取到所有的video
- (void)getAllVideoWithCompletion:(void (^)(NSArray *))completion;

@end
