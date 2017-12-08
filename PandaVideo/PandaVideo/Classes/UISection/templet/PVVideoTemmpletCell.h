//
//  PVVideoTemmpletCell.h
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVVideoListModel.h"
#import "PVVideoDetailTempletCell.h"
#import "TYCyclePagerView.h"


typedef void(^PVVideoTemmpletCellCallBlock)(PVVideoListModel* videoListModel);


@interface PVVideoTemmpletCell : UICollectionViewCell


// 1.视频cell  2.明星cell
@property(nonatomic, assign)NSInteger type;

@property(nonatomic, strong)NSArray<PVVideoListModel*>* videoDataSource;

//@property(nonatomic, strong)UICollectionView* videoTempletCollectView;
@property(nonatomic, strong)NSMutableArray*   videoTempletDataSource;
@property (nonatomic, strong)TYCyclePagerView *pagerView;

-(void)setPVVideoTemmpletCellCallBlock:(PVVideoTemmpletCellCallBlock)block;

@end
