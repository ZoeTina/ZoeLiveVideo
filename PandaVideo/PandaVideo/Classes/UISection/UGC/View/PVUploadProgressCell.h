//
//  PVUploadProgressCell.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAssetModel.h"

typedef void(^PVUploadProgressCellBlock)(UIButton *button);

@interface PVUploadProgressCell : UITableViewCell
- (void)setPVUploadProgressCellBlock:(PVUploadProgressCellBlock)block;

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) SCAssetModel *assetModel;
@property (nonatomic, copy) PVUploadProgressCellBlock block;
@end
