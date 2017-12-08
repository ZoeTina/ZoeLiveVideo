//
//  PVDetailHeipsTextHeadView.h
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVQuestionClassModel.h"

typedef void (^PVDetailHeipsTextHeadViewBlock) ();

@interface PVDetailHeipsTextHeadView : UITableViewHeaderFooterView

@property(nonatomic, strong)PVQuestionModel* detailModel;
-(void)setPVDetailHeipsTextHeadViewBlock:(PVDetailHeipsTextHeadViewBlock)block;
@end
