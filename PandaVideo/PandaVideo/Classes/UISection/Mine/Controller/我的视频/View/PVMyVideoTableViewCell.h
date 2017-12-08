//
//  PVMyVideoTableViewCell.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVMyVideoModel.h"

typedef void(^PVMyVideoTableViewCellBlock)(UIButton *);

@interface PVMyVideoTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) PVMyVideoModel *videoModel;

- (void)setPVMyVideoTableViewCellBlock:(PVMyVideoTableViewCellBlock)block;

@end
