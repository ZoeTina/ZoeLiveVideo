//
//  PVFindColumnHeadView.m
//  PandaVideo
//
//  Created by cara on 17/7/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFindColumnHeadView.h"

@interface PVFindColumnHeadView()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *allLable;

@property(nonatomic, copy)BackBtnClickedBlock backBtnBlock;


@end



@implementation PVFindColumnHeadView



-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.videoImageView.clipsToBounds = true;
    self.videoImageView.layer.cornerRadius = 35;    
}

-(void)setBackBtnClickedBlock:(BackBtnClickedBlock)block{
    self.backBtnBlock = block;
}

-(void)setFindBaseInfoModel:(PVFindBaseInfoModel *)findBaseInfoModel{
    _findBaseInfoModel = findBaseInfoModel;
    [self.bgImageView sc_setImageWithUrlString:findBaseInfoModel.image placeholderImage:[UIImage imageNamed:BIGBITMAP] isAvatar:false];
    [self.videoImageView sc_setImageWithUrlString:findBaseInfoModel.logo placeholderImage:[UIImage imageNamed:@"mine_icon_avatar"] isAvatar:false];
    self.detailLabel.text = findBaseInfoModel.info;
    self.titleLable.text = [NSString stringWithFormat:@"%@",findBaseInfoModel.name];
}


- (IBAction)backBtnClicked {
    if (self.backBtnBlock) {
        self.backBtnBlock();
    }
}


@end
