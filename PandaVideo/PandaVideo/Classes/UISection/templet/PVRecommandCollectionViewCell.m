//
//  PVRecommandCollectionViewCell.m
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRecommandCollectionViewCell.h"

@interface PVRecommandCollectionViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBootmWidthContsaint;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImageView;
@property (weak, nonatomic) IBOutlet UIView *rightBottomView;

@property (weak, nonatomic) IBOutlet UIImageView *recomandInageView;

@property (weak, nonatomic) IBOutlet UIImageView *leftTopImageView;

@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftBottomLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sbstractLabel;

///照片的高约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recomandInageViewHeightConstraint;

///活动模版专有的照片
@property (weak, nonatomic) IBOutlet UIImageView *activityTimeImageView;

///活动角标
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@end


@implementation PVRecommandCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code    
   // CGAffineTransform rotation = CGAffineTransformMakeRotation(-M_PI_4);
//    [self.leftTopLabel setTransform:rotation];
//
    self.activityImageView.clipsToBounds = true;
    self.activityImageView.layer.cornerRadius = 10;
    
}

-(void)setSpecialTopicModel:(PVSpecialTopicModel *)specialTopicModel{
    _specialTopicModel = specialTopicModel;
    self.titleLabel.text = specialTopicModel.topicTitle;
    self.sbstractLabel.text = specialTopicModel.topicSubTitle;
    [self.recomandInageView sc_setImageWithUrlString:specialTopicModel.topicImage placeholderImage:[UIImage imageNamed:BIGBITMAP] isAvatar:false];
}


-(void)setIsSpecial:(BOOL)isSpecial{
    _isSpecial = isSpecial;
    if (self.isSpecial) {
       self.leftBottomLabel.hidden = self.leftTopImageView.hidden = self.rightTopLabel.hidden = self.rightBottomLabel.hidden = true;
    }
    
}

-(void)setType:(NSInteger)type{
    _type = type;
    CGFloat height = self.sc_width*9/16;
    if (type == 3) {
        height = self.sc_width*4/3;
    }
    self.recomandInageViewHeightConstraint.constant = height;
    [self layoutIfNeeded];
}

-(void)setVideoListModel:(PVVideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    NSString* image = @"";
    NSString* imagePlaceOlder = @"";
    if (self.type == 0) {//大图
        image = videoListModel.info.expand.advertiseImageL;
        imagePlaceOlder = BIGBITMAP;
    }else if (self.type == 1){//横图
        image = videoListModel.info.expand.advertiseImageL;
        imagePlaceOlder = VERTICALMAPBITMAP;
    }else if (self.type == 3){//竖图
        image = videoListModel.info.expand.advertiseImageH;
        imagePlaceOlder = CROSSMAPBITMAP;
    }

    [self.recomandInageView sc_setImageWithUrlString:image placeholderImage:[UIImage imageNamed:imagePlaceOlder] isAvatar:false];

    
    
    if (videoListModel.info.expand.topLeftCornerModel.tagImage.length) {
        self.leftTopImageView .hidden = false;
        [self.leftTopImageView sc_setImageWithUrlString:videoListModel.info.expand.topLeftCornerModel.tagImage placeholderImage:nil isAvatar:false];
    }else{
        self.leftTopImageView.hidden = true;
    }
    
    if (videoListModel.info.expand.topRightCornerModel.tagName.length) {
        self.rightTopLabel.hidden = false;
        self.rightTopLabel.backgroundColor = [UIColor hexStringToColor:videoListModel.info.expand.topRightCornerModel.tagColor];
        CGFloat fontSize = 12;
        if (self.type == 0) {
            fontSize = 14;
        }
        self.rightTopLabel.font = [UIFont systemFontOfSize:fontSize];
        self.rightTopLabel.text = [NSString stringWithFormat:@"%@   ",videoListModel.info.expand.topRightCornerModel.tagName];
    }else{
        self.rightTopLabel.hidden = true;
    }
    
    if (videoListModel.info.expand.bottomRightCornerModel.tagName.length) {
        self.rightBottomLabel.hidden = false;
        self.rightBottomView.hidden = false;
        CGFloat fontSize = 12;
        if (self.type == 0) {
            fontSize = 14;
        }
        CGSize size =  [UILabel messageBodyText:videoListModel.info.expand.bottomRightCornerModel.tagName andSyFontofSize:fontSize andLabelwith:200 andLabelheight:fontSize];
        self.rightBootmWidthContsaint.constant = size.width + 5;
        self.rightBottomLabel.font = [UIFont systemFontOfSize:fontSize];
        self.rightBottomLabel.text = videoListModel.info.expand.bottomRightCornerModel.tagName;
//        self.rightBottomLabel.backgroundColor = [UIColor hexStringToColor:videoListModel.info.expand.bottomRightCornerModel.tagColor];
    }else{
        self.rightBottomView.hidden = true;
    }
    if (videoListModel.info.expand.title.length) {
        self.titleLabel.hidden = false;
        self.titleLabel.text = videoListModel.info.expand.title;
    }else{
        self.titleLabel.hidden = true;
    }
    self.activityView.hidden = true;
    if (self.modelType == 7) {
        self.leftTopImageView.hidden = self.rightTopLabel.hidden = self.rightBottomLabel.hidden = true;
        self.sbstractLabel.text = [NSString stringWithFormat:@"%@  至  %@",videoListModel.info.expand.actStartTime,videoListModel.info.expand.actEndTime];
        [self activityStatus:videoListModel];
    }else{
        if (videoListModel.info.expand.subhead.length) {
            self.sbstractLabel.hidden = false;
            self.sbstractLabel.text = videoListModel.info.expand.subhead;
            self.titleLabel.numberOfLines = 1;
        }else{
            self.sbstractLabel.hidden = true;
            self.titleLabel.numberOfLines = 2;
        }
    }
    if (self.modelType == 8) {
        self.leftTopImageView.hidden = self.rightBottomLabel.hidden = true;
        self.rightTopLabel.hidden = false;
        self.rightTopLabel.text = @"广告";
        self.rightTopLabel.backgroundColor = [UIColor blackColor];
    }
    
}

-(void)activityStatus:(PVVideoListModel*)videoListModel{
    NSString* actStartTime = videoListModel.info.expand.actStartTime;
    NSString* actEndTime = videoListModel.info.expand.actEndTime;
    NSTimeInterval actStart = [NSDate PVDateToTimeStamp:[NSDate PVDateStringToDate:actStartTime formatter:@"YYYY-MM-dd HH:mm:ss"] format:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval actEnd = [NSDate PVDateToTimeStamp:[NSDate PVDateStringToDate:actEndTime formatter:@"YYYY-MM-dd HH:mm:ss"] format:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval nowTime = [NSDate PVDateToTimeStamp:[NSDate date] format:@"YYYY-MM-dd HH:mm:ss"];
    if (actStart<nowTime && nowTime< actEnd){
        self.activityView.hidden = false;
        self.activityLabel.text = @"进行中";
    }
}



@end
