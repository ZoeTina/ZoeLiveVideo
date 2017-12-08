//
//  PVTeleplayCollectionViewCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTeleplayCollectionViewCell.h"

@interface PVTeleplayCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *teleplayTitle;   // 电视剧标题
@property (nonatomic, weak) IBOutlet UILabel *teleplaysynopsis;// 电视剧简介
@property (nonatomic, weak) IBOutlet UIImageView *videoImageView;  // 电视剧封面图
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *videoImageViewHeightConstaint;

@end

@implementation PVTeleplayCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) setTitle:(NSString *)title{

//    _teleplayTitle.text = [NSString stringWithFormat:@"%@(%@)",_teleplayTitle.text,title];
}

// 显示模板类型(17.横图，18.竖图)
-(void)setModelType:(NSInteger)modelType{
    _modelType = modelType;
    CGFloat height = self.sc_width*98/174;
    if (modelType == 18) {
        height = self.sc_width*4/3;
    }
    self.videoImageViewHeightConstaint.constant = height;
    [self layoutIfNeeded];
}

-(void)setVideoListModel:(PVVideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    NSString* image = @"";
    NSString* imagePlaceOlder = @"";
    
    if (self.modelType == 17){//横图
        image = videoListModel.info.expand.advertiseImageL;
        imagePlaceOlder = VERTICALMAPBITMAP;
    }else if (self.modelType == 18){//竖图
        image = videoListModel.info.expand.advertiseImageH;
        imagePlaceOlder = CROSSMAPBITMAP;
    }
    
    [self.videoImageView sc_setImageWithUrlString:image placeholderImage:[UIImage imageNamed:imagePlaceOlder] isAvatar:false];
    self.teleplayTitle.text = videoListModel.info.expand.title;
    self.teleplaysynopsis.text = videoListModel.info.expand.subhead;
    if (videoListModel.info.expand.subhead.length > 0) {
        self.teleplayTitle.numberOfLines = 1;
    }else{
        self.teleplayTitle.numberOfLines = 2;
    }
}

- (void)setModel:(PVVideoSiftingListModel *)model{
    _model = model;
    self.teleplayTitle.text = model.videoTitle;
    self.teleplaysynopsis.text = model.videoSubTitle;
    NSString* image = @"";
    NSString* imagePlaceOlder = @"";
//    if (self.modelType == 17){//横图
        image = model.videoVImage;
        imagePlaceOlder = VERTICALMAPBITMAP;
//    }else if (self.modelType == 18){//竖图
//        image = videoListModel.info.expand.advertiseImageH;
//        imagePlaceOlder = CROSSMAPBITMAP;
//    }
    [self.videoImageView sc_setImageWithUrlString:image placeholderImage:[UIImage imageNamed:imagePlaceOlder] isAvatar:false];

}
//<PVVideoSiftingListModel: 0x600002c7d3c0> {
//    code = "d8a8c13c-873f-46bf-80ae-63e23ef7b92a";
//    tagData = <PVVideoSiftingListTagDataModel: 0x600000006330>;
//    videoSubTitle = "没有大学的成才路";
//    videoTitle = "告别高三";
//    videoType = 0;
//    videoUrl = "http://pandafile.sctv.com:42086/content/video/2017/11/27/20000002000000030000000003884399.json";
//    videoVImage = "http://pandafile.sctv.com:42086/Images/2017/11/27/20171127155331511omshqgzuvm.jpg"
//}

@end
