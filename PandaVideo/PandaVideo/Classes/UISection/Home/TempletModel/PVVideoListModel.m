//
//  PVVideoListModel.m
//  PandaVideo
//
//  Created by cara on 17/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoListModel.h"

@implementation PVVideoListModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"info"]) {
        Info* info = [[Info alloc]  init];
        [info setValuesForKeysWithDictionary:value];
        self.info = info;
    }else{
        [super setValue:value forKey:key];
    }
}
@end

@implementation Info

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"expand"]) {
        Expand* expand = [[Expand alloc]  init];
        [expand setValuesForKeysWithDictionary:value];
        self.expand = expand;
    }else if ([key isEqualToString:@"id"]){
        self.kId = value;
    }else{
        [super setValue:value forKey:key];
    }
}

@end

@implementation Expand

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"topLeftCorner"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            ConerModel* conerModel = [[ConerModel alloc]  init];
            [conerModel setValuesForKeysWithDictionary:value];
            self.topLeftCornerModel = conerModel;
        }
    }else if ([key isEqualToString:@"topRightCorner"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            ConerModel* conerModel = [[ConerModel alloc]  init];
            [conerModel setValuesForKeysWithDictionary:value];
            self.topRightCornerModel = conerModel;
        }
    }else if ([key isEqualToString:@"bottomRightCorner"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            ConerModel* conerModel = [[ConerModel alloc]  init];
            [conerModel setValuesForKeysWithDictionary:value];
            self.bottomRightCornerModel = conerModel;
        }
    }else{
        [super setValue:value forKey:key];
    }
}

-(void)setSubhead:(NSString *)subhead{
    _subhead = subhead;
    if(subhead.length){
        NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *str = [[NSString alloc] initWithString:[subhead stringByTrimmingCharactersInSet:whiteSpace]];
        _subhead = str;
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end

@implementation ConerModel


@end
