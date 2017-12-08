//
//  PVHomeInterractionCell.m
//  PandaVideo
//
//  Created by cara on 17/8/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHomeInterractionCell.h"


@interface PVHomeInterractionCell()

@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *middleTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;

@end
@implementation PVHomeInterractionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftTimeLabel.clipsToBounds = self.middleTimeLabel.clipsToBounds = self.rightTimeLabel.clipsToBounds = true;
    self.leftTimeLabel.layer.cornerRadius = self.middleTimeLabel.layer.cornerRadius = self.rightTimeLabel.layer.cornerRadius = 3.0f;
    
}

@end
