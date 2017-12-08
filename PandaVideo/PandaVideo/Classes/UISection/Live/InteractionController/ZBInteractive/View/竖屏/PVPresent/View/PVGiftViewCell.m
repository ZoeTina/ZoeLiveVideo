//
//  PVGiftViewCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVGiftViewCell.h"

@implementation PVGiftViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];//kColorWithRGB(215, 215, 215);
        self.giftImageView.image = [UIImage imageNamed:@"1"];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    [self.contentView addSubview:self.giftImageView];
    [self.contentView addSubview:self.hitButton];
    [self.contentView addSubview:self.giftNameLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.clickBtn];
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_offset(@71);
        make.height.equalTo(@50);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.giftImageView);
        make.top.equalTo(self.giftImageView.mas_bottom).with.offset(5);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.giftNameLabel).offset(-6);
        make.top.equalTo(self.giftNameLabel.mas_bottom).with.offset(5);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.centerY.equalTo(self.moneyLabel);
        make.left.equalTo(self.moneyLabel.mas_right).offset(0);
    }];
    
    [self.hitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.equalTo(self.giftImageView);
    }];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self);
    }];
}

- (UIImageView *)giftImageView{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] init];
        _giftImageView.backgroundColor = [UIColor clearColor];
        _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftImageView;
}

- (UILabel *)giftNameLabel{
    if (!_giftNameLabel) {
        _giftNameLabel = [[UILabel alloc] init];
        _giftNameLabel.text = @"玫瑰花";
        _giftNameLabel.textAlignment    = NSTextAlignmentCenter;
        _giftNameLabel.font             = [UIFont systemFontOfSize:13.f];

    }
    return _giftNameLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"1000";
        _moneyLabel.textColor = kColorWithRGB(128,128,128);
        _moneyLabel.backgroundColor  = [UIColor clearColor];
        _moneyLabel.textAlignment    = NSTextAlignmentCenter;
        _moneyLabel.font             = [UIFont systemFontOfSize:12.f];
        
    }
    return _moneyLabel;
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.backgroundColor = [UIColor clearColor];
        _iconImage.image = [UIImage imageNamed:@"live_icon_money"];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
        _iconImage.backgroundColor = [UIColor clearColor];
    }
    return _iconImage;
}

- (UIButton *)hitButton{
    if (!_hitButton) {
        _hitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hitButton.backgroundColor = [UIColor clearColor];
        _hitButton.layer.borderWidth = 1;
//        _hitButton.hidden = YES;
        // mine_control_select_selected pop_gift_lian.png
        // mine_control_select_normal button_choose-on.png
//        [_hitButton setImage:kGetImage(@"mine_control_select_normal") forState:UIControlStateNormal];
//        [_hitButton setImage:kGetImage(@"mine_control_select_selected") forState:UIControlStateSelected];
    }
    return _hitButton;
}
- (void)hitButtonBorderIsSelected{
    if (self.hitButton.selected) {
        _hitButton.layer.borderColor = [UIColor sc_colorWithHex:0x1aacff].CGColor;
    }else{
        _hitButton.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (UIButton *) clickBtn{
    if (!_clickBtn) {
        _clickBtn = [MultiParamButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.backgroundColor = [UIColor clearColor];
    }
    return _clickBtn;
}
@end

@implementation MultiParamButtons

@end
