//
//  PVVideoPilotView.m
//  PandaVideo
//
//  Created by cara on 2017/10/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoPilotView.h"


@interface PVVideoPilotView()

@property(nonatomic, strong)UIButton* backBtn;
@property(nonatomic, strong)UILabel*  remindLabel;
@property(nonatomic, strong)UIButton* orderBtn;

@end

@implementation PVVideoPilotView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.backgroundColor = [UIColor grayColor];
    
    ///返回按钮
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"all_btn_back_grey"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    
    ///提醒文字
    UILabel* remindLabel = [[UILabel alloc]  init];
    remindLabel.font = [UIFont systemFontOfSize:15];
    remindLabel.textColor = [UIColor darkTextColor];
    remindLabel.text = @"熊猫视频付费影片,观看完整版请订购产品包";
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:remindLabel];
    self.remindLabel = remindLabel;
    
    ///立即订购按钮
    UIButton* orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.backgroundColor = [UIColor whiteColor];
    orderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    orderBtn.titleLabel.textColor = [UIColor darkTextColor];
    orderBtn.layer.borderWidth = 1.0f;
    orderBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [orderBtn setTitle:@"立即订购" forState:UIControlStateNormal];
    [self addSubview:orderBtn];
    self.orderBtn = orderBtn;
    
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(8);
        make.width.height.equalTo(@50);
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(9);
    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.remindLabel.mas_bottom).offset(-20);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
    }];
}
@end
