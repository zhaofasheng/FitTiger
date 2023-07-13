//
//  NoticeCalendarView.m
//  NoticeXi
//
//  Created by li lei on 2022/10/18.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeCalendarView.h"


#import "NSDate+GFCalendar.h"


@interface NoticeCalendarView()<UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic,strong)NSMutableArray *monthdataA;//当月的模型集合

@end

@implementation NoticeCalendarView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        self.currentMonthDate = [NSDate date];
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        
        [self setup];
    }
    return self;
}

- (void)dealDataWith:(NSDate *)date month:(LXCalendarMonthModel * __nullable)month{
    
    self.currentMonthDate = date;
    [self responData:month];
    if (month.daysModel.count) {
        self.netDataArr = month.daysModel;
    }
}

-(void)dealData{
    
    [self responData:nil];
}

-(void)setup{
    [self addSubview:self.calendarHeader];
    if(self.isCanTap){
        self.calendarWeekView.backgroundColor = [UIColor whiteColor];
    }
    [self addSubview:self.collectionView];
    [self addSubview:self.calendarWeekView];
    self.lx_height = self.collectionView.lx_bottom;
    
}
#pragma mark --左滑手势--
-(void)leftSwipe:(UISwipeGestureRecognizer *)swipe{
    
    [self leftSlide];
}

#pragma mark --左滑处理--
-(void)leftSlide{
    self.currentMonthDate = [self.currentMonthDate nextMonthDate];
    [self performAnimations:kCATransitionFromRight];
    [self responData:nil];
}

#pragma mark --右滑处理--
-(void)rightSlide{
    
    self.currentMonthDate = [self.currentMonthDate previousMonthDate];
    [self performAnimations:kCATransitionFromLeft];
    [self responData:nil];
}
#pragma mark --右滑手势--
-(void)rightSwipe:(UISwipeGestureRecognizer *)swipe{
   
    [self rightSlide];
}
#pragma mark--动画处理--
- (void)performAnimations:(NSString *)transition{
    CATransition *catransition = [CATransition animation];
    catransition.duration = 0.5;
    [catransition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    catransition.type = kCATransitionPush; //choose your animation
    catransition.subtype = transition;
    [self.collectionView.layer addAnimation:catransition forKey:nil];
}

#pragma mark--数据以及更新处理--
-(void)responData:(LXCalendarMonthModel *)month{

    [self.monthdataA removeAllObjects];
    
    NSDate *previousMonthDate = [self.currentMonthDate previousMonthDate];
    
//    NSDate *nextMonthDate = [self.currentMonthDate  nextMonthDate];
    
    LXCalendarMonthModel *monthModel = month?month: [[LXCalendarMonthModel alloc] initWithDate:self.currentMonthDate];
    self.currentMonthMondel = monthModel;
    
    LXCalendarMonthModel *lastMonthModel = [[LXCalendarMonthModel alloc] initWithDate:previousMonthDate];
    
    self.calendarHeader.dateStr = [NSString stringWithFormat:@"%ld-%02ld",monthModel.year,monthModel.month];
    
    NSInteger firstWeekday = monthModel.firstWeekday;
    
    NSInteger totalDays = monthModel.totalDays;

    self.calendarHeader.dateLabel.textColor = [UIColor colorWithHexString:@"#25262E"];
    
    for (int i = 0; i <42; i++) {
        
        LXCalendarDayModel *model =[[LXCalendarDayModel alloc]init];
        
        model.firstWeekday = firstWeekday;
        model.totalDays = totalDays;
        
        model.month = monthModel.month;
        model.year = monthModel.year;
        
        //上个月的日期
        if (i < firstWeekday) {
            model.day = lastMonthModel.totalDays - (firstWeekday - i) + 1;
            model.isLastMonth = YES;
        }
        
        //当月的日期
        if (i >= firstWeekday && i < (firstWeekday + totalDays)) {
            
            model.day = i -firstWeekday +1;
            model.isCurrentMonth = YES;
            
            //标识是今天
            if ((monthModel.month == [[NSDate date] dateMonth]) && (monthModel.year == [[NSDate date] dateYear])) {
                if (i == [[NSDate date] dateDay] + firstWeekday - 1) {
                    self.calendarHeader.dateLabel.textColor = [UIColor colorWithHexString:@"#2E66FF"];
                    model.isToday = YES;
                    self.choiceDay = model;
             
                    if(self.isFirstIn){
                        self.oldDay.choiceEd = NO;
                        model.choiceEd = YES;
                        self.oldDay = model;
                        self.choiceDay = model;
                        if (self.choiceBlock) {
                            self.choiceBlock(self.choiceDay);
                        }
                        self.isFirstIn = NO;
                    }
                }
            }
        }
        
        if (monthModel.year > [[NSDate date] dateYear]) {//当前显示的月份大于今年年份
            model.isOverToday = YES;
            model.isOverCurrentMonth = YES;
        }else if(monthModel.year == [[NSDate date] dateYear]){//同一年比较月份
            if (monthModel.month > [[NSDate date] dateMonth]){//大于当前月份
                model.isOverToday = YES;
                model.isOverCurrentMonth = YES;
            }else if(monthModel.month == [[NSDate date] dateMonth]){//同一个月，比较天
                if (i > [[NSDate date] dateDay] + firstWeekday - 1) {
                    model.isOverToday = YES;
                }
            }
        }
        
         //下月的日期
        if (i >= (firstWeekday + monthModel.totalDays)) {
            model.day = i -firstWeekday - monthModel.totalDays +1;
            model.isNextMonth = YES;
        }
        [self.monthdataA addObject:model];
        
        
    }
    month.hasDays = YES;
    [self.collectionView reloadData];

}

- (void)setNetDataArr:(NSMutableArray *)netDataArr{
    _netDataArr = netDataArr;
    if (self.isCanTap && netDataArr.count) {
        if (self.choiceDay.isToday) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == %@",self.choiceDay.dayName];//谓词过滤查找数组中年份相同的数据,这里找到年份相同的数据 "yearName"为数组里面的属性值key，必须为字符串
            NSArray *sameYearArr = [self.netDataArr filteredArrayUsingPredicate:predicate];
            if (sameYearArr.count) {
                NoticeTieTieCaleModel *tModel = sameYearArr[0];
                self.choiceDay.collection = tModel.collection;
                self.choiceDay.voice = tModel.voice;
                self.choiceDay.img_url = tModel.img_url;
            }
        }
    }
 
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.monthdataA.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"cell";
    LXCalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.netDataArr = self.netDataArr;
    cell.isSmall = YES;
    cell.isCanTap = self.isCanTap;
    if (!cell) {
        cell =[[LXCalenderCell alloc]init];
    }
    cell.choiceModel = self.choiceDay;
    
    if (self.isCanTap) {
        cell.nomerModel = self.monthdataA[indexPath.row];
    }else{
        cell.smallModel = self.monthdataA[indexPath.row];
    }
    cell.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:self.isCanTap?0:1];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXCalendarDayModel *model = self.monthdataA[indexPath.row];
    if(!model.isCurrentMonth){
        return;
    }
    
    model.hNum = indexPath.row/7;
    model.hHeight = self.lx_width/7;
        
    self.oldDay.choiceEd = NO;
    model.choiceEd = YES;
    self.oldDay = model;
    self.choiceDay = model;
    if (self.choiceBlock) {
        self.choiceBlock(self.choiceDay);
    }
    [self.collectionView reloadData];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.calendarHeader.frame = CGRectMake(0, 0, self.lx_width, 40);
}
#pragma mark---懒加载
-(LXCalendarHearder *)calendarHeader{
    if (!_calendarHeader) {
        _calendarHeader =[[LXCalendarHearder alloc] initWithFrame:CGRectMake(0, 0, self.lx_width,40)];
        _calendarHeader.isShowLeftAndRightBtn = NO;
        _calendarHeader.dateLabel.textAlignment = NSTextAlignmentLeft;
        _calendarHeader.backgroundColor =[UIColor colorWithHexString:@"#F7F8FC"];
    }
    return _calendarHeader;
}

-(LXCalendarWeekView *)calendarWeekView{
    if (!_calendarWeekView) {
        _calendarWeekView =[[LXCalendarWeekView alloc]initWithFrame:CGRectMake(0, self.calendarHeader.lx_bottom, self.lx_width, 40)];
        _calendarWeekView.isCanTap = self.isCanTap;
        if (!self.isCanTap) {
            _calendarWeekView.weekTitles = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        }
        
    }
    return _calendarWeekView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
        //325*403
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 0;
        flow.sectionInset =UIEdgeInsetsMake(0 , 0, 0, 0);
    
        flow.itemSize = CGSizeMake(self.lx_width/7,self.lx_width/7);
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, self.calendarWeekView.lx_bottom, self.lx_width, 6 * (self.lx_width/7)) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = YES;
        _collectionView.userInteractionEnabled = self.isCanTap;
        _collectionView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:self.isCanTap?0:1];
        [_collectionView registerClass:[LXCalenderCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (void)setIsCanTap:(BOOL)isCanTap{
    _isCanTap = isCanTap;
    self.collectionView.userInteractionEnabled = isCanTap;
    if (isCanTap) {
        self.collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.calendarHeader.backgroundColor = self.collectionView.backgroundColor;
        [self.calendarHeader removeFromSuperview];
        self.backgroundColor = self.collectionView.backgroundColor;
        _calendarWeekView.backgroundColor = self.collectionView.backgroundColor;
        self.calendarWeekView.frame = CGRectMake(0, 0, self.lx_width, 40);
        self.collectionView.frame = CGRectMake(0,self.calendarWeekView.lx_bottom, self.lx_width, 6 * (self.lx_width/7));
    }
}

-(NSMutableArray *)monthdataA{
    if (!_monthdataA) {
        _monthdataA =[NSMutableArray array];
    }
    return _monthdataA;
}


@end
