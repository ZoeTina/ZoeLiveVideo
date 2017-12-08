//
//  PVVideoTextCollectionViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoTextCollectionViewCell.h"
#import "UIButton+Gradient.h"


@interface PVVideoTextCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *videoTextLabel;
@property(nonatomic, strong)UIButton* trailerBtn;

@end


@implementation PVVideoTextCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    self.videoTextLabel.text = anthologyModel.videoName;

    if (anthologyModel.isPlaying) {
        self.videoTextLabel.textColor = [UIColor sc_colorWithHex:0x2AB4E4];
    }else{
        self.videoTextLabel.textColor = [UIColor whiteColor];
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

@end
