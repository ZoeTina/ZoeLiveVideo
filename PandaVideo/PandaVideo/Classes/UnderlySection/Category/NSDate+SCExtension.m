//
//  NSDate+SCExtension.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/20.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "NSDate+SCExtension.h"

@implementation NSDate (SCExtension)

#pragma mark - 单例
+ (NSDateFormatter *)sc_sharedDateFormatter {
    static NSDateFormatter *dateFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    });
    
    return dateFormatter;
}

+ (NSCalendar *)sc_sharedCalendar {
    static NSCalendar *calendar;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    
    return calendar;
}

#pragma mark - 日期方法

- (NSDateComponents *)sc_deltaFrom:(NSDate *)from {
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [[NSDate sc_sharedCalendar] components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear {
    NSDate *now = [NSDate date];
    
    NSInteger nowYear = [[NSDate sc_sharedCalendar] component:NSCalendarUnitYear fromDate:now];
    NSInteger selfYear = [[NSDate sc_sharedCalendar] component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

- (BOOL)isThisDay {
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *nowCmps = [[NSDate sc_sharedCalendar] components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [[NSDate sc_sharedCalendar] components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year
    && nowCmps.month == selfCmps.month
    && nowCmps.day == selfCmps.day;
}

- (BOOL)isTomorrowDay {
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *nowCmps = [[NSDate sc_sharedCalendar] components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [[NSDate sc_sharedCalendar] components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year
    && nowCmps.month == selfCmps.month
    && nowCmps.day  < selfCmps.day;
}

- (BOOL)isYesterday {
    [NSDate sc_sharedDateFormatter].dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [[NSDate sc_sharedDateFormatter] dateFromString:[[NSDate sc_sharedDateFormatter] stringFromDate:[NSDate date]]];
    NSDate *selfDate = [[NSDate sc_sharedDateFormatter] dateFromString:[[NSDate sc_sharedDateFormatter] stringFromDate:self]];
    
    NSDateComponents *cmps = [[NSDate sc_sharedCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

+ (NSString *)sc_dateStringWithDelta:(NSTimeInterval)delta {
    [self sc_sharedDateFormatter].dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:delta];
    
    return [[self sc_sharedDateFormatter] stringFromDate:date];
}

- (NSString *)sc_dateDescription {
    
    NSUInteger units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSDate sc_sharedCalendar] components:units fromDate:self];
    NSDateComponents *thisComponents = [[NSDate sc_sharedCalendar] components:units fromDate:[NSDate date]];
    
    // 今天
    if (dateComponents.year == thisComponents.year
        && dateComponents.month == thisComponents.month
        && dateComponents.day == thisComponents.day) {
        
        NSInteger delta = (NSInteger)[[NSDate date] timeIntervalSinceDate:self];
        
        if (delta < 60) {
            return @"刚刚";
        }
        if (delta < 3600) {
            return [NSString stringWithFormat:@"%zd 分钟前", delta / 60];
        }
        return [NSString stringWithFormat:@"%zd 小时前", delta / 3600];
    }
    
    NSString *format = @"MM-dd HH:mm";
    
    if (dateComponents.year != thisComponents.year) {
        format = [@"yyyy-" stringByAppendingString:format];
    }
    [NSDate sc_sharedDateFormatter].dateFormat = format;
    
    return [[NSDate sc_sharedDateFormatter] stringFromDate:self];
}


+(NSDate*)PVDateStringToDate:(NSString*)timeString formatter:(NSString*)formatter{
    if (timeString.length == 0) return nil;
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:formatter];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formater setTimeZone:timeZone];
    NSDate* date = [formater dateFromString:timeString];
    return date;

}

+(double)PVDateToTimeStamp:(NSDate*) formatTime format:(NSString*)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss")
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSInteger timeSp = [[NSNumber numberWithDouble:[formatTime timeIntervalSince1970]] integerValue];
    return timeSp;
}
+(NSDate* _Nullable)PVTimeStampToData:(double)timestamp format:(NSString* _Nullable)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return confromTimesp;
}

+(nonnull NSString*)PVDateToStringTime:(NSDate* _Nullable) formatTime format:(NSString* _Nullable)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSString *confromTimespStr = [formatter stringFromDate:formatTime];
    return confromTimespStr;
}
+(nonnull NSString*)PVStringTimeToString:(NSString* _Nullable) formatTime format:(NSString* _Nullable)format{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *date = [NSDate PVDateStringToDate:formatTime formatter:format];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    switch (week) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            break;
    }
    return @"";
}

- (NSString *_Nonnull)stringFromDate:(NSString *_Nullable)dateFormat
{
    [NSDate sc_sharedDateFormatter].dateFormat = dateFormat;
    return [[NSDate sc_sharedDateFormatter] stringFromDate:self];
    
}

+ (NSDate * _Nonnull)sc_dateFromString:(NSString *_Nullable)string withFormat:(NSString *_Nullable)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
    
}
@end
