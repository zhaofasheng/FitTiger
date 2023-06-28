//
//  NoticeShareModel.m
//  NoticeXi
//
//  Created by li lei on 2020/7/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeShareModel.h"

@implementation NoticeShareModel
- (void)setNearby_at:(NSString *)nearby_at{
    _nearby_at = nearby_at;
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSInteger time = nearby_at.intValue-currentTime;
    if (time > 60) {
       self.nextTime = [NSString stringWithFormat:@"距离下次共享还剩:%ld分钟",time/60];
    }else{
        self.nextTime = [NSString stringWithFormat:@"距离下次共享还剩:%ld秒",time/60];
    }
    
}
@end
