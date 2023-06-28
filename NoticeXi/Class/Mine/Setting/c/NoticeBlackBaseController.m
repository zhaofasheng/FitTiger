//
//  NoticeBlackBaseController.m
//  NoticeXi
//
//  Created by li lei on 2021/6/17.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBlackBaseController.h"
#import "NoticeBlackListViewController.h"
@interface NoticeBlackBaseController ()
@property (nonatomic, strong) NoticeBlackListViewController *blackVC;
@property (nonatomic, strong) NoticeBlackListViewController *huiVC;
@end

@implementation NoticeBlackBaseController


- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"black.title1"],[NoticeTools getLocalStrWith:@"black.title2"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH([NoticeTools getLocalStrWith:@"black.title1"], 20, 20);
        self.progressHeight = 2;
        self.progressViewBottomSpace = 4;
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 16;
        self.progressColor = [UIColor colorWithHexString:@"#05A8FA"];
        self.titleColorNormal = [UIColor colorWithHexString:@"#25262E"];
        self.titleColorSelected = [UIColor colorWithHexString:@"#25262E"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(7, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
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
    
    return CGRectMake(0,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 25;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#25262E"];
        case WMMenuItemStateNormal: return [UIColor colorWithHexString:@"#25262E"];
    }
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return self.blackVC;
    }else{
        return self.huiVC;
    }
}

- (NoticeBlackListViewController *)blackVC{
    if (!_blackVC) {
        _blackVC = [[NoticeBlackListViewController alloc] init];
        _blackVC.type = 1;
    }
    return _blackVC;
}

- (NoticeBlackListViewController *)huiVC{
    if (!_huiVC) {
        _huiVC = [[NoticeBlackListViewController alloc] init];
        _huiVC.type = 2;
    }
    return _huiVC;
}
@end
