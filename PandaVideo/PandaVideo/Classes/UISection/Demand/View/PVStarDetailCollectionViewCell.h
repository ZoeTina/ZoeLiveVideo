//
//  PVStarDetailCollectionViewCell.h
//  PandaVideo
//
//  Created by cara on 17/8/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVVideoListModel.h"

@interface PVStarDetailCollectionViewCell : UICollectionViewCell


@property(nonatomic, assign)NSInteger type;
@property(nonatomic, strong)PVVideoListModel* videoListModel;



@end
