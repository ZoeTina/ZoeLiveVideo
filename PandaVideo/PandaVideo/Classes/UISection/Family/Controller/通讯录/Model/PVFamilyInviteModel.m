//
//  PVFamilyInviteModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/12.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFamilyInviteModel.h"

@implementation PVFamilyInviteModel

@end


@implementation PVFamilyInviteListModel
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"inviteList" : [PVFamilyInviteModel class]};
}
@end

