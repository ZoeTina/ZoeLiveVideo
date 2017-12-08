//
//  PVProGramTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVProGramTableViewCell.h"
#import "PVDottedLineView.h"


@interface PVProGramTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *proGramImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *proGramTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn;
@property (weak, nonatomic) IBOutlet UIView *proSmallView;
@property (nonatomic, strong)PVDottedLineView* lineView;
@property (nonatomic, copy)PVProGramTableViewCellCallBlock callBlock;

@end


@implementation PVProGramTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.proSmallView.layer.cornerRadius = 8.0f;
    self.proSmallView.layer.borderWidth = 1.0f;
    self.proSmallView.layer.borderColor = [UIColor sc_colorWithHex:0xf2f2f2].CGColor;
    PVDottedLineView* lineView = [[PVDottedLineView alloc]  init];
    self.lineView = lineView;
    [self.contentView insertSubview:lineView atIndex:0];
    
    self.appointmentBtn.layer.borderWidth = 1.0f;
    self.appointmentBtn.layer.borderColor = [UIColor sc_colorWithHex:0x00B6E9].CGColor;
    self.appointmentBtn.clipsToBounds = true;
    self.appointmentBtn.layer.cornerRadius = 13.0f;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(8));
        make.top.equalTo(self);
        make.width.equalTo(@(1));
        make.height.equalTo(@(self.sc_height-30));
    }];
}

-(void)setPVProGramTableViewCellCallBlock:(PVProGramTableViewCellCallBlock)block{
    self.callBlock = block;
}


-(void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    if (isLast) {
        self.lineView.hidden = true;
    }else{
        self.lineView.hidden = false;
    }
}


- (IBAction)appointBtnClicked {
    if (self.callBlock) {
        self.callBlock();
    }
}

-(void)setDetailProGramModel:(PVLiveTelevisionDetailProGramModel *)detailProGramModel{
    self.timeLabel.text = detailProGramModel.startTimeFottmar;
    self.proGramTitleLabel.text = detailProGramModel.programName;
    self.appointmentBtn.hidden = true;
    self.statusLabel.hidden = false;
    self.proSmallView.backgroundColor = [UIColor whiteColor];
    if (detailProGramModel.appointMentStatus.integerValue == 1) {//已经预约
        self.appointmentBtn.selected = true;
        self.appointmentBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.appointmentBtn.backgroundColor = [UIColor sc_colorWithHex:0xFF434C];
    }else{
        self.appointmentBtn.selected = false;
        self.appointmentBtn.layer.borderColor = [UIColor sc_colorWithHex:0x00B6E9].CGColor;
        self.appointmentBtn.backgroundColor = [UIColor sc_colorWithHex:0xffffff];
    }
    if (detailProGramModel.type == 1) {
        self.proGramImageView.hidden = true;
        self.proSmallView.hidden = false;
        self.statusLabel.text = @"回看";
        self.timeLabel.textColor = self.proGramTitleLabel.textColor = self.statusLabel.textColor = [UIColor sc_colorWithHex:0x000000];
    }else if (detailProGramModel.type == 2){
        self.proGramImageView.hidden = false;
        self.proSmallView.hidden = true;
        self.statusLabel.text = @"播放中";
        self.timeLabel.textColor = self.proGramTitleLabel.textColor =  self.statusLabel.textColor = [UIColor sc_colorWithHex:0x00B6E9];
        self.proGramImageView.image = [UIImage imageNamed:@"live_icon_nowplaying"];
    }else if (detailProGramModel.type == 3){
        self.proSmallView.backgroundColor = [UIColor sc_colorWithHex:0x00B6E9];
        self.proGramImageView.hidden = true;
        self.proSmallView.hidden = false;
        self.statusLabel.text = @"正在直播";
        self.timeLabel.textColor = self.proGramTitleLabel.textColor = self.statusLabel.textColor = [UIColor sc_colorWithHex:0x000000];
    }else if (detailProGramModel.type == 4){
        self.proGramImageView.hidden = true;
        self.proSmallView.hidden = false;
        self.statusLabel.hidden = true;
        self.appointmentBtn.hidden = false;
        self.timeLabel.textColor = self.proGramTitleLabel.textColor  = [UIColor sc_colorWithHex:0x808080];
    }
}

@end
