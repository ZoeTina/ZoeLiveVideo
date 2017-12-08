//
//  PVFamilyCircleAlertControlelr.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVAlertModel.h"

typedef void(^AlertViewEventBlock)(id sender);


@interface PVFamilyCircleAlertControlelr : UIViewController


- (instancetype)initAlertViewModel:(PVAlertModel *)alertModel;

- (void)setAlertCancleEventBlock:(AlertViewEventBlock)cancleBlock;
- (void)setAlertViewSureEventBlock:(AlertViewEventBlock)eventBlock;

@end
