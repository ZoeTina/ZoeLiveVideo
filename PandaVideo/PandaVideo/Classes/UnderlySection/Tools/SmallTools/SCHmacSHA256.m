//
//  SCHmacSHA256.m
//  SiChuanFocus
//
//  Created by xiangjf on 2017/8/8.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "SCHmacSHA256.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation SCHmacSHA256

+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext UTF8String];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    return HMAC;
}


@end
