//
//  SCPhotoPreviewItem.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/8/6.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "SCPhotoPreviewItem.h"
#import "SCAssetModel.h"
#import "SCProgressView.h"
#import "SCImageManager.h"
//#import "SCImagePickerController.h"

@implementation SCAssetPreviewItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self prepareSubViews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoPreviewCollectionViewDidScroll) name:@"PhotoPreviewCollectionViewDidScroll" object:nil];
    }
    return self;
}

- (void)prepareSubViews {}

- (void)photoPreviewCollectionViewDidScroll {}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation SCPhotoPreviewItem

- (void)prepareSubViews {
    self.previewView = [[SCPhotoPreviewView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [self.previewView setSingleTapGestureBlock:^{
        if (weakSelf.SingleTapGestureBlock) {
            weakSelf.SingleTapGestureBlock();
        }
    }];
    
    [self.previewView setImageProgressUpdateBlock:^(double progress){
        if (weakSelf.ImageProgressUpdateBlock) {
            weakSelf.ImageProgressUpdateBlock(progress);
        }
    }];
    
    [self addSubview:self.previewView];
}

- (void)setModel:(SCAssetModel *)model {
    [super setModel:model];
    _previewView.asset = model.asset;
}

- (void)recoverSubviews {
    [self.previewView recoverSubViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewView.frame = self.bounds;
}

@end


@interface SCPhotoPreviewView () <UIScrollViewDelegate>

@end

@implementation SCPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.bouncesZoom = YES;
        self.scrollView.maximumZoomScale = 2.5;
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.multipleTouchEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.delaysContentTouches = NO;
        self.scrollView.canCancelContentTouches = YES;
        self.scrollView.alwaysBounceVertical = NO;
        [self addSubview:self.scrollView];
        
        self.imageContainerView = [[UIView alloc] init];
        self.imageContainerView.clipsToBounds = YES;
        self.imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:self.imageContainerView];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.imageContainerView addSubview:self.imageView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        doubleTap.numberOfTapsRequired = 2;
        
        [self addGestureRecognizer:singleTap];
        [self addGestureRecognizer:doubleTap];
        
        [self configProgressView];
    }
    return self;
}

- (void)configProgressView {
    self.progressView = [[SCProgressView alloc] init];
    self.progressView.hidden = YES;
    [self addSubview:self.progressView];
}

- (void)setModel:(SCAssetModel *)model {
    _model = model;
    [_scrollView setZoomScale:1.0 animated:NO];
    if (model.type == AssetModelMediaTypePhotoGif) {
        // 先显示缩略图
        [[SCImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            self.imageView.image = photo;
            [self resizeSubviews];
            
            //gif
            [[SCImageManager manager] getOriginalPhotoDataWithAsset:model.asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
                if (!isDegraded) {
//                    self.imageView.image = [UIImage sc_animatedGIFWithData:data];
                    [self resizeSubviews];
                }
            }];
        } progressHandler:nil networkAccessAllowed:NO];
    } else {
        self.asset = model.asset;
    }
}

- (void)setAsset:(PHAsset *)asset {
    if (_asset && self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
    _asset = asset;
    self.imageRequestID = [[SCImageManager manager] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (![asset isEqual:_asset]) {
            return;
        }
        self.imageView.image = photo;
        [self resizeSubviews];
        _progressView.hidden = YES;
        if (self.ImageProgressUpdateBlock) {
            self.ImageProgressUpdateBlock(1);
        }
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        if (![asset isEqual:_asset]) {
            return;
        }
        _progressView.hidden = NO;
        [self bringSubviewToFront:_progressView];
        progress = progress > 0.02 ? progress : 0.02;
        _progressView.progress = progress;
        if (self.ImageProgressUpdateBlock && progress < 1) {
            self.ImageProgressUpdateBlock(progress);
        }
        
        if (progress >= 1) {
            _progressView.hidden = YES;
            self.imageRequestID = 0;
        }
    } networkAccessAllowed:YES];
}

- (void)setAllowCrop:(BOOL)allowCrop {
    _allowCrop = allowCrop;
    _scrollView.maximumZoomScale = allowCrop ? 4.0 : 2.5;
    
    if ([self.asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)self.asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        
        if (aspectRatio > 1.5) {
            self.scrollView.maximumZoomScale *= aspectRatio / 1.5;
        }
    }
}

- (void)recoverSubViews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
//    self.imageContainerView.sc_origin = CGPointZero;
//    self.imageContainerView.sc_width = self.scrollView.sc_width;
//
//    UIImage *image = self.imageView.image;
//    if (image.size.height / image.size.width > self.sc_height / self.scrollView.sc_width) {
//        self.imageContainerView.sc_height = floor(image.size.height / (image.size.width / self.scrollView.sc_width));
//    } else {
//        CGFloat height = image.size.height / image.size.width * self.scrollView.sc_width;
//        if (height < 1 || isnan(height)) {
//            height = self.sc_height;
//        }
//        height = floor(height);
//        self.imageContainerView.sc_height = height;
//        self.imageContainerView.sc_centerY = self.sc_height / 2;
//    }
//
//    if (self.imageContainerView.sc_height > self.sc_height && self.imageContainerView.sc_height - self.sc_height <= 1) {
//        self.imageContainerView.sc_height = self.sc_height;
//    }
//    CGFloat contentSizeH = MAX(self.imageContainerView.sc_height, self.sc_height);
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.sc_width, contentSizeH);
//    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
//
//    self.scrollView.alwaysBounceVertical = self.imageContainerView.sc_height <= self.sc_height ? NO : YES;
//    self.imageView.frame = self.imageContainerView.bounds;
//
//    [self refreshScrollViewContentSize];
}

- (void)refreshScrollViewContentSize {
    if (_allowCrop) {
        // 裁剪头像需要让图片的任意部分都能在裁剪框内，于是对_scrollView做处理
        // 1. 让contentSize增大(裁剪框右下角的图片部分)
        CGFloat contentWidthAdd = self.scrollView.sc_width - CGRectGetMaxX(_cropRect);
        CGFloat contentHeightAdd = (MIN(_imageContainerView.sc_height, self.sc_height) - self.cropRect.size.height) / 2;
        CGFloat newSizeWidth = self.scrollView.contentSize.width + contentWidthAdd;
        CGFloat newSizeHeight = MAX(self.scrollView.contentSize.height, self.sc_height) + contentHeightAdd;
        
        _scrollView.contentSize = CGSizeMake(newSizeWidth, newSizeHeight);
        _scrollView.alwaysBounceVertical = YES;
        
        // 2. 让scrollView新增欢动区域(裁剪框左上角的图片部分)
        if (contentHeightAdd > 0 || contentWidthAdd > 0) {
            _scrollView.contentInset = UIEdgeInsetsMake(contentHeightAdd, _cropRect.origin.x, 0, 0);
        } else {
            _scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)refreshIMageContainerViewCenter {
    CGFloat offsetX = (self.scrollView.sc_width > self.scrollView.contentSize.width) ? ((self.scrollView.sc_width - self.scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (self.scrollView.sc_height > self.scrollView.contentSize.height) ? ((self.scrollView.sc_height - self.scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX, self.scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(10, 0, self.sc_width - 20, self.sc_height);
    static CGFloat progressWH = 40;
    CGFloat progressX = (self.sc_width - progressWH) / 2;
    CGFloat progressY = (self.sc_height - progressWH) / 2;
    self.progressView.frame = CGRectMake(progressX, progressY, progressWH, progressWH);
    
    [self recoverSubViews];
}

#pragma mark - /***** UITapGestureRecognizer Event *****/

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.SingleTapGestureBlock) {
        self.SingleTapGestureBlock();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale > 1.0) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xSize = self.frame.size.width / newZoomScale;
        CGFloat ySize = self.frame.size.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xSize / 2, touchPoint.y - ySize / 2, xSize, ySize) animated:YES];
    }
}

#pragma mark - /***** UIScrollViewDelegate *****/

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshIMageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self refreshScrollViewContentSize];
}

@end




@implementation SCVideoPreviewItem

- (void)prepareSubViews {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)setModel:(SCAssetModel *)model {
    [super setModel:model];
    [self configMoviePlayer];
}

- (void)configPlayButton {
    if (_playButton) {
        [_playButton removeFromSuperview];
    }
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"disclose_play_btn"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"disclose_play_btn"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playButton];
}

- (void)configMoviePlayer {
    if (_player) {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
        [_player pause];
        _player = nil;
    }
    
    [[SCImageManager manager] getPhotoWithAsset:self.model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        _cover = photo;
    }];
    [[SCImageManager manager] getVideoWithAsset:self.model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _player = [AVPlayer playerWithPlayerItem:playerItem];
            _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
            _playerLayer.frame = self.bounds;
            [self.layer addSublayer:_playerLayer];
            
            [self configPlayButton];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        });
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _playerLayer.frame = self.bounds;
    _playButton.frame = CGRectMake(0, 64, self.sc_width, self.sc_height - 64 - 44);
}

- (void)photoPreviewCollectionViewDidScroll {
    [self pausePlayerAndShowNaviBar];
}

- (void)playButtonAction {
    CMTime currentTime = _player.currentItem.currentTime;
    CMTime durationTime = _player.currentItem.duration;
    
    if (_player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) {
            [_player.currentItem seekToTime:CMTimeMake(0, 1)];
        }
        [_player play];
        [_playButton setImage:nil forState:UIControlStateNormal];
//        if (!SC_isGlobalHideStatusBar) {
//            [UIApplication sharedApplication].statusBarHidden = YES;
//        }
        
        if (self.SingleTapGestureBlock) {
            self.SingleTapGestureBlock();
        }
    } else {
        [self pausePlayerAndShowNaviBar];
    }
}

- (void)pausePlayerAndShowNaviBar {
    if (_player.rate != 0.0) {
        [_player pause];
        [_playButton setImage:[UIImage imageNamed:@"disclose_play_btn"] forState:UIControlStateNormal];
        if (self.SingleTapGestureBlock) {
            self.SingleTapGestureBlock();
        }
    }
}

@end






@implementation SCGifPreviewItem

- (void)prepareSubViews {
    [self configPreviewView];
}

- (void)configPreviewView {
    _previewView = [[SCPhotoPreviewView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [_previewView setSingleTapGestureBlock:^{
        [weakSelf singleTapAction];
    }];
    [self addSubview:_previewView];
}

- (void)setModel:(SCAssetModel *)model {
    [super setModel:model];
    _previewView.model = self.model;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _previewView.frame = self.bounds;
}

- (void)singleTapAction {
    if (self.SingleTapGestureBlock) {
        self.SingleTapGestureBlock();
    }
}

@end
