//
//  LZSearchBar.m
//  PandaVideo
//
//  Created by Ensem on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "LZSearchBar.h"

@implementation LZSearchBar
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [self initView];
    }
    return self;
}

- (id)initWithCoder: (NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        self = [self initView];
    }
    return self;
}

- (id)initView {
    self.backgroundColor = kColorWithRGB(215, 215, 215);
    self.placeholder = @"搜索";
    self.keyboardType = UIKeyboardTypeDefault;
    self.showsCancelButton = NO;
    // 删除UISearchBar中的UISearchBarBackground
    [self setBackgroundImage:[[UIImage alloc] init]];
//    self.tintColor = kColorWithRGB(211, 0, 0);
//    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
    
    // 改变提示文字颜色
//    UITextField *textField = [self valueForKey:@"searchField"]; //首先取出textfield
//    textField.textColor = [UIColor blueColor]; //输入的颜色
//    UILabel *placeHolder = [textField valueForKey:@"placeholderLabel"]; //然后取出textField的placeHolder
//    placeHolder.textColor = [UIColor redColor]; //改变颜色
    return self;
}

@end
