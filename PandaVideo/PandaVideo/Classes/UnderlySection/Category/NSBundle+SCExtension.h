//
//  NSBundle+SCExtension.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/20.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (SCExtension)

/// 当前版本号字符串
+ (nullable NSString *)sc_currentVersion;

/// 与当前屏幕尺寸匹配的启动图像
+ (nullable UIImage *)sc_launchImage;

/// 取BundleName
+ (nullable NSString *)sc_namespace;

@end
