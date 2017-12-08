//
//  PVClearMemoryAlertController.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PVClearMemoryAlertBlock)(id sender);

@interface PVClearMemoryAlertController : UIViewController
- (void)setPVClearMemoryAlertControllerBlock:(PVClearMemoryAlertBlock)block;
@end
