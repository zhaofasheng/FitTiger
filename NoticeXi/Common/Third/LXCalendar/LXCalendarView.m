//
//  LXCalendarView.m
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXCalendarView.h"
#import "LXCalendarHearder.h"
#import "LXCalendarWeekView.h"
#import "LXCalenderCell.h"
#import "LXCalendarMonthModel.h"
#import "NSDate+GFCalendar.h"
#import "LXCalendarDayModel.h"

#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeTieTieTosat.h"
#import "NoticeVoiceGroundController.h"
@interface LXCalendarView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)LXCalendarHearder *calendarHeader; //头部
@property(nonatomic,strong)LXCalendarWeekView *calendarWeekView;//周
@property(nonatomic,strong)UICollectionView *collectionView;//日历
@property(nonatomic,strong)NSMutableArray *monthdataA;//当月的模型集合
@property(nonatomic,strong)NSDate *currentMonthDate;//当月的日期
@property(nonatomic,strong)UISwipeGestureRecognizer *leftSwipe;//左滑手势
@property(nonatomic,strong)UISwipeGestureRecognizer *rightSwipe;//右滑手势
@property(nonatomic,strong)LXCalendarDayModel *selectModel;
@property (nonatomic, strong) NoticeTieTieModel *currentTieTieModel;
@property (nonatomic, strong) NoticeTieTieTosat *tosatView;

@end

@implementation LXCalendarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.currentMonthDate = [NSDate date];

        
        [self setup];
    }
    return self;
}
-(void)dealData{
    
    
    [self responData];
}

-(void)setup{
    [self addSubview:self.calendarHeader];
    __weak __typeof(self) weakSelf = self;
    
    self.calendarHeader.leftClickBlock = ^{
        [weakSelf rightSlide];
    };
    
    self.calendarHeader.rightClickBlock = ^{
        [weakSelf leftSlide];
    };
    
    [self addSubview:self.calendarWeekView];
    
    [self addSubview:self.collectionView];
    
    self.lx_height = self.collectionView.lx_bottom;
    
    //添加左滑右滑手势
    self.leftSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.collectionView addGestureRecognizer:self.leftSwipe];
    
    self.rightSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.collectionView addGestureRecognizer:self.rightSwipe];
}
#pragma mark --左滑手势--
-(void)leftSwipe:(UISwipeGestureRecognizer *)swipe{
    
    [self leftSlide];
}
#pragma mark --左滑处理--
-(void)leftSlide{
    self.currentMonthDate = [self.currentMonthDate nextMonthDate];
    [self performAnimations:kCATransitionFromRight];
    [self responData];
}
#pragma mark --右滑处理--
-(void)rightSlide{
    
    LXCalendarMonthModel *monthModel = [[LXCalendarMonthModel alloc]initWithDate:[self.currentMonthDate previousMonthDate]];
    
    if (monthModel.year == 2022 && monthModel.month < 4) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        if ([NoticeTools getLocalType] == 1) {
            [nav.topViewController showToastWithText:@"None "];
        }else if ([NoticeTools getLocalType] == 2){
            [nav.topViewController showToastWithText:@"すでにトップ"];
        }else{
            [nav.topViewController showToastWithText:@"到顶啦~"];
        }
        
        return;
    }
    
    self.currentMonthDate = [self.currentMonthDate previousMonthDate];
    [self performAnimations:kCATransitionFromLeft];
    [self responData];
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
-(void)responData{
    self.currentTieTieModel = nil;
    [self.monthdataA removeAllObjects];
    
    NSDate *previousMonthDate = [self.currentMonthDate previousMonthDate];
    
//    NSDate *nextMonthDate = [self.currentMonthDate  nextMonthDate];
    
    LXCalendarMonthModel *monthModel = [[LXCalendarMonthModel alloc]initWithDate:self.currentMonthDate];
    
    LXCalendarMonthModel *lastMonthModel = [[LXCalendarMonthModel alloc]initWithDate:previousMonthDate];
    
    self.calendarHeader.dateStr = [NSString stringWithFormat:@"%ld-%02ld",monthModel.year,monthModel.month];
    
    NSInteger firstWeekday = monthModel.firstWeekday;
    
    NSInteger totalDays = monthModel.totalDays;

    for (int i = 0; i <42; i++) {
        
        LXCalendarDayModel *model =[[LXCalendarDayModel alloc]init];
        model.number = @"0";
        //配置外面属性
        [self configDayModel:model];
        
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
                    
                    model.isToday = YES;
                    
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
    
    [self.collectionView reloadData];
    //当前选择月份补大于当前月份
    if ((monthModel.month <= [[NSDate date] dateMonth]) && (monthModel.year <= [[NSDate date] dateYear])) {
        [self request:[NSString stringWithFormat:@"%ld-%02ld",monthModel.year,monthModel.month] month:monthModel];
    }
    if ((monthModel.month == [[NSDate date] dateMonth]) && (monthModel.year == [[NSDate date] dateYear])) {//当前月份的时候才显示
        if (self.showTosatBlock) {
            self.showTosatBlock(NO);
        }
    }else{
        if (self.showTosatBlock) {
            self.showTosatBlock(YES);
        }
    }
}

- (void)request:(NSString *)dateStr month:(LXCalendarMonthModel *)monthModel{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voiceCollection/getSignData?month=%@",dateStr] Accept:@"application/vnd.shengxi.v5.3.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.currentTieTieModel = [NoticeTieTieModel mj_objectWithKeyValues:dict[@"data"]];
            if (self.currentTieTieModel.list.count) {
                [self.collectionView reloadData];
            }
            if ((monthModel.month == [[NSDate date] dateMonth]) && (monthModel.year == [[NSDate date] dateYear])) {//当前月份的时候才显示
                if (self.showTosatBlock) {
                    self.showTosatBlock(NO);
                }
                if (self.contentTosatBlock) {
                    self.contentTosatBlock(self.currentTieTieModel.allTextAttStr,self.currentTieTieModel.textHeight);
                }
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

-(void)configDayModel:(LXCalendarDayModel *)model{
    
    //配置外面属性
    model.isHaveAnimation = self.isHaveAnimation;
    model.currentMonthTitleColor = self.currentMonthTitleColor;
    model.lastMonthTitleColor = self.lastMonthTitleColor;
    model.nextMonthTitleColor = self.nextMonthTitleColor;
    model.selectBackColor = self.selectBackColor;
    model.isHaveAnimation = self.isHaveAnimation;
    model.todayTitleColor = self.todayTitleColor;
    model.isShowLastAndNextDate = self.isShowLastAndNextDate;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.monthdataA.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"cell";
    LXCalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    if (!cell) {
        cell =[[LXCalenderCell alloc]init];
    }
    cell.currentTieTieModel = self.currentTieTieModel;
    cell.model = self.monthdataA[indexPath.row];

    cell.backgroundColor =[UIColor colorWithHexString:@"#F7F8FC"];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    LXCalendarDayModel *model = self.monthdataA[indexPath.row];
  
    if (model.isOverToday || (model.isToday && !model.number.intValue)) {
        if (self.currentTieTieModel) {
            self.tosatView.titleL.text = self.currentTieTieModel.futureModel.title;
            [self.tosatView.imageView sd_setImageWithURL:[NSURL URLWithString:self.currentTieTieModel.futureModel.cover_url]];
            [self.tosatView show];
        }
     
    }else{
        if (model.number.intValue) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
            NoticeVoiceGroundController *ctl = [[NoticeVoiceGroundController alloc] init];
            ctl.isDate = YES;
            ctl.date = [NSString stringWithFormat:@"%ld-%02ld-%02ld",model.year,model.month,model.day];
            CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                            withSubType:kCATransitionFromLeft
                                                                               duration:0.3f
                                                                         timingFunction:kCAMediaTimingFunctionLinear
                                                                                   view:nav.topViewController.navigationController.view];
            [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        }else{
            if (self.currentTieTieModel) {
                self.tosatView.titleL.text = self.currentTieTieModel.pastModel.title;
                [self.tosatView.imageView sd_setImageWithURL:[NSURL URLWithString:self.currentTieTieModel.pastModel.cover_url]];
                [self.tosatView show];
            }
        }
    }

}

- (NoticeTieTieTosat *)tosatView{
    if (!_tosatView) {
        _tosatView = [[NoticeTieTieTosat alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _tosatView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.calendarHeader.frame = CGRectMake(0, 0, self.lx_width, 50);
}
#pragma mark---懒加载
-(LXCalendarHearder *)calendarHeader{
    if (!_calendarHeader) {
        _calendarHeader =[[LXCalendarHearder alloc] initWithFrame:CGRectMake(0, 0, self.lx_width, 50)];
        _calendarHeader.backgroundColor =[UIColor colorWithHexString:@"#F7F8FC"];
    }
    return _calendarHeader;
}
-(LXCalendarWeekView *)calendarWeekView{
    if (!_calendarWeekView) {
        _calendarWeekView =[[LXCalendarWeekView alloc]initWithFrame:CGRectMake(0, self.calendarHeader.lx_bottom, self.lx_width, 50)];
        if ([NoticeTools getLocalType] == 1) {
            _calendarWeekView.weekTitles = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
        }else if([NoticeTools getLocalType] == 2){
            _calendarWeekView.weekTitles = @[@"日曜",@"月曜",@"火曜",@"水曜",@"木曜",@"金曜",@"土曜"];
        }else{
            _calendarWeekView.weekTitles = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
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
    
        flow.itemSize = CGSizeMake(self.lx_width/7,self.lx_width/7+20);
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, self.calendarWeekView.lx_bottom, self.lx_width, 6 * (self.lx_width/7+20)) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = YES;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [_collectionView registerClass:[LXCalenderCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
-(NSMutableArray *)monthdataA{
    if (!_monthdataA) {
        _monthdataA =[NSMutableArray array];
    }
    return _monthdataA;
}

/*
 * 当前月的title颜色
 */
-(void)setCurrentMonthTitleColor:(UIColor *)currentMonthTitleColor{
    _currentMonthTitleColor = currentMonthTitleColor;
}

/*
 * 上月的title颜色
 */
-(void)setLastMonthTitleColor:(UIColor *)lastMonthTitleColor{
    _lastMonthTitleColor = lastMonthTitleColor;
}

/*
 * 下月的title颜色
 */
-(void)setNextMonthTitleColor:(UIColor *)nextMonthTitleColor{
    _nextMonthTitleColor = nextMonthTitleColor;
}

/*
 * 选中的背景颜色
 */
-(void)setSelectBackColor:(UIColor *)selectBackColor{
    _selectBackColor = selectBackColor;
}

/*
 * 选中的是否动画效果
 */

-(void)setIsHaveAnimation:(BOOL)isHaveAnimation{
    
    _isHaveAnimation  = isHaveAnimation;
}

/*
 * 是否禁止手势滚动
 */
-(void)setIsCanScroll:(BOOL)isCanScroll{
    _isCanScroll = isCanScroll;
    
    self.leftSwipe.enabled = self.rightSwipe.enabled = isCanScroll;
}

/*
 * 是否显示上月，下月的按钮
 */

-(void)setIsShowLastAndNextBtn:(BOOL)isShowLastAndNextBtn{
    _isShowLastAndNextBtn  = isShowLastAndNextBtn;
    self.calendarHeader.isShowLeftAndRightBtn = isShowLastAndNextBtn;
}


/*
 * 是否显示上月，下月的的数据
 */
-(void)setIsShowLastAndNextDate:(BOOL)isShowLastAndNextDate{
    _isShowLastAndNextDate =  isShowLastAndNextDate;
}
/*
 * 今日的title颜色
 */

-(void)setTodayTitleColor:(UIColor *)todayTitleColor{
    _todayTitleColor = todayTitleColor;
}
@end
