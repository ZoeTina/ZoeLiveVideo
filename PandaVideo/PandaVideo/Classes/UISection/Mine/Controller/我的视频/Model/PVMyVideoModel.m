//
//  PVMyVideoModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVMyVideoModel.h"

@implementation PVMyVideoModel

@end

@implementation PVMyVideoListModel
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"videoList" : [PVMyVideoModel class]};
}
@end
