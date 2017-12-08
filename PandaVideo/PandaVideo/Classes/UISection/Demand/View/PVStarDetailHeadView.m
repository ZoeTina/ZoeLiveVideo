//
//  PVStarDetailHeadView.m
//  PandaVideo
//
//  Created by cara on 17/8/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVStarDetailHeadView.h"

#define selfHeight 133

@interface PVStarDetailHeadView()

@property(nonatomic, strong)UIImageView* headImageView;
@property(nonatomic, strong)UILabel* nameLabel;
@property(nonatomic, strong)UIView* botttomView;

@end

@implementation PVStarDetailHeadView

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        [self setupUI];
    }
    
    return self;
}

-(void)setupUI{
    
    UIImageView* headImageView = [[UIImageView alloc]  init];
    headImageView.image = [UIImage imageNamed:@"2.jpg"];
    headImageView.frame = CGRectMake((ScreenWidth-90)*0.5, (selfHeight-60)*0.5+5, 60, 60);
    headImageView.clipsToBounds = true;
    headImageView.layer.cornerRadius = (headImageView.sc_width)*0.5;
    [self addSubview:headImageView];
    self.headImageView = headImageView;
    
    UILabel* nameLabel = [[UILabel alloc]  init];
    nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame)+10, 65, 30, 14);
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = @"胡歌";
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIView* botttomView  = [[UIView alloc]  init];
    botttomView.hidden = true;
    botttomView.backgroundColor = [UIColor sc_colorWithHex:0xD7D7D7];
    [self addSubview:botttomView];
    self.botttomView = botttomView;
    [self.botttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@(1));
        make.bottom.equalTo(self).offset(-1);
    }];
    
    
}



@end
