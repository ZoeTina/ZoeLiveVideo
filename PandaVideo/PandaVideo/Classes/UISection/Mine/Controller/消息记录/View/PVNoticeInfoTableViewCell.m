//
//  PVNoticeInfoTableViewCell.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVNoticeInfoTableViewCell.h"

@implementation PVNoticeInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setInfoModel:(PVNoticeInfoModel *)infoModel {
    _infoModel = infoModel;
    self.titleLabel.text = _infoModel.title;
//    self.descriptLabel.text = _infoModel.descript;
    self.timeLabel.text = [[NSDate sc_dateFromString:_infoModel.createTime withFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:@"yyyy-MM-dd HH:mm"];
    
    if (_infoModel.isRead) {
        self.tipsImageView.backgroundColor = [UIColor clearColor];
        [self.titleLabel setTextColor:UIColorHexString(0x808080)];
    }else {
        self.tipsImageView.backgroundColor = UIColorHexString(0xEE5454);
        [self.titleLabel setTextColor:[UIColor blackColor]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tipsImageView.layer.cornerRadius = self.tipsImageView.sc_width / 2.;
    self.tipsImageView.layer.masksToBounds = YES;
    
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(13);
        make.width.height.mas_equalTo(7);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(23);
        make.right.equalTo(self.timeLabel.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel sc_labelWithText:@"" fontSize:15 textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel sc_labelWithText:@"" fontSize:11 textColor:UIColorHexString(0x808080) alignment:NSTextAlignmentRight];
    }
    return _timeLabel;
}

- (UIImageView *)tipsImageView {
    if (!_tipsImageView) {
        _tipsImageView = [[UIImageView alloc] init];
        
    }
    return _tipsImageView;
}

@end
