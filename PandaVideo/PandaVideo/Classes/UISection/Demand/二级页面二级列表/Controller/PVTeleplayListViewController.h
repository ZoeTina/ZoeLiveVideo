//
//  PVTeleplayListViewController.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"
#import "PVChoiceSecondColumnModel.h"

@interface PVTeleplayListViewController : SCBaseViewController

@property (nonatomic, strong) PVChoiceSecondColumnModel *secondColumnModel;

-(instancetype)initWithModels:(PVChoiceSecondColumnModel *) secondColumnModel;

@property(nonatomic, copy)NSString* url;
@property(nonatomic, assign)NSInteger type;

@end
