//
//  PVHistorySearchCell.m
//  PandaVideo
//
//  Created by cara on 17/7/10.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHistorySearchCell.h"

@implementation PVHistorySearchCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    self.nameLabel = [[UILabel alloc]  init];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = [UIColor sc_colorWithHex:0x000000];
    [self addSubview:self.nameLabel];
    self.nameLabel.text = [NSString stringWithFormat:@"多少"];
    self.backgroundColor = [UIColor sc_colorWithHex:0xF2F2F2];

}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.nameLabel.frame = self.bounds;
    self.layer.cornerRadius = self.sc_height*0.5;
}


@end
