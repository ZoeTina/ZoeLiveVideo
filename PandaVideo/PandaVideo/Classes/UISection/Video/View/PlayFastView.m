//
//  PlayFastView.m
//  VideoDemo
//
//  Created by cara on 17/7/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PlayFastView.h"

@interface PlayFastView()


@end

@implementation PlayFastView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.backgroundColor     = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.layer.cornerRadius  = 4;
    self.layer.masksToBounds = YES;
    
    UIImageView* fastImageView = [[UIImageView alloc] init];
    [self addSubview:fastImageView];
    self.fastImageView = fastImageView;
    
    UILabel* fastTimeLabel      = [[UILabel alloc] init];
    fastTimeLabel.textColor     = [UIColor whiteColor];
    fastTimeLabel.textAlignment = NSTextAlignmentCenter;
    fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    [self addSubview:fastTimeLabel];
    self.fastTimeLabel = fastTimeLabel;
    
    UIProgressView* fastProgressView = [[UIProgressView alloc] init];
    fastProgressView.progressTintColor = [UIColor sc_colorWithHex:0x64C4F5];
    fastProgressView.trackTintColor    = [UIColor darkGrayColor];
    [self addSubview:fastProgressView];
    self.fastProgressView = fastProgressView;
    
    [fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(32);
        make.height.mas_offset(32);
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.with.trailing.mas_equalTo(0);
        make.top.mas_equalTo(fastImageView.mas_bottom).offset(2);
    }];
    [fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(fastTimeLabel.mas_bottom).offset(10);
    }];

    
    
}


@end
