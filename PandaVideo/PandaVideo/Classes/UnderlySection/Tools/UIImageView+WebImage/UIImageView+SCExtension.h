//
//  UIImageView+SCExtension.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/7/5.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (SCExtension)

/**
 * 设置头像图像
 */
- (void)sc_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage isAvatar:(BOOL)isAvatar;

@end
