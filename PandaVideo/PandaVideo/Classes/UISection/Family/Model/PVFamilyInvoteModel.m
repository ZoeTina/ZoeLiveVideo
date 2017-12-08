//
//  PVFamilyInvoteModel.m
//  PandaVideo
//
//  Created by songxf on 2017/11/6.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFamilyInvoteModel.h"

@implementation PVFamilyInvoteModel

- (NSString *)description{
    return [self yy_modelDescription];
}

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"inviteList":[PVFamilyInvoteListModel class]};
}
@end


@implementation PVFamilyInvoteListModel

@end

@implementation PVFamilyBasicUIModel

@end
