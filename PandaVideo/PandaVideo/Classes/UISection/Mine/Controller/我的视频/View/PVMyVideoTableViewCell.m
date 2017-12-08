//
//  PVMyVideoTableViewCell.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVMyVideoTableViewCell.h"

@interface PVMyVideoTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoImageLeftConstraint;
@property (weak, nonatomic) IBOutlet UILabel *videoDurationlabel;
@property (nonatomic, copy) PVMyVideoTableViewCellBlock videoCellBlock;
@end

@implementation PVMyVideoTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.videoImageLeftConstraint.constant = -13;
    self.deleteBtn.hidden = YES;
   
}

- (IBAction)deleteBtnClick:(id)sender {
    self.deleteBtn.selected = !self.deleteBtn.selected;
    if (self.videoCellBlock) {
        self.videoCellBlock(self.deleteBtn);
    }
}

- (void)setPVMyVideoTableViewCellBlock:(PVMyVideoTableViewCellBlock)block {
    self.videoCellBlock = block;
}

- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    if (_isShow) {
        self.videoImageLeftConstraint.constant = 13;
        self.deleteBtn.hidden = NO;
    }else {
        self.videoImageLeftConstraint.constant = -20;
        self.deleteBtn.hidden = YES;
    }
}

- (void)setVideoModel:(PVMyVideoModel *)videoModel {
    _videoModel = videoModel;
    [self layoutVideoCell];
}

- (void)layoutVideoCell {
    
    if (self.videoModel.isDelete == NO) {
        self.deleteBtn.selected = NO;
    }else {
        self.deleteBtn.selected = YES;
    }
    
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:[self.videoModel.videoImg sc_urlString]] placeholderImage:[UIImage imageNamed:BIGBITMAP]];
    self.videoTimeLabel.text = [[NSDate sc_dateFromString:self.videoModel.videoSubTime withFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:@"MM-dd HH:mm"];
    self.videoTitle.text = self.videoModel.videoTitle;
    self.videoDurationlabel.text = [NSString getMMSSFromSS:self.videoModel.videoDuration];
    //0：审核中
    if (self.videoModel.videoStatus == 0) {
        self.stateImageView.image = [UIImage imageNamed:@"myvideo_icon_audit"];
        self.stateLabel.text = @"审核中";
    }
    
    //1：审核通过
    if (self.videoModel.videoStatus == 1) {
        self.stateImageView.image = [UIImage imageNamed:@"myvideo_icon_adopt"];
        self.stateLabel.text = @"审核通过";
    }
    
    //2：审核不通过
    if (self.videoModel.videoStatus == 2) {
        self.stateImageView.image = [UIImage imageNamed:@"myvideo_icon_notpass"];
        self.stateLabel.text = @"审核未通过";
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.videoDurationlabel.ins
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
