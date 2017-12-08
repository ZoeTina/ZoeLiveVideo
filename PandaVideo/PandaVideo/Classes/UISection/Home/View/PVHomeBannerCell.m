//
//  PVHomeBannerCell.m
//  PandaVideo
//
//  Created by cara on 17/9/6.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHomeBannerCell.h"

@interface PVHomeBannerCell()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation PVHomeBannerCell


-(void)awakeFromNib{
    [super awakeFromNib];

}


-(void)setBannerModel:(PVBannerModel *)bannerModel{
    _bannerModel = bannerModel;
    [self.bannerImageView sc_setImageWithUrlString:bannerModel.bannerImage placeholderImage:[UIImage imageNamed:BIGBITMAP] isAvatar:false];
    self.titleLabel.text = bannerModel.bannerTxt;
    
}

@end
