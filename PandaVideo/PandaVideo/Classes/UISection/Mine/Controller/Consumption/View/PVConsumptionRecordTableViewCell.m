//
//  PVConsumptionRecordTableViewCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVConsumptionRecordTableViewCell.h"

@interface PVConsumptionRecordTableViewCell ()
/** 圆点 */
@property (weak, nonatomic) IBOutlet UILabel *dotLabel;
/** 日期 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 消费金额 */
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation PVConsumptionRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _dotLabel.layer.masksToBounds = YES;
    _dotLabel.layer.cornerRadius  = _dotLabel.sc_height/2;
}

- (void)setConsumpModel:(PVConsumptionModel *)consumpModel {
    _consumpModel = consumpModel;
   self.dateLabel.text = [[NSDate sc_dateFromString:_consumpModel.date withFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:@"yyyy-MM-dd"];
    self.titleLabel.text = _consumpModel.propName;
    self.amountLabel.text = [NSString stringWithFormat:@"%d",_consumpModel.balance];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
