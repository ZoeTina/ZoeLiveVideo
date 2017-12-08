//
//  PVLiveTelevisionCell.h
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVVideoListModel.h"

@interface PVLiveTelevisionCell : UICollectionViewCell

@property(nonatomic, assign)BOOL isFirst;
@property(nonatomic, assign)BOOL isLast;
@property(nonatomic, strong)PVVideoListModel* videoListModel;


@end
