//
//  SCSmallTool.h
//  SiChuanFocus
//
//  Created by xiangjf on 2017/6/30.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSmallTool : NSObject

/**
 获取当前时间
 */
+(NSString *)getModelTime;

/**
 富文本

 @param text 文本
 @param color1 颜色
 @param color2 颜色
 @param length color1颜色的文本长度
 */
+ (NSMutableAttributedString *)attributed:(NSString *)text color1:(UIColor *)color1 color2:(UIColor *)color2 length:(NSUInteger)length;


/**
 电话号码正则判断

 @param telNumber 电话号码
 @return 是否正确
 */
+ (BOOL)checkTelNumber:(NSString *) telNumber;


/**
 传入秒，得到xx:xx:xx

 @param totalTime 秒数
 @return 小时：分：秒
 */
+ (NSString *)getHHMMSSFromSS:(NSInteger)totalTime;

+ (int)convertToInt:(NSString *)strtemp;

/**
 表情符号的判断

 @param string 字符串
 @return 返回结果
 */

+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
