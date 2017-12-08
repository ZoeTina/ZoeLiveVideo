//
//  PVCommentTableHeadView.m
//  PandaVideo
//
//  Created by cara on 17/7/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVCommentTableHeadView.h"
#import "NSString+SCExtension.h"


@interface PVCommentTableHeadView()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

@property (nonatomic, copy)PraiseBtnClickedBlock praiseBlock;
@property (nonatomic, copy)CommentTableHeadViewTextBlock textBlock;
@property (nonatomic, copy)CommentTableHeadViewTapGestureBlock  tapGestureBlock;

@end



@implementation PVCommentTableHeadView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupUI];
    
}

-(void)setupUI{
    UIView* bgView = [[UIView alloc]  init];
    bgView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bgView;
    
    self.userImageView.clipsToBounds = true;
    self.userImageView.layer.cornerRadius = 33*0.5;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapGestureClicked)];
    [self addGestureRecognizer:tapGesture];
    
}

-(void)tapGestureClicked{
    if (self.tapGestureBlock) {
        self.tapGestureBlock(self.commentModel);
    }
}
-(void)setCommentModel:(PVFindCommentModel *)commentModel{
    
    _commentModel = commentModel;
    self.fullBtn.hidden = !commentModel.isShowFullBtn;
    if (commentModel.isShowText) {
        self.fullBtn.selected = true;
        self.detailLabel.numberOfLines = 0;
    }else{
        self.fullBtn.selected = false;
        self.detailLabel.numberOfLines = 4;
    }
    [self setDetailLabelHeight];
    [self.userImageView sc_setImageWithUrlString:commentModel.demandCommentModel.userData.userAvatar placeholderImage:[UIImage imageNamed:@"mine_icon_avatar"] isAvatar:false];
    if(commentModel.demandCommentModel.userData.userName.length){
        self.userNameLabel.text = commentModel.demandCommentModel.userData.userName;
    }else if(commentModel.demandCommentModel.userData.nickName.length){
        self.userNameLabel.text = commentModel.demandCommentModel.userData.nickName;
    }else if(commentModel.demandCommentModel.userData.userId.length){
        self.userNameLabel.text = commentModel.demandCommentModel.userData.userId;
    }    
    if (commentModel.demandCommentModel.isLike.intValue) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"find_btn_like_selected"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setImage:[UIImage imageNamed:@"find_btn_like_normal"] forState:UIControlStateNormal];
    }
    [self.praiseBtn setTitle: [NSString stringWithFormat:@"  %@",[commentModel.demandCommentModel.like transformationStringToSimplify]] forState:UIControlStateNormal];
    self.timeLabel.text = commentModel.demandCommentModel.detailDate;
    
}


-(void)setDetailLabelHeight{
    if(self.commentModel.text == nil || self.commentModel.text.length == 0){
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.commentModel.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.commentModel.text.length)];
    self.detailLabel.attributedText = attributedString;
}




-(void)setPraiseBtnClickedBlock:(PraiseBtnClickedBlock)block{
    self.praiseBlock = block;
}

-(void)setCommentTableHeadViewTextBlock:(CommentTableHeadViewTextBlock)block{
    self.textBlock = block;
}

-(void)setCommentTableHeadViewTapGestureBlock:(CommentTableHeadViewTapGestureBlock)block{
    self.tapGestureBlock = block;
}


- (IBAction)praiseBtnClicked:(UIButton *)sender {
    
    if (self.praiseBlock) {
        self.praiseBlock(sender);
    }
    
}

- (IBAction)fullBtnClicked:(UIButton *)sender {
    
    if (self.textBlock) {
        sender.selected = !sender.selected;
        self.textBlock(sender);
    }
}


@end
