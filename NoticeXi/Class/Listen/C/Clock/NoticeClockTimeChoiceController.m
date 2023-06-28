//
//  NoticeClockTimeChoiceController.m
//  NoticeXi
//
//  Created by li lei on 2019/10/24.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeClockTimeChoiceController.h"
#import "NoticeLabelAndSwitchCell.h"
#import "NoticeClockDayChoice.h"
@interface NoticeClockTimeChoiceController ()<UIPickerViewDelegate,UIPickerViewDataSource,SwitchChoiceDelegate>
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIPickerView *pickerMinView;
@property (nonatomic, strong) NSArray *hourArrary;
@property (nonatomic, strong) NSArray *minArrary;
@property (nonatomic, strong) NoticeClockDayChoice *dayChoiceView;
@property (nonatomic, strong) NSString *repeatString;
@end

@implementation NoticeClockTimeChoiceController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;//关闭右滑返回
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools isSimpleLau]?@"闹钟设定":@"鬧鐘設定";
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 45, 25);
    [btn setTitle:[NoticeTools getLocalStrWith:@"groupManager.save"] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
    btn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(fifinshClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 45, 25);
    [btn1 setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
    btn1.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    [btn1 setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
    btn1.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [btn1 addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    if (!self.setModel) {
       self.setModel = [[NoticeColockSetModel alloc] init];
    }
    
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[NoticeLabelAndSwitchCell class] forCellReuseIdentifier:@"cell2"];
    self.tableView.rowHeight = 65;
    
    self.hourArrary = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"];
    self.minArrary = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 205+75)];
    headerView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableHeaderView = headerView;
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake((DR_SCREEN_WIDTH-100-65*2)/2,35,65, 205)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [headerView addSubview:self.pickerView];
    
    UILabel *hourL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pickerView.frame), 35+(205-12)/2-10, 12, 12)];
    hourL.text = [NoticeTools isSimpleLau]?@"时":@"時";
    hourL.textColor = GetColorWithName(VMainThumeColor);
    hourL.font = TWOTEXTFONTSIZE;
    [headerView addSubview:hourL];
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *curHour = self.setModel?self.setModel.hour : [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"HH"];
    NSInteger curSelHour = 0;
    NSInteger i = 0;
    for (NSString *strHour in self.hourArrary) {
        if (strHour.integerValue == curHour.integerValue) {
            curSelHour = i;
            break;
        }
        i++;
    }
    
    [self.pickerView selectRow:curSelHour inComponent:0 animated:YES];
    self.setModel.hour = self.hourArrary[curSelHour];
    
    self.pickerMinView = [[UIPickerView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.pickerView.frame)+100,35,65, 205)];
    self.pickerMinView.delegate = self;
    self.pickerMinView.dataSource = self;
    [headerView addSubview:self.pickerMinView];
    
    UILabel *minL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pickerMinView.frame), 35+(205-12)/2-10, 12, 12)];
     minL.text = @"分";
     minL.textColor = GetColorWithName(VMainThumeColor);
     minL.font = TWOTEXTFONTSIZE;
     [headerView addSubview:minL];
    
    NSString *curMin = self.setModel?self.setModel.min : [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"mm"];
    NSInteger curSelMin = 0;
    NSInteger j = 0;
    for (NSString *strMin in self.minArrary) {
        if (strMin.integerValue == curMin.integerValue) {
            curSelMin = j;
            break;
        }
        j++;
    }
    [self.pickerMinView selectRow:curSelMin inComponent:0 animated:YES];
    self.setModel.min = self.minArrary[curSelMin];
    
    self.repeatString = @"永不";
    
    
    if (self.setModel) {
        self.setModel.day7 = self.setModel.day7;
        self.setModel.day6 = self.setModel.day6;
        self.setModel.day5 = self.setModel.day5;
        self.setModel.day4 = self.setModel.day4;
        self.setModel.day3 = self.setModel.day3;
        self.setModel.day2 = self.setModel.day2;
        self.setModel.day1 = self.setModel.day1;
        if (self.setModel.day6.integerValue && self.setModel.day7.integerValue && !self.setModel.day5.integerValue && !self.setModel.day4.integerValue && !self.setModel.day3.integerValue && !self.setModel.day2.integerValue && !self.setModel.day1.integerValue) {
            self.repeatString = @"周末";
        }else if (self.setModel.day6.integerValue && self.setModel.day7.integerValue && self.setModel.day5.integerValue && self.setModel.day4.integerValue && self.setModel.day3.integerValue && self.setModel.day2.integerValue && self.setModel.day1.integerValue){
            self.repeatString = @"每天";
        }else if (!self.setModel.day6.integerValue && !self.setModel.day7.integerValue && self.setModel.day5.integerValue && self.setModel.day4.integerValue && self.setModel.day3.integerValue && self.setModel.day2.integerValue && self.setModel.day1.integerValue){
            self.repeatString = @"工作日";
        }else if (!self.setModel.day6.integerValue && !self.setModel.day7.integerValue && !self.setModel.day5.integerValue && !self.setModel.day4.integerValue && !self.setModel.day3.integerValue && !self.setModel.day2.integerValue && !self.setModel.day1.integerValue){
            self.repeatString = @"永不";
        }
        else{
            self.repeatString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",self.setModel.day1.integerValue?@"周一 ":@"",self.setModel.day2.integerValue?@"周二 ":@"",self.setModel.day3.integerValue?@"周三 ":@"",self.setModel.day4.integerValue?@"周四 ":@"",self.setModel.day5.integerValue?@"周五 ":@"",self.setModel.day6.integerValue?@"周六 ":@"",self.setModel.day7.integerValue?@"周日 ":@""];
            if (self.repeatString.length > 1) {
                self.repeatString = [self.repeatString substringToIndex:self.repeatString.length-1];
            }
        }
        [self.tableView reloadData];
    }
    
    __weak typeof(self) weakSelf = self;
    self.dayChoiceView = [[NoticeClockDayChoice alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.dayChoiceView.daysBlock = ^(NSString * _Nonnull day1, NSString * _Nonnull day2, NSString * _Nonnull day3, NSString * _Nonnull day4, NSString * _Nonnull day5, NSString * _Nonnull day6, NSString * _Nonnull day7) {
        weakSelf.setModel.day7 = day7;
        weakSelf.setModel.day6 = day6;
        weakSelf.setModel.day5 = day5;
        weakSelf.setModel.day4 = day4;
        weakSelf.setModel.day3 = day3;
        weakSelf.setModel.day2 = day2;
        weakSelf.setModel.day1 = day1;
        if (day6.integerValue && day7.integerValue && !day5.integerValue && !day4.integerValue && !day3.integerValue && !day2.integerValue && !day1.integerValue) {
            weakSelf.repeatString = @"周末";
        }else if (day6.integerValue && day7.integerValue && day5.integerValue && day4.integerValue && day3.integerValue && day2.integerValue && day1.integerValue){
            weakSelf.repeatString = @"每天";
        }else if (!day6.integerValue && !day7.integerValue && day5.integerValue && day4.integerValue && day3.integerValue && day2.integerValue && day1.integerValue){
            weakSelf.repeatString = @"工作日";
        }else if (!day6.integerValue && !day7.integerValue && !day5.integerValue && !day4.integerValue && !day3.integerValue && !day2.integerValue && !day1.integerValue){
            weakSelf.repeatString = @"永不";
        }
        else{
            weakSelf.repeatString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",day1.integerValue?@"周一 ":@"",day2.integerValue?@"周二 ":@"",day3.integerValue?@"周三 ":@"",day4.integerValue?@"周四 ":@"",day5.integerValue?@"周五 ":@"",day6.integerValue?@"周六 ":@"",day7.integerValue?@"周日 ":@""];
            if (weakSelf.repeatString.length > 1) {
               weakSelf.repeatString = [weakSelf.repeatString substringToIndex:weakSelf.repeatString.length-1];
            }
        }
        [weakSelf.tableView reloadData];
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.dayChoiceView showDayView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoticeTitleAndImageCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell1.mainL.text = [NoticeTools isSimpleLau]?@"重复":@"重復";
        cell1.mainL.frame = CGRectMake(18, 0,50, 65);
        cell1.subL.text = self.repeatString;
        cell1.subL.frame = CGRectMake(DR_SCREEN_WIDTH-15-9-10-(DR_SCREEN_WIDTH-10-15-9), 0,DR_SCREEN_WIDTH-10-15-9, 65);
        cell1.line.hidden = NO;
        cell1.line.frame = CGRectMake(15, 64, DR_SCREEN_WIDTH-30, 1);
        return cell1;
    }else{
        NoticeLabelAndSwitchCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell2.mainL.text = [NoticeTools isSimpleLau]?@"再睡一会":@"再睡壹會";
        cell2.mainL.frame = CGRectMake(18, 0,270, 65);
        cell2.delegate = self;
        cell2.choiceSection = indexPath.section;
        cell2.choiceTag = indexPath.row;
        [cell2.switchButton setOn:self.setModel.isLater.boolValue];
        return cell2;
    }
}

- (void)choiceTag:(NSInteger)tag withIsOn:(BOOL)isOn section:(NSInteger)section{
    self.setModel.isLater = isOn?@"1":@"0";
}

//返回有几列

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回指定列的行数

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.pickerView) {
        return  self.hourArrary.count;
    }
    return self.minArrary.count;
}

//返回指定列，行的高度，就是自定义行的高度

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return 40.0f;

}

//返回指定列的宽度

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

    return 65;

}

// 自定义指定列的每行的视图，即指定列的每行的视图行为一致

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 65, 40)];
    text.textAlignment = NSTextAlignmentCenter;
    if (pickerView == self.pickerView) {
        text.text = self.hourArrary[row];
    }else{
        text.text = self.minArrary[row];
    }
    text.textColor = GetColorWithName(VMainTextColor);
    text.font = [UIFont systemFontOfSize:40];
    [view addSubview:text];
    //隐藏上下直线
    [self.pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
    [self.pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor clearColor];
    [self.pickerMinView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
    [self.pickerMinView.subviews objectAtIndex:2].backgroundColor = [UIColor clearColor];
    return view;

}

//选择相应列表

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == self.pickerMinView) {
        self.setModel.min = self.minArrary[row];
    }else{
        self.setModel.hour = self.hourArrary[row];
    }
    UIView *piketV = (UIView *)[pickerView viewForRow:row forComponent:component];
    for (UIView *subV in piketV.subviews) {
        if ([subV isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subV;
            label.textColor = GetColorWithName(VMainThumeColor);
        }
    }
}

- (void)fifinshClick{
    
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"reveal"
                                                                     withSubType:kCATransitionFromBottom
                                                                        duration:0.3f
                                                                  timingFunction:kCAMediaTimingFunctionLinear
                                                                            view:self.navigationController.view];
     [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    if (self.setTimeBlock) {
        self.setTimeBlock(self.setModel);
    }
     [self.navigationController popViewControllerAnimated:NO];
}

- (void)cancelClick{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"reveal"
                                                                    withSubType:kCATransitionFromBottom
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController popViewControllerAnimated:NO];
}
@end
