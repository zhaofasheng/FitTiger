//
//  NoticeBodyController.m
//  NoticeXi
//
//  Created by li lei on 2023/5/31.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBodyController.h"
#import "NoticeTeamsController.h"
#import "NoticeHelpListController.h"
#import "NoticeTreeController.h"
#import "NoticeCustumeNavView.h"
#import "NoticreSendHelpController.h"
#import "NoticeStaySys.h"
#import "NoticeSCListViewController.h"
#import "NoticeButtonSelectView.h"
@interface NoticeBodyController ()
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@property (nonatomic, strong) UILabel *allNumL;
@property (nonatomic, strong) NoticeTreeController *voiceVC;
@property (nonatomic, strong) NoticeHelpListController *helpVC;
@property (nonatomic, strong) NoticeTeamsController *teamsVC;
@property (nonatomic, assign) CGFloat menunWidth;
@property (nonatomic, strong) NoticeButtonSelectView *buttonSelectView;
@end

@implementation NoticeBodyController


- (void)msgClick{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeSCListViewController *ctl = [[NoticeSCListViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];

    UIButton *msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
    [msgBtn setBackgroundImage:UIImageNamed(@"msgClick_imgw") forState:UIControlStateNormal];
    [self.menuView addSubview:msgBtn];
    [msgBtn addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.allNumL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24+17,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2-2, 14, 14)];
    self.allNumL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
    self.allNumL.layer.cornerRadius = 7;
    self.allNumL.layer.masksToBounds = YES;
    self.allNumL.textColor = [UIColor whiteColor];
    self.allNumL.font = [UIFont systemFontOfSize:9];
    self.allNumL.textAlignment = NSTextAlignmentCenter;
    [self.menuView addSubview:self.allNumL];
    self.allNumL.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    self.buttonSelectView = [[NoticeButtonSelectView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, msgBtn.frame.origin.x, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [self.menuView addSubview:self.buttonSelectView];
    self.buttonSelectView.choiceSelectIndexBlock = ^(NSInteger index) {
        weakSelf.selectIndex = (int)index;
    };
}

- (void)getCurrentIndex:(NSInteger)currentIndex{
    self.buttonSelectView.choiceIndex = currentIndex;
}

- (void)sendHelpClick{
    __weak typeof(self) weakSelf = self;
    NoticreSendHelpController *ctl = [[NoticreSendHelpController alloc] init];
    ctl.upSuccess = ^(BOOL success) {
        weakSelf.selectIndex = 0;
        [weakSelf.helpVC.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self redCirRequest];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)redCirRequest{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v5.4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeStaySys *stay = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];
            self.allNumL.hidden = stay.chatpriM.num.intValue?NO:YES;
            CGFloat strWidth = GET_STRWIDTH(stay.chatpriM.num, 9, 14);
            if (stay.chatpriM.num.intValue < 10) {
                strWidth = 14;
            }else{
                strWidth = strWidth+6;
            }
            self.allNumL.text = stay.chatpriM.num;
            self.allNumL.frame = CGRectMake(DR_SCREEN_WIDTH-20-24+17, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2-4, strWidth, 14);
        }
    } fail:^(NSError *error) {
    }];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,0, DR_SCREEN_WIDTH,NAVIGATION_BAR_HEIGHT);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  0;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 0;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#25262E"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 3;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 1) {
        return self.teamsVC;
    }else if (index == 2){
        return self.helpVC;
    }
    else{
        return self.voiceVC;
    }
}

- (NoticeHelpListController *)helpVC{
    if (!_helpVC) {
        
        _helpVC = [[NoticeHelpListController alloc] init];
        _helpVC.noNav = YES;
    }
    return _helpVC;
}

- (NoticeTreeController *)voiceVC{
    if (!_voiceVC) {
        _voiceVC = [[NoticeTreeController alloc] init];
    }
    return _voiceVC;
}

- (NoticeTeamsController *)teamsVC{
    if(!_teamsVC){
        _teamsVC = [[NoticeTeamsController alloc] init];
    }
    return _teamsVC;
}

@end
