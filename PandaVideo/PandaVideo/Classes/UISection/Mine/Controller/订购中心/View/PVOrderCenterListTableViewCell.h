//
//  PVOrderCenterListTableViewCell.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVOrderCenterModel.h"

@protocol PVOrderCenterListTableViewProtocolDelegate <NSObject>
- (void)orderProtocolClick;
- (void)purchaseOrderButtonClick;
@end

@interface PVOrderCenterListTableViewCell : UITableViewCell

@property (nonatomic, strong) PVOrderCenterModel *orderModel;
@property (nonatomic, weak) id <PVOrderCenterListTableViewProtocolDelegate> protocolDelegate;
@end
