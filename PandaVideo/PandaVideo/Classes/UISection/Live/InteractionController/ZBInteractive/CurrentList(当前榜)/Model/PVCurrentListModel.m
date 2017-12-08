//
//  PVCurrentListModel.m
//  PandaVideo
//
//  Created by Ensem on 2017/11/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVCurrentListModel.h"

@implementation PVCurrentListModel

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"data"] ){
//        if ([value isKindOfClass:[NSDictionary class]]) {
            PVCurrentListData *listData = [[PVCurrentListData alloc] init];
            [listData setValuesForKeysWithDictionary:value];
            self.listData = listData;
//        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end

@implementation PVCurrentListData

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"rankingList"] ){
        if ([value isKindOfClass:[NSArray class]]) {
            [self.rankingList removeAllObjects];
            NSArray *jsonArr = value;
            for (NSDictionary *jsonDict in jsonArr) {
                PVRankingList *rankingList = [[PVRankingList alloc] init];
                [rankingList setValuesForKeysWithDictionary:jsonDict];
                [self.rankingList addObject:rankingList];
            }
        }
    }else{
        [super setValue:value forKey:key];
    }
}

-(NSMutableArray<PVRankingList *> *)rankingList{
    if (!_rankingList) {
        _rankingList = [NSMutableArray array];
    }
    return _rankingList;
}

@end

@implementation PVRankingList

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"user"]) {
        LZUser *lzUser = [[LZUser alloc] init];
        [lzUser setValuesForKeysWithDictionary:value];
        self.lzUser = lzUser;
    }else{
        [super setValue:value forKey:key];
    }
}

@end

@implementation LZUser

@end

