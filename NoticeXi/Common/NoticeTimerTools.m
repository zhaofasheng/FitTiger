//
//  NoticeTimerTools.m
//  NoticeXi
//
//  Created by li lei on 2023/3/31.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTimerTools.h"

@implementation NoticeTimerTools


static NSMutableDictionary *gCallKitTimers1;
dispatch_semaphore_t callKitTimerSemaphore1;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gCallKitTimers1 = [NSMutableDictionary dictionary];
        callKitTimerSemaphore1 = dispatch_semaphore_create(1);
    });
}

+ (NSString *)timerTask:(void(^)(void))task
                  start:(NSTimeInterval)start
               interval:(NSTimeInterval)interval
                repeats:(BOOL)repeats
                  async:(BOOL)async {
    if (!task || start < 0 || (interval <= 0 && repeats)) {
        return nil;
    }
    
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_semaphore_wait(callKitTimerSemaphore1, DISPATCH_TIME_FOREVER);
    NSString *timerName = [NSString stringWithFormat:@"%zd", gCallKitTimers1.count];
    gCallKitTimers1[timerName] = timer;
    dispatch_semaphore_signal(callKitTimerSemaphore1);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [self deleteTimer:timerName];
        }
    });
    dispatch_resume(timer);
    return timerName;
}

+ (void)deleteTimer:(NSString *)timerName{
    if (timerName.length == 0) {
        return;
    }
    DRLog(@"取消计时器");
    dispatch_semaphore_wait(callKitTimerSemaphore1, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = gCallKitTimers1[timerName];
    
    if (timer) {
        dispatch_source_cancel(timer);
        [gCallKitTimers1 removeObjectForKey:timerName];
    }
    
    dispatch_semaphore_signal(callKitTimerSemaphore1);
}

@end
