//
//  NoticeUserListController.m
//  NoticeXi
//
//  Created by li lei on 2019/7/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserListController.h"
#import "NoticeBlackListViewController.h"
@interface NoticeUserListController ()
@property (nonatomic, strong) NoticeBlackListViewController *blackVC;
@property (nonatomic, strong) NoticeBlackListViewController *syPbVC;
@property (nonatomic, strong) NoticeBlackListViewController *whiteVC;
@end

@implementation NoticeUserListController
- (instancetype)init {
    
    if (self = [super init]) {
        self.titles = @[[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"black.title1"]:@"黑名單",@"善意屏蔽",[NoticeTools isSimpleLau]?@"白名单":@"白名單"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"我的作品", 16, 16);
        self.progressHeight = 2;
        self.titleSizeNormal = 13;
        self.titleSizeSelected = 16;
        self.progressViewBottomSpace = 5;
        self.progressColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        self.titleColorNormal = GetColorWithName(VDarkTextColor);
        self.titleColorSelected = GetColorWithName(VMainTextColor);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor = GetColorWithName(VlineColor);
    [self.view addSubview:line];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 50, 50)];
    [backBtn setImage:[UIImage imageNamed:[NoticeTools isWhiteTheme]?@"btn_nav_back":@"btn_nav_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    return CGRectMake(10,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT+1, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-1);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return GET_STRWIDTH(self.titles[index], 16, 16);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 30;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return GetColorWithName(VMainTextColor);
        case WMMenuItemStateNormal: return GetColorWithName(VDarkTextColor);
    }
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return self.blackVC;
    }else if (index == 1){
        return self.syPbVC;
    }
    else{
        return self.whiteVC;
    }
}


- (NoticeBlackListViewController *)blackVC{
    if (!_blackVC) {
        _blackVC = [[NoticeBlackListViewController alloc] init];
        _blackVC.type = 0;
    }
    return _blackVC;
}

- (NoticeBlackListViewController *)syPbVC{
    if (!_syPbVC) {
        _syPbVC = [[NoticeBlackListViewController alloc] init];
        _syPbVC.type = 1;
    }
    return _syPbVC;
}

- (NoticeBlackListViewController *)whiteVC{
    if (!_whiteVC) {
        _whiteVC = [[NoticeBlackListViewController alloc] init];
        _whiteVC.type = 2;
    }
    return _whiteVC;
}

@end
