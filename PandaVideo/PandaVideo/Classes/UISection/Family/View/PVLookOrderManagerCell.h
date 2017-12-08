//
//  PVLookOrderManagerCell.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVHistoryModel.h"
#import "PVTeleCloudVideoModel.h"
typedef void(^PVLookOrderManagerCellBlock)(UIButton *);

@interface PVLookOrderManagerCell : UITableViewCell
@property (nonatomic, strong) PVTeleCloudVideoListModel *model;
@property (nonatomic, assign) BOOL isShow;

- (void)setPVLookOrderManagerCellBlock:(PVLookOrderManagerCellBlock)block;
@end
