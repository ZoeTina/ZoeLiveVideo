//
//  PVVideoChannelViewController.h
//  PandaVideo
//
//  Created by cara on 17/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVLiveTelevisionAreaModel.h"
#import "PVLiveTelevisionChanelListModel.h"
#import "PVLiveTelevisionDefaultChannelModel.h"


typedef void(^PVVideoChannelViewControllerCallBlock)(PVLiveTelevisionDefaultChannelModel* defaultChannelModel,PVLiveTelevisionAreaModel* selectedAreaModel,PVLiveTelevisionChanelListModel* selectedChanelListModel);


@interface PVVideoChannelViewController : UIViewController

///左边时间
@property(nonatomic, strong)UITableView* timeTableView;
@property(nonatomic, strong)NSMutableArray* timeDataSource;
///右边节目单
@property(nonatomic, strong)UITableView* proGramTableView;
@property(nonatomic, strong)PVLiveTelevisionDefaultChannelModel* defaultChannelModel;
@property(nonatomic, strong)PVLiveTelevisionAreaModel* selectedAreaModel;
@property(nonatomic, strong)PVLiveTelevisionChanelListModel* selectedChanelListModel;


-(void)setPVVideoChannelViewControllerCallBlock:(PVVideoChannelViewControllerCallBlock)block;

@end
