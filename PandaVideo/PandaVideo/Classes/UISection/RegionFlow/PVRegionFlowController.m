//
//  PVRegionFlowController.m
//  PandaVideo
//
//  Created by cara on 17/9/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRegionFlowController.h"

@interface PVRegionFlowController ()


@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIButton *temporarilyBtn;

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@property (weak, nonatomic) IBOutlet UIButton *knowBtn;

@property (weak, nonatomic) IBOutlet UILabel *reminderTitleLabel;

@property (nonatomic, copy) NSString* reminderTitle;

//0.是否已经打开定位, 1.是否在四川省内, 2.是否为数据流量
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, copy)PVRegionFlowControllerCallBlock callBlock;

@end

@implementation PVRegionFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    self.containerView.clipsToBounds = true;
    self.containerView.layer.cornerRadius = 5.0f;
    self.temporarilyBtn.clipsToBounds = self.continueBtn.clipsToBounds = self.knowBtn.clipsToBounds = true;
    self.temporarilyBtn.layer.cornerRadius =  self.continueBtn.layer.cornerRadius =  self.knowBtn.layer.cornerRadius = 20.0f;
    self.temporarilyBtn.layer.borderWidth =  self.continueBtn.layer.borderWidth = self.knowBtn.layer.borderWidth = 1.0f;
    self.continueBtn.layer.borderColor = self.knowBtn.layer.borderColor = [UIColor sc_colorWithHex:0x00B6E9].CGColor;
    self.temporarilyBtn.layer.borderColor = [UIColor sc_colorWithHex:0x00B6E9].CGColor;
    
    if (self.type == 0) {
        self.knowBtn.hidden = true;
        self.temporarilyBtn.hidden = self.continueBtn.hidden = false;
        [self.continueBtn setTitle:@"设置" forState:UIControlStateNormal];
    }else if (self.type == 1) {
        self.knowBtn.hidden = false;
        self.temporarilyBtn.hidden = self.continueBtn.hidden = true;
        [self.continueBtn setTitle:@"继续" forState:UIControlStateNormal];
    }else{
        self.knowBtn.hidden = true;
        self.temporarilyBtn.hidden = self.continueBtn.hidden = false;
    }
    if (self.type == 2){
        self.reminderTitleLabel.textAlignment = NSTextAlignmentLeft;
        NSString *labelText = self.reminderTitle;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        self.reminderTitleLabel.attributedText = attributedString;
    }else{
        self.reminderTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.reminderTitleLabel.text = self.reminderTitle;
    }
    
}

+(PVRegionFlowController*)presentPVRegionFlowController:(NSString*)reminderTitle type:(NSInteger)type{
    PVRegionFlowController* vc = [[PVRegionFlowController alloc]  init];
    vc.reminderTitle = reminderTitle;
    vc.type = type;
    dispatch_async(dispatch_get_main_queue(), ^{
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [PresentModelVC presentViewController:vc animated:false completion:nil];
    });
    return vc;
}
-(void)setPVRegionFlowControllerCallBlock:(PVRegionFlowControllerCallBlock)block{
    self.callBlock = block;
}
- (IBAction)temporarilyBtnClicked {
    if (self.callBlock && self.type == 2){
        self.callBlock(self.type, true);
    }
    self.view.hidden = true;
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)continueBtnClicked {
//    if (self.type == 2) {
//        [self temporarilyBtnClicked];
//    }
    if (self.callBlock) {
        self.callBlock(self.type, false);
    }
    self.view.hidden = true;
    [self dismissViewControllerAnimated:false completion:nil];
}
- (IBAction)knowBtnClicked {
    [self temporarilyBtnClicked];
}
- (IBAction)coverBtnClicked {
}
@end
