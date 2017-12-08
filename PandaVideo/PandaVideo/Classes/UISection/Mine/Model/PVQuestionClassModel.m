//
//  PVQuestionClassModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVQuestionClassModel.h"

@implementation PVQuestionClassModel

- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"classList" : [PVQuestionListModel class]};
}

@end

@implementation PVQuestionListModel

- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"questionList" : [PVQuestionModel class]};
}

@end

@implementation PVQuestionModel

@end
