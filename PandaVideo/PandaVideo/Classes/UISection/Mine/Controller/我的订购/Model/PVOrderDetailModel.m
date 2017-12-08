//
//  PVOrderDetailModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVOrderDetailModel.h"

@implementation PVOrderDetailModel

@end

@implementation PVOrderDetailListModel
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderList" : [PVOrderDetailModel class]};
}

@end
