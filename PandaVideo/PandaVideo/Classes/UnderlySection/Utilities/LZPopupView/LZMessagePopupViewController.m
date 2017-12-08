//
//  LZMessagePopupViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "LZMessagePopupViewController.h"

@interface LZMessagePopupViewController ()

@property (strong, nonatomic) IBOutlet UIButton *iconBtn;           // 按钮(好)

@property (strong, nonatomic) IBOutlet UIView *btnContainerView;    // 两个按钮的容器按钮(好)

@property (strong, nonatomic) IBOutlet UIButton *completeBtn;       // 按钮(好)
@property (strong, nonatomic) IBOutlet UIButton *suspendBtn;        // 按钮(暂停)
@property (strong, nonatomic) IBOutlet UIButton *updateBtn;         // 按钮(立即更新)

@property (strong, nonatomic) IBOutlet UILabel  *titlelabel;        // 标题名字
@property (strong, nonatomic) IBOutlet UILabel  *messagelabel;      // 消息内容

@end

@implementation LZMessagePopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 重设View的frame及其圆角
    self.view.frame = CGRectMake(AUTOLAYOUTSIZE((YYScreenWidth - 235)/2), 0, AUTOLAYOUTSIZE(235), AUTOLAYOUTSIZE(255));
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 12.0;
    
    self.titlelabel.text = self.titleStr;
    self.messagelabel.text = self.messageStr;

    [self.iconBtn setImage:self.imageBtn forState:UIControlStateNormal];
    switch (self.lzViewType) {
        case LZViewTypeLocation:
            
            [self showLocationView];
            break;
        case LZViewTypeUpdate:
            
            [self showUpdateView];
            break;
        case LZViewTypeNotice:
            
            [self showNoticeView];
            break;
        default:
            break;
    }
}


/** 显示位置授权view */
- (void) showLocationView{
    self.btnContainerView.hidden = YES;
    self.messagelabel.textAlignment = NSTextAlignmentCenter;
}

/** 显示位置授权view */
- (void) showUpdateView{
    self.completeBtn.hidden = YES;
}

/** 显示位置授权view */
- (void) showNoticeView{
    self.btnContainerView.hidden = YES;
}

// 关闭按钮
- (IBAction)closePopupView:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}

// 去报名按钮
- (IBAction)dismissedPopupView:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissedButtonClicked:)]) {
        [self.delegate dismissedButtonClicked:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
