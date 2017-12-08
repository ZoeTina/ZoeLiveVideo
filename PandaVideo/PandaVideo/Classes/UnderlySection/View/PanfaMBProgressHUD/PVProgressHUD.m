//
//  PVProgressHUDView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVProgressHUD.h"

@interface PVProgressHUD ()
@property (nonatomic, strong) UIView *loadView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *windowView;
@end

@implementation PVProgressHUD

static PVProgressHUD *pvHud = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pvHud = [[PVProgressHUD alloc] init];
    });
    return pvHud;
}

- (void)showHudInView:(UIView *)view {

    [view addSubview:self.loadView];
    [self.hud showAnimated:YES];
}


- (void)hideHudInView:(UIView *)view {
    [self.hud hideAnimated:YES];
    [self.loadView removeFromSuperview];
}

- (void)showHudInWindow:(UIView *)view {
    
    [view addSubview:self.windowView];
    [self.hud showAnimated:YES];
}

- (void)hideHudInWindow:(UIView *)view {
    [self.hud hideAnimated:YES];
    [self.windowView removeFromSuperview];
}

- (UIView *)loadView {
    if (!_loadView) {
        _loadView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight)];
        _loadView.backgroundColor = [UIColor clearColor];
        _loadView.userInteractionEnabled = NO;
        [_loadView addSubview:self.hud];
        [self.hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_loadView.mas_centerX);
            make.centerY.mas_equalTo(_loadView.mas_centerY);
        }];
    }
    return _loadView;
}

- (UIView *)windowView {
    if (!_windowView) {
        _windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _windowView.backgroundColor = [UIColor clearColor];
        _windowView.userInteractionEnabled = YES;
        [_windowView addSubview:self.hud];
        [self.hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_windowView.mas_centerX);
            make.centerY.mas_equalTo(_windowView.mas_centerY);
        }];
    }
    return _windowView;
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.loadView];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.userInteractionEnabled = NO;
    }
    return _hud;
}
@end
