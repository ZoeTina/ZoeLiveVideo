//
//  PVRechargeRecordCell.m
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRechargeRecordCell.h"

@interface PVRechargeRecordCell()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end


@implementation PVRechargeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftView.clipsToBounds = true;
    self.leftView.layer.cornerRadius = 4.0f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
