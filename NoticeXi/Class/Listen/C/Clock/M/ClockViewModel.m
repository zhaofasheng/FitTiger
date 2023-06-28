
#import "ClockViewModel.h"
#import "YYCache.h"
#import "NSObject+YYModel.h"
#import "UNNotificationsManager.h"

@implementation ClockModel

#pragma mark -- private
- (void)setDateForTimeClock {
    NSDateFormatter *format = [self getFormatter];
    NSString *dateString = [format stringFromDate:_date];
    
    if ([dateString containsString:@"上午"] || [dateString containsString:@"下午"]) {
        _timeText = [dateString substringToIndex:2];
        _timeClock = [dateString substringFromIndex:2];
    } else {
        _timeClock = dateString;
        _timeText = @"";
    }
}

- (NSDateFormatter *)getFormatter {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"ah:mm";
    format.AMSymbol = @"上午";
    format.PMSymbol = @"下午";
    return format;
}

- (void)addUserNotification {
    [self removeUserNotification];
    if ([self.repeatStr isEqualToString:@"每天"]) {
        [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"闹钟时间到，主人该起床了!" subTitle:nil body:nil sound:[UNNotificationSound soundNamed:self.music]] dateComponents:[UNNotificationsManager componentsEveryDayWithDate:self.date] identifer:self.identifer isRepeat:self.repeats completionHanler:^(NSError *error) {
            NSLog(@"add error %@", error);
        }];
    }else if (self.repeatStrs.count == 0) {
        [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"闹钟时间到，主人该起床了!" subTitle:nil body:nil sound:[UNNotificationSound soundNamed:self.music]] dateComponents:[UNNotificationsManager componentsWithDate:self.date] identifer:self.identifer isRepeat:self.repeats completionHanler:^(NSError *error) {
            DRLog(@"add error %@", error);
        }];
    }else {
        [self.repeatStrs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger week = 0;
            if ([obj containsString:@"周日"]) {
                week = 1;
            }else if([obj containsString:@"周一"]){
                week = 2;
            }else if([obj containsString:@"周二"]){
                week = 3;
            }else if([obj containsString:@"周三"]){
                week = 4;
            }else if([obj containsString:@"周四"]){
                week = 5;
            }else if([obj containsString:@"周五"]){
                week = 6;
            }else if([obj containsString:@"周六"]){
                week = 7;
            }
            [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"闹钟时间到，主人该起床了!" subTitle:nil body:nil sound:[UNNotificationSound soundNamed:self.music]] weekDay:week date:self.date identifer:self.identifers[idx] isRepeat:YES completionHanler:^(NSError *error) {
         
            }];
        }];
    }
    
}

- (void)removeUserNotification {
    DRLog(@"关闭所有通知");
    [UNNotificationsManager removeNotificationWithIdentifer:@"shengxinaozhong"];
    [UNNotificationsManager removeAllNotification];

}

#pragma mark -- setter && getter
- (void)setDate:(NSDate *)date {
    _date = date;
    [self setDateForTimeClock];
}

//- (NSDate *)date {
//    if (!_date) {
//        NSDateFormatter *format = [self getFormatter];
//        NSString *dateStr = [NSString stringWithFormat:@"%@%@",_timeText, _timeClock];
//        _date = [format dateFromString:dateStr];
//    }
//    return _date;
//}

- (NSString *)identifer {
    if (!_identifer) {
        _identifer = @"shengxinaozhong";
    }
    return _identifer;
}

- (void)setRepeatStrs:(NSArray *)repeatStrs {
    
    _repeatStrs = repeatStrs;
    NSMutableArray *idenArray = [NSMutableArray array];
    NSMutableArray *repeatArray = [NSMutableArray array];//去掉“每“字
    [repeatStrs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [idenArray addObject:[self.identifer stringByAppendingString:obj]];
        [repeatArray addObject:[obj substringFromIndex:1]];
    }];
    _identifers = [idenArray copy];
    
    if (_repeatStrs.count > 0) {
        NSString *str = [repeatArray componentsJoinedByString:@""];
        _repeatStr = str;
        if (str.length == 14) {
            _repeatStr = @"每天";
        }else if ([str containsString:@"周日"] && [str containsString:@"周六"] && str.length == 4) {
            _repeatStr = @"周末";
        }else if (![str containsString:@"周日"] && ![str containsString:@"周六"] && str.length == 10) {
            _repeatStr = @"工作日";
        }

    }else {
        _repeatStr = @"永不";
    }
}

- (BOOL)repeats {
    if (self.repeatStrs.count <= 0) {
        return NO;
    }else {
        return YES;
    }
}

@end
