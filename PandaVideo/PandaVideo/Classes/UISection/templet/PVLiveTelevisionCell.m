//
//  PVLiveTelevisionCell.m
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLiveTelevisionCell.h"

@interface PVLiveTelevisionCell()

@property (weak, nonatomic) IBOutlet UIImageView *channeImageView;
@property (weak, nonatomic) IBOutlet UILabel *chahnelNicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *programLiveLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelDetailLabelLeftConstraint;


@end


@implementation PVLiveTelevisionCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


-(void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    if (isFirst) {
        self.imageViewTopConstraint.constant = -10;
    }else{
        self.imageViewTopConstraint.constant = 23;
    }
}

-(void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    self.bottomView.hidden = isLast;
}

-(void)setVideoListModel:(PVVideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    [self.channeImageView sc_setImageWithUrlString:videoListModel.info.expand.advertiseImageL placeholderImage:[UIImage imageNamed:@"cross_1_PlaceImage"] isAvatar:false];
    self.chahnelNicknameLabel.text = videoListModel.info.expand.title;
    PVLiveTelevisionChanelListModel* chanelListModel = videoListModel.info.ChanelListModel;
    if (chanelListModel) {
        self.programLiveLabel.text = chanelListModel.channelName;
        if (chanelListModel.nowDetailProGramModel.programName.length) {
            self.programLiveLabel.text = [NSString stringWithFormat:@"%@ 正在播放%@",chanelListModel.nowDetailProGramModel.startTimeFottmar, chanelListModel.nowDetailProGramModel.programName];
            self.smallImageView.hidden = false;
            self.channelDetailLabelLeftConstraint.constant = -2;
        }else{
            self.smallImageView.hidden = true;
            self.programLiveLabel.text = @"暂无播放节目单";
            self.channelDetailLabelLeftConstraint.constant = -16;
        }
    }else{
        self.smallImageView.hidden = true;
        self.programLiveLabel.text = @"正在获取节目单";
        self.channelDetailLabelLeftConstraint.constant = -16;
    }
}


@end
