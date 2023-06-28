//
//  CalenderModel.h
//  YZCCalender
//
//  Created by Jason on 2018/1/18.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalenderModel : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isWeek;
@property (nonatomic, strong) UIColor *activityColor;
@property (nonatomic, assign) BOOL isToday;
@property (nonatomic, assign) BOOL isCurrentYear;
@property (nonatomic, assign) BOOL isHasData;
@property (nonatomic, strong) NSString *allCalderName;
@property (nonatomic, strong) NSString *showTime;
@property (nonatomic, strong) NSString *voiceDay;
@property (nonatomic, strong) NSString *cover;
@end
