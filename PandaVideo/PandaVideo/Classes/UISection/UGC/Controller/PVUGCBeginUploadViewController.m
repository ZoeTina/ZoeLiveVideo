//
//  PVUGCBeginUploadViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUGCBeginUploadViewController.h"
#import "PVUgcHtmlViewController.h"
#import "PVUploadProgressViewController.h"

@interface PVUGCBeginUploadViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backHomeButton;
@property (weak, nonatomic) IBOutlet UIButton *lookUploadProgressButton;

@end

@implementation PVUGCBeginUploadViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scNavigationBar.hidden = YES;
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.scNavigationBar.hidden = NO;
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)backUGCHomeButtonClick:(id)sender {
    
    PVUgcHtmlViewController *homeVC = [[PVUgcHtmlViewController alloc] init];
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[homeVC class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }
    
}

- (IBAction)lookUploadProgressButtonClick:(id)sender {
    PVUploadProgressViewController *con = [[PVUploadProgressViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.backHomeButton.layer.masksToBounds = YES;
    self.backHomeButton.layer.cornerRadius = self.backHomeButton.sc_height / 2.;
    self.backHomeButton.layer.borderWidth = 1;
    self.backHomeButton.layer.borderColor = UIColorHexString(0xDA5955).CGColor;
    
    self.lookUploadProgressButton.layer.masksToBounds = YES;
    self.lookUploadProgressButton.layer.cornerRadius = self.lookUploadProgressButton.sc_height / 2.0;
    self.lookUploadProgressButton.layer.borderColor = UIColorHexString(0xDA5955).CGColor;
    self.lookUploadProgressButton.layer.borderWidth = 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
