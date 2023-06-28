//
//  NoticeBuyOrderListController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBuyOrderListController.h"
#import "NoticeOrderListController.h"
@interface NoticeBuyOrderListController ()
@property (nonatomic, strong) NoticeOrderListController *finishVC;
@property (nonatomic, strong) NoticeOrderListController *noComVC;
@property (nonatomic, strong) NoticeOrderListController *hasComVC;
@end

@implementation NoticeBuyOrderListController


- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[@"全部",@"待评价",@"已评价"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"已完成", 20, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 18;
        self.progressViewBottomSpace = 0;
        self.progressColor = [UIColor colorWithHexString:@"#05A8FA"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
        self.titleColorSelected = [UIColor colorWithHexString:@"#25262E"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.view addSubview:self.navBarView];
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH(@"已完成", 20, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{

    return (DR_SCREEN_WIDTH- GET_STRWIDTH(@"已完成", 20, 18)*3)/4;
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
    if (index == 0) {
        return self.finishVC;
    }else if(index == 1){
        return self.noComVC;
    }else{
        return self.hasComVC;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        _navBarView.titleL.text = @"买过的";
        _navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _navBarView;
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NoticeOrderListController *)finishVC{
    if (!_finishVC) {
        _finishVC = [[NoticeOrderListController alloc] init];
        _finishVC.type = @"1";
        _finishVC.userType = @"2";
    }
    return _finishVC;
}


- (NoticeOrderListController *)noComVC{
    if (!_noComVC) {
        _noComVC = [[NoticeOrderListController alloc] init];
        _noComVC.type = @"2";
        _noComVC.userType = @"2";
    }
    return _noComVC;
}

- (NoticeOrderListController *)hasComVC{
    if (!_hasComVC) {
        _hasComVC = [[NoticeOrderListController alloc] init];
        _hasComVC.type = @"3";
        _hasComVC.userType = @"2";
    }
    return _hasComVC;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}

@end
