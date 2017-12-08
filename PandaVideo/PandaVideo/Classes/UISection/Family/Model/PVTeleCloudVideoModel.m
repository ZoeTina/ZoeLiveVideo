//
//  PVTeleCloudVideoModel.m
//  PandaVideo
//
//  Created by songxf on 2017/11/9.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTeleCloudVideoModel.h"

@implementation PVTeleCloudVideoModel

- (NSString *)description{
    return [self yy_modelDescription];
}

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"cloudVideoList":[PVTeleCloudVideoListModel class]};
}
@end

@implementation PVTeleCloudVideoListModel

@end

@implementation PVTeleCloudAuthorizeModel

@end
