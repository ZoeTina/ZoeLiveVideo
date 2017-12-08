//
//  PVLIveViewController.h
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"
#import "PVMenuModel.h"

@interface PVLIveViewController : SCBaseViewController

@property(nonatomic, strong)PVMenuModel* menuModel;

-(void)scrollTelevision;

@end
