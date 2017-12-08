//
//  PVTipsPopoverView.m
//  PandaVideo
//
//  Created by Ensem on 2017/11/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTipsPopoverView.h"

@interface PVTipsPopoverView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGFloat    viewHeight;
@property (nonatomic, assign) CGFloat    viewWidth;
@property (nonatomic, assign) CGFloat    viewY;
@property (nonatomic, assign) CGFloat    viewX;
@property (nonatomic, strong) IBOutlet UIButton *firstBtn;    // 左边按钮
@property (nonatomic, strong) IBOutlet UIButton *lastBtn;    // 右边按钮
@property(nonatomic,assign)BOOL isWindow;
//@property (nonatomic, strong) PVTipsPopoverView *showTipsView;
@end

@implementation PVTipsPopoverView


#define kViewHeight AUTOLAYOUTSIZE(180)
#define kViewWidth  AUTOLAYOUTSIZE(352)
#define kViewY      (kScreenHeight - kViewHeight)/2
#define kViewX      (kScreenWidth - kViewWidth)/2

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
}


- (IBAction)onShowPopoerButtonClick:(UIButton *)sender {
    if (self.jumpCallBlock) {
        self.jumpCallBlock(2);
    }
}
- (IBAction)onShowButtonClick:(UIButton *)sender {
    if (self.jumpCallBlock) {
        self.jumpCallBlock(1);
    }
}



//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
    if (!view) return;
    self.isWindow = YES;
    [view addSubview:self.coverView];
    self.coverView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    self.coverView.hidden = YES;
    [view addSubview:self];
    
    [self setFrame:CGRectMake(kViewX, ScreenHeight, kViewWidth, kViewHeight)];
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0;
        self.coverView.hidden = NO;
        [self setFrame:CGRectMake(kViewX, kViewY, kViewWidth, kViewHeight)];
        self.coverView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    } completion:nil];
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showNoWindowInView:(UIView *)view
{
    if (!view) return;
    self.isWindow = NO;
    [view addSubview:self.coverView];
    self.coverView.frame = CGRectMake(0, CrossScreenWidth, CrossScreenHeight, CrossScreenWidth);
    self.coverView.hidden = YES;
    [view addSubview:self];
    
    [self setFrame:CGRectMake((CrossScreenHeight - 352)/2, CrossScreenWidth, 352, 180)];
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0;
        self.coverView.hidden = NO;
        [self setFrame:CGRectMake((CrossScreenHeight - 352)/2, (CrossScreenWidth - 180)/2, 352, 180)];
        self.coverView.frame = CGRectMake(0, 0, CrossScreenHeight, CrossScreenWidth);
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    if (!self.isWindow) {
        if (self.jumpCallBlock) {
            self.jumpCallBlock(1);
        }
        return;
    }
    [self setFrame:CGRectMake(kViewX, kViewY ,kViewWidth, kViewHeight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0.0;
                         self.coverView.hidden = YES;
                         [self setFrame:CGRectMake(kViewX, kScreenHeight, kViewWidth, kViewHeight)];
                         [self.coverView setFrame:CGRectMake(kViewX, kScreenHeight, kScreenWidth, kScreenHeight)];
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [self removeFromSuperview];
                     }];
}

- (UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return _coverView;
}
@end
