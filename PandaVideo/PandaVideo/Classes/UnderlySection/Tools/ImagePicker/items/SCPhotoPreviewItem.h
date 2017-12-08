//
//  SCPhotoPreviewItem.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/8/6.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class SCAssetModel;
@interface SCAssetPreviewItem : UICollectionViewCell

@property (nonatomic, strong) SCAssetModel *model;
@property (nonatomic, copy) void (^SingleTapGestureBlock)(void);

- (void)prepareSubViews;
- (void)photoPreviewCollectionViewDidScroll;

@end




@class SCAssetModel, SCPhotoPreviewView, SCProgressView;
@interface SCPhotoPreviewItem : SCAssetPreviewItem

/** 加载进度 */
@property (nonatomic, copy) void (^ImageProgressUpdateBlock)(double progress);
@property (nonatomic, strong) SCPhotoPreviewView *previewView;

- (void)recoverSubviews;

@end




@interface SCPhotoPreviewView : UIView

/**
 * PhotoPreviewItem属性
 */
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) SCProgressView *progressView;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

@property (nonatomic, strong) SCAssetModel *model;
@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, copy) void (^SingleTapGestureBlock)(void);
@property (nonatomic, copy) void (^ImageProgressUpdateBlock)(double progress);

@property (nonatomic, assign) int32_t imageRequestID;

/**
 * 恢复重设子View
 */
- (void)recoverSubViews;

@end





@class AVPlayer, AVPlayerLayer;
@interface SCVideoPreviewItem : SCAssetPreviewItem

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIButton *playButton;
/** 封面图 */
@property (nonatomic, strong) UIImage *cover;

- (void)pausePlayerAndShowNaviBar;

@end






@interface SCGifPreviewItem : SCAssetPreviewItem

@property (nonatomic, strong) SCPhotoPreviewView *previewView;

@end
