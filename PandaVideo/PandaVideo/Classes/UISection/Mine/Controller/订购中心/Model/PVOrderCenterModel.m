//
//  PVOrderCenterModel.m
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVOrderCenterModel.h"

@implementation PVOrderCenterModel
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"privilegeList" : [PrivilegeModel class], @"orderInfo":[OrderInfoModel class]};
}
@end


@implementation PrivilegeModel

@end

@implementation OrderInfoModel

@end

@implementation PVOrderCenterListModel
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderList" : [PVOrderCenterModel class]};
}
@end

