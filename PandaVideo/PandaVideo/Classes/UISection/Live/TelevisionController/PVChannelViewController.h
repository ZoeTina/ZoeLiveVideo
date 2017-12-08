//
//  PVChannelViewController.h
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVLiveTelevisionDefaultChannelModel.h"
#import "PVLiveTelevisionChanelListModel.h"
#import "PVLiveTelevisionAreaModel.h"

typedef void(^PVChannelViewControllerCallBlock)(PVLiveTelevisionChanelListModel* chanelListModel);

@interface PVChannelViewController : UIViewController

///左边频道名称
@property(nonatomic, strong)UITableView* channelTableView;
///右边节目单
@property(nonatomic, strong)UITableView* channelDetailTableView;
@property(nonatomic, copy)NSString* url;
@property(nonatomic, strong)NSMutableArray* channelDataSource;
@property(nonatomic, strong)PVLiveTelevisionDefaultChannelModel* defaultChannelModel;
@property(nonatomic, strong)PVLiveTelevisionAreaModel* selectedAreaModel;
@property(nonatomic, strong)PVLiveTelevisionChanelListModel* selectedChanelListModel;

-(void)setPVChannelViewControllerCallBlock:(PVChannelViewControllerCallBlock)block;

-(void)loadLocalCollectionData;

@end
