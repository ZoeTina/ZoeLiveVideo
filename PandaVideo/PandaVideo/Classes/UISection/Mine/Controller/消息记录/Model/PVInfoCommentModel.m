//
//  PVInfoCommentModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInfoCommentModel.h"

@implementation PVUserDataModel

@end

@implementation PVInfoCommentModel

@end

@implementation PVInfoListCommentModel
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"replyList" : [PVInfoCommentModel class]};
}
@end
