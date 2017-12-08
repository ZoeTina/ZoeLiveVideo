//
//  PVHotCollectionCell.m
//  PandaVideo
//
//  Created by cara on 17/7/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHotCollectionCell.h"

@interface PVHotCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *isHotLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleHotLabel;

@end


@implementation PVHotCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.numberLabel.clipsToBounds = true;
    self.numberLabel.layer.cornerRadius = 7.0f;

}

-(void)setSection:(NSInteger)section{
    _section = section;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(section+1)];
    if (_section == 0) {
        self.numberLabel.backgroundColor = [UIColor sc_colorWithHex:0xFF0000];
    }else if (_section == 1){
        self.numberLabel.backgroundColor = [UIColor sc_colorWithHex:0xF86B08];
    }else if (_section == 2){
        self.numberLabel.backgroundColor = [UIColor sc_colorWithHex:0x00B6E9];
    }else{
        self.numberLabel.backgroundColor = [UIColor sc_colorWithHex:0xD7D7D7];
    }
    
}

-(void)setHotWordModel:(PVHotWord *)hotWordModel{
    _hotWordModel = hotWordModel;
    self.titleHotLabel.text = hotWordModel.hotword;
    if (hotWordModel.tag.length) {
        self.isHotLabel.hidden = false;
        self.isHotLabel.text = [NSString stringWithFormat:@"  %@  ",hotWordModel.tag];
    }else{
        self.isHotLabel.hidden = true;
    }
    
}


- (void)setFrame:(CGRect)frame {
    frame.origin.y += 0.5;
    frame.size.height -= 0.5;
    [super setFrame:frame];
}

@end
