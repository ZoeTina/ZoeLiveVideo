//
//  PVAssociationKeyWordModel.m
//  PandaVideo
//
//  Created by cara on 2017/11/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVAssociationKeyWordModel.h"

@implementation PVAssociationKeyWordModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.kId = value;
    }else{
        [super setValue:value forKey:key];
    }
}
-(void)setWord:(NSString *)word{
    _word = word;
    self.lowerWord = [self transform:word];
}
- (NSString *)transform:(NSString *)chinese{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin lowercaseString];
}
@end
