//
//  PVThridLoginView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/19.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVThridLoginView.h"


@interface PVThridLoginView ()
{
    CGFloat buttonWidth;
}
@property (nonatomic, strong) NSMutableArray *subViewsArrays;
@end


@implementation PVThridLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        buttonWidth = IPHONE6WH(53);
        [self getButtonSubviews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)getButtonSubviews {
    
    //判断微信是否安装
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
        UIView *weixinButton = [self createButtonWithTitle:@"微信" imageName:@"live_btn_wechat"];
        [self addSubview:weixinButton];
        
        UITapGestureRecognizer *weixinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weixinLogin)];
        [weixinButton addGestureRecognizer:weixinTap];
        [self.subViewsArrays addObject:weixinButton];
        
    }
    
    //判断QQ是否安装
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
        UIView *QQButton = [self createButtonWithTitle:@"QQ" imageName:@"mine_btn_qq"];
        [self addSubview:QQButton];
        UITapGestureRecognizer *QQTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QQLogin)];
        [QQButton addGestureRecognizer:QQTap];
        [self.subViewsArrays addObject:QQButton];
    }
    
    UIView *weiboButton = [self createButtonWithTitle:@"微博" imageName:@"mine_btn_weibo"];
    [self addSubview:weiboButton];
    [self.subViewsArrays addObject:weiboButton];
    UITapGestureRecognizer *weiboTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weiboLogin)];
    [weiboButton addGestureRecognizer:weiboTap];
    [self layoutButtons];
    
}

- (void)weixinLogin {
    if (self.thridLoginViewDelegate && [self.thridLoginViewDelegate respondsToSelector:@selector(weixinClick)]) {
        [self.thridLoginViewDelegate weixinClick];
    }
}
- (void)QQLogin {
    if (self.thridLoginViewDelegate && [self.thridLoginViewDelegate respondsToSelector:@selector(QQClick)]) {
        [self.thridLoginViewDelegate QQClick];
    }
}

- (void)weiboLogin {
    if (self.thridLoginViewDelegate && [self.thridLoginViewDelegate respondsToSelector:@selector(weiboClick)]) {
        [self.thridLoginViewDelegate weiboClick];
    }
}

- (void)layoutButtons {
    if (self.subViewsArrays.count == 3) {
        [self layoutThreeButton];
    }
    if (self.subViewsArrays.count == 2) {
        [self layoutTwoButton];
    }
    if (self.subViewsArrays.count == 1) {
        [self layoutOneButton];
    }
}

- (void)layoutThreeButton {
    
    CGFloat letMargin = kDistanceWidthRatio(58);
    CGFloat margin = (kScreenWidth - letMargin * 2 - 3 * buttonWidth ) / 2.0;
    for (int i = 0; i < self.subViewsArrays.count; i ++) {
        
        UIView *button = [self.subViewsArrays sc_safeObjectAtIndex:i];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(letMargin + buttonWidth * i + margin * i);
            make.top.mas_offset(0);
            make.height.mas_equalTo(self.mas_height);
            make.width.mas_equalTo(buttonWidth);
        }];
    }
    
}

- (void)layoutTwoButton {
    CGFloat margin = (kScreenWidth - buttonWidth * 2) / 3.0;
    for (int i = 0; i < self.subViewsArrays.count; i ++) {
        UIView *button = [self.subViewsArrays sc_safeObjectAtIndex:i];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(buttonWidth * i + margin * (i + 1));
            make.width.mas_equalTo(buttonWidth);
            make.top.mas_offset(0);
            make.height.mas_equalTo(self.mas_height);
        }];
    }
}

- (void)layoutOneButton {
    UIView *button = [self.subViewsArrays sc_safeObjectAtIndex:0];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.mas_offset(0);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(self.mas_height);
    }];
}

- (NSMutableArray *)subViewsArrays {
    if(!_subViewsArrays) {
        _subViewsArrays = [[NSMutableArray alloc] init];
    }
    return _subViewsArrays;
}

- (UIView *)createButtonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.userInteractionEnabled = YES;
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
        make.left.right.bottom.mas_offset(0);
    }];
    return view;
}
@end
