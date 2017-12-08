//
//  PVOrderCenterHeaderView.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Login = 0,
    Purchase,
    RepeatOrder,
    LookOrderHistory,
} OrderCenterHeaderViewEevent;

typedef void(^PVOrderCenterHeaderViewBlock)(id sender);
@interface PVOrderCenterHeaderView : UIView

- (void)setPVOrderCenterHeaderViewBlock:(PVOrderCenterHeaderViewBlock)block;

- (void)initSubView;
- (instancetype)initOrderCenterViewWithFrame:(CGRect)frame;
@end
