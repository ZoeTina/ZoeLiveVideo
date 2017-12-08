//
//  PVLookOrderManagerCell.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLookOrderManagerCell.h"

@interface PVLookOrderManagerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *surfaceImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoImageLeftConstraint;

@property (weak, nonatomic) IBOutlet UIButton *isSelectImageView;
@property (nonatomic, copy) PVLookOrderManagerCellBlock managerBlock;
@end


@implementation PVLookOrderManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.videoImageLeftConstraint.constant = -13;
    self.isSelectImageView.hidden = YES;
    self.surfaceImageView.layer.cornerRadius = 3;
    self.surfaceImageView.layer.masksToBounds = YES;
}

- (IBAction)deleteBtnClick:(id)sender {
    self.isSelectImageView.selected = !self.isSelectImageView.selected;
    if (self.managerBlock) {
        self.managerBlock(self.isSelectImageView);
    }
}

- (void)setPVLookOrderManagerCellBlock:(PVLookOrderManagerCellBlock)block {
    self.managerBlock = block;
}

- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    if (_isShow) {
        self.videoImageLeftConstraint.constant = 13;
        self.isSelectImageView.hidden = NO;
    }else {
        self.videoImageLeftConstraint.constant = -20;
        self.isSelectImageView.hidden = YES;
    }
}

- (void)setModel:(PVTeleCloudVideoListModel *)model {
    _model = model;
    self.isSelectImageView.selected = model.isDelete;
    [self layoutManagerCell];
}

- (void)layoutManagerCell {
    [self.surfaceImageView sd_setImageWithURL:[NSURL URLWithString:[self.model.image sc_urlString]] placeholderImage:[UIImage imageNamed:CROSSMAPBITMAP]];
    self.titleLabel.text = self.model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
