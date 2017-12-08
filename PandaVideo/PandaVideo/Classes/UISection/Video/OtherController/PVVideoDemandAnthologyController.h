//
//  PVVideoDemandAnthologyController.h
//  PandaVideo
//
//  Created by cara on 17/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PVVideoDemandAnthologyControllerBlock)(NSInteger index);


@interface PVVideoDemandAnthologyController : UIViewController

@property(nonatomic, assign)NSInteger index;
@property(nonatomic, assign)NSInteger type;
@property(nonatomic, strong)NSArray* anthologyDataSource;

-(void)setPVVideoDemandAnthologyControllerBlock:(PVVideoDemandAnthologyControllerBlock)block;


@end
