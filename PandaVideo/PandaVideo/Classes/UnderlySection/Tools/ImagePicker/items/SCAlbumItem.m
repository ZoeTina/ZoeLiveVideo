//
//  SCAlbumItem.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/7/30.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "SCAlbumItem.h"
#import "SCImageManager.h"

@interface SCAlbumItem ()

@property (nonatomic, weak) UIImageView *posterImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *arrowImageView;

@end

@implementation SCAlbumItem

- (UIImageView *)posterImageView {
    if (!_posterImageView) {
        UIImageView *posterImageView = [[UIImageView alloc] init];
        posterImageView.contentMode = UIViewContentModeScaleAspectFill;
        posterImageView.clipsToBounds = YES;
        posterImageView.frame = CGRectMake(0, 0, 70, 70);
        [self.contentView addSubview:posterImageView];
        _posterImageView = posterImageView;
    }
    return _posterImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.frame = CGRectMake(80, 0, self.sc_width - 80 - 50, self.sc_height);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        CGFloat arrowWidthHeight = 15;
        arrowImageView.frame = CGRectMake(self.sc_width - arrowWidthHeight - 12, 28, arrowWidthHeight, arrowWidthHeight);
        [arrowImageView setImage:[UIImage imageNamed:@""]];
        [self.contentView addSubview:arrowImageView];
        _arrowImageView = arrowImageView;
    }
    return _arrowImageView;
}

- (UIButton *)selectedCountButton {
    if (!_selectedCountButton) {
        UIButton *seletedCountButton = [[UIButton alloc] init];
        seletedCountButton.layer.cornerRadius = 12;
        seletedCountButton.clipsToBounds = YES;
        seletedCountButton.backgroundColor = [UIColor redColor];
        [seletedCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        seletedCountButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:seletedCountButton];
        _selectedCountButton = seletedCountButton;
    }
    return _selectedCountButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectedCountButton.frame = CGRectMake(self.sc_width - 24 - 30, 23, 24, 24);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
}

- (void)setModel:(SCAlbumModel *)model {
    _model = model;
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:model.name attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)", model.count] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.titleLabel.attributedText = nameString;
    
    [[SCImageManager manager] getPostImageWithAlbumModel:model completion:^(UIImage *postImage) {
        self.posterImageView.image = postImage;
    }];
    
    if (model.selectedCount) {
        self.selectedCountButton.hidden = NO;
        [self.selectedCountButton setTitle:[NSString stringWithFormat:@"%zd", model.selectedCount] forState:UIControlStateNormal];
    } else {
        self.selectedCountButton.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
