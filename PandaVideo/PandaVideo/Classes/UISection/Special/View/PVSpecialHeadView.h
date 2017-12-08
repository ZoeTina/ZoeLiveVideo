//
//  PVSpecialHeadView.h
//  PandaVideo
//
//  Created by cara on 17/8/10.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVSpecialDetailModel.h"


@interface PVSpecialHeadView : UIView

@property(nonatomic, strong)PVSpecialDetailModel* specialDetailModel;


-(instancetype)initPVSpecialDetailModel:(PVSpecialDetailModel*)specialDetailModel;


@end
