//
//  PVPackageListModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPackageListModel.h"

@implementation PVPackageListModel
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"packageList" : [PVPackageModel class]};
}
@end

@implementation PVPackageModel

@end
