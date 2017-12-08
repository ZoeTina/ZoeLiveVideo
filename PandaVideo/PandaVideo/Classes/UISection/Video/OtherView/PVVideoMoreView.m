//
//  PVVideoMoreView.m
//  VideoDemo
//
//  Created by cara on 17/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoMoreView.h"

@interface PVVideoMoreView()

//电视囤片按钮
@property(nonatomic, strong)SCButton* televersionBtn;

@property(nonatomic, copy)PVVideoMoreViewCallBlock callBlock;


@end

@implementation PVVideoMoreView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setPVVideoMoreViewCallBlock:(PVVideoMoreViewCallBlock)block{
    self.callBlock = block;
}

-(void)setupUI{
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView* bgView = [[UIView alloc]  init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.8;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    SCButton* collectBtn = [SCButton customButtonWithTitlt:@"收藏" imageNolmalString:@"live_btn_collection_normal" imageSelectedString:@"live_btn_collection_selected"];
    [collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:collectBtn];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    self.collectBtn = collectBtn;
    [collectBtn addTarget:self action:@selector(collectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
//    SCButton* televersionBtn = [SCButton customButtonWithTitlt:@"电视囤片" imageNolmalString:@"live_btn_collect" imageSelectedString:@"live_btn_collect"];
//    [televersionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    televersionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [self addSubview:televersionBtn];
//    [televersionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@60);
//        make.width.equalTo(@80);
//        make.centerX.equalTo(self.mas_centerX);
//        make.centerY.equalTo(self.mas_centerY).offset(70);
//    }];
//    self.televersionBtn = televersionBtn;
//    [televersionBtn addTarget:self action:@selector(televersionBtnClicked) forControlEvents:UIControlEventTouchUpInside];

}

-(void)setIsCollect:(BOOL)isCollect{
    _isCollect = isCollect;
    if (isCollect) {
        self.collectBtn.selected = true;
    }else{
        self.collectBtn.selected = false;
    }
}



-(void)collectBtnClicked{
    if (self.callBlock) {
        self.callBlock();
    }
}
-(void)televersionBtnClicked{
    
    NSLog(@"电视囤片");
    
}

@end
