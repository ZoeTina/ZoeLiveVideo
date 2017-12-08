//
//  PVFindHomeTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/7/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFindHomeTableViewCell.h"
#import "NSString+SCExtension.h"


@interface PVFindHomeTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTttileLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *videoBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property(nonatomic, copy)CommentBtnClickedBlock commentBtnBlock;
@property(nonatomic, copy)PraiseBtnClickedBlock  praiseBtnBlock;
@property(nonatomic, copy)ShareBtnClickedBlock   shareBtnBlock;
@property(nonatomic, copy)ImageViewClickedBlock  imageViewBlock;

@end



@implementation PVFindHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.videoImageView.image = [UIImage imageNamed:@"1.jpg"];
    self.videoImageView.clipsToBounds = true;
    self.videoImageView.layer.cornerRadius = 20;
    self.videoBgImageView.image = [UIImage imageNamed:@"2.jpg"];
    
    self.videoBgImageView.userInteractionEnabled = true;
    UITapGestureRecognizer* imageViewTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(imageViewTapGestureClicked)];
    [self.videoBgImageView addGestureRecognizer:imageViewTapGesture];
    
}

-(void)imageViewTapGestureClicked{
    
    if (self.imageViewBlock) {
        self.imageViewBlock(self.playBtn);
    }
    
    NSLog(@"-----------");
    
}

-(void)setImageViewClickedBlock:(ImageViewClickedBlock)block{
    self.imageViewBlock = block;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 3;
    frame.size.height -= 3;
    [super setFrame:frame];
}

-(void)setFindHomeModel:(PVFindHomeModel *)findHomeModel{
    _findHomeModel = findHomeModel;
    self.playBtn.hidden = findHomeModel.isHiddenPlayBtn;
    [self.videoImageView sc_setImageWithUrlString:findHomeModel.authorData.logo placeholderImage:[UIImage imageNamed:@"mine_icon_avatar"] isAvatar:false];
    self.videoTttileLabel.text = findHomeModel.authorData.name;
    self.videoTimeLabel.text = findHomeModel.publishTimeStr;
    self.videoTextLabel.text = findHomeModel.title;
    self.videoDetailLabel.text = findHomeModel.subTitle;
    [self.videoBgImageView sc_setImageWithUrlString:findHomeModel.image placeholderImage:[UIImage imageNamed:BIGBITMAP] isAvatar:false];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"  %@",[findHomeModel.commentCount transformationStringToSimplify]] forState:UIControlStateNormal];
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"  %@",[findHomeModel.upCount transformationStringToSimplify]] forState:UIControlStateNormal];
    self.praiseBtn.selected = findHomeModel.isUp.intValue;
    self.videoTotalTimeLabel.text = findHomeModel.videoTime;
}


-(void)setCommentBtnClickedBlock:(CommentBtnClickedBlock)block{
    self.commentBtnBlock = block;
}
-(void)setPraiseBtnClickedBlock:(PraiseBtnClickedBlock)block{
    self.praiseBtnBlock = block;
}
-(void)setShareBtnClickedBlock:(ShareBtnClickedBlock)block{
    self.shareBtnBlock = block;
}
- (IBAction)commentBtnClicked:(UIButton *)sender {
    if (self.commentBtnBlock) {
        self.commentBtnBlock(sender);
    }
}
- (IBAction)praiseBtnClicked:(UIButton *)sender {
    if (self.praiseBtnBlock) {
        self.praiseBtnBlock(sender);
    }
}
- (IBAction)shareBtnClicked:(UIButton *)sender {
    if (self.shareBtnBlock) {
        self.shareBtnBlock(sender);
    }
}
@end
