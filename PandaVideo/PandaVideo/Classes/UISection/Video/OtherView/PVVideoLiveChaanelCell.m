//
//  PVVideoLiveChaanelCell.m
//  PandaVideo
//
//  Created by cara on 17/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoLiveChaanelCell.h"


@interface PVVideoLiveChaanelCell()

@property (weak, nonatomic) IBOutlet UILabel *chaanelTitleLael;
@property (weak, nonatomic) IBOutlet UILabel *chaanelTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *chanelIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelDetailLabelLeftConstraint;


@end


@implementation PVVideoLiveChaanelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setChanelListModel:(PVLiveTelevisionChanelListModel *)chanelListModel{
    _chanelListModel = chanelListModel;
    self.chaanelTitleLael.text = chanelListModel.channelName;
    if(chanelListModel.nowDetailProGramModel.programName.length){
      self.chaanelTextLabel.text = [NSString stringWithFormat:@"%@ 正在播放%@",chanelListModel.nowDetailProGramModel.startTimeFottmar, chanelListModel.nowDetailProGramModel.programName];
        self.channelDetailLabelLeftConstraint.constant = 0;
        self.chanelIconImageView.hidden = false;
    }else{
        self.chaanelTextLabel.text = @"暂无播放节目单";
        self.channelDetailLabelLeftConstraint.constant = -18;
        self.chanelIconImageView.hidden = true;
    }
    
    if(chanelListModel.channelTag.length){
        self.rightLabel.text =  chanelListModel.channelTag;
        self.rightLabel.hidden = false;
    }else{
        self.rightLabel.hidden = true;
    }
    
    if (chanelListModel.isSelected) {
        self.chaanelTitleLael.textColor = self.chaanelTextLabel.textColor = [UIColor sc_colorWithHex:0x2AB4E4];
        [self.chanelIconImageView setImage:[UIImage imageNamed:@"live_icon_play_bule"] forState:UIControlStateNormal];
    }else{
        self.chaanelTextLabel.textColor = self.chaanelTitleLael.textColor = [UIColor sc_colorWithHex:0xffffff];
        [self.chanelIconImageView setImage:[UIImage imageNamed:@"live_icon_play_grey"] forState:UIControlStateNormal];
    }
}
@end
