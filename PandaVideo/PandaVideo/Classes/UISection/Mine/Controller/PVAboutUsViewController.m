//
//  PVAboutUsViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVAboutUsViewController.h"
#import "SCSmallTool.h"

@interface PVAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end

@implementation PVAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topLayout.constant = kNavBarHeight + 47;
    self.scNavigationItem.title = @"关于我们";
    NSString *versionText = [NSString stringWithFormat:@"当前版本%@（已是最新版本）",VERSIONing];
    NSMutableAttributedString *text = [SCSmallTool attributed:versionText color1:[UIColor blackColor] color2:UIColorHexString(0x808080) length:(versionText.length - 9)];
    self.versionLabel.attributedText = text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
