//
//  PVChannelTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVChannelTableViewCell.h"
#import "PVDottedLineView.h"


@interface PVChannelTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *channelImageView;
@property (weak, nonatomic) IBOutlet UILabel *channalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *channalDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *definitionLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (nonatomic, strong)PVDottedLineView* lineView;
@property (nonatomic, copy)PVChannelTableViewCellCallBlock callBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelDetailLabelLeftConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end



@implementation PVChannelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    PVDottedLineView* lineView = [[PVDottedLineView alloc]  init];
    self.lineView = lineView;
    [self.contentView insertSubview:lineView atIndex:0];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@(0));
        make.width.equalTo(@(1));
        make.bottom.equalTo(@(0));
    }];

    self.bottomView.hidden = false;
}


-(void)setPVChannelTableViewCellCallBlock:(PVChannelTableViewCellCallBlock)block{
    self.callBlock = block;
}

-(void)setIsFisrt:(BOOL)isFisrt{
    _isFisrt = isFisrt;
    if (!isFisrt) {
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.top.equalTo(@(24));
            make.width.equalTo(@(1));
            make.bottom.equalTo(@(0));
        }];
    }else{
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.top.equalTo(@(0));
            make.width.equalTo(@(1));
            make.bottom.equalTo(@(0));
        }];
    }
}

-(void)setChanelListModel:(PVLiveTelevisionChanelListModel *)chanelListModel{
    _chanelListModel = chanelListModel;
    self.channalNameLabel.text = chanelListModel.channelName;
    if (chanelListModel.nowDetailProGramModel.programName.length) {
        self.channalDetailLabel.text = [NSString stringWithFormat:@"%@ 正在播放%@",chanelListModel.nowDetailProGramModel.startTimeFottmar, chanelListModel.nowDetailProGramModel.programName];
        self.smallImageView.hidden = false;
        self.channelDetailLabelLeftConstraint.constant = -2;
    }else{
        self.smallImageView.hidden = true;
        self.channalDetailLabel.text = @"暂无播放节目单";
        self.channelDetailLabelLeftConstraint.constant = -18;
    }
    
    
    NSLog(@"---313131%@---",chanelListModel.channelTag);
    
    if (chanelListModel.channelTag.length) {
        self.definitionLabel.text =  chanelListModel.channelTag;
        self.definitionLabel.hidden = false;
    }else{
        self.definitionLabel.hidden = true;
    }
    
    if (chanelListModel.isSelected) {
        self.channalNameLabel.textColor = self.channalDetailLabel.textColor = [UIColor sc_colorWithHex:0x00B6E9];
        self.smallImageView.image = [UIImage imageNamed:@"live_icon_play_bule"];
    }else{
        self.channalDetailLabel.textColor = [UIColor sc_colorWithHex:0x808080];
        self.channalNameLabel.textColor = [UIColor sc_colorWithHex:0x000000];
        self.smallImageView.image = [UIImage imageNamed:@"live_icon_play_grey"];
    }
    self.collectionBtn.selected = chanelListModel.isCollect;
    [self.channelImageView sd_setImageWithURL:[NSURL URLWithString:chanelListModel.channelLogo] placeholderImage:[UIImage imageNamed:CROSSMAPBITMAP]];
}

- (IBAction)collectionBtnClicked {
    if (self.callBlock) {
        self.callBlock(self.chanelListModel);
    }
    
}

@end
