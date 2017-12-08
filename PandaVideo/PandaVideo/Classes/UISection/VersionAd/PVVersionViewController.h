//
//  PVVersionViewController.h
//  PandaVideo
//
//  Created by songxf on 2017/10/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVVersionModel.h"
#import "PVADsModel.h"
@interface PVVersionViewController : UIViewController

@property(nonatomic,strong)PVVersionModel *versionModel;
@property(nonatomic,strong)NSArray *adsArray;
- (void)updateAllData;
@end
