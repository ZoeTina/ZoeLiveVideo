//
//  PVShakeSleepView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//
//PVShakeSleepView *shakeView = [[PVShakeSleepView alloc] initShakeSleepView];
//shakeView.frame = CGRectMake(0, 100, IPHONE6WH(307), IPHONE6WH(239));
//[self.view insertSubview:shakeView aboveSubview:self.personTableView];

#import "PVShakeSleepView.h"

@interface PVShakeSleepView ()
@property (nonatomic, copy) ShakeSleepViewCancleBlock cancleBlock;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *descTwoLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation PVShakeSleepView

- (instancetype)initShakeSleepView {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PVShakeSleepView" owner:self options:nil] lastObject];
    }
    return self;
    
}


- (void)layoutSubviews {
    self.layer.cornerRadius = 5;
    [self.titleLabel setFont:[UIFont systemFontOfSizeAdapter:15]];
    [self.descOneLabel setFont:[UIFont systemFontOfSizeAdapter:13]];
    [self.descTwoLabel setFont:[UIFont systemFontOfSizeAdapter:13]];
    [self.sureButton.titleLabel setFont:[UIFont systemFontOfSizeAdapter:16]];
}

//知道了按钮的点击事件，如果没有block，则直接移除
- (IBAction)cancleButtonClick:(id)sender {
    if (self.cancleBlock) {
        self.cancleBlock(self);
    }else {
        [self removeFromSuperview];
    }
}

- (void)ShakeSleepViewCancle:(ShakeSleepViewCancleBlock)cancleBlock {
    self.cancleBlock = cancleBlock;
}
@end
