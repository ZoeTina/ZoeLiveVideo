//
//  PVNoticeInfoTableViewCell.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVNoticeInfoModel.h"

@interface PVNoticeInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tipsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) PVNoticeInfoModel *infoModel;
@end
