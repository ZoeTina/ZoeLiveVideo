//
//  PVSearchResultCell.m
//  PandaVideo
//
//  Created by cara on 17/8/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSearchResultCell.h"

@interface PVSearchResultCell()

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoRightTopImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoStarLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaAndYearLabel;
@property (weak, nonatomic) IBOutlet UIButton *televesionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topLeftImageView;
@property (weak, nonatomic) IBOutlet UILabel *topRightLabel;
@property (weak, nonatomic) IBOutlet UIView *bootomRightView;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bootomRightViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *iphoneBtn;

//tv播放
- (IBAction)playToTV:(UIButton *)button;
//云添加播放
- (IBAction)TVCloudToPlay:(UIButton *)button;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoStarTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoInfoTopConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoAreaTopConstraint;


@end


@implementation PVSearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.videoImageView.image = [UIImage imageNamed:CROSSMAPBITMAP];
    
}

- (void)setModel:(PVSearchVideoListModel *)model{

    [self.videoImageView sc_setImageWithUrlString:model.videoVImage placeholderImage:[UIImage imageNamed:CROSSMAPBITMAP] isAvatar:NO];
    self.videoTitleLabel.text = model.videoTitle;
    self.videoStarLabel.text = model.actors;
    self.videoInfoLabel.text = model.tagType;
    NSString* text = model.area;
    if (model.area.length && model.year.length) {
        text = [NSString stringWithFormat:@"%@/%@",model.area,model.year];
    }else if (model.area.length == 0){
        text = model.year;
    }
    self.areaAndYearLabel.text = text;
    if(model.isTvSource){
        self.televesionBtn.hidden = false;
    }else{
        self.televesionBtn.hidden = true;
    }
    if (model.isMoblieSource) {
        self.iphoneBtn.hidden = false;
    }else{
        self.iphoneBtn.hidden = true;
    }
    if (model.tagData.topLeftCornerModel.tagImage.length) {
        self.topLeftImageView.hidden = false;
        [self.topLeftImageView sc_setImageWithUrlString:model.tagData.topLeftCornerModel.tagImage placeholderImage:nil isAvatar:false];
    }else{
        self.topLeftImageView.hidden = true;
    }
    if (model.tagData.topRightCornerModel.tagName.length) {
        self.topRightLabel.hidden = false;
        self.topRightLabel.backgroundColor = [UIColor hexStringToColor:model.tagData.topRightCornerModel.tagColor];
        CGFloat fontSize = 12;
        self.topRightLabel.font = [UIFont systemFontOfSize:fontSize];
        self.topRightLabel.text = [NSString stringWithFormat:@"%@   ",model.tagData.topRightCornerModel.tagName];
    }else{
        self.topRightLabel.hidden = true;
    }
    if (model.tagData.bottomRightCornerModel.tagName.length) {
        self.bootomRightView.hidden = false;
        CGFloat fontSize = 12;
        CGSize size =  [UILabel messageBodyText:model.tagData.bottomRightCornerModel.tagName andSyFontofSize:fontSize andLabelwith:200 andLabelheight:fontSize];
        self.bootomRightViewWidthConstraint.constant = size.width + 5;
        self.bottomRightLabel.font = [UIFont systemFontOfSize:fontSize];
        self.bottomRightLabel.text = model.tagData.bottomRightCornerModel.tagName;
    }else{
        self.bootomRightView.hidden = true;
    }
    
    if (model.actors.length) {
        self.videoStarTopConstraint.constant = 10;
    }else{
        self.videoStarTopConstraint.constant = 0;
    }
    if (model.tagType.length) {
        self.videoInfoTopConstaint.constant = 10;
    }else{
        self.videoInfoTopConstaint.constant = 0;
    }
    if (text.length) {
        self.videoAreaTopConstraint.constant = 10;
    }else{
        self.videoAreaTopConstraint.constant = 0;
    }
}
- (IBAction)televesionBtnClicked {
}

//tv播放
- (IBAction)playToTV:(UIButton *)button{
    if (self.playTVBlock) {
        self.playTVBlock();
    }
}
//云添加播放
- (IBAction)TVCloudToPlay:(UIButton *)button{
    if (self.addCloudBlock) {
        self.addCloudBlock(button);
    }
}
@end
