//
//  PVDetailHelpsTextFootView.h
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVHistoryDetailModel.h"

typedef void (^PVDetailHelpsTextFootViewBlock) (UIButton* userfulBtn,UIButton* unlessUserfulBtn);


@interface PVDetailHelpsTextFootView : UITableViewHeaderFooterView

@property(nonatomic, strong)PVHistoryDetailModel* detailModel;
-(void)setPVDetailHelpsTextFootViewBlock:(PVDetailHelpsTextFootViewBlock)block;

@end
