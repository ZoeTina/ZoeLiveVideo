//
//  PVVideoTemletModel.m
//  PandaVideo
//
//  Created by cara on 17/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoTemletModel.h"

@implementation PVVideoTemletModel


-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"modelTitleData"]) {
        PVModelTitleDataModel* modelTitleData = [[PVModelTitleDataModel alloc]  init];
        [modelTitleData setValuesForKeysWithDictionary:value];
        self.modelTitleDataModel = modelTitleData;
    }else if ([key isEqualToString:@"hasChangeData"]){
        HasChangeData* hasChangeData = [[HasChangeData alloc]  init];
        [hasChangeData setValuesForKeysWithDictionary:value];
        self.hasChangeData = hasChangeData;
    }else if ([key isEqualToString:@"modelMoreData"]){
        ModelMoreData* modelMoreData = [[ModelMoreData alloc]  init];
        [modelMoreData setValuesForKeysWithDictionary:value];
        self.modelMoreData = modelMoreData;
    }else if ([key isEqualToString:@"videoList"]){
        [self.videoListModel removeAllObjects];
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray* jsonDict = value;
            for (NSDictionary* dict in jsonDict) {
                PVVideoListModel* videoListModel = [[PVVideoListModel alloc]  init];
                [videoListModel setValuesForKeysWithDictionary:dict];
                [self.videoListModel addObject:videoListModel];
            }
            self.count = self.videoListModel.count;
        }
    }else{
        [super setValue:value forKey:key];
    }
}

-(NSMutableArray<PVVideoListModel *> *)videoListModel{
    if (!_videoListModel) {
        _videoListModel = [NSMutableArray array];
    }
    return _videoListModel;
}

@end

@implementation ModelMoreData

@end


@implementation HasChangeData

@end


@implementation PVVideoSiftingModel
- (NSString *)description{
    return [self yy_modelDescription];
}

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"videoList":[PVVideoSiftingListModel class]};
}
@end

@implementation PVVideoSiftingListModel
- (NSString *)description{
    return [self yy_modelDescription];
}

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"tagData":PVVideoSiftingListModel.class};
}
@end

@implementation PVVideoSiftingListTagDataModel

@end
