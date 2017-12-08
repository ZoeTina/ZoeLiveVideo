//
//  PVCollectionModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVCollectionModel.h"

@implementation PVCollectionModel

@end


@implementation PVCollectionListModel

- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"favList" : [PVCollectionModel class]};
}

@end
