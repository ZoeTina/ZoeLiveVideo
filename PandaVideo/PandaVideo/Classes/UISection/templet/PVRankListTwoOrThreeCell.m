//
//  PVRankListTwoOrThreeCell.m
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRankListTwoOrThreeCell.h"

@interface PVRankListTwoOrThreeCell()

@property (weak, nonatomic) IBOutlet UIImageView *rankListImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankListNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankListTitle;
@property (weak, nonatomic) IBOutlet UILabel *rankListDetailTitle;
@property (weak, nonatomic) IBOutlet UIView *rankListNumberContainerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end



@implementation PVRankListTwoOrThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.rankListImageView.image = [UIImage imageNamed:@"4.jpg"];
    CGAffineTransform rotation = CGAffineTransformMakeRotation(-M_PI_4);
    [self.rankListNumberContainerView setTransform:rotation];
}


-(void)setIndex:(NSInteger)index{
    _index = index;
    self.rankListNumberLabel.text = [NSString stringWithFormat:@"%d",index+1];
}

-(void)setVideoListModel:(PVVideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    [self.rankListImageView sc_setImageWithUrlString:videoListModel.info.expand.advertiseImageL placeholderImage:[UIImage imageNamed:VERTICALMAPBITMAP] isAvatar:false];
    self.rankListTitle.text = videoListModel.info.expand.title;
    self.rankListDetailTitle.text = videoListModel.info.expand.subhead;
}

-(void)setIsRanking:(BOOL)isRanking{
    _isRanking = isRanking;
    self.rankListNumberContainerView.hidden = self.rankListNumberLabel.hidden = false;
    if (_index == 0) {
        self.rankListNumberContainerView.backgroundColor = [UIColor sc_colorWithHex:0xF34B4B];
    }else if (_index == 1){
        self.rankListNumberContainerView.backgroundColor = [UIColor sc_colorWithHex:0xFF814E];
    }else if (_index == 2){
        self.rankListNumberContainerView.backgroundColor = [UIColor sc_colorWithHex:0xFFB633];
    }else{
        self.rankListNumberContainerView.hidden = self.rankListNumberLabel.hidden = true;
    }
}


@end
