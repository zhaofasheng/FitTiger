//
//  NoticeBdController.m
//  NoticeXi
//
//  Created by li lei on 2019/10/16.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeBdController.h"
#import "NoticeClockBdCell.h"
#import "NoticeTopTenController.h"
#import "NoticeYourBdCell.h"
#import "NoticeNewBdController.h"
#import "NoticeCustumBackImageView.h"
@interface NoticeBdController ()

@property (nonatomic, strong) NoticeNewBdController *dayVC;
@property (nonatomic, strong) NoticeNewBdController *allVC;
@property (nonatomic, strong) UIView *mbsView;
@property (nonatomic, strong) NoticeCustumBackImageView *backGroundImageView;
@end

@implementation NoticeBdController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"py.dayb"],[NoticeTools getLocalStrWith:@"py.allb"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"心情", 20, 20);
        self.progressHeight = 2;
        self.progressViewBottomSpace = 4;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 20;
        self.progressColor = [UIColor colorWithHexString:@"#05A8FA"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
        self.titleColorSelected = [UIColor colorWithHexString:@"#25262E"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"py.bList"];
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 46, DR_SCREEN_WIDTH, 2)];
    line.backgroundColor = [UIColor whiteColor];
    [self.menuView addSubview:line];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarView.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [self.view addSubview:_navBarView];
        _navBarView.hidden = YES;
        [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        _navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _navBarView.titleL.text = self.navigationItem.title;
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,50+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 50;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#25262E"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
    }
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return self.dayVC;
    }else{
        return self.allVC;
    }
}

- (NoticeNewBdController *)dayVC{
    if (!_dayVC) {
        _dayVC = [[NoticeNewBdController alloc] init];
    }
    return _dayVC;
}

- (NoticeNewBdController *)allVC{
    if (!_allVC) {
        _allVC = [[NoticeNewBdController alloc] init];
        _allVC.allBd = YES;
    }
    return _allVC;
}

@end
