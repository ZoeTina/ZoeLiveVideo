//
//  PVLiveInfoView.m
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLiveInfoView.h"

@interface PVLiveInfoView()

@property(nonatomic, copy)ProgramBtnClickedBlock programBtnBlock;
@property(nonatomic, copy)ScreenBtnClickedBlock screenBtnBlock;
@property(nonatomic, copy)ShakeBtnClickedBlock shakeBtnBlock;

@end


@implementation PVLiveInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI:frame];
    }
    return self;
}

-(void)setupUI:(CGRect)frame{
    
    UILabel* titleLabel = [[UILabel alloc]  init];
    titleLabel.frame = CGRectMake(0, 0, ScreenWidth-220,self.sc_height);
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton* programeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    programeBtn.frame = CGRectMake(ScreenWidth-120, (self.sc_height-26)*0.5, 65, 26);
    [programeBtn setTitle:@"节目单" forState:UIControlStateSelected];
    [programeBtn setTitle:@"频道" forState:UIControlStateNormal];
    programeBtn.layer.borderWidth = 1.0f;
    programeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    programeBtn.layer.borderColor = [UIColor sc_colorWithHex:0x00B6E9].CGColor;
    programeBtn.layer.cornerRadius = programeBtn.sc_height*0.5;
    [programeBtn setTitleColor:[UIColor sc_colorWithHex:0x00B6E9] forState:UIControlStateNormal];
    programeBtn.selected = true;
    [self addSubview:programeBtn];
    self.programeBtn = programeBtn;
    [programeBtn addTarget:self action:@selector(programeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton* screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    screenBtn.frame = CGRectMake(CGRectGetMaxX(programeBtn.frame)+10, 0, 40, self.sc_height);
//    [screenBtn setImage:[UIImage imageNamed:@"live_btn_cloud"] forState:UIControlStateNormal];
//    [self addSubview:screenBtn];
//    [screenBtn addTarget:self action:@selector(screenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//
    UIButton* shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(CGRectGetMaxX(programeBtn.frame)+10, 0, 40, self.sc_height);
    [shareBtn setImage:[UIImage imageNamed:@"home2_btn_share"] forState:UIControlStateNormal];
    [self addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* topView = [[UIView alloc]  init];
    topView.backgroundColor = [UIColor sc_colorWithHex:0xd7d7d7];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(1));
    }];
    
    UIView* bottomView = [[UIView alloc]  init];
    bottomView.backgroundColor = [UIColor sc_colorWithHex:0xd7d7d7];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(1));
    }];
    
}

-(void)setProgramBtnClickedBlock:(ProgramBtnClickedBlock)block{
    self.programBtnBlock = block;
}
-(void)setScreenBtnClickedBlock:(ScreenBtnClickedBlock)block{
    self.screenBtnBlock = block;
}
-(void)setShakeBtnClickedBlock:(ShakeBtnClickedBlock)block{
    self.shakeBtnBlock = block;
}

-(void)programeBtnClicked:(UIButton*)programeBtn{
    
    if (self.programBtnBlock) {
        programeBtn.selected = !programeBtn.selected;
        self.programBtnBlock(programeBtn);
    }
    
}
-(void)screenBtnClicked{
    
    if (self.screenBtnBlock) {
        self.screenBtnBlock();
    }
    
    
}
-(void)shareBtnClicked{
    
    if (self.shakeBtnBlock) {
        self.shakeBtnBlock();
    }
    
}
@end
