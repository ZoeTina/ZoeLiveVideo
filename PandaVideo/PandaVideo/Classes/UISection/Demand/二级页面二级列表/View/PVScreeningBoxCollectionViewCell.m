//
//  PVScreeningBoxCollectionViewCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/10/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVScreeningBoxCollectionViewCell.h"

@interface PVScreeningBoxCollectionViewCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonHeightConstaint;

@end

@implementation PVScreeningBoxCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = kColorWithRGB(42, 180, 228).CGColor;
    self.layer.borderWidth = 0;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textBtn.userInteractionEnabled = NO;
}

- (void)setKeyModel:(KeyModel *)keyModel{
    
    _keyModel = keyModel;
    [self.textBtn setTitle:keyModel.name forState:UIControlStateNormal];
    if (keyModel.isSelect) {
        self.textBtn.layer.masksToBounds = YES;
        self.textBtn.layer.cornerRadius = self.textBtn.sc_height/2;
        self.textBtn.layer.borderWidth = 0.5;
        self.textBtn.layer.borderColor = kColorWithRGB(42, 180, 228).CGColor;
    }else{
        self.textBtn.layer.masksToBounds = YES;
        self.textBtn.layer.cornerRadius = self.textBtn.sc_height/2;
        self.textBtn.layer.borderWidth = 0;
        self.textBtn.layer.borderColor = kColorWithRGB(42, 180, 228).CGColor;
    }
}

@end
