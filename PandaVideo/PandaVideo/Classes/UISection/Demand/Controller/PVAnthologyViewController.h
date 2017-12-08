//
//  PVAnthologyViewController.h
//  PandaVideo
//
//  Created by cara on 17/8/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PVAnthologyViewControllerCallBlock)(NSInteger index);


@interface PVAnthologyViewController : UIViewController

@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, assign)NSInteger type;
@property(nonatomic, strong)NSArray* anthologyDatasource;


-(void)setPVAnthologyViewControllerCallBlock:(PVAnthologyViewControllerCallBlock)block;

@end
