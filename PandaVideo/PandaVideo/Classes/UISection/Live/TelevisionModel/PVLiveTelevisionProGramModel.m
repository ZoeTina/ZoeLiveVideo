//
//  PVLiveTelevisionProGramModel.m
//  PandaVideo
//
//  Created by cara on 17/9/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLiveTelevisionProGramModel.h"

@implementation PVLiveTelevisionProGramModel


-(void)setDate:(NSString *)date{
    _date = date;
    self.dateString  = [NSDate PVStringTimeToString:date format:@"YYYY-MM-dd"];
    NSDate* tempDate = [NSDate PVDateStringToDate:date formatter:@"YYYY-MM-dd"];
    if (tempDate.isThisDay) {
        self.type = 1;
    }else if (tempDate.isYesterday){
        self.type = 2;
    }else if (tempDate.isTomorrowDay){
        self.type = 3;
    }else{
        self.type = 0;
    }
}
-(NSMutableArray<PVLiveTelevisionDetailProGramModel *> *)programs{
    if (!_programs) {
        _programs = [NSMutableArray array];
    }
    return _programs;
}
-(void)selectTodayProgramAppointMentStatus{
    for (PVLiveTelevisionDetailProGramModel* detailProGramModel in self.programs) {
        BOOL result = [[PVDBManager sharedInstance] selectLiveChannelDetailProgram:detailProGramModel];
        if (result) {
            detailProGramModel.appointMentStatus = @"1";
        }else{
            detailProGramModel.appointMentStatus = @"2";
        }
    }
}
@end

@implementation PVLiveTelevisionDetailProGramModel

-(void)setStartTime:(NSString *)startTime{
    _startTime = startTime;
    NSMutableString* time = [[NSMutableString alloc]  initWithString:_startTime];
    if (time.length > 4) {
        time = [[NSMutableString alloc]  initWithString:[_startTime substringToIndex:4]];
    }
    [time insertString:@":" atIndex:2];
    self.startTimeFottmar = time;
}

///计算今天节目单时间
-(void)calculationProgramTime:(NSString*)dateStr{
    
    NSString* nowStartTime = dateStr;
    nowStartTime = [NSString stringWithFormat:@"%@ %@",nowStartTime,self.startTime];
    NSDate* date = [NSDate PVDateStringToDate:nowStartTime formatter:@"YYYY-MM-dd HHmmss"];
    double  nowTatolTime = [NSDate PVDateToTimeStamp:date format:@"YYYY-MM-dd HHmmss"];
    double  tatolTime = nowTatolTime + self.duration.doubleValue;
    
    double nowTime = [NSDate PVDateToTimeStamp:[NSDate date] format:@"YYYY-MM-dd HHmmss"];
    if (tatolTime < nowTime) {
        self.type = 1;
    }else if (nowTatolTime >= nowTime){
        self.type = 4;
    }else if (nowTatolTime < nowTime && nowTime < tatolTime){
        self.type = 3;
        self.isPlaying = true;
    }
}


//取消预约-通知
- (void)cancelLocalNotificationWithKey:(NSString *)key {
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (!notificaitons || notificaitons.count<=0) {
        return;
    }
    for (UILocalNotification *notification in notificaitons) {
        if ([[notification.userInfo objectForKey:@"id"] isEqualToString:key]) {
            //取消一个特定的通知
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}

//预约-通知
- (void)sureLocalNotification{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSString* yearStr = [NSDate PVDateToStringTime:[NSDate date] format:@"YYYYMMdd"];
    NSString* nowStartTime = [NSString stringWithFormat:@"%@ %@",yearStr,self.startTime];
    NSDate* date = [NSDate PVDateStringToDate:nowStartTime formatter:@"YYYYMMdd HHmmss"];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate * nowDate = [date dateByAddingTimeInterval:interval];
    NSDate *fireDate = [NSDate dateWithTimeInterval:-10*60 sinceDate:nowDate];
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = 0;
    // 通知内容
    notification.alertTitle = @"您有一个预约直播即将开始";
    notification.alertBody = self.programName;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = @{@"id":self.programId};
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
