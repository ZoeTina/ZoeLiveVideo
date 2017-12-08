//
//  PVPictrueTemmpletCell.m
//  PandaVideo
//
//  Created by cara on 2017/10/16.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPictrueTemmpletCell.h"


@interface   PVPictrueTemmpletCell()


@property(nonatomic, strong)UIImageView* pictureImageView;


@end


@implementation PVPictrueTemmpletCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIView* topView = [[UIView alloc]  init];
    topView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@3);
    }];
    UIImageView*  pictureImageView = [[UIImageView alloc]   init];
    [self addSubview:pictureImageView];
    self.pictureImageView = pictureImageView;
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(self);
    }];
}

-(void)setBannerModel:(PVBannerModel *)bannerModel{
    _bannerModel = bannerModel;
    [self.pictureImageView sc_setImageWithUrlString:bannerModel.bannerImage placeholderImage:nil isAvatar:false];
}


@end
