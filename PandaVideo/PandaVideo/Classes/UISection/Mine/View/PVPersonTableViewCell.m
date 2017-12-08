//
//  PVPersonTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPersonTableViewCell.h"

@interface PVPersonTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end


@implementation PVPersonTableViewCell

-(void)setPersonModel:(PVPersonModel *)personModel{
    _personModel = personModel;
    self.titleLabel.text = personModel.title;
    self.leftImageView.image = [UIImage imageNamed:personModel.imageText];
    
    if (personModel.index == 3) {
        self.bottomView.hidden = true;
    }else{
        self.bottomView.hidden = false;
    }
    
    
}

@end
