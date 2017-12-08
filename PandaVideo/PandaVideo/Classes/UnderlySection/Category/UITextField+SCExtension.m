//
//  UITextField+SCExtension.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/27.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "UITextField+SCExtension.h"

@implementation UITextField (SCExtension)

+ (instancetype)sc_textFieldWithPlaceHolder:(NSString *)placeHolder {
    
    UITextField *textField = [[self alloc] init];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = placeHolder;
    
    return textField;
}


@end
