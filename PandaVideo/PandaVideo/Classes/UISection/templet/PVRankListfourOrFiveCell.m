//
//  PVRankListfourOrFiveCell.m
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRankListfourOrFiveCell.h"

@interface PVRankListfourOrFiveCell()
@property (weak, nonatomic) IBOutlet UILabel *rankListnumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *rankListTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *rankListDetailTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end

@implementation PVRankListfourOrFiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setIndex:(NSInteger)index{
    _index = index;
    self.rankListnumberLabel.text = [NSString stringWithFormat:@"%ld",index+1];
    if (index == 3) {
        self.bottomView.hidden = false;
    }else{
        self.bottomView.hidden = true;
    }
}

-(void)setVideoListModel:(PVVideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    self.rankListTitleLabel.text = videoListModel.info.expand.title;
    self.rankListDetailTitleLabel.text = videoListModel.info.expand.subhead;
}

@end
