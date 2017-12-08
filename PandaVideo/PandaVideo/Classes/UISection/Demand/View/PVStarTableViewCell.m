//
//  PVStarTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVStarTableViewCell.h"

@interface PVStarTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *starImageView;

@property (weak, nonatomic) IBOutlet UILabel *starNameLabel;

@end


@implementation PVStarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.starImageView.clipsToBounds = true;
    self.starImageView.layer.cornerRadius = 30;
    self.starImageView.image = [UIImage imageNamed:@"4.jpg"];
}


@end
