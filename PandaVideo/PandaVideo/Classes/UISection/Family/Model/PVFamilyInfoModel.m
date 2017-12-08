//
//  PVFamilyInfoModel.m
//  PandaVideo
//
//  Created by songxf on 2017/11/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFamilyInfoModel.h"

@implementation PVFamilyInfoModel

- (NSString *)description{
    return [self yy_modelDescription];
}

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"familyMemberList":[PVFamilyInfoListModel class]};
}

@end


@implementation PVFamilyInfoListModel

@end
