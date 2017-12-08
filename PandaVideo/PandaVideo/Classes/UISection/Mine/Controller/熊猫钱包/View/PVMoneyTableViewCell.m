//
//  PVMoneyTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVMoneyTableViewCell.h"

@interface PVMoneyTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

@end



@implementation PVMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.rechargeBtn.layer.borderWidth = 1.0f;
    self.rechargeBtn.layer.borderColor = [UIColor sc_colorWithHex:0x2AB4E4].CGColor;
    self.rechargeBtn.clipsToBounds = true;
    self.rechargeBtn.layer.cornerRadius = 17;
    
}

- (IBAction)rechargeBtnClicked {
}

- (void)setPackageModel:(PVPackageModel *)packageModel {
    _packageModel = packageModel;
    if (_packageModel.isDiscountTag == 0) {
        self.discountDetailLabel.text = @"";
    }else {
        self.discountDetailLabel.text = @"惠";
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%ld",_packageModel.exchangePrice];
    self.discountLabel.text = [NSString stringWithFormat:@"%.2lf元",_packageModel.price/100.];
}

@end
