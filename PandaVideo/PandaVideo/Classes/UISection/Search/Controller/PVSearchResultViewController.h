//
//  PVSearchResultViewController.h
//  PandaVideo
//
//  Created by cara on 17/8/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVVideoListModel.h"

@interface PVSearchResultViewController : UIViewController

@property(nonatomic, strong)UINavigationController* nav;
@property(nonatomic,assign)BOOL isFamily; //是否家庭圈
@property(nonatomic,copy)NSString *targetPhone;
-(void)reloadSearchresultData:(NSArray *)dataSource;

@end
