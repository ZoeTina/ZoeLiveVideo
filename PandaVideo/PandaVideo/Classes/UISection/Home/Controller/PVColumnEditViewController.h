//
//  PVColumnEditViewController.h
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"

typedef void(^PVColumnEditViewControllerBlock)(NSArray* columnDataSource,NSInteger selectedIndex);

@interface PVColumnEditViewController : SCBaseViewController

@property(nonatomic,copy)PVColumnEditViewControllerBlock columnEditViewControllerBlock;
@property(nonatomic,strong)NSArray* dataSource;

@end
