//
//  PVCommentHeadTable.m
//  PandaVideo
//
//  Created by cara on 17/7/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVCommentHeadTable.h"

@interface PVCommentHeadTable()

@property (weak, nonatomic) IBOutlet UIImageView *commentVideoImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentVideoBgImageView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, copy) ImageViewClickedBlock  imageViewBlock;

@end

@implementation PVCommentHeadTable


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupUI];
    
}

-(void)setupUI{
    self.commentVideoImageView.clipsToBounds = true;
    self.commentVideoImageView.layer.cornerRadius = 20.0f;
    
    self.commentVideoBgImageView.userInteractionEnabled = true;
    UITapGestureRecognizer* imageViewTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(imageViewTapGestureClicked)];
    [self.commentVideoBgImageView addGestureRecognizer:imageViewTapGesture];
    
    self.commentVideoImageView.userInteractionEnabled = true;
    UITapGestureRecognizer* imageViewTapGesture2 = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(imageViewTapGesture2Clicked)];
    [self.commentVideoImageView addGestureRecognizer:imageViewTapGesture2];
    
}

-(void)imageViewTapGesture2Clicked{
    if (self.imageViewBlock) {
        self.imageViewBlock(2);
    }
}

-(void)setFindHomeModel:(PVFindHomeModel *)findHomeModel{
    _findHomeModel = findHomeModel;
    self.commentTitleLabel.text = findHomeModel.title;
    self.commentDetailLabel.text = findHomeModel.subTitle;
    [self.commentVideoBgImageView sc_setImageWithUrlString:findHomeModel.image placeholderImage:[UIImage imageNamed:BIGBITMAP] isAvatar:false];
    self.commentTimeLabel.text = findHomeModel.publishTimeStr;
    
    if (findHomeModel.authorData.logo.length) {
        [self.commentVideoImageView sc_setImageWithUrlString:findHomeModel.authorData.logo placeholderImage:[UIImage imageNamed:@"mine_icon_avatar"] isAvatar:false];
    }else{
        [self.commentVideoImageView sc_setImageWithUrlString:findHomeModel.userIcon placeholderImage:[UIImage imageNamed:@"mine_icon_avatar"] isAvatar:false];
    }
    
    self.commentNickNameLabel.text = findHomeModel.authorData.name;
    self.timeLabel.text = findHomeModel.videoTime;
}

-(void)setImageViewClickedBlock:(ImageViewClickedBlock)block{
    self.imageViewBlock = block;
}

-(void)imageViewTapGestureClicked{
    if (self.imageViewBlock) {
        self.imageViewBlock(1);
    }
}

@end
