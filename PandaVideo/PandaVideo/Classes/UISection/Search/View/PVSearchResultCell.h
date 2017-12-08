//
//  PVSearchResultCell.h
//  PandaVideo
//
//  Created by cara on 17/8/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PVSearchResultModel.h"
@interface PVSearchResultCell : UITableViewCell

@property(nonatomic,strong)PVSearchVideoListModel * model;
@property(nonatomic,copy)void (^playTVBlock)(void);
@property(nonatomic,copy)void (^addCloudBlock)(UIButton * button);
@end
