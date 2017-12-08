//
//  PVNoticeInfoModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVNoticeInfoModel.h"

@implementation PVNoticeInfoModel

@end


@implementation PVNoticeInfoListModel
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [PVNoticeInfoModel class]};
}
@end

@implementation PVNoticeInfoDetailModel

@end
