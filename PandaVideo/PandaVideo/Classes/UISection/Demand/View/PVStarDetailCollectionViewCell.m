//
//  PVStarDetailCollectionViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVStarDetailCollectionViewCell.h"

@interface PVStarDetailCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;

@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *videoTextLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoImageViewHeightConstaint;

@end



@implementation PVStarDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.videoImageView.image = [UIImage imageNamed:@"1.jpg"];
}

-(void)setType:(NSInteger)type{
    _type = type;
    CGFloat height = self.sc_width*98/174;
    if (type == 2) {
        height = self.sc_width*4/3;
    }
    self.videoImageViewHeightConstaint.constant = height;
    
    [self layoutIfNeeded];
}

-(void)setVideoListModel:(PVVideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    NSString* image = @"";
    NSString* imagePlaceOlder = @"";
    if (self.type == 1){//横图
        image = videoListModel.info.expand.advertiseImageL;
        imagePlaceOlder = VERTICALMAPBITMAP;
    }else if (self.type == 2){//竖图
        image = videoListModel.info.expand.advertiseImageH;
        imagePlaceOlder = CROSSMAPBITMAP;
    }
    [self.videoImageView sc_setImageWithUrlString:image placeholderImage:[UIImage imageNamed:imagePlaceOlder] isAvatar:false];
    self.videoTitleLabel.text = videoListModel.info.expand.title;
    self.videoTextLabel.text = videoListModel.info.expand.subhead;
}

@end
