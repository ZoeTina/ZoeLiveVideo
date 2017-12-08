//
//  PVOrderDetailTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVOrderDetailTableViewCell.h"


@interface PVOrderDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectiveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;

@end


@implementation PVOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrderDetailModel:(PVOrderDetailModel *)orderDetailModel {
    _orderDetailModel = orderDetailModel;
    self.titleLabel.text = _orderDetailModel.productNmae;
    self.buyTimeLabel.text = [NSString stringWithFormat:@"购买时长：%@",_orderDetailModel.timeLimit];
    self.transactionTimeLabel.text = [NSString stringWithFormat:@"交易时间：%@",_orderDetailModel.orderTime];
    self.effectiveTimeLabel.text = [NSString stringWithFormat:@"有效时间：%@到%@",_orderDetailModel.startTime,_orderDetailModel.endTime];
    self.paymentMethodLabel.text = [NSString stringWithFormat:@"支付方式：%@",_orderDetailModel.orderType];
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",_orderDetailModel.orderNo];
    self.moneyLabel.text = orderDetailModel.price;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 2;
    [super setFrame:frame];
}

@end
