//
//  PVBottomAlertView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBottomAlertView.h"

@interface PVBottomAlertView ()
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *imagesNameArray;

@property (nonatomic, strong) UIView *buttonContentView;
@property (nonatomic, strong) UIButton *cancleButton;
@end

@implementation PVBottomAlertView

- (instancetype)initWithFrame:(CGRect)frame ImagesArray:(NSArray *)imagesArray textsArray:(NSArray *)imagesNameArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imagesArray = imagesArray;
        self.imagesNameArray = imagesNameArray;
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    
    //添加取消按钮
    [self addSubview:self.cancleButton];
    
    //添加顶端label后面的线
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectZero];
    topLineView.backgroundColor = UIColorHexString(0xD7D7D7);
    [self addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(12);
        make.top.mas_offset(18);
        make.right.mas_offset(-12);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *tipsLabel = [UILabel sc_labelWithText:@"提醒Ta接受邀请" fontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    tipsLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topLineView.mas_centerX);
        make.centerY.equalTo(topLineView.mas_centerY);
        make.width.mas_equalTo(100);
    }];
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-SafeAreaBottomHeight);
        make.height.mas_equalTo(IPHONE6WH(51));
    }];
    
    //添加底部高度比较高的线view
    UIView *bottomGrayView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomGrayView.backgroundColor = UIColorHexString(0xF2F2F2);
    [self addSubview:bottomGrayView];
    [bottomGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.cancleButton.mas_top);
        make.height.mas_equalTo(4);
    }];
    
    //添加承载小button的view
    [self addSubview:self.buttonContentView];
    [self.buttonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(topLineView.mas_bottom);
        make.bottom.equalTo(bottomGrayView.mas_top);
    }];
    
    //添加每行button下面的横线
    NSInteger rows = ceilf(self.imagesArray.count / 3.0);
    for (int i = 0; i < rows - 1; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(13, IPHONE6WH(102) * (i+1) + IPHONE6WH(19), kScreenWidth - 26, 1)];
        view.backgroundColor = UIColorHexString(0xD7D7D7);
        [self addSubview:view];
        
    }
    
    //添加小button
    [self addButtons];
    
}

- (void)addButtons {
    
    int totalColumn = 3;
    
//    CGFloat btnH = IPHONE6WH(72);
    CGFloat btnH = IPHONE6WH(102);
    CGFloat btnW = IPHONE6WH(54);
    CGFloat margin = IPHONE6WH(50);
    CGFloat leftMargin = IPHONE6WH(57);
    
    for (int i = 0; i < self.imagesArray.count; i ++) {
        NSString *imageName = [self.imagesArray sc_safeObjectAtIndex:i];
        NSString *btnName = [self.imagesNameArray sc_safeObjectAtIndex:i];
        
        UIView *btnView = [self createButtonWithTitle:btnName imageName:imageName];
        
        int row = i / totalColumn;
        int col = i % totalColumn;
        CGFloat cellX = leftMargin + (btnW + margin) * col;
//        CGFloat cellY = row * btnH + IPHONE6WH(19);
        CGFloat cellY = self.sc_height - (IPHONE6WH(51) );
        [self.buttonContentView addSubview:btnView];
//        btnView.frame = CGRectMake(cellX, cellY, btnW, btnH);
        [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(cellX);
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(btnH);
            make.bottom.equalTo(self.cancleButton.mas_top).mas_offset(-4+IPHONE6WH(19)- btnH * row);
            
        }];
        
    }

}

- (void)cancleButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PVBottomAlertViewCancleButtonClick)]) {
        [self.delegate PVBottomAlertViewCancleButtonClick];
    }
}



- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton sc_buttonWithTitle:@"取消" fontSize:15 textColor:[UIColor blackColor]];
        [_cancleButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return _cancleButton;
}

- (UIView *)buttonContentView {
    if (!_buttonContentView) {
        _buttonContentView = [[UIView alloc] initWithFrame:CGRectZero];
        _buttonContentView.backgroundColor = [UIColor clearColor];
    }
    return _buttonContentView;
}

- (UIView *)createButtonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.userInteractionEnabled = NO;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.mas_equalTo(IPHONE6WH(54));
    }];
    
    UILabel *titleLabel = [UILabel sc_labelWithText:title fontSize:13 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(imageView.mas_bottom).mas_offset(IPHONE6WH(7));
    }];
    return view;
}

@end
