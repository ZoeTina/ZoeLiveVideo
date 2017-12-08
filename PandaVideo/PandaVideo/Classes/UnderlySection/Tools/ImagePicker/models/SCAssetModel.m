//
//  SCAssetModel.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/7/29.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "SCAssetModel.h"
#import "SCImageManager.h"

@implementation SCAssetModel

+ (instancetype)modelWithAsset:(PHAsset *)asset
                          type:(AssetModelMediaType)type {
    SCAssetModel *model = [[SCAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(PHAsset *)asset
                          type:(AssetModelMediaType)type
                    timeLength:(NSString *)timeLength {
    SCAssetModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

@end

//按照日期分类
@implementation SCAssetListModel

@end

@implementation SCAlbumModel

- (void)setResult:(PHFetchResult *)result {
    _result = result;
    BOOL allowPickingImage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allowPickingImage"] isEqualToString:@"1"];
    BOOL allowPickingVideo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allowPickingVideo"] isEqualToString:@"1"];
    [[SCImageManager manager] getAssetsFromFetchResult:result allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage completion:^(NSArray<SCAssetModel *> *models) {
        _models = models;
        if (_selectedModels) {
            [self checkSelectedModels];
        }
    }];
}

- (void)setSelectedModels:(NSArray *)selectedModels {
    _selectedModels = selectedModels;
    if (_models) {
        [self checkSelectedModels];
    }
}

- (void)checkSelectedModels {
    self.selectedCount = 0;
    NSMutableArray *selectedAssets = [NSMutableArray array];
    for (SCAssetModel *model in _selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    for (SCAssetModel *model in _models) {
        if ([[SCImageManager manager] isAssetsArray:selectedAssets containAsset:model.asset]) {
            self.selectedCount++;
        }
    }
}

- (NSString *)name {
    if (_name) {
        return _name;
    }
    return @"";
}

@end
