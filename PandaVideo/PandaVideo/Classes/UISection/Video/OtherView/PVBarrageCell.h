//
//  PVBarrageCell.h
//  PandaVideo
//
//  Created by cara on 17/8/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "BarrageViewCell.h"

@class BarrageModel, BarrageView;

@interface PVBarrageCell : BarrageViewCell

@property (strong, nonatomic) BarrageModel *model;

+ (instancetype)cellWithBarrageView:(BarrageView *)barrageView;

@end
