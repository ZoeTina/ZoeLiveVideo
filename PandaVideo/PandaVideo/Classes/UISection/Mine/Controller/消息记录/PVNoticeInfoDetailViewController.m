//
//  PVNoticeInfoDetailViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVNoticeInfoDetailViewController.h"

@interface PVNoticeInfoDetailViewController ()
@property (nonatomic, copy) PVNoticeDetailBlock noticeBlock;
@end

@implementation PVNoticeInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.scNavigationItem.title = @"通知";
    [self setLeftNavBarItemWithImage:@"all_btn_back_grey"];
}

- (void)setPVNoticeDetailBlock:(PVNoticeDetailBlock)block {
    self.noticeBlock = block;
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"通知";
    self.automaticallyAdjustsScrollViewInsets = false;
}
- (void)leftItemClick:(UIButton *)sender {
    
    if (self.noticeBlock) {
        self.noticeBlock(self);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
