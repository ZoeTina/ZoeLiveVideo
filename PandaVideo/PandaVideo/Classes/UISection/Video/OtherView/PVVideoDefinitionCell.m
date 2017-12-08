//
//  PVVideoDefinitionCell.m
//  PandaVideo
//
//  Created by cara on 2017/9/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoDefinitionCell.h"

@interface PVVideoDefinitionCell()

@property(nonatomic, strong)UIButton*  definitionBtn;

@end


@implementation PVVideoDefinitionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor sc_colorWithHex:0x2AB4E4] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 33*0.5;
    btn.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
    btn.layer.borderWidth = 1.0f;
    [self addSubview:btn];
    btn.userInteractionEnabled = false;
    self.definitionBtn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-25);
    }];
}
-(void)setRateListModel:(PVLiveTelevisionCodeRateList *)rateListModel{
    _rateListModel = rateListModel;
    [self.definitionBtn setTitle:rateListModel.showName forState:UIControlStateNormal];
    if (rateListModel.isSelected) {
        self.definitionBtn.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
        self.definitionBtn.layer.borderColor = [UIColor sc_colorWithHex:0x2BBCF0].CGColor;
        self.definitionBtn.selected = true;
    }else{
        self.definitionBtn.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
        self.definitionBtn.layer.borderWidth = 1.0f;
        self.definitionBtn.selected = false;
    }
}

-(void)setIntroduceReteList:(CodeRateList *)introduceReteList{
    _introduceReteList = introduceReteList;
    [self.definitionBtn setTitle:introduceReteList.showName forState:UIControlStateNormal];
    if (introduceReteList.isSelected) {
        self.definitionBtn.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
        self.definitionBtn.layer.borderColor = [UIColor sc_colorWithHex:0x2BBCF0].CGColor;
        self.definitionBtn.selected = true;
    }else{
        self.definitionBtn.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
        self.definitionBtn.layer.borderWidth = 1.0f;
        self.definitionBtn.selected = false;
    }
}


@end
