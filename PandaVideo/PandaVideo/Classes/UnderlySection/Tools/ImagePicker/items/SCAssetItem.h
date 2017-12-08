//
//  SCAssetItem.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/7/30.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger, SCAssetItemType) {
    SCAssetItemTypePhoto = 0,
    SCAssetItemTypeLivePhoto,
    SCAssetItemTypePhotoGif,
    SCAssetItemTypeVideo,
    SCAssetItemTypeAudio,
};

@class SCAssetModel;
@interface SCAssetItem : UICollectionViewCell

@property (nonatomic, weak) UIButton *selectPhotoButton;
@property (nonatomic, strong) SCAssetModel *model;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);

@property (nonatomic, assign) SCAssetItemType type;
@property (nonatomic, assign) BOOL allowPickingGif;
@property (nonatomic, assign) BOOL allowPickingMultipleVideo;

@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;

@property (nonatomic, copy) NSString *photoSelImageName;
@property (nonatomic, copy) NSString *photoDefImageName;

@property (nonatomic, assign) BOOL showSelectButton;

@end

