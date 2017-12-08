//
//  NSDictionary+PVExtension.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/9.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "NSDictionary+PVExtension.h"

@implementation NSDictionary (PVExtension)
- (id)pv_objectForKey:(NSString *)key {
    
    if ([self isKindOfClass:[NSDictionary class]]){
        if ([self.allKeys containsObject:key]) {
            return [self objectForKey:key];
        }else{
            return nil;
        }
    }else {
        return nil;
    }
    
}
@end
