//
//  NSString+LZPinYin.m
//  拼音扩展
//
//  Created by  jason on 15/12/18.
//  Copyright © 2015年 renlairenwang. All rights reserved.
//

#import "NSString+LZPinYin.h"

@implementation NSString (LZPinYin)

- (NSString *)lz_chineseStringTransformToPinYin {

    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
    // 转为带声调的拉丁文
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, NO);
    // 去掉声调
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, NO);
    return mutableString;
}


- (NSString *)lz_fisrtUppercasePinYin {

    
    NSString *str = [self lz_chineseStringTransformToPinYin];
    return  [[str uppercaseString] substringToIndex:1];
}


- (BOOL)lz_isContainChinese {
    for (int i = 0; i<self.length; i++) {
        unichar ch = [self characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

@end
