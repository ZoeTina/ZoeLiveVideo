//
//  PVTeleplayChildViewController.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "LZTeleplayViewController.h"
#import "PVChoiceSecondColumnModel.h"
#import "PVVideoTemletModel.h"
@class PVVideoListModel,PVVideoTemletModel;
@interface PVTeleplayChildViewController : SCBaseViewController//LZTeleplayViewController


@property (nonatomic, strong) PVVideoTemletModel *templetModel;

//@property (nonatomic, strong) NSMutableArray <PVVideoListModel*>*videoListModel;

@property (nonatomic, strong) PVChoiceSecondColumnModel *secondColumnModel;
-(instancetype)initWithModels:(PVChoiceSecondColumnModel *) secondColumnModel;
@property (nonatomic,copy) NSString *teleplayUrl;
@property(nonatomic, assign)NSInteger type;

@end
