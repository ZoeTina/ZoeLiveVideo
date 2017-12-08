//
//  PVHelpsTextHeaderView.h
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVQuestionClassModel.h"

typedef void (^PVHelpsTextHeaderViewBlock) ();


@interface PVHelpsTextHeaderView : UITableViewHeaderFooterView

@property(nonatomic, assign)NSInteger section;

@property (nonatomic, strong) PVQuestionListModel *questsionListModel;

-(void)setPVHelpsTextHeaderViewBlock:(PVHelpsTextHeaderViewBlock)block;

@end
