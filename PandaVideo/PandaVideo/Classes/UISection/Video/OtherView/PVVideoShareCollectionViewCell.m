//
//  PVVideoShareCollectionViewCell.m
//  VideoDemo
//
//  Created by cara on 17/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoShareCollectionViewCell.h"

@interface PVVideoShareCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;

@property (weak, nonatomic) IBOutlet UILabel *shareLabel;

@end

@implementation PVVideoShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setShareModel:(ShareModel *)shareModel{
    
    _shareModel = shareModel;
    self.shareImageView.image = [UIImage imageNamed:shareModel.imageName];
    self.shareLabel.text = shareModel.title;
}


@end
