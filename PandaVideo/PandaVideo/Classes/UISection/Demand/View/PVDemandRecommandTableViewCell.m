//
//  PVDemandRecommandTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDemandRecommandTableViewCell.h"

@interface PVDemandRecommandTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *recommandImageView;

@property (weak, nonatomic) IBOutlet UILabel *recommandTtitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *recommandDetailLabel;

@property (weak, nonatomic) IBOutlet UIView *botttomView;

@end



@implementation PVDemandRecommandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];


}

-(void)setSearchVideoListModel:(PVSearchVideoListModel *)searchVideoListModel{
    _searchVideoListModel = searchVideoListModel;
    self.recommandTtitleLabel.text = searchVideoListModel.videoTitle;
    self.recommandDetailLabel.text = searchVideoListModel.videoSubTitle;
    [self.recommandImageView sc_setImageWithUrlString:searchVideoListModel.videoVImage placeholderImage:[UIImage imageNamed:VERTICALMAPBITMAP] isAvatar:false];

}


-(void)setVideoListModel:(PVVideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    self.recommandTtitleLabel.text = videoListModel.info.expand.title;
    self.recommandDetailLabel.text = videoListModel.info.expand.subhead;
    [self.recommandImageView sc_setImageWithUrlString:videoListModel.info.expand.advertiseImageL placeholderImage:[UIImage imageNamed:VERTICALMAPBITMAP] isAvatar:false];

    
}


-(void)setSystemVideoModel:(PVDemandSystemVideoModel *)systemVideoModel{
    _systemVideoModel = systemVideoModel;
    self.recommandTtitleLabel.text = systemVideoModel.videoTitle;
    self.recommandDetailLabel.text = systemVideoModel.videoSubTitle;
    [self.recommandImageView sc_setImageWithUrlString:systemVideoModel.videoVImage placeholderImage:[UIImage imageNamed:VERTICALMAPBITMAP] isAvatar:false];
}


-(void)setIsHiddenView:(BOOL)isHiddenView{
    _isHiddenView = isHiddenView;
    self.botttomView.hidden = isHiddenView;
}

-(void)setIsSearch:(BOOL)isSearch{
    _isSearch = isSearch;
    self.botttomView.hidden = isSearch;
}


- (void)setFrame:(CGRect)frame {
    frame.origin.y += 0;
    [super setFrame:frame];
}

@end
