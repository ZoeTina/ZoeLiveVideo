//
//  PVVideoDetailTempletCell.m
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoDetailTempletCell.h"


@interface PVVideoDetailTempletCell()

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;

@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBootmWidthContsaint;

@end


@implementation PVVideoDetailTempletCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


-(void)setVideoListModel:(PVVideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    [self.videoImageView sc_setImageWithUrlString:videoListModel.info.expand.advertiseImageH placeholderImage:[UIImage imageNamed:CROSSMAPBITMAP] isAvatar:false];
    self.videoTitleLabel.text = videoListModel.info.expand.title;
    self.videoSubTitleLabel.text = videoListModel.info.expand.subhead;
    
    if (videoListModel.info.expand.topLeftCornerModel.tagImage.length) {
        self.leftTopImageView .hidden = false;
        [self.leftTopImageView sc_setImageWithUrlString:videoListModel.info.expand.topLeftCornerModel.tagImage placeholderImage:nil isAvatar:false];
    }else{
        self.leftTopImageView.hidden = true;
    }
    if (videoListModel.info.expand.topRightCornerModel.tagName.length) {
        self.rightTopLabel.hidden = false;
        self.rightTopLabel.backgroundColor = [UIColor hexStringToColor:videoListModel.info.expand.topRightCornerModel.tagColor];
        CGFloat fontSize = 11;
        self.rightTopLabel.font = [UIFont systemFontOfSize:fontSize];
        self.rightTopLabel.text = [NSString stringWithFormat:@"%@   ",videoListModel.info.expand.topRightCornerModel.tagName];
    }else{
        self.rightTopLabel.hidden = true;
    }
    if (videoListModel.info.expand.bottomRightCornerModel.tagName.length) {
        self.rightBottomLabel.hidden = false;
        self.rightBottomView.hidden = false;
        CGFloat fontSize = 11;
        CGSize size =  [UILabel messageBodyText:videoListModel.info.expand.bottomRightCornerModel.tagName andSyFontofSize:fontSize andLabelwith:200 andLabelheight:fontSize];
        self.rightBootmWidthContsaint.constant = size.width + 5;
        self.rightBottomLabel.font = [UIFont systemFontOfSize:fontSize];
        self.rightBottomLabel.text = videoListModel.info.expand.bottomRightCornerModel.tagName;
    }else{
        self.rightBottomView.hidden = true;
    }
}

@end
