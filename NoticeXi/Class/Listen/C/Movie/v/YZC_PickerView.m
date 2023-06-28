//
//  YZC_PickerView.m
//  YiZuChe
//
//  Created by 赵发生 on 16/7/23.
//  Copyright (c) 2016年 赵发生. All rights reserved.
//

/*
 
 宜租车专属封装 YiZuChe
 
 */

#import "YZC_PickerView.h"
// 根据字符串获取日期
#define Time2Date(_dateStr_, _formatStr_)       [XCDateFormatUtil getDateWithTime:_dateStr_ Formatter:_formatStr_]
static YZC_PickerView * picker = nil;

@implementation YZC_PickerView
{
    __weak IBOutlet UIButton *sureBtn;
    IBOutlet UIPickerView * _pickerView;
    IBOutlet UILabel * _alertLB;
    
    __weak IBOutlet UIView *_selectView;
    __weak IBOutlet UIView *DownView;
    __weak IBOutlet UIButton *cancenBtn;
    NSInteger years;            //年
    NSInteger months;           //月
    NSInteger days;             //日
    NSInteger hours;
    NSInteger countIndex;
    NSInteger returnMonth;//dataThree返回的月份
    BOOL haveGet;
    BOOL notNow;
    BOOL NoRemove;
    
    NSMutableArray *_yearArray;
    NSMutableArray *_mothArray;
    NSMutableArray *_dayArray ;
    UIView *_view;
    
    NSString * _returnYears;
    NSString * _returnMonths;
    NSString * _monthDays;
    NSInteger currentYear;
    NSInteger currentMonth;
    NSInteger currentDay;
    NSString * _choiceYear;
    NSString * _choiceMonth;
    NSString * _choiceDay;
    NSInteger _monthForDays;
}

+ (YZC_PickerView *)shared
{
    picker = [[YZC_PickerView alloc] init];
    return picker;
}

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"YZC_PickerView" owner:self options:nil] firstObject];
    self.frame = [[UIScreen mainScreen] bounds];
   
    self.alpha = 1;
    NoRemove = YES;
    self.window = [UIApplication sharedApplication].keyWindow;
    
    //取得当前的年月日
    years = [[ZFSDateFormatUtil nowDateCmp] year];
    months = [[ZFSDateFormatUtil nowDateCmp] month];
    days = [[ZFSDateFormatUtil nowDateCmp] day];
    self.nowYear = years;
    //获取当前时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString * NowTime = [formatter stringFromDate:[NSDate date]];
    self.startTime = [NowTime integerValue];
    self.endTime = 23;
  
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;

    _alertLB.backgroundColor = GetColorWithName(VBackColor);
    
    //选中颜色
    _selectView.layer.borderColor = GetColorWithName(VBackColor).CGColor;
    _selectView.layer.borderWidth = 1;
    _pickerView.backgroundColor = GetColorWithName(VBackColor);
    DownView.backgroundColor = GetColorWithName(VBackColor);
    _selectView.backgroundColor = GetColorWithName(VBackColor);
    cancenBtn.backgroundColor = GetColorWithName(VBackColor);
    [cancenBtn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
    sureBtn.backgroundColor = cancenBtn.backgroundColor;
    [sureBtn setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
    
    UIView *mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 42)];
    mView.backgroundColor = GetColorWithName(VBackColor);
    [DownView addSubview:mView];
    [DownView bringSubviewToFront:cancenBtn];
    [DownView bringSubviewToFront:sureBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor = GetColorWithName(VlineColor);
   // [DownView addSubview:line];
    return self;
}
#pragma mark - dataSource
-(void)initData{
    //86400 这个是每一天的数值
    NSArray *array = [ZFSDateFormatUtil getsystemtime];//获取系统当前时间
    self.model = [[ZFSPickerModel alloc]init];
    self.model.year = array[0];
    self.model.moth = array[1];
    self.model.day = array[2];
    _yearArray = [NSMutableArray array];
    NSString *yearSystem = array[0];
    int yearCount = [yearSystem intValue];
    for (int i = BEGINYEAR; i<yearCount+81; i++) {
        NSString *year = [NSString stringWithFormat:@"%d",i];
        [_yearArray addObject:year];
    }
    _mothArray = [NSMutableArray array];
    for (int i = 1; i<13; i++) {
        NSString *moth = [NSString stringWithFormat:@"%d",i];
        [_mothArray addObject:moth];
    }
    _dayArray = [NSMutableArray array];
    for (int i = 1; i<32; i++) {
        NSString *day = [NSString stringWithFormat:@"%d",i];
        [_dayArray addObject:day];
    }
    NSArray *array1 = [ZFSDateFormatUtil getsystemtime];
    NSString  *yearRow = array1[0];
    int year = [yearRow intValue]-BEGINYEAR;
    
    NSString *mothStr = array1[1];
    int moth = [mothStr intValue];
    
    NSString *dayStr = array1[2];
    int day = [dayStr intValue];
    
    //  设置默认选中日期
    [_pickerView selectRow:year inComponent:0 animated:YES];
    [_pickerView selectRow:(moth-1) inComponent:1 animated:YES];
    [_pickerView selectRow:(day-1) inComponent:2 animated:YES];
    
    
    //如果需要保存上一次的选择时间,则打开这里,否则关闭以下代码
    if (self.lastTimeYear) {
        [_pickerView selectRow:(self.lastTimeDay-1) inComponent:2 animated:YES];
        [_pickerView selectRow:(self.lastTimeYear - BEGINYEAR) inComponent:0 animated:YES];
        [_pickerView selectRow:(self.lastTimeMonth-1) inComponent:1 animated:YES];
    }
    
}


//- (void)setLastTimeDay:(NSInteger)lastTimeDay{
//    
//    [_pickerView selectRow:(lastTimeDay-1) inComponent:2 animated:YES];
//    
//}
//
//- (void)setLastTimeYear:(NSInteger)lastTimeYear{
//    
//    [_pickerView selectRow:lastTimeYear inComponent:0 animated:YES];
//}
//
//- (void)setLastTimeMonth:(NSInteger)lastTimeMonth{
//    
//    [_pickerView selectRow:(lastTimeMonth-1) inComponent:1 animated:YES];
//    
//}

#pragma mark - pickerView
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //行  这里根据picker样式设置返回多少行
    
    if (_pickerViewStyleType == YZCPickerViewStyleDateThree){//年月日返回的行数
    
        if (component==0) {
            return  _yearArray.count;
        } else if(component==1){
            
            return  _mothArray.count;
        }
        NSInteger year = [pickerView selectedRowInComponent:0] + BEGINYEAR;
        NSInteger month = [pickerView selectedRowInComponent:1] +1;
        
        return [ZFSDateFormatUtil getDayCountYear:year Month:month];
    }
    if (_pickerViewStyleType == YZCPickerViewStyleSex) {//性别返回的行数
        
        return [SEXARR count];
    }
    else{
        return 0;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //列 根据picker类型返回每一行的列数
   if (_pickerViewStyleType == YZCPickerViewStyleDateThree) {//年月日返回的列数
        return 3;
    }
    if (_pickerViewStyleType == YZCPickerViewStyleSex) {//性别返回的列数
        return 1;
    }
   else{
        return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_pickerView reloadAllComponents];
    //选中 根据样式,设置返回值,返回在代理方法中
  if (_pickerViewStyleType == YZCPickerViewStyleDateThree) {
        
        if (component==0) {
            
            self.model.year = [_yearArray objectAtIndex:row];
        }
        
        if (component==1) {
            
            self.model.moth = [_mothArray objectAtIndex:row];
        }
        if (component==2) {
            
            self.model.day = [_dayArray objectAtIndex:row];
        }
    }
    
    UILabel * label = (UILabel *)[pickerView viewForRow:row forComponent:component];
    //选中文字的颜色
    label.textColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
}
//每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    //根据picker样式返回每一列的宽度
  
    if (_pickerViewStyleType == YZCPickerViewStyleDateThree) {
        return DR_SCREEN_WIDTH / 3;
    }
    
    if (_pickerViewStyleType == YZCPickerViewStyleSex) {
        return DR_SCREEN_WIDTH;
    }
  
    else {
        return 0;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    if (NoRemove) {
        for (UIView *view in _pickerView.subviews) {//分割线颜色设置
            
            if (view.frame.size.height < 2) {//判断是否是中间分割线
                UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,1)];
                view2.backgroundColor = GetColorWithName(VlineColor);
                [view addSubview:view2];
                view.backgroundColor = [UIColor clearColor];
            }
        }
    }
    NoRemove = NO;
    UILabel * label = (UILabel *)view;
    
    //设置文字格式
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
     
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];//常规颜色
        label.textAlignment = NSTextAlignmentCenter;
    }if (_pickerViewStyleType == YZCPickerViewStyleDateThree) {
        switch (component) {
            case 0:{
              
                label.text = [NSString stringWithFormat:@"%@年",[_yearArray objectAtIndex:row]];
            }
                break;
            case 1:{
                
                label.text = [NSString stringWithFormat:@"%@月", [_mothArray objectAtIndex:row]];
                
            }
                break;
            case 2:{
     
                label.text = [NSString stringWithFormat:@"%@日",[_dayArray objectAtIndex:row]];
            }
                break;
                
            default:
                break;
        }
    }
    if (_pickerViewStyleType == YZCPickerViewStyleSex) {
        switch (row) {
            case 0:{
                
                label.text = @"男";
            }
                break;
            case 1:{
                
                label.text = @"女";
                
            }
                break;
            default:
                break;
        }
    }
    return label;
}


- (void)show
{
    if (_pickerViewStyleType == YZCPickerViewStyleDateThree) {
        [self initData];
    }
    [_pickerView reloadAllComponents];
    dispatch_async(dispatch_get_main_queue(), ^{
        //放在主线程中
        if (self.window) {
            [self.window addSubview:self];
        }
        
    });
    
    if (self.alpha == 0)
    {
        NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
        [UIView animateWithDuration:0.25 delay:0 options:options animations:^{
            self.alpha = 1;
            self.hidden = NO;
        }
                         completion:^(BOOL finished) {
        }];
    }

}


- (void)disMiss
{
    if (self.alpha == 1)
    {
        NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
        [UIView animateWithDuration:0.25 delay:0 options:options animations:^{
            self.alpha = 0;
        }
                         completion:^(BOOL finished) {
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    }
}





#pragma mark - action
- (IBAction)offOnClick:(id)sender {
    //取消
    [self disMiss];
}

- (IBAction)doneOnClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(backWeakPickerView:year: style:)]) {
        [self.delegate backWeakPickerView:_pickerView year:years style:_pickerViewStyleType];
    }
    [self disMiss];
}

@end
