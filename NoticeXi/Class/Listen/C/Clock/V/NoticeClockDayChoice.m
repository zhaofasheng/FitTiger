//
//  NoticeClockDayChoice.m
//  NoticeXi
//
//  Created by li lei on 2019/11/5.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeClockDayChoice.h"
#import "NoticeClockDaysCell.h"
@implementation NoticeClockDayChoice
{
    NSArray *_dayArr;
    NSArray *_choiceArr;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UIView *disView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-591)];
        disView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissDayView)];
        [disView addGestureRecognizer:tap];
        [self addSubview:disView];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 591+10)];
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        self.contentView.layer.cornerRadius = 20;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, DR_SCREEN_WIDTH, 15)];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = XGFifthBoldFontSize;
        titleL.textColor = GetColorWithName(VMainTextColor);
        titleL.text = [NoticeTools isSimpleLau]?@"重复":@"重復";
        [self.contentView addSubview:titleL];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleL.frame)+16, DR_SCREEN_WIDTH, 63*7)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 63;
        [self.tableView registerClass:[NoticeClockDaysCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.tableView];
        self.tableView.backgroundColor = GetColorWithName(VBackColor);
        
        _dayArr =[NoticeTools getLocalType]?@[@"Sun",@"Mon",@"Tues",@"Wed",@"Thur",@"Fri",@"Sat"] : @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
        
        NSArray *buttonNameArr = @[[NoticeTools getLocalStrWith:@"main.cancel"],[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"sure.comgir"]:@"確認"];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-315)/2+165*i, CGRectGetMaxY(self.tableView.frame)+16, 150, 48)];
            button.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#B2B2B2"];
            if (i == 0) {
                [button setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#333333":@"#72727F"] forState:UIControlStateNormal];
            }else{
                [button setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
            }
            button.layer.cornerRadius = 24;
            button.layer.masksToBounds = YES;
            [button setTitle:buttonNameArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
        
        NoticeColockSetModel *model = [NoticeComTools getCloclSetModel];
        if (model) {
            self.day1 = model.day1.boolValue? @"1" : @"0";
            self.day2 = model.day2.boolValue? @"1" : @"0";
            self.day3 = model.day3.boolValue? @"1" : @"0";
            self.day4 = model.day4.boolValue? @"1" : @"0";
            self.day5 = model.day5.boolValue? @"1" : @"0";
            self.day6 = model.day6.boolValue? @"1" : @"0";
            self.day7 = model.day7.boolValue? @"1" : @"0";
        }else{
            self.day1 = self.day2 = self.day3 = self.day4 = self.day5 = self.day6 = self.day7 = @"0";
            
        }
        _choiceArr = @[self.day1,self.day2,self.day3,self.day4,self.day5,self.day6,self.day7];
        [self.tableView reloadData];
    }
    return self;
}

- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == 1) {
        if (self.daysBlock) {
            self.daysBlock(self.day1, self.day2, self.day3, self.day4, self.day5, self.day6, self.day7);
        }
    }
    [self dissDayView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = _choiceArr[indexPath.row];
    if (str.integerValue) {
        str = @"0";
    }else{
        str = @"1";
    }
    if (indexPath.row == 0) {
        self.day1 = str;
    }else if (indexPath.row == 1){
        self.day2 = str;
    }else if (indexPath.row == 2){
        self.day3 = str;
    }else if (indexPath.row == 3){
        self.day4 = str;
    }else if (indexPath.row == 4){
        self.day5 = str;
    }else if (indexPath.row == 5){
        self.day6 = str;
    }else if (indexPath.row == 6){
        self.day7 = str;
    }
    _choiceArr = @[self.day1,self.day2,self.day3,self.day4,self.day5,self.day6,self.day7];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dayArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeClockDaysCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.dayL.text = _dayArr[indexPath.row];
    if ([NoticeTools isWhiteTheme]) {
        cell.seleImageVeiw.image = [_choiceArr[indexPath.row] integerValue] ? UIImageNamed(@"Img_clock_selday") : UIImageNamed(@"Img_clock_seldayn");
    }else{
        cell.seleImageVeiw.image = [_choiceArr[indexPath.row] integerValue] ? UIImageNamed(@"Img_clock_seldayy") : UIImageNamed(@"Img_clock_seldayny");
    }
    
    return cell;
}

- (void)showDayView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
     [rootWindow addSubview:self];
     [UIView animateWithDuration:0.3 animations:^{
         self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-591, DR_SCREEN_WIDTH, 591+20);
         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
     }];
}

- (void)dissDayView{
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 591+20);
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
