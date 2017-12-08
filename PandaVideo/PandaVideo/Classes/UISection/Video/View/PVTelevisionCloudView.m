//
//  PVTelevisionCloudView.m
//  PandaVideo
//
//  Created by cara on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTelevisionCloudView.h"

@interface  PVTelevisionCloudView()

@property(nonatomic, strong)UIButton* backBtn;
@property(nonatomic, strong)UIButton* bgBtn;
@property(nonatomic, copy)PVTelevisionCloudViewCallBlock callBlock;


@end


@implementation PVTelevisionCloudView

-(instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

-(void)setPVTelevisionCloudViewCallBlock:(PVTelevisionCloudViewCallBlock)block{
    self.callBlock = block;
}


-(void)setupUI{
    
    UIButton* bgBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    bgBtn.backgroundColor = [UIColor blackColor];
    bgBtn.alpha = 0.6f;
    [bgBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.bgBtn = bgBtn;
    
//    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setImage:[UIImage imageNamed:@"all_btn_back_white"] forState:UIControlStateNormal];
//    backBtn.adjustsImageWhenDisabled = false;
//    backBtn.adjustsImageWhenHighlighted = false;
//    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:backBtn];
//    
//    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@3);
//        make.top.equalTo(@(8));
//        make.width.height.equalTo(@(50));
//    }];
//    self.backBtn = backBtn;
    
    [self addSubview:self.televisionPlayBtn];
    [self.televisionPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(IPHONE6WH(161)));
        make.height.equalTo(@(IPHONE6WH(34)));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    
    [self addSubview:self.addTelevisionCloudBtn];
    [self.addTelevisionCloudBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(IPHONE6WH(161)));
        make.height.equalTo(@(IPHONE6WH(34)));
        make.centerX.equalTo(self);
        make.top.equalTo(self.televisionPlayBtn.mas_bottom).offset(20);
    }];
    
}


-(void)backBtnClicked{
    self.hidden = true;
}


-(UIButton *)televisionPlayBtn{
    if (!_televisionPlayBtn) {
        _televisionPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_televisionPlayBtn setImage:[UIImage imageNamed:@"live_btn_send"] forState:UIControlStateNormal];
        _televisionPlayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _televisionPlayBtn.layer.borderWidth = 1.0f;
        _televisionPlayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _televisionPlayBtn.clipsToBounds = true;
        _televisionPlayBtn.layer.cornerRadius = 17.0f;
        [_televisionPlayBtn setTitle:@"  电视播放" forState:UIControlStateNormal];
        [_televisionPlayBtn addTarget:self action:@selector(televisionPlayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _televisionPlayBtn;
}
-(void)televisionPlayBtnClick{
    if (self.callBlock) {
        self.callBlock(false);
    }
    NSLog(@"电视播放电视播放电视播放");
    
}
- (UIButton *)addTelevisionCloudBtn{
    if (!_addTelevisionCloudBtn) {
        _addTelevisionCloudBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addTelevisionCloudBtn setImage:[UIImage imageNamed:@"live_btn_collect-拷贝"] forState:UIControlStateNormal];
        _addTelevisionCloudBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _addTelevisionCloudBtn.layer.borderWidth = 1.0f;
        _addTelevisionCloudBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _addTelevisionCloudBtn.clipsToBounds = true;
        _addTelevisionCloudBtn.layer.cornerRadius = 17.0f;
        _addTelevisionCloudBtn.hidden = true;
        [_addTelevisionCloudBtn setTitle:@"  添加至电视云看单" forState:UIControlStateNormal];
        [_addTelevisionCloudBtn addTarget:self action:@selector(addTelevisionCloudBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addTelevisionCloudBtn;
}
-(void)addTelevisionCloudBtnClick{
    if (self.callBlock) {
        self.callBlock(true);
    }
    NSLog(@"电视播放看单电视播放看单电视播放看单");
    
}



@end
