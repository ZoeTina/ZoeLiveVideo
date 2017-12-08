//
//  PVSearchResultModel.m
//  PandaVideo
//
//  Created by songxf on 2017/11/12.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSearchResultModel.h"

@implementation PVSearchResultModel

- (NSString *)description{
    return [self yy_modelDescription];
}

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"videoList":[PVSearchVideoListModel class]};
}
@end

@implementation PVSearchVideoListModel

- (NSString *)description{
    return [self yy_modelDescription];
}

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"episodeList":[PVSearchEpisodeListModel class],@"tagData":PVSearchVideoTagDataModel.class};
}
@end

@implementation PVSearchEpisodeListModel
- (NSString *)description{
    return [self yy_modelDescription];
}

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"episodeModel":PVSearchEpisodeDataModel.class};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"sc_description":@"description"};
}
@end

@implementation PVSearchEpisodeDataModel

@end

@implementation PVSearchVideoTagDataModel

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"topLeftCorner":PVTagDataModel.class,@"topRightCorner":PVTagDataModel.class,@"bottomRightCorner":PVTagDataModel.class};
}
@end

@implementation PVTagDataModel

@end
