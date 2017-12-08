//
//  PVAnthologyCollectionViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVAnthologyCollectionViewCell.h"
#import "UIButton+WebCache.h"
#import "UIButton+Gradient.h"


@interface PVAnthologyCollectionViewCell ()

@end

@implementation PVAnthologyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.countAnthology.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
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
    [self.countAnthology setTitle:anthologyModel.sort forState:UIControlStateNormal];
    self.countAnthology.selected = anthologyModel.isPlaying;
    if (anthologyModel.isPlaying) {
        self.countAnthology.layer.borderWidth = 1.0f;
        self.countAnthology.layer.borderColor = [UIColor sc_colorWithHex:0x2AB4E4].CGColor;
    }else{
        self.countAnthology.layer.borderWidth = 1.0f;
        self.countAnthology.layer.borderColor = [UIColor sc_colorWithHex:0xD7D7D7].CGColor;
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
        NSArray* colors = @[[UIColor sc_colorWithHex:0xec9041],[UIColor sc_colorWithHex:0xf3b744]];
        [self.trailerBtn gradientButtonWithSize:CGSizeMake(24, 12) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
    }else{
        self.trailerBtn.hidden = true;
    }
}


-(void)setEpisodeListModel:(PVSearchEpisodeListModel *)episodeListModel{
    _episodeListModel = episodeListModel;
    [self.countAnthology setTitle:[NSString stringWithFormat:@"%ld",episodeListModel.episodeModel.sort] forState:UIControlStateNormal];
    self.trailerBtn.hidden = false;
    if(episodeListModel.episodeModel.tag.integerValue == 1){
        [self.trailerBtn setTitle:@"预告" forState:UIControlStateNormal];
        NSArray* colors = @[[UIColor sc_colorWithHex:0xEC9041],[UIColor sc_colorWithHex:0xF3B744]];
        [self.trailerBtn gradientButtonWithSize:CGSizeMake(24, 12) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
    }else if (episodeListModel.episodeModel.tag.integerValue == 2){
        [self.trailerBtn setTitle:@"最新" forState:UIControlStateNormal];
        NSArray* colors = @[[UIColor sc_colorWithHex:0x3FC53F],[UIColor sc_colorWithHex:0x8DD03F]];
        [self.trailerBtn gradientButtonWithSize:CGSizeMake(24, 12) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
    }else if (episodeListModel.episodeModel.tag.integerValue == 3){
        [self.trailerBtn setTitle:@"付费" forState:UIControlStateNormal];
        NSArray* colors = @[[UIColor sc_colorWithHex:0xec9041],[UIColor sc_colorWithHex:0xf3b744]];
        [self.trailerBtn gradientButtonWithSize:CGSizeMake(24, 12) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
    }else{
        self.trailerBtn.hidden = true;
    }
}


-(void)setIsCross:(BOOL)isCross{
    _isCross = isCross;
    if (isCross) {
        self.countAnthology.backgroundColor = [UIColor sc_colorWithHex:0x000000];
        self.layer.borderColor = [UIColor sc_colorWithHex:0x4E4E4E].CGColor;
        self.layer.borderWidth = 0.5f;
    }
}

@end
