//
//  PVHistoryModel.m
//  PandaVideo
//
//  Created by cara on 17/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHistoryModel.h"

@implementation PVHistoryListModel

- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"historyList" : [PVHistoryModel class]};
}

@end

@implementation PVHistoryModel



@end
