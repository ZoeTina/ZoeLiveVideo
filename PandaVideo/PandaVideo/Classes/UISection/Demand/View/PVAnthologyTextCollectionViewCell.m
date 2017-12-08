//
//  PVAnthologyTextCollectionViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVAnthologyTextCollectionViewCell.h"
#import "UIButton+Gradient.h"


@interface PVAnthologyTextCollectionViewCell()

@property(nonatomic, strong)UILabel* titleLabel;
@property(nonatomic, strong)UIButton* trailerBtn;

@end

@implementation PVAnthologyTextCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    UILabel* titleLabel = [[UILabel alloc]  init];
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor sc_colorWithHex:0x2AB4E4];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UIButton* trailerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trailerBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [trailerBtn setTintColor:[UIColor sc_colorWithHex:0xffffff]];
    trailerBtn.backgroundColor = [UIColor sc_colorWithHex:0xEC9041];
    [self addSubview:trailerBtn];
    NSArray* colors = @[[UIColor sc_colorWithHex:0xF3B744],[UIColor sc_colorWithHex:0xEC9041]];
    [trailerBtn gradientButtonWithSize:CGSizeMake(24, 12) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
    self.trailerBtn = trailerBtn;
    [self.trailerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
    }];
    
}


-(void)setAnthologyModel:(PVDemandVideoAnthologyModel *)anthologyModel{
    _anthologyModel = anthologyModel;
    self.titleLabel.attributedText = [UILabel getLabelParagraph:anthologyModel.videoName height:5];
    if (anthologyModel.isPlaying) {
        self.titleLabel.textColor = [UIColor sc_colorWithHex:0x2AB4E4];
    }else{
        self.titleLabel.textColor = [UIColor sc_colorWithHex:0x000000];
    }
    
    self.trailerBtn.hidden = false;
    if(anthologyModel.tag.integerValue == 1){
        [self.trailerBtn setTitle:@"预告" forState:UIControlStateNormal];
        NSArray* colors = @[[UIColor sc_colorWithHex:0xEC9041],[UIColor sc_colorWithHex:0xF3B744]];
        [self.trailerBtn gradientButtonWithSize:CGSizeMake(24, 12) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
    }else if (anthologyModel.tag.integerValue == 2){
        [self.trailerBtn setTitle:@"最新" forState:UIControlStateNormal];
        NSArray* colors = @[[UIColor sc_colorWithHex:0x3FC53F],[UIColor sc_colorWithHex:0x8DD03F]];
        [self.trailerBtn gradientButtonWithSize:CGSizeMake(24, 12) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
    }else if (anthologyModel.tag.integerValue == 3){
        [self.trailerBtn setTitle:@"付费" forState:UIControlStateNormal];
        NSArray* colors = @[[UIColor sc_colorWithHex:0xEC9041],[UIColor sc_colorWithHex:0xF3B744]];
        [self.trailerBtn gradientButtonWithSize:CGSizeMake(24, 12) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
    }else{
        self.trailerBtn.hidden = true;
    }
}



-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(5, 12, self.sc_width-10, self.sc_height-20);
}

@end
