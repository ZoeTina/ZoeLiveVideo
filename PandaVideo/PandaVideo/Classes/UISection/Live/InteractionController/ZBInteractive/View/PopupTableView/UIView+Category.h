//
//  UIView+Category.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapAction)();

@interface UIView (Category)

- (void)tapHandle:(TapAction)block;
- (void)shakeView;
- (void)shakeRotation:(CGFloat)rotation;

@end
