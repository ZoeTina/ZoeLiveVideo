//
//  PVAdvertisementModel.m
//  PandaVideo
//
//  Created by cara on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVAdvertisementModel.h"

@implementation PVAdvertisementModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.kId = value;
    }else{
        [super setValue:value forKey:key];
    }
}

-(void)setImgUrl:(NSString *)imgUrl{
    if (!imgUrl) {
        _imgUrl = @"";
    }else{
        _imgUrl = imgUrl;
    }
}



@end
