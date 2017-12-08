//
//  PVSpecialHeadView.m
//  PandaVideo
//
//  Created by cara on 17/8/10.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSpecialHeadView.h"

#define selfHeight 133

@interface PVSpecialHeadView()

@property(nonatomic, strong)UIImageView* headImageView;
@property(nonatomic, strong)UILabel* nameLabel;


@end

@implementation PVSpecialHeadView

-(instancetype)initPVSpecialDetailModel:(PVSpecialDetailModel *)specialDetailModel{
    self = [super init];
    self.specialDetailModel = specialDetailModel;
    if (self) {
        [self setupUI];
    }
    
    return self;
}

-(void)setupUI{
    
    UIImageView* headImageView = [[UIImageView alloc]  init];
    headImageView.image = [UIImage imageNamed:@"2.jpg"];
    headImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*211/375);
    [self addSubview:headImageView];
    self.headImageView = headImageView;
    [self.headImageView sc_setImageWithUrlString:self.specialDetailModel.topicImage placeholderImage:[UIImage imageNamed:BIGBITMAP] isAvatar:false];
    UILabel* nameLabel = [[UILabel alloc]  init];
    nameLabel.frame = CGRectMake(12, CGRectGetMaxY(headImageView.frame)+12, ScreenWidth-24, self.specialDetailModel.topicSubTitleHeight);
    nameLabel.numberOfLines = 0;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.text = self.specialDetailModel.topicSubTitle;
}



@end
