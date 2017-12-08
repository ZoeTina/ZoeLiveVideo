//
//  NSDate+SCExtension.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/20.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SCExtension)

#pragma mark - 单例
+ (nonnull NSDateFormatter *)sc_sharedDateFormatter;
+ (nonnull NSCalendar *)sc_sharedCalendar;

#pragma mark - 日期方法


///将字符串转成nsdate
+(NSDate* _Nullable)PVDateStringToDate:(nonnull NSString*)timeString formatter:(nonnull NSString*)formatter;
///将nsdate转成时间戳
+(double)PVDateToTimeStamp:(NSDate* _Nullable) formatTime format:(NSString* _Nullable)format;
///将时间戳转成nsdate
+(NSDate* _Nullable)PVTimeStampToData:(double) timestamp format:(NSString* _Nullable)format;
///将nsdate转成标准字符串
+(nonnull NSString*)PVDateToStringTime:(NSDate* _Nullable) formatTime format:(NSString* _Nullable)format;
///将字符串时间转成周末制
+(nonnull NSString*)PVStringTimeToString:(NSString* _Nullable) formatTime format:(NSString* _Nullable)format;

/// 比较from和self的时间差值
- (NSDateComponents *_Nonnull)sc_deltaFrom:(NSDate *_Nullable)from;

/// 是否为今年
- (BOOL)isThisYear;

/// 是否为昨天
- (BOOL)isYesterday;

/// 是否为今天
- (BOOL)isThisDay;

///是否为明天
- (BOOL)isTomorrowDay;

/// 返回指定时间差值的日期字符串
///
/// @param delta 时间差值
///
/// @return 日期字符串，格式：yyyy-MM-dd HH:mm:ss
+ (nonnull NSString *)sc_dateStringWithDelta:(NSTimeInterval)delta;

/**
 NSdate 转为 NSString
 */
- (NSString *_Nonnull)stringFromDate:(NSString *_Nullable)dateFormat;

/// 返回日期格式字符串
///
/// 具体格式如下：
///     - 刚刚(一分钟内)
///     - X分钟前(一小时内)
///     - X小时前(当天)
///     - MM-dd HH:mm(一年内)
///     - yyyy-MM-dd HH:mm(更早期)
@property (nonnull, nonatomic, readonly) NSString *sc_dateDescription;

/**
 *  根据日期字符串生成日期对象
 *
 *  @param string [in]日期字符串 e.g. @"2014-06-07 13:36:07"
 *  @param format [in]日期格式  e.g. @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return NSDate
 */
+ (NSDate * _Nonnull)sc_dateFromString:(NSString *_Nullable)string withFormat:(NSString *_Nullable)format;
@end
