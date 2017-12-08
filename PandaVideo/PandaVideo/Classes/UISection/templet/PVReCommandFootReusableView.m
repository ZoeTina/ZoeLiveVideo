//
//  PVReCommandFootReusableView.m
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVReCommandFootReusableView.h"

@interface PVReCommandFootReusableView()
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIView *chargeView;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;

@property (weak, nonatomic) IBOutlet UIView *devideView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chargeWidthConstaint;


@property(nonatomic, copy)PVReCommandFootReusableViewCallBlock callBlock;

@end


@implementation PVReCommandFootReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.chargeLabel.text = @"换一换";
    self.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    
    UITapGestureRecognizer* moreTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(moreTapGesture)];
    [self.moreView addGestureRecognizer:moreTapGesture];
    
    UITapGestureRecognizer* chargeTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(chargeTapGesture)];
    [self.chargeView addGestureRecognizer:chargeTapGesture];
    
}

-(void)setPVReCommandFootReusableViewCallBlock:(PVReCommandFootReusableViewCallBlock)block{
    self.callBlock = block;
}
///跳转
-(void)moreTapGesture{
    if (self.callBlock) {
        self.callBlock(false);
    }
}
///换一换
-(void)chargeTapGesture{
    if (self.callBlock) {
        self.callBlock(true);
    }
}
-(void)setVideoTemletModel:(PVVideoTemletModel *)videoTemletModel{
    _videoTemletModel = videoTemletModel;
    if (videoTemletModel.modelMoreData.modelMore.integerValue) {//显示
        self.moreView.hidden = false;
        self.moreLaebl.text = videoTemletModel.modelMoreData.modelMoreTxt;
    }else{
        self.moreView.hidden = true;
    }
    if (videoTemletModel.hasChangeData.hasChange.integerValue) {
        self.chargeView.hidden = false;
        self.chargeLabel.text = videoTemletModel.hasChangeData.hasChangeWord;
    }else{
        self.chargeView.hidden = true;
    }
    if (videoTemletModel.modelMoreData.modelMore.integerValue && !videoTemletModel.hasChangeData.hasChange.integerValue) {
        self.moreView.hidden = false;
        self.chargeView.hidden = true;
        self.devideView.hidden = true;
        self.moreViewConstraint.constant = self.sc_width*0.5;
        self.chargeWidthConstaint.constant = 0;
    }else if(!videoTemletModel.modelMoreData.modelMore.integerValue && videoTemletModel.hasChangeData.hasChange.integerValue){
        self.moreView.hidden = true;
        self.chargeView.hidden = false;
        self.devideView.hidden = true;
        self.moreViewConstraint.constant = 0;
        self.chargeWidthConstaint.constant = self.sc_width*0.5;
    }else{
        self.moreViewConstraint.constant = 0;
        self.chargeWidthConstaint.constant = 0;
    }
}

-(void)setType:(NSInteger)type{
    
    _type = type;
    return;
    if (type == 1 || type == 2 ||  type == 7) {
        self.devideView.hidden = false;
        self.moreViewConstraint
        .constant = 0;
        self.moreView.hidden = false;
        self.chargeView.hidden = false;
        self.moreLaebl.text = @"更多精彩";
        self.chargeLabel.text = @"换一换";
    }else if (type == 3){
        self.devideView.hidden = true;
        self.chargeView.hidden = true;
        self.moreView.hidden = false;
        self.moreLaebl.text = @"全部精彩剧情";
        self.moreViewConstraint
        .constant = self.sc_width*0.5;
    }else if (type == 10){
        self.devideView.hidden = true;
        self.chargeView.hidden = true;
        self.moreView.hidden = false;
        self.moreLaebl.text = @"XXX排行榜";
        self.moreViewConstraint
        .constant = self.sc_width*0.5;
    }
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 3;
    frame.size.height -= 3;
    [super setFrame:frame];
}


@end
