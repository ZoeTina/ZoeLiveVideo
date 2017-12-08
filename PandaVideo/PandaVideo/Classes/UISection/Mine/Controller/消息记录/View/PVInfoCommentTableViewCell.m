//
//  PVInfoCommentTableViewCell.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInfoCommentTableViewCell.h"

@interface PVInfoCommentTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *replaylabel;
@property (weak, nonatomic) IBOutlet UILabel *mineCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) PVInfoCommentTableViewCellBlock cellBlock;
@end

@implementation PVInfoCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGesture];
}

- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullTextLabelTap)];
    [self.fullTextLabel addGestureRecognizer:tap];
}

//全文按钮
- (void)fullTextLabelTap {
    if (self.fullTextLabel.text.length == 0) return;
    if (self.cellBlock) {
        self.cellBlock(self);
    }
}


- (void)setCommentModel:(PVInfoCommentModel *)commentModel {
    _commentModel = commentModel;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[_commentModel.userData.avatar sc_urlString]] placeholderImage:[UIImage imageNamed:@"mine_icon_avatar"]];
    self.nameLabel.text = _commentModel.userData.userName;
    self.timeLabel.text = _commentModel.replyTime;
    self.replaylabel.text = [NSString stringWithFormat:@"回复我：%@",_commentModel.replyContent];
    self.mineCommentLabel.text = [NSString stringWithFormat:@"我的评论：%@",_commentModel.comment];
    self.titleLabel.text = [NSString stringWithFormat:@"内容标题：%@",_commentModel.title];
    
    CGSize titleSize = [_commentModel.comment boundingRectWithSize:CGSizeMake(kScreenWidth - 56 - 13, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    CGFloat labelHeight = [self.mineCommentLabel sizeThatFits:CGSizeMake(kScreenWidth - 56 - 13, MAXFLOAT)].height;
    CGFloat count = @((titleSize.height) / self.mineCommentLabel.font.lineHeight).floatValue;
    if (count <= 2) {
        self.isOpen = YES;
    }else {
        if (_commentModel.isFullText) {
            self.isOpen = YES;
        }else {
            self.isOpen = NO;
        }
    }
    
//    if (count > 2.0 && _commentModel.isFullText){
//        self.isOpen = NO;
//    }else {
//        self.isOpen = YES;
////        [self layoutSubviews];
//    }
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    [self layoutSubviews];

}

- (void)setPVInfoCommentTableViewCellBlock:(PVInfoCommentTableViewCellBlock)block {
    self.cellBlock = block;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.sc_height / 2.;
    if (self.isOpen) {
        [self hideFullTextLabel];
    }else {
        [self displayFulltextlabel];
    }
}

- (void)displayFulltextlabel {
    self.mineCommentLabel.numberOfLines = 2;
    [self.fullTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replaylabel.mas_left);
        make.top.equalTo(self.mineCommentLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(32);
        make.bottom.equalTo(self.titleLabel.mas_top);
    }];
    self.fullTextLabel.text = @"全文";
}

- (void)hideFullTextLabel {
    self.mineCommentLabel.numberOfLines = 0;
    [self.fullTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replaylabel.mas_left);
        make.top.equalTo(self.mineCommentLabel.mas_bottom);
        make.height.mas_equalTo(9);
        make.bottom.equalTo(self.titleLabel.mas_top);
    }];
    self.fullTextLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
