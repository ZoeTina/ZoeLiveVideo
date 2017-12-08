//
//  PVTimeTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTimeTableViewCell.h"

@interface PVTimeTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end


@implementation PVTimeTableViewCell

-(void)setTimeString:(NSString *)timeString{    
    _timeString = timeString;
    self.timeLabel.text = timeString;
}

-(void)setAreaModel:(PVLiveTelevisionAreaModel *)areaModel{
    self.timeLabel.text = areaModel.stationName;
    if (areaModel.isSelected) {
        self.timeLabel.textColor = self.lineView.backgroundColor = [UIColor sc_colorWithHex:0x00B6E9];
    }else{
        self.lineView.backgroundColor = [UIColor sc_colorWithHex:0xd7d7d7];
        self.timeLabel.textColor = [UIColor sc_colorWithHex:0x808080];
    }
}

-(void)setProGramModel:(PVLiveTelevisionProGramModel *)proGramModel{
    self.timeLabel.text = proGramModel.dateString;
    if (proGramModel.type == 1) {
        self.timeLabel.text = @"今天";
    }else if (proGramModel.type == 2){
        self.timeLabel.text = @"昨天";
    }
    if (proGramModel.isSelected) {
         self.timeLabel.textColor = self.lineView.backgroundColor = [UIColor sc_colorWithHex:0x00B6E9];
    }else{
        self.lineView.backgroundColor = [UIColor sc_colorWithHex:0xd7d7d7];
        self.timeLabel.textColor = [UIColor sc_colorWithHex:0x808080];
    }
    
}


@end
