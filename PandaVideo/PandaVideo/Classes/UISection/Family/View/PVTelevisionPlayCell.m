//
//  PVTelevisionPlayCell.m
//  PandaVideo
//
//  Created by cara on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTelevisionPlayCell.h"

@interface  PVTelevisionPlayCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgeView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;


@end

@implementation PVTelevisionPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PVFamilyInfoListModel *)model{
    [self.userImageView sc_setImageWithUrlString:model.avatar placeholderImage:[UIImage imageNamed:@"user_logo"] isAvatar:NO];
    self.userNameLabel.text = model.nickName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
