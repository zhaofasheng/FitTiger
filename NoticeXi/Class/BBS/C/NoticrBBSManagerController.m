//
//  NoticrBBSManagerController.m
//  NoticeXi
//
//  Created by li lei on 2020/11/12.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticrBBSManagerController.h"
#import "NoticeUserBBSManagerController.h"
#import "NoticeManagerBBSController.h"
@interface NoticrBBSManagerController ()
@property (nonatomic, strong) NoticeUserBBSManagerController *userBBSVC;
@property (nonatomic, strong) NoticeManagerBBSController *bbsVC;
@end

@implementation NoticrBBSManagerController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[@"帖子管理",@"投稿管理"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"帖子管理", 16, 16);
        self.progressHeight = 2;
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 16;
        self.progressViewBottomSpace = 5;
        self.progressColor = GetColorWithName(VMainThumeColor);
        self.titleColorNormal = GetColorWithName(VMainTextColor);
        self.titleColorSelected = GetColorWithName(VMainTextColor);
    }
    return self;
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return GET_STRWIDTH(@"帖子管理", 16, 16);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return (DR_SCREEN_WIDTH-GET_STRWIDTH(@"忒子喜欢", 16, 16)*4)/4;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return GetColorWithName(VMainThumeColor);
        case WMMenuItemStateNormal: return GetColorWithName(VMainTextColor);
    }
}
- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.bbsVC;
    }else{
        return self.userBBSVC;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, STATUS_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:[UIImage imageNamed:[NoticeTools isWhiteTheme]?@"btn_nav_back":@"btn_nav_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
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

- (NoticeUserBBSManagerController *)userBBSVC{
    if (!_userBBSVC) {
        _userBBSVC = [[NoticeUserBBSManagerController alloc] init];
        _userBBSVC.mangagerCode = self.mangagerCode;
    }
    return _userBBSVC;
}

- (NoticeManagerBBSController *)bbsVC{
    if (!_bbsVC) {
        _bbsVC = [[NoticeManagerBBSController alloc] init];
        _bbsVC.mangagerCode = self.mangagerCode;
    }
    return _bbsVC;
}
@end
