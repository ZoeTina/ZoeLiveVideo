//
//  PVNoticeInfoDetailViewController.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"

typedef void(^PVNoticeDetailBlock)(id sender);

@interface PVNoticeInfoDetailViewController : SCBaseViewController

- (void)setPVNoticeDetailBlock:(PVNoticeDetailBlock)block;
@end
