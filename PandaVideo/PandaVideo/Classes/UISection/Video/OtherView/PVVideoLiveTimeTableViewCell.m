//
//  PVVideoLiveTimeTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoLiveTimeTableViewCell.h"

@interface PVVideoLiveTimeTableViewCell()

@property(nonatomic, strong)UILabel* timeLabel;

@property(nonatomic, strong)UIView* selectedView;

@end

@implementation PVVideoLiveTimeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
    self.selectedView = [[UIView alloc]  init];
    self.selectedView.backgroundColor = [UIColor sc_colorWithHex:0x2AB4E4];
    self.selectedView.hidden = true;
    [self addSubview:self.selectedView];
    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(@5);
        make.bottom.equalTo(@(-5));
        
    }];
    
    self.backgroundColor = [UIColor clearColor];
    self.timeLabel = [[UILabel alloc]  init];
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];

}


-(void)setAreaModel:(PVLiveTelevisionAreaModel *)areaModel{
    self.timeLabel.text = areaModel.stationName;
    self.selectedView.hidden = !areaModel.isSelected;
}

-(void)setProGramModel:(PVLiveTelevisionProGramModel *)proGramModel{
    _proGramModel = proGramModel;
    self.timeLabel.text = proGramModel.dateString;
    if (proGramModel.type == 1) {
        self.timeLabel.text = @"今天";
    }else if (proGramModel.type == 2){
        self.timeLabel.text = @"昨天";
    }
    self.selectedView.hidden = !proGramModel.isSelected;
}


@end
