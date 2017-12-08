//
//  PVUploadVideoTool.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAssetModel.h"
#import "PVUGCModel.h"

@interface PVUploadVideoTool : NSObject

- (void)postAssetModel:(SCAssetModel *)assetModel videoModel:(PVUGCVideoInfo *)videoInfoModel;
- (void)compressWithAssetModel:(SCAssetModel *)assetModel assetModel:(PHAsset *)asset;

- (void)postNoticicationWithState:(NSString *)state assetModel:(SCAssetModel *)assetModel;
@end
