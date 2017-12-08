//
//  PVShowShareView.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVShowShareView : UIView
//加载xib
+ (PVShowShareView *)loadXibView;

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view;
- (void)disMissView;
@end
