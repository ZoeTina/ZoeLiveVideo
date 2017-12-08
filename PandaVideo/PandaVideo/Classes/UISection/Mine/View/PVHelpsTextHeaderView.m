//
//  PVHelpsTextHeaderView.m
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHelpsTextHeaderView.h"

@interface PVHelpsTextHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic, copy)PVHelpsTextHeaderViewBlock headerViewBlock;


@end

@implementation PVHelpsTextHeaderView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    UIView* bgView = [[UIView alloc]  init];
    bgView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bgView;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapGestureClicked)];
    [self addGestureRecognizer:tapGesture];
}

-(void)tapGestureClicked{
    if (self.headerViewBlock) {
        self.headerViewBlock();
    }
}
-(void)setPVHelpsTextHeaderViewBlock:(PVHelpsTextHeaderViewBlock)block{
    self.headerViewBlock = block;
}
-(void)setSection:(NSInteger)section{
    
    _section = section;
    NSString* imageText = @"mine_icon_question_1";
    NSString* title = @"常见问题";
    if (section != 0) {
        imageText = (section == 1) ? @"mine_icon_question_2" : @"mine_icon_question_3";
        title = (section == 1) ? @"系统问题" : @"其他问题";
    }
    self.leftImageView.image = [UIImage imageNamed:imageText];
    self.titleLabel.text = title;
    
}

- (void)setQuestsionListModel:(PVQuestionListModel *)questsionListModel {
    _questsionListModel = questsionListModel;
    self.titleLabel.text = _questsionListModel.className;
//    self.titleLabel.text = @"系统问题其他问题系统问题其他问题系统问题其他问题系统问题其他问题系统问题其他问题";
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[_questsionListModel.icon sc_urlString]] placeholderImage:[UIImage imageNamed:@"mine_icon_question_2"]];
}
@end
