//
//  NoticeStayMesssage.m
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeStayMesssage.h"

@implementation NoticeStayMesssage

- (void)setTime:(NSString *)time{
    self.timeinter = time;
    _time = [NoticeTools updateTimeForRow:time];
}

@end
