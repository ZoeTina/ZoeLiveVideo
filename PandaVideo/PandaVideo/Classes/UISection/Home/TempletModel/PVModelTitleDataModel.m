//
//  PVModelTitleDataModel.m
//  PandaVideo
//
//  Created by cara on 17/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVModelTitleDataModel.h"

@implementation PVModelTitleDataModel


-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"modelWord1"]) {
        if (![value isKindOfClass:[NSDictionary class]])return;
        ModelWord* modelWord = [[ModelWord alloc]  init];
        [modelWord setValuesForKeysWithDictionary:value];
        self.modelWord1 = modelWord;
    }else if ([key isEqualToString:@"modelWord2"]){
        if (![value isKindOfClass:[NSDictionary class]]) return;
        ModelWord* modelWord = [[ModelWord alloc]  init];
        [modelWord setValuesForKeysWithDictionary:value];
        self.modelWord2 = modelWord;
    }else if ([key isEqualToString:@"modelWord3"]){
        if (![value isKindOfClass:[NSDictionary class]]) return;
        ModelWord* modelWord = [[ModelWord alloc]  init];
        [modelWord setValuesForKeysWithDictionary:value];
        self.modelWord3 = modelWord;
    }else{
        [super setValue:value forKey:key];
    }
}
@end



@implementation ModelWord


-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"modelArrowData"]) {
        ModelArrowData* modelArrowData = [[ModelArrowData alloc]  init];
        [modelArrowData setValuesForKeysWithDictionary:value];
        self.modelArrowData = modelArrowData;
    }else if([key isEqualToString:@"modelKeyData"]) {
            ModelKeyData* modelKeyData = [[ModelKeyData alloc]  init];
            [modelKeyData setValuesForKeysWithDictionary:value];
            self.modelKeyData = modelKeyData;
    }else{
        [super setValue:value forKey:key];
    }
}

@end

@implementation ModelArrowData

@end

@implementation ModelKeyData

@end
