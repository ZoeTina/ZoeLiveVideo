//
//  PVVideoInformationTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/2.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoInformationTableViewCell.h"
#import "NSString+SCExtension.h"

@interface PVVideoInformationTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *videoNickName;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UIButton *viodeDetailBtn;
@property (weak, nonatomic) IBOutlet UIView *videoDetailInfo;
@property (weak, nonatomic) IBOutlet UILabel *updateNumber;
@property (weak, nonatomic) IBOutlet UILabel *videoYear;
@property (weak, nonatomic) IBOutlet UILabel *videoStar;
@property (weak, nonatomic) IBOutlet UILabel *videoText;
@property (weak, nonatomic) IBOutlet UIButton *commentNumber;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *storeVideo;
@property (weak, nonatomic) IBOutlet UIButton *collectVideo;
@property (weak, nonatomic) IBOutlet UIImageView *videoActivity;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateNumberTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoYearTopConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoStarTopConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoTextTopConstaint;



@property (nonatomic, copy) VideoDetailBtnClickedBlock videoDetailBlock;
@property (nonatomic, copy) CommentBtnClickedBlock commentBlock;
@property (nonatomic, copy) StoreBtnClickedBlock storeBlock;
@property (nonatomic, copy) ShareBtnClickedBlock shareBlock;
@property (nonatomic, copy) CollectBtnClickedBlock collectlBlock;

@end

@implementation PVVideoInformationTableViewCell


-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.videoNickName.font =  [UIFont fontWithName:FontBlod size:15];
}


-(void)setVideoDetailModel1:(PVDemandVideoDetailModel *)videoDetailModel1{
    _videoDetailModel1 = videoDetailModel1;
    if (videoDetailModel1.favoriteState.length) {
        self.collectVideo.selected = !videoDetailModel1.favoriteState.intValue;
    }
    if (videoDetailModel1.commentCount == nil) {
        videoDetailModel1.commentCount = @"0";
    }
    NSString* title = [NSString stringWithFormat:@"  %@",[videoDetailModel1.commentCount transformationStringToSimplify]];
    if ([title rangeOfString:@"null"].location == NSNotFound) {
        [self.commentNumber setTitle:title forState:UIControlStateNormal];
    }
    if (videoDetailModel1.playNum == nil) {
        videoDetailModel1.playNum = @"0";
    }
    NSString* playNum = [NSString stringWithFormat:@"播放次数  %@",[videoDetailModel1.playNum transformationStringToSimplify]];
    if ([playNum rangeOfString:@"null"].location == NSNotFound) {
        self.playCount.text = playNum;
    }

}

-(void)setVideoDetailModel:(PVDemandVideoDetailModel *)videoDetailModel{
    _videoDetailModel = videoDetailModel;
    self.videoDetailInfo.hidden = !videoDetailModel.isShowVideoDetail;
    self.viodeDetailBtn.selected = videoDetailModel.isShowVideoDetail;
    self.updateNumberTopConstraint.constant = videoDetailModel.videoDescription.updateMsg.length ? 10.0 : 0;
    self.videoYearTopConstaint.constant = (videoDetailModel.videoDescription.year.length || videoDetailModel.videoDescription.area.length || videoDetailModel.videoDescription.type.length) ? 10.0 : 0;
    self.videoStarTopConstaint.constant = videoDetailModel.videoDescription.actors.length ? 10.0 : 0;
    self.videoTextTopConstaint.constant = videoDetailModel.videoSubTitle.length ? 10.0 : 0;
    
    self.videoNickName.text = videoDetailModel.videoTitle;
    self.updateNumber.text = videoDetailModel.videoDescription.updateMsg;
    self.videoYear.text = [NSString stringWithFormat:@"%@   %@   %@年",videoDetailModel.videoDescription.type,videoDetailModel.videoDescription.area,videoDetailModel.videoDescription.year];
    self.videoStar.text = videoDetailModel.videoDescription.actors;
    self.videoText.text = videoDetailModel.videoSubTitle;
}

- (IBAction)videoDetailBtnClicked {
    if (self.videoDetailBlock) {
        self.videoDetailBlock(self.viodeDetailBtn);
    }
}

- (IBAction)commentBtnClicked:(UIButton *)sender {
    if (self.commentBlock) {
        self.commentBlock(sender);
    }
}
- (IBAction)shareBtnClicked:(id)sender {
    if (self.shareBlock) {
        self.shareBlock(sender);
    }
}
- (IBAction)storeBtnClicked {
    if (self.storeBlock) {
        self.storeBlock(self.storeVideo);
    }
    
}
- (IBAction)collectBtnClicked {
    if (self.collectlBlock) {
        self.collectlBlock(self.collectVideo);
    }
}

-(void)setVideoDetailBtnClickedBlock:(VideoDetailBtnClickedBlock)block{
    self.videoDetailBlock = block;
}
-(void)setCommentBtnClickedBlock:(CommentBtnClickedBlock)block{
    self.commentBlock = block;
}
-(void)setShareBtnClickedBlock:(ShareBtnClickedBlock)block{
    self.shareBlock = block;
}
-(void)setStoreBtnClickedBlock:(StoreBtnClickedBlock)block{
    self.storeBlock = block;
}
-(void)setCollectBtnClickedBlock:(CollectBtnClickedBlock)block{
    self.collectlBlock = block;
}


@end
