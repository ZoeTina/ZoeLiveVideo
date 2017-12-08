//
//  PVVideoMoreView.h
//  VideoDemo
//
//  Created by cara on 17/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCButton.h"

typedef void(^PVVideoMoreViewCallBlock)(void);

@interface PVVideoMoreView : UIView

//收藏按钮
@property(nonatomic, strong)SCButton* collectBtn;

@property(nonatomic, assign)BOOL isCollect;


-(void)setPVVideoMoreViewCallBlock:(PVVideoMoreViewCallBlock)block;

@end
