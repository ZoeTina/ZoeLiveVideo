//
//  PVVideoLiveTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoLiveTableViewCell.h"

@interface PVVideoLiveTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UILabel *videoTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn;

@property (weak, nonatomic) IBOutlet UIView *smallView;
@property (nonatomic, copy)PVProGramTableViewCellCallBlock callBlock;

@end


@implementation PVVideoLiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.appointmentBtn.layer.borderWidth = 1.0f;
    self.appointmentBtn.clipsToBounds = true;
    self.appointmentBtn.layer.cornerRadius = 13.0f;
    self.smallView.clipsToBounds = true;
    self.smallView.layer.cornerRadius = 5.0f;

    
}


-(void)setPVProGramTableViewCellCallBlock:(PVProGramTableViewCellCallBlock)block{
    self.callBlock = block;
}

- (IBAction)appointmentBtnClicked {
    if (self.callBlock) {
        self.callBlock();
    }
}


-(void)setDetailProGramModel:(PVLiveTelevisionDetailProGramModel *)detailProGramModel{
    _detailProGramModel = detailProGramModel;
    self.timeLabel.text = detailProGramModel.startTimeFottmar;
    self.videoTextLabel.text = detailProGramModel.programName;
    self.appointmentBtn.hidden = true;
    self.smallView.hidden = true;;
    self.statusLabel.hidden = false;
    if (detailProGramModel.appointMentStatus.integerValue == 1) {//已经预约
        self.appointmentBtn.selected = true;
        self.appointmentBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.appointmentBtn.backgroundColor = [UIColor sc_colorWithHex:0xFF434C];
    }else{
        self.appointmentBtn.selected = false;
        self.appointmentBtn.layer.borderColor = [UIColor sc_colorWithHex:0x00B6E9].CGColor;
        self.appointmentBtn.backgroundColor = [UIColor blackColor];
    }
    if (detailProGramModel.type == 1) {
        self.leftImageView.hidden = true;
        self.statusLabel.text = @"回看";
        self.timeLabel.textColor = self.videoTextLabel.textColor = self.statusLabel.textColor = [UIColor sc_colorWithHex:0xFFFFFF];
    }else if (detailProGramModel.type == 2){
        self.leftImageView.hidden = false;
        self.statusLabel.text = @"播放中";
        self.timeLabel.textColor = self.videoTextLabel.textColor =  self.statusLabel.textColor = [UIColor sc_colorWithHex:0x2AB4E4];
        self.leftImageView.image = [UIImage imageNamed:@"live_icon_nowplaying"];
    }else if (detailProGramModel.type == 3){
        self.smallView.hidden = false;
        self.leftImageView.hidden = true;
        self.statusLabel.text = @"正在直播";
        self.timeLabel.textColor = self.videoTextLabel.textColor = self.statusLabel.textColor = [UIColor sc_colorWithHex:0xffffff];
    }else if (detailProGramModel.type == 4){
        self.leftImageView.hidden = true;
        self.statusLabel.hidden = true;
        self.appointmentBtn.hidden = false;
        self.timeLabel.textColor = self.videoTextLabel.textColor  = [UIColor sc_colorWithHex:0x808080];
    }
}
@end
