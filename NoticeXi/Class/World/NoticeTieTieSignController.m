//
//  NoticeTieTieSignController.m
//  NoticeXi
//
//  Created by li lei on 2022/4/21.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeTieTieSignController.h"
#import "NoticeCustumeNavView.h"
#import "NoticeAllTieTieController.h"
#import "NoticeSendEmilController.h"
#import "NoticeCurentLeaveController.h"
#import "NoticeTieTieVoiceController.h"
#import "NoticeTieTieRliDayVoiceController.h"
@interface NoticeTieTieSignController ()
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@property (nonatomic, strong) FSCustomButton *monthL;
@property (nonatomic, strong) NoticeTieTieRliDayVoiceController *riliVC;
@property (nonatomic, strong) NoticeTieTieVoiceController *monthVC;
@property (nonatomic, strong) UIButton *dayViewBtn;
@property (nonatomic, strong) UIButton *monthViewBtn;
@end

@implementation NoticeTieTieSignController

- (NoticeTieTieRliDayVoiceController *)riliVC{
    if(!_riliVC){
        _riliVC = [[NoticeTieTieRliDayVoiceController alloc] init];
    }
    return _riliVC;
}

- (NoticeTieTieVoiceController *)monthVC{
    if(!_monthVC){
        _monthVC = [[NoticeTieTieVoiceController alloc] init];
    }
    return _monthVC;
}

- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [self.view addSubview:_navBarView];
        [_navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        _navBarView.titleL.text = self.navigationItem.title;
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT+50, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.riliVC;
    }else{
        return self.monthVC;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];

    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*251/375)];
    backImageView.image = UIImageNamed(@"Image_rilibackviewimg");
    [self.view addSubview:backImageView];
    
    [self.navBarView.rightButton setImage:UIImageNamed(@"Image_rilispai") forState:UIControlStateNormal];
    [self.navBarView.rightButton addTarget:self action:@selector(downTapVoice) forControlEvents:UIControlEventTouchUpInside];
    
    self.menuView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
    
    self.monthL = [[FSCustomButton alloc] initWithFrame:CGRectMake(15,0,136, 50)];
    self.monthL.titleLabel.font = XGTwentyTwoBoldFontSize;
    [self.monthL setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    [self.monthL setImage:UIImageNamed(@"riliintoimg") forState:UIControlStateNormal];
    self.monthL.buttonImagePosition = FSCustomButtonImagePositionRight;
    [self.menuView addSubview:self.monthL];
    [self.monthL addTarget:self action:@selector(riliClick) forControlEvents:UIControlEventTouchUpInside];
    
    if([NoticeTools getLocalType] > 0){
        self.monthL.frame = CGRectMake(15,NAVIGATION_BAR_HEIGHT,GET_STRWIDTH(@"Year 2023 month 03", 21, 50)+18, 50);
        self.monthL.titleLabel.font = XGTwentyBoldFontSize;
    }
    
    LXCalendarMonthModel *monthModel = [[LXCalendarMonthModel alloc] initWithDate:[NSDate date]];
    self.monthVC.year = [NSString stringWithFormat:@"%ld",monthModel.year];
    self.monthVC.month = [NSString stringWithFormat:@"%ld",monthModel.month];
  
    if ([NoticeTools getLocalType] == 1) {
        [self.monthL setTitle:[NSString stringWithFormat:@"Year %ld Month %02ld",monthModel.year,monthModel.month] forState:UIControlStateNormal];
    }else{
        [self.monthL setTitle:[NSString stringWithFormat:@"%ld年%02ld月",monthModel.year,monthModel.month] forState:UIControlStateNormal];
    }
    
    [self.view bringSubviewToFront:self.menuView];
    [self.view bringSubviewToFront:self.navBarView];
    
    self.dayViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-76-24, 13, 24, 24)];
    [self.dayViewBtn addTarget:self action:@selector(dayVieClick) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:self.dayViewBtn];
    [self.dayViewBtn setBackgroundImage:UIImageNamed(@"Image_dayviewy") forState:UIControlStateNormal];
    
    self.monthViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24, 13, 24, 24)];
    [self.monthViewBtn addTarget:self action:@selector(monthVieClick) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:self.monthViewBtn];
    [self.monthViewBtn setBackgroundImage:UIImageNamed(@"Image_monthviewn") forState:UIControlStateNormal];
    
    [self.view sendSubviewToBack:backImageView];
}

- (void)dayVieClick{
    [self.dayViewBtn setBackgroundImage:UIImageNamed(@"Image_dayviewy") forState:UIControlStateNormal];
    [self.monthViewBtn setBackgroundImage:UIImageNamed(@"Image_monthviewn") forState:UIControlStateNormal];
    self.selectIndex = 0;
}

- (void)monthVieClick{
    [self.dayViewBtn setBackgroundImage:UIImageNamed(@"Image_dayviewn") forState:UIControlStateNormal];
    [self.monthViewBtn setBackgroundImage:UIImageNamed(@"Image_monthviewy") forState:UIControlStateNormal];
    self.selectIndex = 1;
}

- (void)getCurrentIndex:(NSInteger)currentIndex{

    if(currentIndex == 0){
        [self.dayViewBtn setBackgroundImage:UIImageNamed(@"Image_dayviewy") forState:UIControlStateNormal];
        [self.monthViewBtn setBackgroundImage:UIImageNamed(@"Image_monthviewn") forState:UIControlStateNormal];
    }else{
        [self.dayViewBtn setBackgroundImage:UIImageNamed(@"Image_dayviewn") forState:UIControlStateNormal];
        [self.monthViewBtn setBackgroundImage:UIImageNamed(@"Image_monthviewy") forState:UIControlStateNormal];
    }
}

- (void)downTapVoice{
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if (!userM.level.integerValue) {
        NSString *str = nil;
        if ([NoticeTools getLocalType] == 2) {
            str = @"Lv1へのアップグレードを使用できる〜";
        }else if ([NoticeTools getLocalType] == 1){
            str = @"Limited to Lv1 or higher";
        }else{
            str = @"升级至Lv1可使用";
        }
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:[NoticeTools chinese:@"普通用户进入日历后，可以下载单日的音频，打包下载需升级至Lv1才能使用" english:@"Instead of downloading by the day\nYou can download by the month" japan:@"日ごとにダウンロードする代わりに\n月単位でダウンロードできます"] sureBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.golv"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                NoticeCurentLeaveController *ctl = [[NoticeCurentLeaveController alloc] init];
                [weakSelf.navigationController pushViewController:ctl animated:YES];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    
    NoticeSendEmilController *ctl = [[NoticeSendEmilController alloc] init];
    ctl.canChoiceDate = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)riliClick{
    __weak typeof(self) weakSelf = self;
    NoticeAllTieTieController *ctl = [[NoticeAllTieTieController alloc] init];
    ctl.choiceMongthBlock = ^(LXCalendarMonthModel * _Nonnull month, NSDate * _Nonnull date) {
        [weakSelf.riliVC refreshCal:month date:date];
        [weakSelf.monthL setTitle:[NSString stringWithFormat:@"%ld年%02ld月",month.year,month.month] forState:UIControlStateNormal];
        weakSelf.monthVC.year = [NSString stringWithFormat:@"%ld",month.year];
        weakSelf.monthVC.month = [NSString stringWithFormat:@"%ld",month.month];
        [weakSelf.monthVC refreshData];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarView.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.menuView.dataSource = self;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
@end
