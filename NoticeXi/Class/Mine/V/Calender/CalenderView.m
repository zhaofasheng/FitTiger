//
//  CalenderView.m
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "CalenderCollectionCell.h"
#import "CalenderHeaderView.h"
#import "CalenderView.h"
#import "NSDate+Extension.h"
#import "UIColor+Extension.h"
#import "CalenderFootView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeCoverModel.h"
@interface CalenderView ()<UICollectionViewDelegate, UICollectionViewDataSource,NoticeChangeCanlderThumeDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) CalenderModel *oldModel;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) NSString *lastYear;
@property (nonatomic, strong) NSString *lastMonth;
@property (nonatomic, strong) NSMutableArray *hasDataArr;
@property (nonatomic, strong) NSMutableArray *allDataSource;
@property (nonatomic, assign) NSInteger choiceSection;
@end

static NSString *const reuseIdentifier  = @"collectionViewCell";
static NSString *const headerIdentifier = @"headerIdentifier";

@implementation CalenderView

- (instancetype)initWithFrame:(CGRect)frame startDay:(NSString *)startDay endDay:(NSString *)endDay {
    self = [super initWithFrame:frame];
    if (self) {
    
        self.allDataSource = [NSMutableArray new];
        [self addSubview:self.collectionView];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //获取当前时间日期展示字符串 如：2019-05-23-13:58:59
        NSString *CurrentYear = [formatter stringFromDate:date];
        NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
        [self buildSourceWithStartDate:[NSString stringWithFormat:@"%@-%02d-01",userInfo.createYear,userInfo.createMonth.intValue] endDate:CurrentYear];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAllTime) name:@"REFRESHUSERINFORNOTICATION" object:nil];
    
        [self requestDate];
    }
    return self;
}

#pragma mark - 设置数据源
- (void)buildSourceWithStartDate:(NSString *)startDate endDate:(NSString *)endDate{
    self.startDay = startDate;
    self.endDay = endDate;
    NSAssert(self.startDay.length && self.endDay.length, @"开始时间和结束时间不能为空");
    if (!self.startDay.length || !self.endDay.length) {
        self.startDay = [NSDate timeStringWithInterval:[NSDate date].timeIntervalSince1970];
        self.endDay   = [NSDate timeStringWithInterval:[NSDate date].timeIntervalSince1970];
    }
    
    NSArray   *startArray = [self.startDay componentsSeparatedByString:@"-"];
    NSArray   *endArray   = [self.endDay componentsSeparatedByString:@"-"];
    NSInteger month       = ([endArray[0] integerValue] - [startArray[0] integerValue])* 12 + ([endArray[1] integerValue] - [startArray[1] integerValue]) + 1;
    
    for (int i = 0; i < month; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [self.allDataSource addObject:array];
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    //获取当前时间日期展示字符串 如：2019-05-23-13:58:59
    NSString *CurrentYear = [formatter stringFromDate:date];
    
    for (int i = 0; i < month; i++) {
        int              calcNumberMonth = (int)[NSDate month:self.startDay] + i;
        int              month           = (calcNumberMonth)%12;
        NSDateComponents *components     = [[NSDateComponents alloc]init];
        
        //获取下个月的年月日信息,并将其转为date
        components.month = month ? month : 12;
        NSInteger starYear = [startArray[0] integerValue];//开始年份
        if (calcNumberMonth >= 24 && (calcNumberMonth % 12 == 0)) {
            components.year = starYear+calcNumberMonth/12-1;
        }else{
           components.year  = starYear + (calcNumberMonth == 12 ? 0 : calcNumberMonth) / 12;
        }
        
        components.day   = 1;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate     *nextDate = [calendar dateFromComponents:components];
        
        //获取该月第一天星期几
        NSInteger firstDayInThisMounth = [NSDate firstWeekdayInThisMonth:nextDate];
        
        //该月的有多少天daysInThisMounth
        NSInteger daysInThisMounth = [NSDate totaldaysInMonth:nextDate];
        NSString  *string          = [[NSString alloc]init];
        for (int j = 0; j < (daysInThisMounth > 29 && (firstDayInThisMounth == 6 || firstDayInThisMounth == 5) ? 42 : 35); j++) {
            
            CalenderModel *model = [[CalenderModel alloc] init];
            model.year  = components.year;
            if (model.year == CurrentYear.integerValue) {
                model.isCurrentYear = YES;
            }else{
                model.isCurrentYear = NO;
            }
            model.month = components.month;
            if (model.isCurrentYear) {
                model.showTime = [NSString stringWithFormat:@"%zd月",model.month];
            }else{
                model.showTime = [NSString stringWithFormat:@"%ld年%zd月",(long)model.year, model.month];
            }
            
            if (j < firstDayInThisMounth || j > daysInThisMounth + firstDayInThisMounth - 1) {
                string    = @"";
                model.day = string;
            } else {
                string    = [NSString stringWithFormat:@"%02ld", (long)(j - firstDayInThisMounth + 1)];
                model.day = string;
            }
            
            NSString *mon = [NSString stringWithFormat:@"%02ld",(long)model.month];
        
            if ([mon isEqualToString:@"01"]) {
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"Jan.%@",model.day] : [NSString stringWithFormat:@"Jan.%@ %zd",model.day,model.year];
            }else if ([mon isEqualToString:@"02"]){
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"Feb.%@",model.day]:[NSString stringWithFormat:@"Feb.%@ %zd",model.day,model.year];
            }else if ([mon isEqualToString:@"03"]){
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"Mar.%@",model.day]:[NSString stringWithFormat:@"Mar.%@ %zd",model.day,model.year];
            }else if ([mon isEqualToString:@"04"]){
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"Apr.%@",model.day]:[NSString stringWithFormat:@"Apr.%@ %zd",model.day,model.year];
            }else if ([mon isEqualToString:@"05"]){
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"May.%@",model.day]:[NSString stringWithFormat:@"May.%@ %zd",model.day,model.year];
            }else if ([mon isEqualToString:@"06"]){
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"Jun.%@",model.day]:[NSString stringWithFormat:@"Jun.%@ %zd",model.day,model.year];
            }else if ([mon isEqualToString:@"07"]){
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"Jul.%@",model.day]:[NSString stringWithFormat:@"Jul.%@ %zd",model.day,model.year];
            }else if ([mon isEqualToString:@"08"]){
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"Aug.%@",model.day]:[NSString stringWithFormat:@"Aug.%@ %zd",model.day,model.year];
            }else if ([mon isEqualToString:@"09"]){
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"Sept.%@",model.day]:[NSString stringWithFormat:@"Sept.%@ %zd",model.day,model.year];
            }else if ([mon isEqualToString:@"10"]){
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"Oct.%@",model.day]:[NSString stringWithFormat:@"Oct.%@ %zd",model.day,model.year];
            }else if ([mon isEqualToString:@"11"]){
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"Nov.%@",model.day]:[NSString stringWithFormat:@"Nov.%@ %zd",model.day,model.year];
            }else if ([mon isEqualToString:@"12"]){
                model.allCalderName = model.isCurrentYear?[NSString stringWithFormat:@"Dec.%@",model.day]:[NSString stringWithFormat:@"Dec.%@ %zd",model.day,model.year];
            }
            [[self.allDataSource objectAtIndex:i]addObject:model];
        }
    }
}

- (void)refreshCandeler{
    
    if (self.hasDataArr.count) {
        NSMutableArray *hasVoiceArr = self.hasDataArr[self.hasDataArr.count-1];
        CalenderModel *voiceM = hasVoiceArr[0];
        
        for (NSMutableArray *allArr in self.allDataSource) {
            CalenderModel *curMon = allArr[0];
                    
            if ([[voiceM.voiceDay substringToIndex:6] isEqualToString:[NSString stringWithFormat:@"%ld%02ld",(long)curMon.year,(long)curMon.month]]) {
                if ([[voiceM.voiceDay substringToIndex:6] isEqualToString:@"201811"]) {
                    DRLog(@"%@",voiceM.voiceDay);
                }
                for (CalenderModel *dataM in hasVoiceArr) {//识别哪个日期有心情
                    for (CalenderModel *model in allArr) {
                        if ([dataM.voiceDay isEqualToString:[NSString stringWithFormat:@"%ld%02ld%@",(long)model.year,(long)model.month,model.day]]) {
                            model.isHasData = YES;
                            model.voiceDay = dataM.voiceDay;
                            break;
                        }
                    }
                }
                
                [self requestCover:[NSString stringWithFormat:@"%ld%02ld",(long)curMon.year,(long)curMon.month] currentModel:curMon];
                
                [self.dataSource addObject:allArr];
                break;
            }
        }
        

    }
    [self.collectionView reloadData];
    
}

- (void)requestCover:(NSString *)yearAndMon currentModel:(CalenderModel *)curMon{
    //获取封面
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/covers?coverName=calendartheme_cover&coverTag=%@",[NoticeTools getuserId],yearAndMon] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
        if (success1) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NSMutableArray *arr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                if (arr.count) {
                    return;
                }
                NoticeCoverModel *model = [NoticeCoverModel mj_objectWithKeyValues:dic];
                curMon.cover = model.coverUrl;
                [arr addObject:model];
                [self.collectionView reloadData];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)noVoiceCanlader{
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:self.allDataSource[self.allDataSource.count-1]];
    if (self.dataSource.count) {
        for (CalenderModel *model in self.dataSource[0]) {
            model.isHasData = NO;
            [self requestCover:[NSString stringWithFormat:@"%ld%02ld",(long)model.year,(long)model.month] currentModel:model];
        }
    }
    
    [self.collectionView reloadData];
}

- (void)requestDate{

    //从当前年月开始
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMM"];
    //获取当前时间日期展示字符串 如：2019-05-23-13:58:59
    NSString *CurrentYear = [formatter stringFromDate:date];
    self.lastYear = [CurrentYear substringToIndex:4];
    self.lastMonth = [CurrentYear substringFromIndex:4];
    if (self.lastMonth.length) {
        if ([[self.lastMonth substringToIndex:1] isEqualToString:@"0"]) {
            self.lastMonth = [self.lastMonth substringFromIndex:1];
        }
    }else{
        return;
    }

    NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/calendar?year=%@&month=%@",userInfo.user_id,self.lastYear,self.lastMonth] Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NSMutableArray *arr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                CalenderModel *model = [CalenderModel mj_objectWithKeyValues:dic];
                [arr addObject:model];
            }
            if (arr.count) {//如果存在这个月份就添加这个月份的日历
          
                [self.hasDataArr addObject:arr];
                [self refreshCandeler];
            }
            [self contiuneRequest];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

//如果没有获取到有数据的日历，那就继续获取，一直到当前月份
- (void)contiuneRequest{

    NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
    if (self.lastYear.intValue >= userInfo.createYear.intValue) {//只有年份大于等于注册年份的时候才继续加载日历
        if (self.lastYear.intValue == userInfo.createYear.intValue) {//年份等于注册年份的时候比较月份
            if (self.lastMonth.intValue > userInfo.createMonth.intValue) {
                if (self.lastMonth.intValue > 1) {//小于十二个月的时候
                    self.lastMonth = [NSString stringWithFormat:@"%d",self.lastMonth.intValue-1];
                }else{
                    self.lastMonth = @"12";
                    self.lastYear = [NSString stringWithFormat:@"%d",self.lastYear.intValue-1];
                }
            }else{
                return;
            }
        }else{
            if (self.lastMonth.intValue > 1) {//小于十二个月的时候
                self.lastMonth = [NSString stringWithFormat:@"%d",self.lastMonth.intValue-1];
            }else{
                self.lastMonth = @"12";
                self.lastYear = [NSString stringWithFormat:@"%d",self.lastYear.intValue-1];
            }
        }
    }else{
        return;
    }
  
    DRLog(@"继续请求下一个月");
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/calendar?year=%@&month=%@",userInfo.user_id,self.lastYear,self.lastMonth] Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
   
        if (success) {
            NSMutableArray *arr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                CalenderModel *model = [CalenderModel mj_objectWithKeyValues:dic];
                [arr addObject:model];
            }
            if (arr.count) {//如果存在这个月份就添加这个月份的日历
                [self.hasDataArr addObject:arr];
                [self refreshCandeler];
            }
            [self contiuneRequest];
        }else{
            
            DRLog(@"继续请求下一个月失败%@",dict);
        }
    } fail:^(NSError * _Nullable error) {
        DRLog(@"继续请求下一个月失败%@",error);
    }];
}

- (void)requestAllTime{
    [self.hasDataArr removeAllObjects];
    [self.dataSource removeAllObjects];
    [self.collectionView reloadData];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/about",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeAbout *aboutM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            if (aboutM.voice_total_len.intValue) {
                [self requestDate];
            }else{
                [self noVoiceCanlader];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CalenderModel *model = self.dataSource[indexPath.section][indexPath.item];
    
    if (!model.day.length || !model.isHasData) {
        return;
    }
    
    if (model != self.oldModel) {
        for (NSMutableArray *arr in self.dataSource) {
             for (CalenderModel *allM in arr) {
                 allM.isSelected = NO;
             }
         }
    }
 
    NSString *selectDate = [NSString stringWithFormat:@"%zd-%zd-%@", model.year, model.month, model.day];
    DRLog(@"%@",selectDate);
    self.oldModel = model;
    if ([self.delegate respondsToSelector:@selector(calenderView:dateString:isSelect:)]) {
        [self.delegate calenderView:indexPath dateString:model isSelect:model.isSelected];
    }
    [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalenderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.contentView.backgroundColor = GetColorWithName(VBackColor);
    CalenderModel *model = self.dataSource[indexPath.section][indexPath.item];
    model.isWeek = NO;

    if (indexPath.item == 0 || indexPath.item == 7 || indexPath.item == 14 || indexPath.item == 21 || indexPath.item == 28 || indexPath.item == 35) {
        model.isWeek = YES;
        cell.leftLine.hidden = NO;
    }else{
        cell.leftLine.hidden = YES;
    }
    
    if (indexPath.item == 6 || indexPath.item == 13 || indexPath.item == 20 || indexPath.item == 27 || indexPath.item == 34 || indexPath.row == 41) {
        model.isWeek = YES;
        cell.rightLine.hidden = NO;
    }else{
        cell.rightLine.hidden = YES;
    }
    
    cell.model = model;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CalenderHeaderView *heardView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        heardView.delegate = self;
        heardView.section = indexPath.section;
        heardView.backgroundColor = GetColorWithName(VBackColor);
        CalenderModel      *model     = self.dataSource[indexPath.section][0];
        heardView.yearAndMonthLabel.text = model.showTime;
        [heardView.thumeImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_rilithum":@"Image_rilithumy")];
        if (indexPath.section == 0) {//切半边圆角
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:heardView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
            self.maskLayer.frame = heardView.bounds;
            self.maskLayer.path = maskPath.CGPath;
            heardView.layer.mask = self.maskLayer;
        }else{
            heardView.layer.mask = nil;
        }
        return heardView;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        CalenderFootView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footView.bootomLine.hidden = NO;
        return footView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section < self.dataSource.count-1) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(self.frame.size.width, 58+35+BOTTOM_HEIGHT+25+75);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);//分别为上、左、下、右
}

- (CAShapeLayer *)maskLayer{
    if (!_maskLayer) {
        _maskLayer = [[CAShapeLayer alloc] init];
    }
    return _maskLayer;
}

#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        float                      cellw       = (self.bounds.size.width-30)/7;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setHeaderReferenceSize:CGSizeMake(self.frame.size.width, 65)];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing      = 0;
        flowLayout.itemSize                = CGSizeMake(cellw, 50);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)  collectionViewLayout:flowLayout];
        
        _collectionView.dataSource                     = self;
        _collectionView.delegate                       = self;
        _collectionView.showsVerticalScrollIndicator   = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[CalenderFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        [_collectionView registerClass:[CalenderHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
        [_collectionView registerClass:[CalenderCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
        _collectionView.backgroundColor = GetColorWithName(VlistColor);
    }
    return _collectionView;
}

- (void)changeThumeImageView:(NSInteger)section{
    self.choiceSection = section;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = false;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = false;
    imagePicker.allowCrop = true;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    [nav.topViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%u",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99999];
            [self upLoadHeader:choiceImage path:filePath withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }else{
            [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""] withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }
    }];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path withDate:(NSString *)date{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"23" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
   
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"calendartheme_cover" forKey:@"coverName"];
            [parm setObject:Message forKey:@"coverUri"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            CalenderModel *curMon = self.dataSource[self.choiceSection][0];
            [parm setObject:[NSString stringWithFormat:@"%ld%02ld",(long)curMon.year,(long)curMon.month] forKey:@"coverTag"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/covers",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success2) {
                [nav.topViewController hideHUD];
                if (success2) {
                    NoticeCoverModel *covverM = [NoticeCoverModel mj_objectWithKeyValues:dict[@"data"]];
                    curMon.cover = covverM.coverUrl;
                    [self.collectionView reloadData];
                }
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
            
        }else{
            [nav.topViewController hideHUD];
        }
    }];
}


- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)hasDataArr{
    if (!_hasDataArr) {
        _hasDataArr = [NSMutableArray new];
    }
    return _hasDataArr;
}
@end

