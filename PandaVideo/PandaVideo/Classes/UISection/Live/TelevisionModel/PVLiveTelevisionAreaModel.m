//
//  PVLiveTelevisionAreaModel.m
//  PandaVideo
//
//  Created by cara on 17/9/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLiveTelevisionAreaModel.h"

@implementation PVLiveTelevisionAreaModel


-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"channelList"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            [self.chanelList removeAllObjects];
            for (NSDictionary* dict in value) {
                PVLiveTelevisionChanelListModel* chanelListModel = [[PVLiveTelevisionChanelListModel alloc]  init];
                [chanelListModel setValuesForKeysWithDictionary:dict];
                [self.chanelList addObject:chanelListModel];
            }
        }
    }else{
        [super setValue:value forKey:key];
    }
}

-(NSMutableArray<PVLiveTelevisionChanelListModel *> *)chanelList{
    if (!_chanelList) {
        _chanelList = [NSMutableArray array];
    }
    return _chanelList;
}
@end
