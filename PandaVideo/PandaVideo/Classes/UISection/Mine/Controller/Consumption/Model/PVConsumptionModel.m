//
//  PVConsumptionModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVConsumptionModel.h"

@implementation PVConsumptionModel

@end


@implementation PVConsumptionListModel 
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"consumeList" : [PVConsumptionModel class]};
}
@end
