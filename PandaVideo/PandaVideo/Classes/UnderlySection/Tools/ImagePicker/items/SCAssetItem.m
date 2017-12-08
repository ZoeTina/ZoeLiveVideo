//
//  SCAssetItem.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/7/30.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "SCAssetItem.h"
#import "SCAssetModel.h"
#import "SCImageManager.h"
//#import "SCImagePickerController.h"
#import "SCProgressView.h"

@interface SCAssetItem ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIImageView *selectImageView;
@property (nonatomic, weak) UILabel *selectIndex;

@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIView *timeLengthView;
@property (nonatomic, weak) UILabel *timeLength;

@property (nonatomic, strong) SCProgressView *progressView;
@property (nonatomic, assign) int32_t bigImageRequestID;

@end

@implementation SCAssetItem

- (void)setModel:(SCAssetModel *)model {
    _model = model;
    
    self.representedAssetIdentifier = [[SCImageManager manager] getAssetIdentifier:model.asset];
    
    int32_t imageRequestID = [[SCImageManager manager] getPhotoWithAsset:model.asset photoWidth:self.sc_width completion:^(UIImage *photoImage, NSDictionary *info, BOOL isDegraded) {
        if (self.progressView) {
            self.progressView.hidden = YES;
            self.imageView.alpha = 1.0;
        }
        
        if (!([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)) {
            self.imageView.image = photoImage;
            return;
        }
        
        if ([self.representedAssetIdentifier isEqualToString:[[SCImageManager manager] getAssetIdentifier:model.asset]]) {
            self.imageView.image = photoImage;
        } else {
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
        
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    } progressHandler:nil networkAccessAllowed:NO];
    
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
//    self.imageRequestID = imageRequestID;
    
//    self.selectPhotoButton.selected = model.isSelected;
//    self.selectImageView.image = self.selectPhotoButton.isSelected ? [UIImage imageNamed:self.photoSelImageName] : [UIImage imageNamed:self.photoDefImageName];
    
//    self.selectIndex.hidden = !model.isSelected;
//    if (model.index && model.index != 0) {
//        self.selectIndex.text = [NSString stringWithFormat:@"%zd", model.index];
//    }
    
//    self.type = (NSInteger)model.type;
    
//    if (![[SCImageManager manager] isPhotoSelectableWithAsset:model.asset]) {
//        if (_selectImageView.hidden == NO) {
//            self.selectPhotoButton.hidden = YES;
//            _selectImageView.hidden = YES;
//        }
//    }
    
//    if (model.isSelected) {
//        [self fetchBigImage];
//    }
//    [self setNeedsLayout];
}

- (void)setShowSelectButton:(BOOL)showSelectButton {
    _showSelectButton = showSelectButton;
    if (!self.selectPhotoButton.hidden) {
        self.selectPhotoButton.hidden = !showSelectButton;
    }
    if (!self.selectImageView.hidden) {
        self.selectImageView.hidden = !showSelectButton;
    }
}

- (void)setType:(SCAssetItemType)type {
    _type = type;
    if (type == SCAssetItemTypePhoto || type == SCAssetItemTypeLivePhoto || (type == SCAssetItemTypePhotoGif && !self.allowPickingGif) || self.allowPickingMultipleVideo) {
        _selectImageView.hidden = NO;
        _selectPhotoButton.hidden = NO;
        _bottomView.hidden = YES;
        _timeLengthView.hidden = YES;
    } else { // Video of Gif
        _selectImageView.hidden = YES;
        _selectPhotoButton.hidden = YES;
    }
    
    if (type == SCAssetItemTypeVideo) {
        self.bottomView.hidden = NO;
        self.timeLengthView.hidden = NO;
        self.timeLength.text = _model.timeLength;
        _timeLength.textAlignment = NSTextAlignmentCenter;
    } else if (type == SCAssetItemTypePhotoGif) {
        self.bottomView.hidden = NO;
        self.timeLength.text = @"GIF";
        _timeLength.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)fetchBigImage {
    _bigImageRequestID = [[SCImageManager manager] getPhotoWithAsset:self.model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (_progressView) {
            [self hideProgressView];
        }
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        if (_model.isSelected) {
            progress = progress > 0.02 ? progress : 0.02;
            self.progressView.progress = progress;
            self.progressView.hidden = NO;
            self.imageView.alpha = 0.4;
            if (progress >= 1) {
                [self hideProgressView];
            }
        } else {
            *stop = YES;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } networkAccessAllowed:YES];
}

- (void)hideProgressView {
    self.progressView.hidden = YES;
    self.imageView.alpha = 1.0;
}

#pragma mark - /***** Lazy Methods *****/

- (UIButton *)selectPhotoButton {
    if (!_selectPhotoButton) {
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(selectPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        _selectPhotoButton = button;
    }
    return _selectPhotoButton;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        _imageView = imageView;
        
        [self.contentView bringSubviewToFront:_selectImageView];
        [self.contentView bringSubviewToFront:_bottomView];
    }
    return _imageView;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        UIImageView *selectImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:selectImageView];
        _selectImageView = selectImageView;
    }
    return _selectImageView;
}

- (UILabel *)selectIndex {
    if (!_selectIndex) {
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.font = [UIFont boldSystemFontOfSize:14.0];
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        [self.selectImageView addSubview:indexLabel];
        _selectIndex = indexLabel;
    }
    return _selectIndex;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:bottomView];
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (UIView *)timeLengthView {
    if (!_timeLengthView) {
        UIView *timeView = [[UIView alloc] init];
        timeView.backgroundColor = [UIColor sc_colorWithHex:0xF13517];
        timeView.layer.cornerRadius = 3.0;
        [self.bottomView addSubview:timeView];
        _timeLengthView = timeView;
    }
    return _timeLengthView;
}

- (UILabel *)timeLength {
    if (!_timeLength) {
        UILabel *timeLength = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLength.font = [UIFont boldSystemFontOfSize:11.0];
        timeLength.textColor = [UIColor whiteColor];
        timeLength.textAlignment = NSTextAlignmentCenter;
        [self.timeLengthView addSubview:timeLength];
        _timeLength = timeLength;
    }
    return _timeLength;
}

- (SCProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[SCProgressView alloc] init];
        _progressView.hidden = YES;
        [self addSubview:_progressView];
    }
    return _progressView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _selectPhotoButton.frame = CGRectMake(self.sc_width - 44, 0, 44, 44);
    
    [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(27);
        make.trailing.equalTo(self.mas_trailing).mas_offset(-5);
        make.top.equalTo(self.mas_top).mas_offset(5);
    }];
    
    [_selectIndex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_selectImageView.mas_centerX);
        make.centerY.equalTo(_selectImageView.mas_centerY);
        make.width.height.mas_equalTo(20);
    }];
    
    _imageView.frame = CGRectMake(0, 0, self.sc_width, self.sc_height);
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(21);
        make.width.equalTo(self.mas_width);
    }];
    
    [_timeLengthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_bottomView.mas_trailing).mas_offset(-5);
        make.top.equalTo(_bottomView.mas_top).offset(0);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(41);
    }];
    
    [_timeLength mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.timeLengthView);
    }];
    
    static CGFloat progressWidthHeight = 20;
    CGFloat progressXY = (self.sc_width - progressWidthHeight) / 2;
    _progressView.frame = CGRectMake(progressXY, progressXY, progressWidthHeight, progressWidthHeight);
    
    self.type = (NSInteger)self.model.type;
    self.showSelectButton = self.showSelectButton;
}

#pragma mark - /***** Selector Methods *****/

- (void)selectPhotoButtonClick:(UIButton *)button {
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(button.isSelected);
    }
    self.selectImageView.image = button.isSelected ? [UIImage imageNamed:self.photoSelImageName] : [UIImage imageNamed:self.photoDefImageName];
    
    if (button.isSelected) {
        // MARK: - 选中Item大小变化动画
        //[UIView showOscillatoryAnimationWithLayer:self.selectImageView.layer type:SCOscillatoryAnimationTypeToBigger];
        
        //MARK: - 提前获取大图
        [self fetchBigImage];
    } else {
        if (_bigImageRequestID && _progressView) {
            [[PHImageManager defaultManager] cancelImageRequest:_bigImageRequestID];
            [self hideProgressView];
        }
    }
}

@end
