//
//  UIButton+UserInfo.m
//  SEZB
//
//  Created by 寕小陌 on 2017/1/20.
//  Copyright © 2017年 寜小陌. All rights reserved.
//

#import "UIButton+UserInfo.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

static char key;

@implementation UIButton (UserInfo)

- (NSObject *)userid {
    return objc_getAssociatedObject(self, &key);
}

- (void)setUserid:(NSObject *)value {
    objc_setAssociatedObject(self, &key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
