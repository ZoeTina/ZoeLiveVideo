//
//  PVSubCenterTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSubCenterTableViewCell.h"

@interface PVSubCenterTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeadConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLabelRightConstraint;

@end


@implementation PVSubCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.buyBtn.layer.borderWidth = 1.0f;
    self.buyBtn.layer.borderColor = [UIColor sc_colorWithHex:0x2AB4E4].CGColor;
    self.buyBtn.clipsToBounds = true;
    self.buyBtn.layer.cornerRadius = 17;
}


-(void)setOrderCenterModel:(PVOrderCenterModel *)orderCenterModel{
    _orderCenterModel = orderCenterModel;
//    if (orderCenterModel.index == 1) {
//        self.leftImageView.hidden = self.moneyLabel.hidden = self.rightImageView.hidden = self.buyBtn.hidden = true;
//    }else if (orderCenterModel.index == 2){
//        self.leftImageView.hidden = self.rightImageView.hidden = true;
//        self.moneyLabel.hidden = self.buyBtn.hidden = false;
//        self.moneyLabel.textColor = [UIColor sc_colorWithHex:0xFF882A];
//        self.moneyLabelRightConstraint.constant = 10;
//        self.moneyLabel.text = orderCenterModel.subTitle;
//    }else if(orderCenterModel.index == 3){
//        self.leftImageView.hidden = self.moneyLabel.hidden = self.rightImageView.hidden = false;
//        self.leftImageView.hidden = true;
//        self.buyBtn.hidden = true;
//        self.moneyLabel.textColor = [UIColor sc_colorWithHex:0x808080];
//        self.moneyLabelRightConstraint.constant = -40;
//        self.moneyLabel.text = orderCenterModel.subTitle;
//    }
//    self.titleLabelLeadConstraint.constant = -30;
//    self.titleLabel.text = orderCenterModel.title;
}



- (IBAction)buyBtnClicked {
}


@end
