//
//  NoticeAllTieTieController.m
//  NoticeXi
//
//  Created by li lei on 2022/10/19.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeAllTieTieController.h"
#import "NoticeRliCell.h"
#import "HQCollectionViewFlowLayout.h"
#import "ZFSDateFormatUtil.h"
#import "NSDate+GFCalendar.h"
#import "LXCalendarDayModel.h"

static NSString *const DRMerchantCollectionViewCellID = @"DRTILICollectionViewCell";

@interface NoticeAllTieTieController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *merchantCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) NSInteger todayIndex;
@property (nonatomic, strong) NSMutableArray *monthArr;

@end

@implementation NoticeAllTieTieController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView removeFromSuperview];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    self.dataArr = [[NSMutableArray alloc] init];
    self.monthArr = [[NSMutableArray alloc] init];
    
    NSDate *startDate = [ZFSDateFormatUtil getDateWithTime:userM.regTimeForMid Formatter:@"yyyy-MM-dd"];
    NSDate *endDate = [NSDate date];
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitMonth;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    
    LXCalendarMonthModel *todayMonth = [[LXCalendarMonthModel alloc] initWithDate:endDate];
    LXCalendarMonthModel *otherMonth = [[LXCalendarMonthModel alloc] initWithDate:startDate];
    if (otherMonth.year == todayMonth.year && otherMonth.month == todayMonth.month) {
        self.todayIndex = 0;
    }
    
    LXCalendarMonthModel *monthModel = [[LXCalendarMonthModel alloc] initWithDate:startDate];
    monthModel.yearName = [NSString stringWithFormat:@"%ld",monthModel.year];
    [self.monthArr addObject:monthModel];
    [self.dataArr addObject: startDate];
    if (delta.month > 0) {
        //打印
        for (int i = 0; i <= delta.month; i++) {
            NSDate *nextDate = [startDate nextMonthDate];
            [self.dataArr addObject:nextDate];
            LXCalendarMonthModel *monM = [[LXCalendarMonthModel alloc] initWithDate:nextDate];
            monM.yearName = [NSString stringWithFormat:@"%ld",monM.year];
            [self.monthArr addObject:monM];
            startDate = nextDate;
            
            LXCalendarMonthModel *nextMonth = [[LXCalendarMonthModel alloc] initWithDate:nextDate];
            if (nextMonth.year == todayMonth.year && nextMonth.month == todayMonth.month) {
                self.todayIndex = i;
            }
        }
    }

    [self initCollectionView];
    
    if (self.todayIndex < self.dataArr.count-1) {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:self.todayIndex inSection:0];
        [self.merchantCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }

    for (NSInteger i = otherMonth.year; i <= todayMonth.year; i++) {
        [self requestWithYear:[NSString stringWithFormat:@"%ld",i]];
    }
}

- (void)requestWithYear:(NSString *)year{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/voices/calendar?year=%@",year] Accept:@"application/vnd.shengxi.v5.5.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeTieTieCaleModel *yearModel = [NoticeTieTieCaleModel mj_objectWithKeyValues:dict[@"data"]];
    
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"yearName == %@",yearModel.year];//谓词过滤查找数组中年份相同的数据,这里找到年份相同的数据 "yearName"为数组里面的属性值key，必须为字符串
            NSArray *sameYearArr = [self.monthArr filteredArrayUsingPredicate:predicate];
           
            for (LXCalendarMonthModel *mondateM in sameYearArr) {
                for (NoticeTieTieCaleModel *monsM in yearModel.monthModels) {
                    if (mondateM.month == monsM.month.intValue) {
                        mondateM.daysModel = monsM.dayModels;
                    }
                }
            }
            [self.merchantCollectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LXCalendarMonthModel *model = self.monthArr[indexPath.row];
    if (self.choiceMongthBlock) {
        self.choiceMongthBlock(model,self.dataArr[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeRliCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:DRMerchantCollectionViewCellID forIndexPath:indexPath];
    [merchentCell.calenderView dealDataWith:self.dataArr[indexPath.row] month:self.monthArr[indexPath.row]];
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-30)/2,(DR_SCREEN_WIDTH-30)/2+40+40);
}


// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


- (void)initCollectionView {
    //1.初始化layout
    HQCollectionViewFlowLayout *layout = [[HQCollectionViewFlowLayout alloc] init];
    //layout.naviHeight = NAVIGATION_BAR_HEIGHT;
    // 设置列的最小间距
    layout.minimumInteritemSpacing = 5;
    // 设置最小行间距
    layout.minimumLineSpacing = 10;
    self.layout = layout;
    
    //2.初始化collectionView
    _merchantCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT - BOTTOM_HEIGHT- NAVIGATION_BAR_HEIGHT) collectionViewLayout:self.layout];
    _merchantCollectionView.dataSource = self;
    _merchantCollectionView.delegate = self;
    _merchantCollectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    _merchantCollectionView.showsVerticalScrollIndicator = NO;
    _merchantCollectionView.showsHorizontalScrollIndicator = NO;
    [_merchantCollectionView registerClass:[NoticeRliCell class] forCellWithReuseIdentifier:DRMerchantCollectionViewCellID];
   // [_merchantCollectionView registerClass:[NoticePhotoHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell"];
    [self.view addSubview:_merchantCollectionView];
}

@end
