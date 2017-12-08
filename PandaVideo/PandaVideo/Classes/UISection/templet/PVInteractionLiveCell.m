//
//  PVInteractionLiveCell.m
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInteractionLiveCell.h"

@interface PVInteractionLiveCell()

@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
///1:预告，2:直播, 3:回看
@property (weak, nonatomic) IBOutlet UILabel *liveStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *liveStatusView;

@property (weak, nonatomic) IBOutlet UIImageView *liveStatusImageView;


@end


@implementation PVInteractionLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.liveStatusView.clipsToBounds = true;
    self.liveStatusView.layer.cornerRadius = 3.5f;
    self.liveStatusView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.liveStatusView.layer.borderWidth = 1.0f;
    self.liveStatusImageView.userInteractionEnabled = true;
    self.liveStatusImageView.clipsToBounds = true;
    self.liveStatusImageView.layer.cornerRadius = 10.0f;
}

-(void)setVideoListModel:(PVVideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    [self.liveImageView sc_setImageWithUrlString:videoListModel.info.expand.advertiseImageL placeholderImage:[UIImage imageNamed:BIGBITMAP] isAvatar:false];
    self.titleLabel.text = videoListModel.info.expand.title;
    if (videoListModel.info.expand.liveStatus.intValue == 0) {
        self.liveStatusLabel.text = @"预告";
        self.liveStatusView.backgroundColor = [UIColor redColor];
         self.countLabel.text = [NSString stringWithFormat:@"直播时间：%@",videoListModel.info.expand.startTime];
    }else if (videoListModel.info.expand.liveStatus.intValue == 1){
        self.liveStatusLabel.text = @"直播";
        self.liveStatusView.backgroundColor = [UIColor sc_colorWithHex:0x2AB4E4];
         self.countLabel.text = [NSString stringWithFormat:@"%@人在看",videoListModel.info.expand.liveCount];
    }else if (videoListModel.info.expand.liveStatus.intValue == 2){
        self.liveStatusLabel.text = @"回看";
        self.liveStatusView.backgroundColor = [UIColor sc_colorWithHex:0xFF8C46];
         self.countLabel.text = [NSString stringWithFormat:@"%@人在看",videoListModel.info.expand.liveCount];
    }
    
    
    
}


@end
