//
//  UIImage+Blur.h
//  SEZB
//
//  Created by 寕小陌 on 2017/2/16.
//  Copyright © 2017年 寜小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (Blur)

// 0.0 to 1.0
- (UIImage*)blurredImage:(CGFloat)blurAmount;

@end
