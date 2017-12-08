//
//  PVHelpsTextTableViewCell.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVQuestionClassModel.h"

@interface PVHelpsTextTableViewCell : UITableViewCell
@property (nonatomic, strong) PVQuestionModel *questionModel;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, assign)BOOL isQuestion;
@end
