//
//  NSTimer+Extension.m
//  YYNavigationController
//
//  Created by 寕小陌 on 2016/12/12.
//  Copyright © 2016年 寕小陌. All rights reserved.
//

#import "NSTimer+Extension.h"

LZSYNTH_DUMMY_CLASS(NSTimer_Extension)


@implementation NSTimer (Extension)

+ (void)_lz_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_lz_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_lz_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

@end
