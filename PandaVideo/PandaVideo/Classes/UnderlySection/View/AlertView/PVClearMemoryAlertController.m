//
//  PVClearMemoryAlertController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVClearMemoryAlertController.h"

@interface PVClearMemoryAlertController ()
@property (weak, nonatomic) IBOutlet UIView *alertContentView;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (nonatomic, copy) PVClearMemoryAlertBlock alertBlock;
@end

@implementation PVClearMemoryAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
}

- (IBAction)cancleButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)sureButtonClick:(id)sender {
    if (self.alertBlock) {
        self.alertBlock(self);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setPVClearMemoryAlertControllerBlock:(PVClearMemoryAlertBlock)block {
    self.alertBlock = block;
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cancleButton.layer.borderColor = UIColorHexString(0x808080).CGColor;
    self.cancleButton.layer.borderWidth = 1;
    self.cancleButton.layer.masksToBounds = YES;
    self.cancleButton.layer.cornerRadius = self.cancleButton.sc_height / 2.;
    
    self.sureButton.layer.borderColor = UIColorHexString(0x2AB4E4).CGColor;
    self.sureButton.layer.borderWidth = 1;
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = self.sureButton.sc_height / 2.;
    
    self.alertContentView.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
