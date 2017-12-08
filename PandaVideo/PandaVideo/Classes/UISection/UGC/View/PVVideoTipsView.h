//
//  PVVideoTipsView.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVVideoTipsView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (nonatomic, copy) NSString *tipsText;
- (instancetype)initUGCTipsViewWithFrame:(CGRect)frame;
@end
