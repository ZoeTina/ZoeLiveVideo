//
//  PVTimeTableViewCell.h
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVLiveTelevisionAreaModel.h"
#import "PVLiveTelevisionProGramModel.h"

@interface PVTimeTableViewCell : UITableViewCell

@property(nonatomic, copy)NSString* timeString;

@property(nonatomic, assign)BOOL  isCrossScreen;

@property(nonatomic, strong)PVLiveTelevisionAreaModel* areaModel;
@property(nonatomic, strong)PVLiveTelevisionProGramModel* proGramModel;

@end
