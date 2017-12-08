//
//  PVAnthologyNumberAndTextCell.m
//  PandaVideo
//
//  Created by cara on 17/8/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVAnthologyNumberAndTextCell.h"
#import "UIButton+Gradient.h"


@interface PVAnthologyNumberAndTextCell()

@property (weak, nonatomic) IBOutlet UIImageView *anthologyImageView;
@property (weak, nonatomic) IBOutlet UILabel *anthologyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *anthologyTitleLabel;
@property(nonatomic, strong)UIButton* trailerBtn;

@end


@implementation PVAnthologyNumberAndTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
    [self.anthologyImageView sc_setImageWithUrlString:anthologyModel.verticalPic placeholderImage:[UIImage imageNamed:VERTICALMAPBITMAP] isAvatar:false];
    self.anthologyTitleLabel.text = anthologyModel.videoName;
    if (anthologyModel.isPlaying) {
        self.anthologyTitleLabel.textColor = [UIColor sc_colorWithHex:0x2AB4E4];
    }else{
        self.anthologyTitleLabel.textColor = [UIColor sc_colorWithHex: 0x000000];
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
