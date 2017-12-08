//
//  PVSearchBar.m
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSearchBar.h"

@implementation PVSearchBar


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    UIToolbar* bar = [[UIToolbar alloc]  init];
    bar.frame = CGRectMake(0, 0, ScreenWidth, 0);
    self.inputAccessoryView = bar;
    self.font = [UIFont systemFontOfSize:15];
//    self.background = [UIImage imageNamed:@""];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    self.borderStyle = UITextBorderStyleRoundedRect;
    UIImageView *view = [[UIImageView alloc] init];
//    view.image = [UIImage imageNamed:@"搜索栏"];
    view.sc_width = 30;
    view.sc_height = 30;
    view.contentMode = UIViewContentModeCenter;
    self.leftView = view;
    self.leftImageView = view;
    //左边搜索图标总是显示
    self.leftViewMode = UITextFieldViewModeAlways;
}


@end
