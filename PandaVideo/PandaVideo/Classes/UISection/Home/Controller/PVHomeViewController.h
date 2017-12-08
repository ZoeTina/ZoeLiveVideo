//
//  PVHomeViewController.h
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"

@interface PVHomeViewController : SCBaseViewController

@property(nonatomic, assign)BOOL isHiddenTitleView;
@property(nonatomic, copy)NSString* menuUrl;

-(void)scrollColumn:(NSInteger)index;

@end
