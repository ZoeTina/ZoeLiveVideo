//
//  UIView+SCFactory.h
//  SiChuanFocus
//
//  Created by xiangjf on 2017/6/16.
//  Copyright © 2017年 Zcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SCFactory)

//UILabel
+ (id)createLabel;
+(id)createLabelWithFrame:(CGRect)frame;
+(id)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color font:(CGFloat)font textAlignment:(NSTextAlignment)alignment;

//UITextField
+ (id)createTextField;
+ (id)createTextFieldWithStyle:(UITextBorderStyle)style;
+ (id)createTextFieldWithFrame:(CGRect)frame borderStyle:(UITextBorderStyle)style;

//UIButton
+ (id)createButtonWithFrame:(CGRect)frame;
+ (id)createButtonWithFrame:(CGRect)frame type:(UIButtonType)type;
+ (id)createButtonWithFrame:(CGRect)frame target:(id)target action:(SEL)action;
+ (id)createButton:(CGRect)frame target:(id)target action:(SEL)action buttonType:(UIButtonType)type title:(NSString *)title titleColor:(UIColor *)titleColor;
+ (id)createButton:(CGRect)frame target:(id)target action:(SEL)action buttonType:(UIButtonType)type normalImage:(NSString *)normalImage;
+ (id)createButton:(CGRect)frame target:(id)target action:(SEL)action buttonType:(UIButtonType)type normalImage:(NSString *)normalImage selectImage:(NSString *)selectImage;
//UITableView
+ (id)createTableView:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource;
+ (id)createTableView:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource style:(UITableViewStyle)style;
+ (id)createTableView:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource frame:(CGRect)frame;
+ (id)createTableViewWithFrame:(CGRect)frame delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource style:(UITableViewStyle)style;
@end
