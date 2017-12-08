//
//  PVLoginViewController.h
//  PandaVideo
//
//  Created by xiangjf on 2017/9/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"

typedef void(^PVLoginViewControllerLoginSuccess)(void);


@interface PVLoginViewController : SCBaseViewController


-(void)setPVLoginViewControllerLoginSuccess:(PVLoginViewControllerLoginSuccess)block;


@end
