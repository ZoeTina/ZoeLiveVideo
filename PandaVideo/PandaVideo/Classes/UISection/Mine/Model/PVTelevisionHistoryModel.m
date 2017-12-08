//
//  PVTelevisionHistoryModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTelevisionHistoryModel.h"

@implementation PVTelevisionHistoryModel

@end

@implementation PVTelevisionListHistoryModel
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"historyList" : [PVTelevisionHistoryModel class]};
}
@end
