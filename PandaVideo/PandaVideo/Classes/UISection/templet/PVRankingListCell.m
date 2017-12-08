//
//  PVRankingListCell.m
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRankingListCell.h"

@interface PVRankingListCell()

@property (weak, nonatomic) IBOutlet UIImageView *rankListImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankListTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankListMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankListNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *rankListNumberContainerView;


@end


@implementation PVRankingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rankListImageView.image = [UIImage imageNamed:@"4.jpg"];
    CGAffineTransform rotation = CGAffineTransformMakeRotation(-M_PI_4);
    [self.rankListNumberContainerView setTransform:rotation];
    
}

-(void)setVideoListModel:(PVVideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    [self.rankListImageView sc_setImageWithUrlString:videoListModel.info.expand.advertiseImageL placeholderImage:[UIImage imageNamed:BIGBITMAP] isAvatar:false];
    self.rankListTitleLabel.text = videoListModel.info.expand.title;
    self.rankListMarkLabel.text = videoListModel.info.expand.liveCount;
}



@end
