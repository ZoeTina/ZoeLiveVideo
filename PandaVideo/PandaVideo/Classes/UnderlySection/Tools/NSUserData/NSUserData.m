//
//  NSUserData.m
//  MarriageLeave
//
//  Created by Neo on 16/6/3.
//  Copyright © 2016年 heng. All rights reserved.
//

#import "NSUserData.h"

@implementation NSUserData
/**
 *  缓存写入
 */
+ (void)putUserDefaults:(NSString *)value key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  缓存读取
 */
+ (NSString *)getUserDefaults:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
/**
 *  缓存清除
 */
+ (void)clearUserDefaults:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
