//
//  PVLiveTelevisionChanelListModel.m
//  PandaVideo
//
//  Created by cara on 17/9/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLiveTelevisionChanelListModel.h"

@implementation PVLiveTelevisionChanelListModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"codeRateList"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            [self.codeRateLists removeAllObjects];
            for (NSDictionary* dict in value) {
                PVLiveTelevisionCodeRateList* codeRateList = [[PVLiveTelevisionCodeRateList alloc]  init];
                [codeRateList setValuesForKeysWithDictionary:dict];
                [self.codeRateLists addObject:codeRateList];
            }
        }
    }else if ([key isEqualToString:@"copyRight"]){
        self.copyright = value;
    }else if ([key isEqualToString:@"programInfo"]){
        if ([value isKindOfClass:[NSDictionary class]]) {
            PVLiveTelevisionBackProgramInfoModel* model = [[PVLiveTelevisionBackProgramInfoModel alloc]  init];
            [model setValuesForKeysWithDictionary:value];
            self.backProgramInfoModel = model;
        }
    }else{
        [super setValue:value forKey:key];
    }
}
-(NSMutableArray<PVLiveTelevisionCodeRateList *> *)codeRateLists{
    if (!_codeRateLists) {
        _codeRateLists = [NSMutableArray array];
    }
    return _codeRateLists;
}
-(NSMutableArray<PVLiveTelevisionProGramModel *> *)programs{
    if (!_programs) {
        _programs = [NSMutableArray array];
    }
    return _programs;
}
@end

@implementation PVLiveTelevisionBackProgramInfoModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.kId = value;
    }else{
        [super setValue:value forKey:key];
    }
}

@end
