//
//  PVIntroduceModel.m
//  PandaVideo
//
//  Created by Ensem on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVIntroduceModel.h"

@implementation PVIntroduceModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"codeRateList"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            [self.codeRateList removeAllObjects];
            NSArray* jsonArr = value;
            for (NSDictionary* jsonDict in jsonArr) {
                CodeRateList* list = [[CodeRateList alloc]  init];
                [list setValuesForKeysWithDictionary:jsonDict];
                [self.codeRateList addObject:list];
            }
            if (jsonArr.count==0) {
                CodeRateList* list = [[CodeRateList alloc] init];
                list.showName = @"标清";
                list.isDefaultRate = @"true";
                list.isSelected = true;
                [self.codeRateList addObject:list];

            }
        }
    }else if ([key isEqualToString:@"info"] ){
        if ([value isKindOfClass:[NSDictionary class]]) {
            LZInfo *info = [[LZInfo alloc] init];
            [info setValuesForKeysWithDictionary:value];
            self.info = info;
        }
    }else if([key isEqualToString:@"review"] ){
        LZReview *review = [[LZReview alloc] init];
        [review setValuesForKeysWithDictionary:value];
        self.review = review;
    }else{
        [super setValue:value forKey:key];
    }
}

- (NSMutableArray<CodeRateList *> *)codeRateList{
    if (!_codeRateList) {
        _codeRateList = [[NSMutableArray alloc] init];
    }
    return _codeRateList;
}
@end

@implementation CodeRateList

- (void)setIsDefaultRate:(NSString *)isDefaultRate{
    _isDefaultRate = isDefaultRate;
    YYLog(@"isDefaultRate --- %@",isDefaultRate);
    if ([isDefaultRate isEqualToString:@"false"]) {
        self.isSelected = false;
    }else{
        self.isSelected = true;
    }
}

@end

@implementation LZReview

@end

@implementation LZInfo

@end

@implementation PVIntroduceMoneyModel

@end
