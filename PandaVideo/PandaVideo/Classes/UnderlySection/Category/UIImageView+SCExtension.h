//
//  UIImageView+SCExtension.h
//  PandaVideo
//
//  Created by songxf on 2017/11/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (SCExtension)

- (void)sc_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage isAvatar:(BOOL)isAvatar;
@end
