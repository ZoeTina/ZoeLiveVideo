//
//  PVHelpDetailsViewController.h
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"
#import "PVQuestionClassModel.h"

@interface PVHelpDetailsViewController : SCBaseViewController

@property(nonatomic,assign)NSInteger section;
@property (nonatomic, strong) PVQuestionListModel *questListModel;

@end
