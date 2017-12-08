//
//  PVInfoCommentTableViewCell.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVInfoCommentModel.h"

typedef void(^PVInfoCommentTableViewCellBlock)(id sender);

@interface PVInfoCommentTableViewCell : UITableViewCell

- (void)setPVInfoCommentTableViewCellBlock:(PVInfoCommentTableViewCellBlock)block;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) PVInfoCommentModel *commentModel;
@end
