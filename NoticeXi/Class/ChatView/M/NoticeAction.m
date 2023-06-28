//
//  NoticeAction.m
//  NoticeXi
//
//  Created by li lei on 2019/3/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeAction.h"

@implementation NoticeAction

- (void)setReleased_at:(NSString *)released_at{
    _released_at = released_at;
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSInteger time = released_at.intValue - currentTime;
    self.releaseTime = [NSString stringWithFormat:@"对话清空还剩%ld天",time/86400];
}

@end
