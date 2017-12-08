//
//  PVGiftsListModel.m
//  PandaVideo
//
//  Created by Ensem on 2017/11/6.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVGiftsListModel.h"

@implementation PVGiftsListModel

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"data"]) {
        PVGiftListData* data = [[PVGiftListData alloc]  init];
        [data setValuesForKeysWithDictionary:value];
        self.data = data;
    }else{
        [super setValue:value forKey:key];
    }
}

@end

@implementation PVGiftListData

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"giftList"] ){
        if ([value isKindOfClass:[NSArray class]]) {
            [self.giftList removeAllObjects];
            NSArray *jsonArr = value;
            for (NSDictionary *jsonDict in jsonArr) {
                PVGiftList *giftList = [[PVGiftList alloc] init];
                [giftList setValuesForKeysWithDictionary:jsonDict];
                [self.giftList addObject:giftList];
            }
        }
    }else{
        [super setValue:value forKey:key];
    }
}

-(NSMutableArray<PVGiftList *> *)giftList{
    if (!_giftList) {
        _giftList = [NSMutableArray array];
    }
    return _giftList;
}

@end

@implementation PVGiftList

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"code"]) {
        self.giftId = [value integerValue];
    }else if ([key isEqualToString:@"name"]) {
        self.giftName = value;
    }else if ([key isEqualToString:@"descr"]) {
        self.sender = value;
    }else if ([key isEqualToString:@"imageUrl"]) {
        self.giftImageName = value;
    }else if ([key isEqualToString:@"type"]) {
        self.liveType = value;
    }else{
        [super setValue:value forKey:key];
    }
}

@end

