//
//  PVStarCollectionCell.m
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVStarCollectionCell.h"

@interface PVStarCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *starImageView;

@property (weak, nonatomic) IBOutlet UILabel *starNicknameLabel;

@end


@implementation PVStarCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.starImageView.image = [UIImage imageNamed:@"4.jpg"];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.starImageView.clipsToBounds = true;
    self.starImageView.layer.cornerRadius = self.sc_width*0.5;
}



@end
