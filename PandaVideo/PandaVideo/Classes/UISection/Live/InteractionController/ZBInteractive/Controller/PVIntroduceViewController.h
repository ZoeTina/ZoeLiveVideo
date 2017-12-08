//
//  PVIntroduceViewController.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVIntroduceModel.h"

@interface PVIntroduceViewController : UIViewController

- (instancetype)initIntroduceModel:(PVIntroduceModel *) introduceModel;
@property (nonatomic, assign) CGFloat currentHeigh;

@end
