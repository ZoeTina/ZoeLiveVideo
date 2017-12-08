//
//  NSUserData.h
//  MarriageLeave
//
//  Created by Neo on 16/6/3.
//  Copyright © 2016年 heng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserData : NSObject
/**
 *  缓存写入
 */
+ (void)putUserDefaults:(NSString *)value key:(NSString *)key;
/**
 *  缓存读取
 */
+ (NSString *)getUserDefaults:(NSString *)key;
/**
 *  缓存清除
 */
+ (void)clearUserDefaults:(NSString *)key;

//存入头像
@end
