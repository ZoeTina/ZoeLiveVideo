//
//  PVUgcEditVideoViewController.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"
#import "SCAssetModel.h"
#import "PVUGCModel.h"

@interface PVUgcEditVideoViewController : SCBaseViewController
@property (nonatomic, strong) SCAssetModel *assetModel;
@property (nonatomic, strong) PVUGCModel *editUgcModel;
@end
