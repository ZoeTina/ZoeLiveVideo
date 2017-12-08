//
//  PVUploadProgressCell.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUploadProgressCell.h"
#import "PVUploadCellSmallView.h"

@interface PVUploadProgressCell ()
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoPubTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *faileImageView;
@property (weak, nonatomic) IBOutlet UILabel *faileStateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoImageLeftConstraint;
@property (nonatomic, strong) PVUploadCellSmallView *processingView;
@property (nonatomic, strong) PVUploadCellSmallView *uploadingView;
@property (nonatomic, strong) PVUploadCellSmallView *failedUploadView;
@property (nonatomic, strong) PVUploadCellSmallView *rePublishViewView;
@end

@implementation PVUploadProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.videoImageView addSubview:self.processingView];
    [self.videoImageView addSubview:self.uploadingView];
    [self.videoImageView addSubview:self.rePublishViewView];
    [self.videoImageView addSubview:self.failedUploadView];
    
    UIView *layerView = [[UIView alloc] init];
    layerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.videoImageView insertSubview:layerView belowSubview:self.processingView];
    [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
    
    [self.processingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.videoImageView).mas_offset(0);
    }];
    [self.uploadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.videoImageView).mas_offset(0);
    }];
    [self.failedUploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.videoImageView).mas_offset(0);
    }];
    [self.rePublishViewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.videoImageView).mas_offset(0);
    }];
}

- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    if (_isShow) {
        self.videoImageLeftConstraint.constant = 13;
        self.deleteBtn.hidden = NO;
    }else {
        self.videoImageLeftConstraint.constant = -20;
        self.deleteBtn.hidden = YES;
    }
}

- (void)setAssetModel:(SCAssetModel *)assetModel {
    _assetModel = assetModel;
    [self layoutCell];
}

- (IBAction)deleteBtnClick:(id)sender {
    self.deleteBtn.selected = !self.deleteBtn.selected;
    if (self.block) {
        self.block(self.deleteBtn);
    }
}

/** 视频上传状态， 0:压缩中，1:压缩失败，2:上传中，3:封面图上传失败，4.封面图上传成功，视频上传失败 5:视频上传成功，但是其他视频信息上传失败,6:上传成功*/
- (void)layoutCell {
    
    if (self.assetModel.isDelete == NO) {
        self.deleteBtn.selected = NO;
    }else {
        self.deleteBtn.selected = YES;
    }
    
    self.videoImageView.image = [UIImage imageWithData:self.assetModel.corverImageData];
    self.videoTitleLabel.text = self.assetModel.videoTitle;
    self.videoPubTimeLabel.text = [[NSDate sc_dateFromString:self.assetModel.publishTime withFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:@"MM-dd HH:mm"];
    self.faileImageView.hidden = YES;
    self.faileStateLabel.hidden = YES;
    NSInteger state = self.assetModel.videoPublishState.integerValue;
    
    switch (state) {
            
        case 0:{
//            PVUploadCellSmallView *processingView = [[PVUploadCellSmallView alloc] initUploadStateViewWithProcessing];
//            [self.videoImageView addSubview:processingView];
//            [processingView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.top.bottom.equalTo(self.videoImageView).mas_offset(0);
//            }];
            self.processingView.hidden = NO;
            self.uploadingView.hidden = YES;
            self.rePublishViewView.hidden = YES;
            self.failedUploadView.hidden = YES;
            break;
        }
            
        case 1:{
            self.faileImageView.hidden = NO;
            self.faileStateLabel.hidden = NO;
            self.faileStateLabel.text = @"视频处理失败";
            
            self.processingView.hidden = YES;
            self.uploadingView.hidden = YES;
            self.rePublishViewView.hidden = NO;
            self.failedUploadView.hidden = YES;
        }
        case 2:{
//            PVUploadCellSmallView *processingView = [[PVUploadCellSmallView alloc] initUploadStateViewWithUploading];
//            [self.videoImageView addSubview:processingView];
//            [processingView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.top.bottom.equalTo(self.videoImageView).mas_offset(0);
//            }];
            self.processingView.hidden = YES;
            self.uploadingView.hidden = NO;
            self.rePublishViewView.hidden = YES;
            self.failedUploadView.hidden = YES;
            break;
        }
        case 3:{
//            PVUploadCellSmallView *processingView = [[PVUploadCellSmallView alloc] initUploadStateViewWithRePublish];
//            [self.videoImageView addSubview:processingView];
            self.faileImageView.hidden = NO;
            self.faileStateLabel.hidden = NO;
            self.faileStateLabel.text = @"视频上传失败";
//            [processingView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.top.bottom.equalTo(self.videoImageView).mas_offset(0);
//            }];
            self.processingView.hidden = YES;
            self.uploadingView.hidden = YES;
            self.rePublishViewView.hidden = NO;
            self.failedUploadView.hidden = YES;
            break;
            
        }
        case 4:
        {
//            PVUploadCellSmallView *processingView = [[PVUploadCellSmallView alloc] initUploadStateViewWithRePublish];
//            [self.videoImageView addSubview:processingView];
            self.faileImageView.hidden = NO;
            self.faileStateLabel.hidden = NO;
            self.faileStateLabel.text = @"视频上传失败";
//            [processingView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.top.bottom.equalTo(self.videoImageView).mas_offset(0);
//            }];
            self.processingView.hidden = YES;
            self.uploadingView.hidden = YES;
            self.rePublishViewView.hidden = NO;
            self.failedUploadView.hidden = YES;
            break;
        }
            
        case 5:
        {
//            PVUploadCellSmallView *processingView = [[PVUploadCellSmallView alloc] initUploadStateViewWithRePublish];
//            [self.videoImageView addSubview:processingView];
            self.faileImageView.hidden = NO;
            self.faileStateLabel.hidden = NO;
            self.faileStateLabel.text = @"视频上传失败";
//            [processingView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.top.bottom.equalTo(self.videoImageView).mas_offset(0);
//            }];
            self.processingView.hidden = YES;
            self.uploadingView.hidden = YES;
            self.rePublishViewView.hidden = NO;
            self.failedUploadView.hidden = YES;
            break;
        }
            
        case 6:
        {
            break;
        }
        case 7:{
            self.faileImageView.hidden = NO;
            self.faileStateLabel.hidden = NO;
            self.faileStateLabel.text = @"找不到视频源";
            //            [processingView mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.left.right.top.bottom.equalTo(self.videoImageView).mas_offset(0);
            //            }];
            self.processingView.hidden = YES;
            self.uploadingView.hidden = YES;
            self.rePublishViewView.hidden = YES;
            self.failedUploadView.hidden = NO;
            break;
        }
        default:
            break;
    }
}

- (void)setPVUploadProgressCellBlock:(PVUploadProgressCellBlock)block {
    self.block = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (PVUploadCellSmallView *)processingView {
    if (!_processingView) {
        _processingView = [[PVUploadCellSmallView alloc] initUploadStateViewWithProcessing];
        
    }
    return _processingView;
}

- (PVUploadCellSmallView *)uploadingView {
    if (!_uploadingView) {
        _uploadingView = [[PVUploadCellSmallView alloc] initUploadStateViewWithUploading];
    }
    return _uploadingView;
}

- (PVUploadCellSmallView *)rePublishViewView {
    if (!_rePublishViewView) {
        _rePublishViewView = [[PVUploadCellSmallView alloc] initUploadStateViewWithRePublish];
    }
    return _rePublishViewView;
}

- (PVUploadCellSmallView *)failedUploadView {
    if (!_failedUploadView) {
        _failedUploadView = [[PVUploadCellSmallView alloc] initUploadStateViewWithFailure];
    }
    return _failedUploadView;
}
@end
