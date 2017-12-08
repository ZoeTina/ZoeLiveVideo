//
//  UIView+SCFactory.m
//  SiChuanFocus
//
//  Created by xiangjf on 2017/6/16.
//  Copyright © 2017年 Zcy. All rights reserved.
//

#import "UIView+SCFactory.h"

@implementation UIView (SCFactory)

//UILabel
+ (id)createLabel {
    return [UIView createLabelWithFrame:CGRectZero];
}

+(id)createLabelWithFrame:(CGRect)frame {
    return [UIView createLabelWithFrame:frame text:@"" textColor:[UIColor blackColor] font:15 textAlignment:NSTextAlignmentLeft];
}

+(id)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color font:(CGFloat)font textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = alignment;
    [label setFont:[UIFont systemFontOfSizeAdapter:font]];
    label.textColor = color;
    label.text = text;
    return label;
}

//UITextField
+ (id)createTextField {
    return [UIView createTextFieldWithStyle:UITextBorderStyleRoundedRect];
}
+ (id)createTextFieldWithStyle:(UITextBorderStyle)style {
    return [UIView createTextFieldWithFrame:CGRectZero borderStyle:style];
}

+ (id)createTextFieldWithFrame:(CGRect)frame borderStyle:(UITextBorderStyle)style {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = [UIColor blackColor];
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = style;
    return textField;
}

//UIButton
+ (id)createButtonWithFrame:(CGRect)frame {
    return [UIView createButtonWithFrame:frame type:UIButtonTypeRoundedRect];
}

+ (id)createButtonWithFrame:(CGRect)frame type:(UIButtonType)type {
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = frame;
    return button;
}

+ (id)createButtonWithFrame:(CGRect)frame target:(id)target action:(SEL)action {
    return [UIView createButton:frame target:target action:action buttonType:UIButtonTypeRoundedRect title:@"" titleColor:[UIColor blackColor]];
}

+ (id)createButton:(CGRect)frame target:(id)target action:(SEL)action buttonType:(UIButtonType)type title:(NSString *)title titleColor:(UIColor *)titleColor{
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)createButton:(CGRect)frame target:(id)target action:(SEL)action buttonType:(UIButtonType)type normalImage:(NSString *)normalImage {
    return [UIView createButton:frame target:target action:action buttonType:type normalImage:normalImage selectImage:nil];
}

+ (id)createButton:(CGRect)frame target:(id)target action:(SEL)action buttonType:(UIButtonType)type normalImage:(NSString *)normalImage selectImage:(NSString *)selectImage {
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = frame;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setContentMode:UIViewContentModeScaleAspectFit];
    if (normalImage && normalImage.length > 0) {
        [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    }
    if (selectImage && selectImage.length > 0) {
        [button setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    }
    
    return button;
}

//UITableView
+ (id)createTableView:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource {
    return [UIView createTableViewWithFrame:CGRectZero delegate:delegate dataSource:dataSource style:UITableViewStyleGrouped];
}

+ (id)createTableView:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource style:(UITableViewStyle)style {
    return [UIView createTableViewWithFrame:CGRectZero delegate:delegate dataSource:dataSource style:style];
}

+ (id)createTableView:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource frame:(CGRect)frame {
    return [UIView createTableViewWithFrame:frame delegate:delegate dataSource:dataSource style:UITableViewStyleGrouped];
}

+ (id)createTableViewWithFrame:(CGRect)frame delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource style:(UITableViewStyle)style {
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.delegate = delegate;
    tableView.dataSource = dataSource;
    return tableView;
}


@end
