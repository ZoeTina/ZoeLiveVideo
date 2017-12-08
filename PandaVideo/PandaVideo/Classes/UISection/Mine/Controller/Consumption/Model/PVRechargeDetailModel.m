//
//  PVRechargeDetailModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/6.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRechargeDetailModel.h"

@implementation PVRechargeDetailModel

@end

@implementation PVRechargeDetailListModel

- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"rechargeList" : [PVRechargeDetailModel class]};
}

@end
