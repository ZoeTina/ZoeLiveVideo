//
//  PVDemandViewController.h
//  PandaVideo
//
//  Created by cara on 17/8/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseVideoPlayToolController.h"

@interface PVDemandViewController : SCBaseVideoPlayToolController

@property(nonatomic, copy)NSString* code;
@property(nonatomic, copy)NSString* url;
@property(nonatomic, copy)NSString* continuePlayVideoSecond;
///是否需要滚
@property(nonatomic, assign)BOOL isScroll;

@end
