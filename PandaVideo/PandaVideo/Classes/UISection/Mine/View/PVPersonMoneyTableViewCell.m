//
//  PVPersonMoneyTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPersonMoneyTableViewCell.h"

@interface PVPersonMoneyTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moneyImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end


@implementation PVPersonMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setPersonModel:(PVPersonModel *)personModel{
    _personModel = personModel;
    
    self.titleLabel.text = personModel.title;
    self.leftImageView.image = [UIImage imageNamed:personModel.imageText];
    self.moneyLabel.text = personModel.subtitle;
    if (personModel.index == 0) {
        self.bottomView.hidden = false;
        self.moneyImageView.hidden = true;
        self.moneyLabel.textColor = [UIColor sc_colorWithHex:0x808080];
    }else{
        self.bottomView.hidden = true;
        self.moneyImageView.hidden = false;
        self.moneyLabel.textColor = [UIColor sc_colorWithHex:0xFEA727];
    }
    
}

@end
