//
//  PVUGCVideoHeaderView.m
//  PandaVideo
//
//  Created by songxf on 2017/11/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUGCVideoHeaderView.h"
#import "SCImageManager.h"


@implementation PVUGCVideoHeaderView

#pragma mark getter setter

- (UILabel *)dateLabel{
    if (_dateLabel == nil) {
        _dateLabel = [UILabel sc_labelWithText:@"" fontSize:15.0 textColor:[UIColor sc_colorWithHex:0x000000] alignment:NSTextAlignmentLeft];
    }
    return _dateLabel;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(7);
        make.center.mas_offset(0);
        make.height.equalTo(@20);
    }];
 }
@end


#pragma mark  主播动态图片
@interface PVUGCVideoSelectedCell () {
@private
    UIButton *_selectPhotoButton;
    UIButton *_playButton;
    UIImageView *_photoImageView;
}
@property (nonatomic, strong,readonly) UIButton *playButton;
@property (nonatomic, strong,readonly) UIImageView *photoImageView;
@end

@implementation PVUGCVideoSelectedCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}


- (void)setModel:(SCAssetModel *)model{
    _model = model;
    [[SCImageManager manager] getPhotoWithAsset:model.asset photoWidth:self.sc_width completion:^(UIImage *photoImage, NSDictionary *info, BOOL isDegraded) {
        self.photoImageView.image = photoImage;
    }];
    
}
- (void)setupUI {
    [self.contentView addSubview:self.photoImageView];
    [self.contentView addSubview:self.playButton];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.mas_equalTo(0);
        make.right.equalTo(self.contentView).offset(-5);
        make.width.height.mas_equalTo(25);
    }];
}

- (void)playVideoClick{
    if (self.playVideoBlock) {
        self.playVideoBlock();
    }
}
#pragma mark --  getter setter

- (UIButton *)playButton {
    if (_selectPhotoButton == nil) {
        _selectPhotoButton =[[UIButton alloc] init];
        _selectPhotoButton.backgroundColor = [UIColor clearColor];
        [_selectPhotoButton setImage:[UIImage imageNamed:@"ugc_album_player"] forState:UIControlStateNormal];
        [_selectPhotoButton addTarget:self action:@selector(playVideoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _selectPhotoButton;
}

- (UIImageView *)photoImageView {
    if (_photoImageView == nil) {
        _photoImageView =[[UIImageView alloc] init];
        _photoImageView.backgroundColor = [UIColor blackColor];
        _photoImageView.userInteractionEnabled = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return  _photoImageView;
}

@end
