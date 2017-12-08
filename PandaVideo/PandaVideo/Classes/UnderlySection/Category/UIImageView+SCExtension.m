//
//  UIImageView+SCExtension.m
//  PandaVideo
//
//  Created by songxf on 2017/11/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "UIImageView+SCExtension.h"

@implementation UIImageView (SCExtension)


- (void)sc_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage isAvatar:(BOOL)isAvatar{
    
    if (isAvatar) {
        placeholderImage = [placeholderImage sc_avatarImage:self.bounds.size backColor:[UIColor whiteColor] borderColor:[UIColor whiteColor]];
    }
    // 处理Url
    if (urlString.length < 1) {
        self.image = placeholderImage;
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    SDWebImageOptions imageOption = SDWebImageLowPriority;
    if (isAvatar) {
        imageOption = SDWebImageRetryFailed;
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:[urlString sc_urlString]] placeholderImage:placeholderImage options:imageOption completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image == nil) {
            weakSelf.image = placeholderImage;
            return;
        }
        // 设置头像
        if (isAvatar) {
            if (!image) {
                weakSelf.image = placeholderImage;
            } else {
                weakSelf.image = [image sc_avatarImage:self.bounds.size backColor:[UIColor whiteColor] borderColor:[UIColor whiteColor]];
            }
        }
    }];
}

@end
