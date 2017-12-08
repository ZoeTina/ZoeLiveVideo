//
//  PVHelpBottomView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/10.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHelpBottomView.h"

@interface PVHelpBottomView ()
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;


@property (nonatomic, copy) PVHelpBottomViewBlock helpBlock;
@end


@implementation PVHelpBottomView

- (instancetype)initHelpBottomView {
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PVHelpBottomView" owner:self options:nil];
        return [array lastObject];
    }
    return self;
}

- (void)initUI {
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:IPHONE6WH(10)];

    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:self.questionClassModel.info];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.questionClassModel.info length])];
    
    // 设置Label要显示的text
    [self.serveerLabel setAttributedText:setString];
    
    
//    self.serveerLabel.text = self.questionClassModel.info;
    self.phonelabel.text = self.questionClassModel.phoneNum;
//    self.phonelabel.text = self.phoneNum;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callServerPhone)];
    self.phonelabel.userInteractionEnabled = YES;
    [self.phonelabel addGestureRecognizer:tap];
    
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callServerPhone)];
    [self.phoneImageView addGestureRecognizer:phoneTap];
    self.phoneImageView.userInteractionEnabled = YES;
}

//- (void)setPhoneNum:(NSString *)phoneNum {
//    _phoneNum = phoneNum;
//    [self initUI];
//}

- (void)setQuestionClassModel:(PVQuestionClassModel *)questionClassModel {
    _questionClassModel = questionClassModel;
    [self initUI];
}

- (void)setPVHelpBottomViewBlock:(PVHelpBottomViewBlock)block {
    self.helpBlock = block;
//    [self initUI];
}


- (void)callServerPhone {
    if (self.helpBlock) {
        self.helpBlock(self);
    }
}

@end
