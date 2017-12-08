//
//  PVorderInfoTableViewCell.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVorderInfoTableViewCell.h"

@interface PVorderInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UILabel *proNameLabel;

@end

@implementation PVorderInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrderInfoModel:(OrderInfoModel *)orderInfoModel {
    _orderInfoModel = orderInfoModel;
    [self initSubView];
}

- (void)initSubView {
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元",self.orderInfoModel.price / 100.];
    self.proNameLabel.text = self.orderInfoModel.timeLimit;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.purchaseButton.layer.masksToBounds = YES;
    self.purchaseButton.layer.cornerRadius = self.purchaseButton.sc_height / 2.;
    self.purchaseButton.layer.borderWidth = 1;
    self.purchaseButton.layer.borderColor = [UIColorHexString(0x2AB4E4) CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
