//
//  NSMutableDictionary+SCExtension.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/9/8.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "NSMutableDictionary+SCExtension.h"
#import "SCHmacSHA256.h"

@implementation NSMutableDictionary (SCExtension)

- (NSMutableDictionary *)sc_requestParamsAddTokenWithImageArray:(NSArray *)imageArray {
    NSString *hmacStr = [NSString new];
    
    NSArray *arr = self.allKeys;
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *desArr = [arr sortedArrayUsingDescriptors:descriptors];
    
    for (NSInteger i = 0; i < self.allKeys.count; i++) {
        NSString *subKey = desArr[i];
        id subValue = [self objectForKey:subKey];
        NSString *imageString = [NSString new];
        if ([subValue isKindOfClass:[NSArray class]]) {
            for (NSString *imageUrl in imageArray) {
                imageString = [imageString stringByAppendingString:imageUrl];
            }
            hmacStr = [hmacStr stringByAppendingString:imageString];
        } else {
            hmacStr = [hmacStr stringByAppendingString:subValue];
        }
    }
    
    NSString *hmac = [SCHmacSHA256 hmac:hmacStr withKey:[PVUserModel shared].token];
    [self setObject:hmac forKey:@"token"];
    SCLog(@"%@", hmacStr);
    SCLog(@"%@", hmac);
    
    return self;
}


@end
