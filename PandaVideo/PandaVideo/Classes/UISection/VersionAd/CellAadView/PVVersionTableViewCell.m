//
//  PVVersionTableViewCell.m
//  PandaVideo
//
//  Created by songxf on 2017/10/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVersionTableViewCell.h"

@implementation PVVersionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
    
}
- (void)setupUI
{
    UIView * pointView = [UIView sc_viewWithColor:[UIColor sc_colorWithHex:0x999999]];
    pointView.clipsToBounds = YES;
    pointView.layer.cornerRadius = 2;
    [self.contentView addSubview:pointView];
    [self.contentView addSubview:self.textLabel];
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8.5);
        make.left.mas_offset(18);
        make.width.height.mas_equalTo(4);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_offset(26);
        make.right.mas_offset(-18);
    }];
    
}
- (UILabel *)textLabel{
    if (_textlabel == nil) {
        _textlabel = [UILabel sc_labelWithText:@"" fontSize:12 textColor:[UIColor sc_colorWithHex:0x808080] alignment:NSTextAlignmentLeft];
        _textlabel.numberOfLines = 0;
       
    }
    return _textlabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
