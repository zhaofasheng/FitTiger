//
//  NoticeNearViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/30.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeNearViewController.h"
#import "CLLocation+Sino.h"
#import "NoticeByPersonCell.h"
#import <CoreLocation/CoreLocation.h>
#import "NoticeOtherUserInfoViewController.h"
#import "NoticeMineViewController.h"
#import "NoticeNoticenterModel.h"
#import "NoticeNoDataView.h"


@interface NoticeNearViewController ()<CLLocationManagerDelegate,NoticeNearByClickDelegate>
@property (nonatomic, strong) CLLocationManager *locationmanager;//定位服务
@property (nonatomic, strong) NSString *currentCity;//当前城市
@property (nonatomic, strong) NSString *strlatitude;//经度
@property (nonatomic, strong) NSString *strlongitude;//纬度
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger page;  //YES  下拉
@property (nonatomic, strong) UILabel *headerViewL;

@property (nonatomic, strong) NSArray *titArr;
@property (nonatomic, strong) NSArray *boolArr;
@property (nonatomic, strong) NSArray *setArr;
@property (nonatomic, strong) NSArray *keyArr;
@property (nonatomic, strong) NSArray *nextBoolArr;
@property (nonatomic, strong) NoticeNoticenterModel *noticeM;


@end

@implementation NoticeNearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"附近";
    self.page = 1;
    
    [self requestData];
        
    self.dataArr = [NSMutableArray new];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.rowHeight = 90;
    [self.tableView registerClass:[NoticeByPersonCell class] forCellReuseIdentifier:@"byCell"];
    
    UILabel *headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
    headView.backgroundColor = GetColorWithName(VlistColor);
    headView.textColor = GetColorWithName(VDarkTextColor);
    headView.font = TWOTEXTFONTSIZE;
    headView.textAlignment = NSTextAlignmentCenter;
    headView.text = GETTEXTWITE(@"nearby.mark");
    headView.numberOfLines = 2;
    _headerViewL = headView;

    self.keyArr = @[@"chatWith",@"chatPriWith",@"strangeView",@"gpsSwitch"];
    self.setArr = @[@[Localized(@"privacy.all"),Localized(@"privacy.limit")],@[Localized(@"privacy.all"),Localized(@"privacy.limit")],@[Localized(@"privacy.seven"),Localized(@"privacy.no")],@[Localized(@"privacy.open"),Localized(@"privacy.close")]];
    self.titArr = @[Localized(@"privacy.sendVoice"),Localized(@"privacy.chat"),Localized(@"privacy.photo"),Localized(@"privacy.distance"),Localized(@"privacy.list")];
}


- (void)requestData{
    [self showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeNoticenterModel*noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            
            if (noticeM.gps_switch.integerValue) {
                self.tableView.tableHeaderView = self.headerViewL;
                [self getLocation];
                self.tableView.bounces = YES;
                self.tableView.tableFooterView = nil;
                [self createRefesh];
            }else{//跳转到设置界面
                self.tableView.bounces = NO;
                self.noticeM = noticeM;
                self.noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
                self.boolArr = @[self.noticeM.chantWithName,self.noticeM.chantPriWithName,self.noticeM.lookWithName,self.noticeM.ditanceName,@""];
                self.nextBoolArr = @[self.noticeM.chat_with,self.noticeM.chat_pri_with,self.noticeM.strange_view,self.noticeM.gps_switch];

            }
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)openClick{
    NoticePrivacySetViewController *ctl = [[NoticePrivacySetViewController alloc] init];
    ctl.titArr = self.setArr[3];
    ctl.headerTitle = self.titArr[3];
    ctl.keyString = self.keyArr[3];
    ctl.boolStr = self.nextBoolArr[3];
    ctl.tag = 3;
    __weak typeof(self) weakSelf = self;
    ctl.openBlock = ^(BOOL open) {
        if (open) {
            [weakSelf createRefesh];
            weakSelf.tableView.tableHeaderView = self.headerViewL;
            [weakSelf getLocation];
            weakSelf.tableView.bounces = YES;
            weakSelf.tableView.tableFooterView = nil;
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNearPerson *person = self.dataArr[indexPath.row];
    if ([person.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        NoticeMineViewController *ctl = [[NoticeMineViewController alloc] init];
        ctl.isFromOther = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeOtherUserInfoViewController *ctl = [[NoticeOtherUserInfoViewController alloc] init];
        ctl.userId = person.user_id;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = YES;
    [self.audioPlayer pause:self.isPasue];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    // 跳转
    [self.audioPlayer.player seekToTime:CMTimeMake(dratNum, 1) completionHandler:^(BOOL finished) {
        if (finished) {
        }
    }];
}

#pragma Mark - 音频播放模块
- (void)startPlayAndStop:(NSInteger)tag{
    
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }
    
    NoticeNearPerson *model = self.dataArr[tag];
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.wave_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            model.isPlaying = YES;
            [weakSelf.tableView reloadData];
        }
    };
    self.audioPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        model.nowTime = model.wave_len;
        //weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        [weakSelf.tableView reloadData];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        NoticeByPersonCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ((model.wave_len.integerValue-currentTime) <= 0) {
            cell.playerView.timeLen = model.wave_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            model.nowPro = 0;
            model.nowTime = model.wave_len;
            [weakSelf.tableView reloadData];
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.wave_len.integerValue-currentTime];
        cell.playerView.slieView.progress = currentTime/model.wave_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.wave_len.integerValue-currentTime];
        model.nowPro = currentTime/model.wave_len.floatValue;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeByPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"byCell"];
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.person = self.dataArr[indexPath.row];
    cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
    cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
    NoticeNearPerson *person = self.dataArr[indexPath.row];
    if (person.isPlaying) {
        [cell.playerView.playButton.imageView startAnimating];
    }else{
        [cell.playerView.playButton.imageView stopAnimating];
    }
    return cell;
}
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //设置提示提醒用户打开定位服务
    [self showToastWithText:@"请在手机手机设置中打开应用定位"];
}

-(void)getLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationmanager = [[CLLocationManager alloc]init];
        self.locationmanager.delegate = self;
        [self.locationmanager requestAlwaysAuthorization];
        self.currentCity = [NSString new];
        [self.locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        self.locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationmanager.distanceFilter = 5.0;
        [self.locationmanager startUpdatingLocation];
    }
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationmanager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    
    //获取当前位置----是地球地址(国际地址)
    //地球地址转化为火星地址
    CLLocation *location = [currentLocation locationMarsFromEarth];
    //打印当前的经度与纬度
    DRLog(@"%f,%f",location.coordinate.latitude,location.coordinate.longitude);
    self.strlatitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    self.strlongitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    if (currentLocation && currentLocation.coordinate.latitude) {
        [self.locationmanager stopUpdatingLocation];
        [self.tableView.mj_header beginRefreshing];
        return;
    }
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            self.currentCity = placeMark.locality;
            if (!self.currentCity) {
                self.currentCity = @"无法定位当前城市";
            }
        }
    }];
}

- (void)createRefesh{
    
    __weak NoticeNearViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.page = 1;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        ctl.page++;
        [ctl request];
    }];
}

- (void)request{
    
    NSString *url = [NSString stringWithFormat:@"users/%@/round?lng=%@&lat=%@&pageNo=%ld",[[NoticeSaveModel getUserInfo] user_id],self.strlongitude,self.strlatitude,(long)self.page];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeNearPerson *person = [NoticeNearPerson mj_objectWithKeyValues:dic];
                [self.dataArr addObject:person];
                
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}




@end
