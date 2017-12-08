//
//  PVprivilegeListTableViewCell.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVprivilegeListTableViewCell.h"
@interface PVprivilegeListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation PVprivilegeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPrivilageModel:(PrivilegeModel *)privilageModel {
    _privilageModel = privilageModel;
    [self initSubView];

}

- (void)initSubView {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.privilageModel.image]];
    self.typeLabel.text = self.privilageModel.title;
    self.descLabel.text = self.privilageModel.desc;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.sc_height / 2.;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
