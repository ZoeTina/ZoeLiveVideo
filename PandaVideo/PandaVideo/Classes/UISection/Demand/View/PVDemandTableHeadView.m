//
//  PVDemandTableHeadView.m
//  PandaVideo
//
//  Created by cara on 17/8/2.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDemandTableHeadView.h"

@interface PVDemandTableHeadView()

@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *headCountLabel;

@property (weak, nonatomic) IBOutlet UIView *headRightContanierView;

@property (weak, nonatomic) IBOutlet UIImageView *headRightImageView;

@property (weak, nonatomic) IBOutlet UIButton *headRightCountBtn;

@property (nonatomic, copy)HeadViewGestureBlock gestureBlock;

@end

@implementation PVDemandTableHeadView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupUI];
    
}

-(void)setupUI{
    UIView* bgView = [[UIView alloc]  init];
    bgView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bgView;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapGestureClicked)];
    [self.headRightContanierView addGestureRecognizer:tapGesture];
    self.headTitleLabel.font = [UIFont fontWithName:FontBlod size:15];
    
}

-(void)tapGestureClicked{
    if (self.gestureBlock) {
        self.gestureBlock();
    }
}

-(void)setHeadViewGestureBlock:(HeadViewGestureBlock)block{
    self.gestureBlock = block;
}



-(void)setCount:(NSInteger)count{
    [self.headRightCountBtn setTitle:[NSString stringWithFormat:@"%ld个",count] forState:UIControlStateNormal];
}

-(void)setType:(NSInteger)type{
    _type = type;
    if (type == 2) {
        self.headRightContanierView.hidden = false;
        self.headCountLabel.hidden = true;
        self.headTitleLabel.text = @"选集";
    }else if (type == 3) {
        self.headCountLabel.hidden = self.headRightContanierView.hidden = true;
        self.headTitleLabel.text = @"小编推荐";
    }else if (type == 4){
        self.headCountLabel.hidden = self.headRightContanierView.hidden = true;
        self.headTitleLabel.text = @"猜你喜欢";
    }else if (type == 5){
        self.headCountLabel.hidden = true;
        self.headRightContanierView.hidden = false;
        self.headTitleLabel.text = @"相关明星";
    }
}
@end
