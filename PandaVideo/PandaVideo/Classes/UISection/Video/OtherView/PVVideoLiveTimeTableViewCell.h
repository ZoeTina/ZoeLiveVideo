//
//  PVVideoLiveTimeTableViewCell.h
//  PandaVideo
//
//  Created by cara on 17/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVLiveTelevisionProGramModel.h"
#import "PVLiveTelevisionAreaModel.h"

@interface PVVideoLiveTimeTableViewCell : UITableViewCell

@property(nonatomic, strong)PVLiveTelevisionProGramModel* proGramModel;

@property(nonatomic, strong)PVLiveTelevisionAreaModel* areaModel;

@end
