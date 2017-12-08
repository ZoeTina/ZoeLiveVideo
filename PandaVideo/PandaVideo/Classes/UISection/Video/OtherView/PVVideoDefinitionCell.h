//
//  PVVideoDefinitionCell.h
//  PandaVideo
//
//  Created by cara on 2017/9/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVLiveTelevisionCodeRateList.h"
#import "PVIntroduceModel.h"

@interface PVVideoDefinitionCell : UITableViewCell

@property(nonatomic, strong)PVLiveTelevisionCodeRateList* rateListModel;
@property(nonatomic, strong)CodeRateList* introduceReteList;

@end
