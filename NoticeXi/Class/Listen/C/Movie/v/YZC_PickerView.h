//
//  YZC_PickerView.h
//  YiZuChe
//
//  Created by 赵发生 on 16/7/23.
//  Copyright (c) 2016年 赵发生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFSDateFormatUtil.h"
#import "ZFSPickerModel.h"

#define SEXARR @[@"男", @"女"]
#define BEGINYEAR 1888 //开始显示的年份

/**************************************************************
 *
 * 对pickerView封装 宜租车专属(赵发生)
 *
 **************************************************************/

/**
这里是枚举值,根据需求,选择要显示的控件样式,里面有些样式没有做,可以自行添加
 */
typedef NS_ENUM(NSUInteger, YZCPickerViewStyleType)
{
    YZCPickerViewStyleDateThree,//年月日
    YZCPickerViewStyleSex//性别
};

@protocol pickerDelegate <NSObject>

@optional
- (void)backWeakPickerView:(UIPickerView *)picker year:(NSInteger)nowyear style:(YZCPickerViewStyleType)pickerStyle;

@end

@interface YZC_PickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) ZFSPickerModel *model ;
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) NSInteger returnDays;

@property (nonatomic) NSInteger nowYear;

@property (assign, nonatomic) YZCPickerViewStyleType pickerViewStyleType;

@property (weak, nonatomic) id <pickerDelegate> delegate;

@property (nonatomic) NSInteger startTime;
@property (nonatomic) NSInteger endTime;

/*
 *
 * 如果需要设置显示上一次显示的值,则在调用该视图时,用点语法传入年月日即可
 *
 */
@property (nonatomic) NSInteger lastTimeYear;//传入上一次显示的值
@property (nonatomic) NSInteger lastTimeMonth;//传入上一次显示的值
@property (nonatomic) NSInteger lastTimeDay;//传入上一次显示的值

+ (YZC_PickerView *)shared;

- (void)show;

@end
