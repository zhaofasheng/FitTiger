//
//  NoticeTimerTools.h
//  NoticeXi
//
//  Created by li lei on 2023/3/31.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTimerTools : NSObject

+ (NSString *)timerTask:(void(^)(void))task
                  start:(NSTimeInterval)start
               interval:(NSTimeInterval)interval
                repeats:(BOOL)repeats
                  async:(BOOL)async;

+ (void)deleteTimer:(NSString *)timerName;

@end

NS_ASSUME_NONNULL_END
