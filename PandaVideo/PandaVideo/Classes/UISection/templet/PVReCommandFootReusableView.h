//
//  PVReCommandFootReusableView.h
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVVideoTemletModel.h"


typedef void(^PVReCommandFootReusableViewCallBlock)(BOOL isCharge);

@interface PVReCommandFootReusableView : UICollectionReusableView

@property(nonatomic, assign)NSInteger type;
@property(weak, nonatomic) IBOutlet UILabel *moreLaebl;

@property(nonatomic, strong)PVVideoTemletModel* videoTemletModel;

-(void)setPVReCommandFootReusableViewCallBlock:(PVReCommandFootReusableViewCallBlock)block;

@end
