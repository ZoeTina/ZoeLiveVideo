//
//  PVRegionFlowController.h
//  PandaVideo
//
//  Created by cara on 17/9/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PVRegionFlowControllerCallBlock)(NSInteger type, BOOL isStop);

@interface PVRegionFlowController : UIViewController

+(PVRegionFlowController*)presentPVRegionFlowController:(NSString*)reminderTitle type:(NSInteger)type;

-(void)setPVRegionFlowControllerCallBlock:(PVRegionFlowControllerCallBlock)block;

@end
