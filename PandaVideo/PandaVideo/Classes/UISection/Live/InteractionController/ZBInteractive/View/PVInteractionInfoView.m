//
//  PVInteractionInfoView.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInteractionInfoView.h"

@interface PVInteractionInfoView()

@property (nonatomic, copy) JJBtnClickedBlock JJBtnBlock;
@end

@implementation PVInteractionInfoView

- (instancetype) initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self initUI:frame];
    }
    return self;
}

- (void) initUI:(CGRect)frame{

    CGFloat vHeight = CGRectGetHeight(self.frame);
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"";
    self.titleLabel.frame = CGRectMake(13, 0, kScreenWidth-200,self.sc_height);
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:self.titleLabel];
    
    self.profileLabel = [[UILabel alloc] init];
    self.profileLabel.frame = CGRectMake(kScreenWidth-82, (vHeight-20)/2, 50, 20);
    self.profileLabel.textAlignment = NSTextAlignmentRight;
    self.profileLabel.font = [UIFont systemFontOfSize:13.0];
    self.profileLabel.textColor = [UIColor sc_colorWithRed:128 green:128 blue:128];
    self.profileLabel.text = @"简介";
    [self addSubview:self.profileLabel];
    
    _iconIMG = [[UIImageView alloc] init];
    _iconIMG.frame = CGRectMake(CGRectGetMaxX(_profileLabel.frame)+5, (vHeight-14)/2, 14, 14);
    _iconIMG.image = [UIImage imageNamed:[NSString stringWithFormat:@"live_btn_enter_black"]];
    [self addSubview:_iconIMG];
}

-(void)setJJBtnClickedBlock:(JJBtnClickedBlock)block{
    self.JJBtnBlock = block;
}

@end
