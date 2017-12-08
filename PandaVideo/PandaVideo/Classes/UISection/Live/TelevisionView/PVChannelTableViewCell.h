//
//  PVChannelTableViewCell.h
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVLiveTelevisionChanelListModel.h"


typedef void(^PVChannelTableViewCellCallBlock)(PVLiveTelevisionChanelListModel* chanelListModel);

@interface PVChannelTableViewCell : UITableViewCell


@property(nonatomic, assign)BOOL isFisrt;

@property(nonatomic, strong)PVLiveTelevisionChanelListModel* chanelListModel;

-(void)setPVChannelTableViewCellCallBlock:(PVChannelTableViewCellCallBlock)block;

@end
