//
//  NoticeTieTieRliDayVoiceController.h
//  NoticeXi
//
//  Created by li lei on 2023/7/13.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LXCalendarMonthModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTieTieRliDayVoiceController : BaseTableViewController
-(void)refreshCal:(LXCalendarMonthModel * _Nonnull)month  date:(NSDate * _Nonnull)date;
@property (nonatomic, assign) BOOL ismonthVoice;
@property (nonatomic, strong) NSString *visibility;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;
- (void)refreshData;
@end

NS_ASSUME_NONNULL_END
