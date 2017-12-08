//
//  SCImagePickerVideoController.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/8/5.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "SCImagePickerVideoController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PVDBManager.h"
#import "PVUgcEditVideoViewController.h"
//#import "SCImagePickerController.h"
#import "SCImageManager.h"

@interface SCImagePickerVideoController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) AVURLAsset *urlAsset;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImage *cover;

@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation SCImagePickerVideoController {
    UIStatusBarStyle _statusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self configMoviePlayer];
    [self configVideoPlayer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.popViewblock) {
        self.popViewblock();
    }
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.naviBar.frame = CGRectMake(0, 0, self.view.sc_width, 64);
    self.backButton.frame = CGRectMake(10, 10, 44, 44);
    
    _playerLayer.frame = self.view.bounds;
    _playButton.frame = CGRectMake(0, 64, self.view.sc_width, self.view.sc_height - 64 - 44);
    
    _toolBar.frame = CGRectMake(0, self.view.sc_height - 49, self.view.sc_width, 49);
    _doneButton.frame = CGRectMake(self.view.sc_width - 76 - 10, 10, 76, 30);
}


/**
 * 点击播放视频(videoUrl)
 */
- (void)configVideoPlayer {
    self.urlAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:self.videoUrlString]];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.view.bounds;
    
    [self.view.layer addSublayer:self.playerLayer];
    
    [self configPlayButton];
    [self addProgressObserver];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [_player play];
    [_playButton setImage:nil forState:UIControlStateNormal];
}

/**
 * 照片浏览
 */
- (void)configMoviePlayer {
    [[SCImageManager manager] getPhotoWithAsset:_model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        _cover = photo;
    }];
    [[SCImageManager manager] getVideoWithAsset:_model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _player = [AVPlayer playerWithPlayerItem:playerItem];
            _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            _playerLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:_playerLayer];
            [self addProgressObserver];
            [self configPlayButton];
            [self configCustomNaviBar];
            [self configBottomToolBar];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        });
    }];
}

- (void)addProgressObserver {
    AVPlayerItem *item = _player.currentItem;
    UIProgressView *progressView = _progressView;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([item duration]);
        if (current) {
            [progressView setProgress:current / total animated:YES];
        }
    }];
}

- (void)configPlayButton {
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isImagePickerPreView) {
        [_playButton setImage:[UIImage imageNamed:@"live_play_btn"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    } else {
        [_playButton setImage:nil forState:UIControlStateNormal];
    }
    
    [_playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
}

- (void)configCustomNaviBar {
    
    self.naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    self.naviBar.backgroundColor = [UIColor sc_colorWithHex:0x222222];
    
    self.backButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"点播播放-icon-返回点击状态"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
     [self.naviBar addSubview:self.backButton];
    [self.view addSubview:self.naviBar];
   
}
- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    _toolBar.backgroundColor = [UIColor sc_colorWithHex:0x222222];
    
    if (self.isImagePickerPreView) {
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.doneButton.layer.cornerRadius = 5.0;
        self.doneButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.doneButton setBackgroundColor:[UIColor sc_colorWithHex:0xFF0400]];
        [self.doneButton addTarget:self action:@selector(doneButtonActionClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [_toolBar addSubview:self.doneButton];
    }
    [self.view addSubview:_toolBar];
}

#pragma mark - /***** selector *****/

- (void)backButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pausePlayerAndShowNaviBar {
    if (self.isImagePickerPreView) {
        [_player pause];
        _toolBar.hidden = NO;
        self.naviBar.hidden = NO;
        [_playButton setImage:[UIImage imageNamed:@"live_play_btn"] forState:UIControlStateNormal];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)playButtonAction {
    CMTime currentTime = _player.currentItem.currentTime;
    CMTime durationTime = _player.currentItem.duration;
    if (_player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) [_player.currentItem seekToTime:CMTimeMake(0, 1)];
        [_player play];
        [self.navigationController setNavigationBarHidden:YES];
        _toolBar.hidden = YES;
        self.naviBar.hidden = YES;
        [_playButton setImage:nil forState:UIControlStateNormal];
    } else {
        [self pausePlayerAndShowNaviBar];
    }
}

- (void)doneButtonActionClicked {
    NSArray *assetArray = [[PVDBManager sharedInstance] selectShortVideoModelAllData];
    for (SCAssetModel *assetModel in assetArray) {
        if ([assetModel.videoPublishState isEqualToString:@"0"] || [assetModel.videoPublishState isEqualToString:@"2"]) {
            Toast(@"有视频正在上传，请稍后");
            return;
        }
    }
    
   
    PVUgcEditVideoViewController *videoCon = [[PVUgcEditVideoViewController alloc] init];
    videoCon.editUgcModel = self.ugcModel;
    [[SCImageManager manager] getPhotoWithAsset:_model.asset photoWidth:kDistanceWidthRatio(250) completion:^(UIImage *photoImage, NSDictionary *info, BOOL isDegraded) {
        _model.corverImage = photoImage;
        videoCon.assetModel = _model;
    }];
    
    //    [[PVProgressHUD shared] showHudInView:self.view];
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [[PVProgressHUD shared] showHudInView:self.view];
    [manager requestAVAssetForVideo:_model.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        
        NSURL *url = urlAsset.URL;
        NSNumber *fileSizeValue = nil;
        [url getResourceValue:&fileSizeValue forKey:NSURLFileSizeKey error:nil];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        CGFloat size = data.length / 1024. / 1024.;
        if (size > self.ugcModel.videoSize) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[PVProgressHUD shared] hideHudInView:self.view];
                Toast(@"视频大小超出限制");
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                PV(pv);
                [[PVProgressHUD shared] hideHudInView:self.view];
                [pv.navigationController pushViewController:videoCon animated:YES];
            });
            
        }
    }];
}

- (void)itemDelegateMethod {
//    SCImagePickerController *imagePickerController = (SCImagePickerController *)self.navigationController;
//    if ([imagePickerController.pickerDelegate respondsToSelector:@selector(sc_imagePickerController:didFinishPickingVideo:sourceAssets:)]) {
//        [imagePickerController.pickerDelegate sc_imagePickerController:imagePickerController didFinishPickingVideo:_cover sourceAssets:_model.asset];
//    }
//    if (imagePickerController.didFinishPickingVideoHandle) {
//        imagePickerController.didFinishPickingVideoHandle(_cover,_model.asset);
//    }
}

@end
