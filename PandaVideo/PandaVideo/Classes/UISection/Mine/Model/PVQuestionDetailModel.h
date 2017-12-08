//
//  PVQuestionDetailModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVQuestionClassModel.h"

@interface PVQuestionDetailModel : NSObject
@property (nonatomic, copy) NSString *className;
@property (nonatomic, strong) NSArray <PVQuestionModel *> *questionList;
@end
