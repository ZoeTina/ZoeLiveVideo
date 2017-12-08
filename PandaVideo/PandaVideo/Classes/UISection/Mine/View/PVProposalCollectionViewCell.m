//
//  PVProposalCollectionViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVProposalCollectionViewCell.h"

@interface PVProposalCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *contanierView;
@property (weak, nonatomic) IBOutlet UIImageView *placeorImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *rightTopBtn;

@property(nonatomic, copy)PVProposalCollectionViewCellBlock cellBlock;

@end



@implementation PVProposalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contanierView.layer.borderWidth = 1.0f;
    self.contanierView.layer.borderColor = [UIColor sc_colorWithHex:0xf2f2f2].CGColor;
}
- (IBAction)rightTopBtnClicked {
    if (self.cellBlock) {
        self.cellBlock();
    }
}

-(void)setPVProposalCollectionViewCellBlock:(PVProposalCollectionViewCellBlock)block{
    self.cellBlock = block;
}

-(void)setPhotoModel:(PVPhotoModel *)photoModel{
    _photoModel = photoModel;
    if (photoModel.image) {
        self.iconImageView.hidden = self.rightTopBtn.hidden = false;
        self.contanierView.hidden = true;
        self.iconImageView.image = photoModel.image;
        self.placeorImageView.hidden = self.placeorLabel.hidden = true;
    }else{
        self.iconImageView.hidden =
        self.rightTopBtn.hidden = true;
        self.contanierView.hidden = false;
        if (photoModel.isLast) {//第一张照片
            self.placeorImageView.hidden = self.placeorLabel.hidden = false;
        }else{//前四张
            
        }
    }
}
@end
