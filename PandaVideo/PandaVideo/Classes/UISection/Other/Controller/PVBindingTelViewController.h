//
//  PVBindingTelViewController.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/30.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCBaseViewController.h"

typedef void(^BindSuccessBlock)(BOOL bindIsSuccess);

@interface PVBindingTelViewController : SCBaseViewController

- (void)setBindSuccessBlock:(BindSuccessBlock)block;

@property (nonatomic, strong) NSMutableDictionary *parameterDict;
@end
