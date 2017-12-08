//
//  PVShakeSleepView.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShakeSleepViewCancleBlock)(id sender);

@interface PVShakeSleepView : UIView
- (instancetype)initShakeSleepView;
- (void)ShakeSleepViewCancle:(ShakeSleepViewCancleBlock)cancleBlock;
@end
