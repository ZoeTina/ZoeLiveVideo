//
//  PVHomeBannerCell.h
//  PandaVideo
//
//  Created by cara on 17/9/6.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVBannerModel.h"

@interface PVHomeBannerCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property(nonatomic, strong)PVBannerModel* bannerModel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
