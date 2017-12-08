//
//  PVTeleplayCollectionViewCell.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVVideoListModel.h"
#import "PVVideoTemletModel.h"
@interface PVTeleplayCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) PVVideoListModel* videoListModel;
@property(nonatomic, assign)NSInteger modelType;

@property(nonatomic, strong) PVVideoSiftingListModel* model;

@end
