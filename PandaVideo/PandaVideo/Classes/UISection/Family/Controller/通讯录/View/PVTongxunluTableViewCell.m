//
//  PVTongxunluTableViewCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTongxunluTableViewCell.h"
@interface PVTongxunluTableViewCell ()


@end

@implementation PVTongxunluTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 第一种Cell的显示
- (void) showUI1{
    
    self.labelName.hidden = NO;
    self.labelTel.hidden = NO;
    self.inviteBtn.hidden = NO;
    
    self.labelState.hidden = YES;
    self.teleplayIcon.hidden = YES;
    self.labelTels.hidden = YES;
}

// 第二种Cell的显示
- (void) showUI2{
    
    self.labelName.hidden = NO;
    self.labelTel.hidden = NO;
    self.teleplayIcon.hidden = NO;
    self.labelState.hidden = NO;
    
    self.inviteBtn.hidden = YES;
    self.labelTels.hidden = YES;
}

// 第三种Cell的显示
- (void) showUI3{
    
    self.labelName.hidden = YES;
    self.labelTel.hidden = YES;
    self.teleplayIcon.hidden = YES;
    self.inviteBtn.hidden = YES;
    
    self.labelState.hidden = NO;
    self.labelTels.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
