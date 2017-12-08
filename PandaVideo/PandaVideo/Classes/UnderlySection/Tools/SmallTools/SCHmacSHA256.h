//
//  SCHmacSHA256.h
//  SiChuanFocus
//
//  Created by xiangjf on 2017/8/8.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCHmacSHA256 : NSObject

/**
 *  加密方式,MAC算法: HmacSHA256
 *
 *  @param plaintext 要加密的文本
 *  @param key       秘钥
 *
 *  @return 加密后的字符串
 */
+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;
@end
