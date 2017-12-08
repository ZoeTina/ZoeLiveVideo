//
//  PVFamilyNoDataView.m
//  PandaVideo
//
//  Created by cara on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFamilyNoDataView.h"


@interface PVFamilyNoDataView()

@property(nonatomic, strong)UILabel* noBingLabel;
@property(nonatomic, strong)UILabel* loginBingLabel;
@property(nonatomic, strong)UIButton* addBtn;

@end



@implementation PVFamilyNoDataView

-(instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
        
    UILabel* noTelevisionLabel = [[UILabel alloc]  init];
    noTelevisionLabel.textColor = [UIColor sc_colorWithHex:0x808080];
    noTelevisionLabel.textAlignment = NSTextAlignmentCenter;
    noTelevisionLabel.font = [UIFont systemFontOfSize:13];
    noTelevisionLabel.text = @"(暂无绑定“熊猫视频”电视端的家人)";
    [self addSubview:noTelevisionLabel];
    self.noBingLabel = noTelevisionLabel;
    [self.noBingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self.mas_centerX).offset(0);
    }];
    
    UILabel* noLoginLabel = [[UILabel alloc]  init];
    noLoginLabel.textColor = [UIColor sc_colorWithHex:0x000000];
    noLoginLabel.textAlignment = NSTextAlignmentCenter;
    noLoginLabel.font = [UIFont systemFontOfSize:13];
    noLoginLabel.text = @"请先确保家人已登录“熊猫视频”电视端";
    [self addSubview:noLoginLabel];
    [noLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noTelevisionLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.mas_centerX);
    }];
    noLoginLabel.hidden = true;
    self.loginBingLabel = noLoginLabel;
    
    
    UIButton* addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    addBtn.clipsToBounds = true;
    addBtn.layer.cornerRadius = 17.0f;
    addBtn.layer.borderWidth = 1.0f;
    addBtn.layer.borderColor = [UIColor sc_colorWithHex:0x2AB4E4].CGColor;
    [addBtn setTitleColor:[UIColor sc_colorWithHex:0x2AB4E4] forState:UIControlStateNormal];
    [addBtn setTitle:@"加入家庭圈" forState:UIControlStateNormal];
    [self addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noTelevisionLabel.mas_bottom).offset(17);
        make.width.equalTo(@(152));
        make.height.equalTo(@(34));
        make.centerX.equalTo(self.mas_centerX);
    }];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addBtnClicked{
    
    NSLog(@"加入电视剧");
    
}


@end

