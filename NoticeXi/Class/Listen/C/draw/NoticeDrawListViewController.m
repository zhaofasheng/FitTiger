//
//  NoticeDrawListViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/7/8.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeDrawListViewController.h"
#import "NoticeDrawViewController.h"
#import "NoticeDrawDateViewController.h"
#import "NoticeMySelfDrawController.h"
#import "NoticeDrawShowListController.h"
#import "FSCustomButton.h"
#import "UIImage+Color.h"
@interface NoticeDrawListViewController ()
@property (nonatomic, strong) NoticeDrawShowListController *hotVC;
@property (nonatomic, strong) NoticeDrawShowListController *tuijianVC;
@property (nonatomic, strong) NoticeDrawShowListController *nowVC;
@property (nonatomic, strong) NoticeMySelfDrawController *selfVC;
@end

@implementation NoticeDrawListViewController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getTextWithSim:@"今日推荐" fantText:@"今日推薦"],[NoticeTools isSimpleLau]?@"热门":@"熱門",[NoticeTools isSimpleLau]?@"实时":@"實時",@"我的"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressViewWidths = @[@(GET_STRWIDTH(@"今日推荐", 16, 16)),@(GET_STRWIDTH([NoticeTools getLocalStrWith:@"hh.zuop"], 16, 16)),@(GET_STRWIDTH([NoticeTools getLocalStrWith:@"hh.zuop"], 16, 16)),@(GET_STRWIDTH([NoticeTools getLocalStrWith:@"hh.zuop"], 16, 16))];
        self.progressHeight = 2;
        self.titleSizeNormal = 13;
        self.titleSizeSelected = 16;
        self.progressViewBottomSpace = 5;
        self.progressColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]? WHITEMAINCOLOR:@"#318F90"];
        self.titleColorNormal = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#757575":@"#318F90"];
        self.titleColorSelected = GetColorWithName(VMainTextColor);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools isSimpleLau]?@"灵魂画手":@"靈魂畫手";
    self.view.backgroundColor = GetColorWithName(VBackColor);
    FSCustomButton *btn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0,30, 40)];
    [btn setImage:[UIImage imageNamed:[NoticeTools isWhiteTheme]? @"drawClickImg":@"drawClickImgy"] forState:UIControlStateNormal];
    [btn setTitle:@"  " forState:UIControlStateNormal];
    [btn setButtonImagePosition:FSCustomButtonImagePositionRight];
    [btn addTarget:self action:@selector(drawClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIImageView *markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*95/375)];
    markImageView.image = UIImageNamed([NoticeTools isSimpleLau]?  @"drawIsE" : @"drawIsEF");
    [self.view addSubview:markImageView];
    if (![NoticeTools isWhiteTheme]) {
        UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, markImageView.frame.size.height)];
        mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [markImageView addSubview:mbView];
    }
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 42, 44);
    [backButton setTitle:@"    " forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    if ([NoticeTools isWhiteTheme]) {
        [backButton setImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateNormal];
    }else{
        [backButton setImage:[UIImage imageNamed:@"btn_nav_white"] forState:UIControlStateNormal];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goNowVC) name:@"CHANGETHEROOTSELECTART" object:nil];
}

- (void)backToPageAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    return CGRectMake(0,DR_SCREEN_WIDTH*95/375, DR_SCREEN_WIDTH, 42);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,DR_SCREEN_WIDTH*95/375+42, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-(DR_SCREEN_WIDTH*95/375+42));
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 4;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return GET_STRWIDTH(self.titles[index], 16, 16);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return (DR_SCREEN_WIDTH-GET_STRWIDTH(@"你好", 14, 50)*5)/5-1-5;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return GetColorWithName(VMainThumeColor);
        case WMMenuItemStateNormal: return [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#757575":@"#72727f"];
    }
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return self.tuijianVC;
    }else if(index == 1){
        return self.hotVC;
    }else if(index == 2){
        return self.nowVC;
    }else{
        return self.selfVC;
    }
}

- (void)drawClick{
     NoticeDrawViewController *ctl = [[NoticeDrawViewController alloc] init];
     [self.navigationController pushViewController:ctl animated:YES];
}
- (void)goNowVC{
    self.selectIndex = 2;
}

- (NoticeDrawShowListController *)tuijianVC{
    if (!_tuijianVC) {
        _tuijianVC = [[NoticeDrawShowListController alloc] init];
        _tuijianVC.listType = 0;
        __weak typeof(self) weakSelf = self;
        _tuijianVC.setHotBlock = ^(BOOL goHot) {
            weakSelf.selectIndex = 1;
        };
    }
    return _tuijianVC;
}

- (NoticeDrawShowListController *)hotVC{
    if (!_hotVC) {
        _hotVC = [[NoticeDrawShowListController alloc] init];
        _hotVC.listType = 1;
        __weak typeof(self) weakSelf = self;
        _hotVC.setNowBlock = ^(BOOL goNow) {
            weakSelf.selectIndex = 2;
        };
    }
    return _hotVC;
}

- (NoticeDrawShowListController *)nowVC{
    if (!_nowVC) {
        _nowVC = [[NoticeDrawShowListController alloc] init];
        _nowVC.listType = 2;
    }
    return _nowVC;
}

- (NoticeMySelfDrawController *)selfVC{
    if (!_selfVC) {
        _selfVC = [[NoticeMySelfDrawController alloc] init];
        __weak typeof(self) weakSelf = self;
        _selfVC.setHotBlock = ^(BOOL goHot) {
            weakSelf.selectIndex = 1;
        };
    }
    return _selfVC;
}
@end
