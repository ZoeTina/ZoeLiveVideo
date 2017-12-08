//
//  PVDetailHeipsTextHeadView.m
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDetailHeipsTextHeadView.h"


@interface PVDetailHeipsTextHeadView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property(nonatomic, copy)PVDetailHeipsTextHeadViewBlock headerViewBlock;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation PVDetailHeipsTextHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIView* bgView = [[UIView alloc]  init];
    bgView.backgroundColor = [UIColor clearColor];
    self.backgroundView = bgView;

    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapGestureClicked)];
    [self addGestureRecognizer:tapGesture];
    

}

-(void)tapGestureClicked{
    if (self.headerViewBlock) {
        self.headerViewBlock();
    }
}

-(void)setPVDetailHeipsTextHeadViewBlock:(PVDetailHeipsTextHeadViewBlock)block{
    self.headerViewBlock = block;
}

-(void)setDetailModel:(PVQuestionModel *)detailModel{
    _detailModel = detailModel;
    self.leftBtn.selected = detailModel.isOpen;
    self.titleLabel.textColor = detailModel.isOpen ? [UIColor sc_colorWithHex:0x2AB4E4] : [UIColor sc_colorWithHex:0x000000];
    self.bottomView.hidden = detailModel.isOpen;
    self.titleLabel.text = detailModel.question;
}

- (IBAction)leftBtnClicked {
    self.leftBtn.selected = !self.leftBtn.selected;
    [self tapGestureClicked];
}
@end
