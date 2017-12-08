//
//  PVQuestionDetailModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVQuestionDetailModel.h"

@implementation PVQuestionDetailModel
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"questionList" : [PVQuestionModel class]};
}
@end
