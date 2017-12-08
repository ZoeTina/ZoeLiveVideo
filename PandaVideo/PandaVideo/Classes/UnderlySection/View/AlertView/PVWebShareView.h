//
//  PVWebShareView.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVShareViewController.h"

@interface PVWebShareView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, strong) PVShareModel *shareModel;

@end
