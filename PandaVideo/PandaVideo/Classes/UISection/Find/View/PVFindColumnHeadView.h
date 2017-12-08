//
//  PVFindColumnHeadView.h
//  PandaVideo
//
//  Created by cara on 17/7/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVFindBaseInfoModel.h"

typedef void (^BackBtnClickedBlock) ();



@interface PVFindColumnHeadView : UIView


@property(nonatomic, strong)PVFindBaseInfoModel*  findBaseInfoModel;

-(void) setBackBtnClickedBlock:(BackBtnClickedBlock)block;

@end
