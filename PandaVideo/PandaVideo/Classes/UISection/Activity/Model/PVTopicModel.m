//
//  PVTopicModel.m
//  PandaVideo
//
//  Created by cara on 2017/10/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTopicModel.h"

@implementation PVTopicModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.kId = value;
    }else{
        [super setValue:value forKey:key];
    }
}

@end
