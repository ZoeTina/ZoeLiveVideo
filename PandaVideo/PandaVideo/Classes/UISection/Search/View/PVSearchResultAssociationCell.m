//
//  PVSearchResultAssociationCell.m
//  PandaVideo
//
//  Created by cara on 2017/11/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSearchResultAssociationCell.h"


@interface  PVSearchResultAssociationCell ()

@property(nonatomic, strong)UILabel* titleLabel;

@end

@implementation PVSearchResultAssociationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel = [[UILabel alloc]  init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor sc_colorWithHex:0x000000];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(14));
        make.right.equalTo(@(14));
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.titleLabel.text = @"哈哈哈";
    UIView* bottomView = [[UIView alloc]  init];
    bottomView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
        make.bottom.equalTo(@(0));
        make.height.equalTo(@(1));
    }];
}
-(void)setKeyWordModel:(PVAssociationKeyWordModel *)keyWordModel{
    _keyWordModel = keyWordModel;
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:keyWordModel.word];
    NSRange range = [keyWordModel.word rangeOfString:self.searchWord];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor sc_colorWithHex:0x00B6E9] range:range];
    self.titleLabel.attributedText = noteStr;
}

@end
