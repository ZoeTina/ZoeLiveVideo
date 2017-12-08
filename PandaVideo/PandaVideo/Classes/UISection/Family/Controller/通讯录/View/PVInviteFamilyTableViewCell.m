//
//  PVInviteFamilyTableViewCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInviteFamilyTableViewCell.h"

@interface PVInviteFamilyTableViewCell ()




/** 姓名等电视剧logo */
@property (nonatomic, strong) IBOutlet UIImageView *teleplayIcon;
/** 箭头logo */
@property (nonatomic, strong) IBOutlet UIImageView *arrowIcon;

/** 没有姓名时候的电视logo */
@property (weak, nonatomic) IBOutlet UIImageView *noNameTeleLogo;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;

@end

@implementation PVInviteFamilyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void) initView{
    if (self.contractModel.name.length == 0) {
        [self showUI2];
    }else {
        [self showUI1];
    }
    
    //未加入
    if (self.contractModel.state == 0) {
//        self.joinStateLabel.text = @"未加入";
        self.joinStateLabel.hidden = YES;
        self.inviteLabel.hidden = NO;
    }
    if (self.contractModel.state == 1) {
        self.joinStateLabel.text = @"已加入当前家庭圈";
        self.joinStateLabel.hidden = NO;
        self.inviteLabel.hidden = YES;
    }
    if (self.contractModel.state == 2) {
        self.joinStateLabel.text = @"待加入";
        self.joinStateLabel.hidden = NO;
        self.inviteLabel.hidden = YES;
    }
    if (self.contractModel.state == 3) {
        self.joinStateLabel.text = @"已加入其他家庭圈";
        self.joinStateLabel.hidden = NO;
        self.inviteLabel.hidden = YES;
        
    }
    
}

- (void)setContractModel:(PVTongxunluModel *)contractModel {
    _contractModel = contractModel;
    [self initView];
}

// 第一种Cell的显示,有姓名
- (void) showUI1{
    
    self.labelName.hidden = NO;
    self.smallPhoneLabel.hidden = NO;
    self.arrowIcon.hidden = NO;
    self.labelName.text = self.contractModel.name;
    self.smallPhoneLabel.text = self.contractModel.phone;
    
    
    if (self.contractModel.state == 3) {
        self.teleplayIcon.hidden = NO;
    }else {
        self.teleplayIcon.hidden = YES;
    }
    
    self.bigPhoneLabel.hidden = YES;
    self.noNameTeleLogo.hidden = YES;
}

// 第二种Cell的显示,无姓名
- (void) showUI2{
    
    self.labelName.hidden = YES;
    self.smallPhoneLabel.hidden = YES;
    self.teleplayIcon.hidden = YES;
    
    if (self.contractModel.state == 3) {
        self.noNameTeleLogo.hidden = NO;
    }else {
        self.noNameTeleLogo.hidden = YES;
    }
    
    self.bigPhoneLabel.text = self.contractModel.phone;
    self.bigPhoneLabel.hidden = YES;
    self.arrowIcon.hidden = YES;
    
}

// 第三种Cell的显示,没有姓名
- (void) showUI3{
    
    self.labelName.hidden = YES;
    self.smallPhoneLabel.hidden = YES;
    self.teleplayIcon.hidden = YES;
    
    
    self.arrowIcon.hidden = NO;
    
    self.bigPhoneLabel.hidden = NO;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.inviteLabel.layer.borderColor = [UIColorHexString(0x2AB4E4) CGColor];
    self.inviteLabel.layer.borderWidth = 1;
    self.inviteLabel.layer.masksToBounds = YES;
    self.inviteLabel.layer.cornerRadius = self.inviteLabel.sc_height / 2.;
}

- (void)setIsShowArrowView:(BOOL)isShowArrowView {
    
    if (self.contractModel.state == 2) {
        self.arrowIcon.hidden = NO;
    }else {
        self.arrowIcon.hidden = YES;
    }
    
    _isShowArrowView = isShowArrowView;
    if (!_isShowArrowView) {
        self.arrowIcon.hidden = YES;
    }
//    }else {
//        self.arrowIcon.hidden = YES;
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
