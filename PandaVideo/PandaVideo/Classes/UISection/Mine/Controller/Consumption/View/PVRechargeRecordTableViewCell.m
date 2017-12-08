//
//  PVRechargeRecordTableViewCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRechargeRecordTableViewCell.h"

@interface PVRechargeRecordTableViewCell ()
/** 圆点 */
@property (weak, nonatomic) IBOutlet UILabel *dotLabel;
/** 日期 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
/** 金币 */
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
/** 消费金额 */
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
@implementation PVRechargeRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _dotLabel.layer.masksToBounds = YES;
    _dotLabel.layer.cornerRadius  = _dotLabel.sc_height/2;
}

- (void)setChargeDetailModel:(PVRechargeDetailModel *)chargeDetailModel {
    _chargeDetailModel = chargeDetailModel;
    self.dateLabel.text = [[NSDate sc_dateFromString:_chargeDetailModel.date withFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:@"yyyy-MM-dd"];
//    self.dateLabel.text = [NSDate sc_dateFromString:[_chargeDetailModel.date ] withFormat:@"yyyy-MM_dd"];
    self.coinLabel.text = _chargeDetailModel.balance;
    self.amountLabel.text = [NSString stringWithFormat:@"%.2f元",_chargeDetailModel.price.integerValue / 100.];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
