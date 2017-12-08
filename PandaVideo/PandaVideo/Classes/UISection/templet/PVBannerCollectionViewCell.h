//
//  PVBannerCollectionViewCell.h
//  PandaVideo
//
//  Created by cara on 2017/10/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVBannerModel.h"

typedef void(^PVBannerCollectionViewCellCallBlock)(PVBannerModel* bannerModel);

@interface PVBannerCollectionViewCell : UICollectionViewCell

@property(nonatomic, assign)NSInteger type;

-(void)listDataSource:(NSArray*)dataSource;

-(void)setPVBannerCollectionViewCellCallBlock:(PVBannerCollectionViewCellCallBlock)block;

@end
