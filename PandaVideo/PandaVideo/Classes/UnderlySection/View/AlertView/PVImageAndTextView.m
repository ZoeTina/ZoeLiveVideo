//
//  PVImageAndTextView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVImageAndTextView.h"

@interface PVImageAndTextView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptLabel;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *sureImageView;
@end

@implementation PVImageAndTextView

- (instancetype)initImageAndTextViewWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        [self initSubViews];
    }
    return self;
}

//标题
- (void)setAlertTitle:(NSString *)alertTitle {
    _alertTitle = alertTitle;
    
    if (_alertTitle.length == 0) return;
    self.titleLabel.text = _alertTitle;
    //    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(IPHONE6WH(51));
        make.left.mas_offset(IPHONE6WH(123));
    }];
    
    [self.sureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.mas_left).mas_offset(-9);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.height.mas_equalTo(IPHONE6WH(37));
    }];
}

//描述
- (void)setDescript:(NSString *)descript {
    _descript = descript;
    if (_descript.length == 0) return;
    self.descriptLabel.text = _descript;
    
    [self.descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(IPHONE6WH(26));
        make.right.mas_offset(-IPHONE6WH(26));
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(IPHONE6WH(40));
   }];
    
}

//imageView图片名字
- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    if (_imageName.length == 0) return;
    
    self.imageView.image = [UIImage imageNamed:_imageName];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.mas_offset(IPHONE6WH(45));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(self.descriptLabel.mas_bottom).mas_offset(IPHONE6WH(34));
        make.width.mas_equalTo(IPHONE6WH(215));
        make.height.mas_equalTo(IPHONE6WH(123));
    }];
}

//中间图片等偏移，是向左偏还是向右偏
- (void)setImagePosition:(ImagePosition)imagePosition {
    if (imagePosition == Left) {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(IPHONE6WH(45));
            make.top.equalTo(self.descriptLabel.mas_bottom).mas_offset(IPHONE6WH(34));
            make.width.mas_equalTo(IPHONE6WH(215));
            make.height.mas_equalTo(IPHONE6WH(123));
        }];
    }else {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-IPHONE6WH(45));
            make.top.equalTo(self.descriptLabel.mas_bottom).mas_offset(IPHONE6WH(34));
            make.width.mas_equalTo(IPHONE6WH(206));
            make.height.mas_equalTo(IPHONE6WH(123));
        }];
    }
}

//设置取消和确定按钮，如果没有确定按钮，则把取消按钮等字体和边框颜色改为蓝色
- (void)initCancelButtonName:(NSString *)cancelName eventButtonName:(NSString *)eventName {
    if (cancelName.length == 0 && eventName.length == 0) return;
    
    if (eventName.length == 0) {
        [self.cancleButton setTitle:cancelName forState:UIControlStateNormal];
        [self.cancleButton setTitleColor:UIColorHexString(0x29B4E4) forState:UIControlStateNormal];
        self.cancleButton.layer.borderColor = UIColorHexString(0x29B4E4).CGColor;
        [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-IPHONE6WH(16));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(IPHONE6WH(151));
            make.height.mas_equalTo(IPHONE6WH(32));
        }];
    }else {
        [self.cancleButton setTitle:cancelName forState:UIControlStateNormal];
        [self.sureButton setTitle:eventName forState:UIControlStateNormal];
        [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(IPHONE6WH(13));
            make.bottom.mas_offset(-IPHONE6WH(16));
            make.width.mas_equalTo(IPHONE6WH(151));
            make.height.mas_equalTo(IPHONE6WH(32));
        }];
        [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-IPHONE6WH(13));
            make.top.equalTo(self.cancleButton.mas_top);
            make.width.equalTo(self.cancleButton.mas_width);
            make.height.equalTo(self.cancleButton.mas_height);
            
        }];
    }
}

//弹窗取消按钮点击事件
- (void)alertViewDismiss {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageAndTextCancelButtonClick)]) {
        [self.delegate imageAndTextCancelButtonClick];
    }
}

//弹窗确定按钮点击事件
- (void)eventButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageAndTextSureButtonClick)]) {
        [self.delegate imageAndTextSureButtonClick];
    }
}


- (void)initSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.descriptLabel];
    [self addSubview:self.cancleButton];
    [self addSubview:self.sureButton];
    [self addSubview:self.imageView];
    [self addSubview:self.sureImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.cancleButton.sc_height != 0) {
        self.cancleButton.layer.cornerRadius = self.cancleButton.sc_height / 2.;
        self.cancleButton.layer.masksToBounds = YES;
    }
    
    if (self.sureButton.sc_height != 0) {
        self.sureButton.layer.cornerRadius = self.sureButton.sc_height / 2.0;
        self.sureButton.layer.masksToBounds = YES;
    }
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel sc_labelWithText:@"" fontSize:15 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UILabel *)descriptLabel {
    if (!_descriptLabel) {
        _descriptLabel = [UILabel sc_labelWithText:@"" fontSize:15 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        _descriptLabel.numberOfLines = 0;
    }
    return _descriptLabel;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton sc_buttonWithTitle:@"" fontSize:15 textColor:[UIColor blackColor]];
        [_cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancleButton.layer.cornerRadius = _cancleButton.sc_height / 2.0;
        _cancleButton.layer.borderWidth = 1;
        _cancleButton.layer.masksToBounds = YES;
        [_cancleButton addTarget:self action:@selector(alertViewDismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton sc_buttonWithTitle:@"" fontSize:15 textColor:UIColorHexString(0x29B4E4)];
        [_sureButton setTitleColor:UIColorHexString(0x29B4E4) forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = _sureButton.sc_height / 2.0;
        _sureButton.layer.borderWidth = 1;
        _sureButton.layer.borderColor = UIColorHexString(0x29B4E4).CGColor;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton addTarget:self action:@selector(eventButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

- (UIImageView *)sureImageView {
    if (!_sureImageView) {
        _sureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IPHONE6WH(37), IPHONE6WH(37))];
        _sureImageView.image = [UIImage imageNamed:@"live_btn_comment"];
    }
    return _sureImageView;
}
@end
