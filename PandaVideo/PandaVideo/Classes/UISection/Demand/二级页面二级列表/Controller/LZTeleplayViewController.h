//
//  LZTeleplayViewController.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVChoiceSecondColumnModel.h"

@interface LZTeleplayViewController : SCBaseViewController

@property (nonatomic,copy) NSString *teleplayUrl;
@property (nonatomic, strong) PVChoiceSecondColumnModel *secondColumnModel;

@end
