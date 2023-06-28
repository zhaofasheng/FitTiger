//
//  NoticeClockDayChoice.h
//  NoticeXi
//
//  Created by li lei on 2019/11/5.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeClockDayChoice : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *day1;
@property (nonatomic, strong) NSString *day2;
@property (nonatomic, strong) NSString *day3;
@property (nonatomic, strong) NSString *day4;
@property (nonatomic, strong) NSString *day5;
@property (nonatomic, strong) NSString *day6;
@property (nonatomic, strong) NSString *day7;

@property (nonatomic,copy) void (^daysBlock)(NSString *day1,NSString *day2,NSString *day3,NSString *day4,NSString *day5,NSString *day6,NSString *day7);
- (void)showDayView;
@end

NS_ASSUME_NONNULL_END
