//
//  NoticeHelpBaseController.m
//  NoticeXi
//
//  Created by li lei on 2022/8/18.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeHelpBaseController.h"
#import "NoticeHelpListController.h"
#import "NoticeCustumeNavView.h"
#import "NoticreSendHelpController.h"
#import "NoticeSupportedHelpController.h"
@interface NoticeHelpBaseController ()
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@property (nonatomic, strong) NoticeHelpListController *mineVC;
@property (nonatomic, strong) NoticeHelpListController *qiuzhuVC;
@property (nonatomic, strong) NoticeSupportedHelpController *supportVC;
@property (nonatomic, strong) UIImageView *leadImageView;
@end

@implementation NoticeHelpBaseController


- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"groundg.grou"],[NoticeTools getLocalStrWith:@"tabbar.mine"],[NoticeTools chinese:@"建议过" english:@"Commented" japan:@"提案をした"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH([NoticeTools getLocalStrWith:@"tabbar.mine"], 20, 18);
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
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView.rightButton setImage:UIImageNamed(@"sendhelpImg") forState:UIControlStateNormal];
    [self.navBarView.rightButton addTarget:self action:@selector(sendHelpClick) forControlEvents:UIControlEventTouchUpInside];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"help.qiuz"];
    if([NoticeTools isFirstDrawOnThisDeveice]){
        [self.navigationController.view addSubview:self.leadImageView];
    }
}

- (void)sendHelpClick{
    __weak typeof(self) weakSelf = self;
    NoticreSendHelpController *ctl = [[NoticreSendHelpController alloc] init];
    ctl.upSuccess = ^(BOOL success) {
        weakSelf.selectIndex = 0;
        [weakSelf.qiuzhuVC.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UIImageView *)leadImageView{
    if(!_leadImageView){
        _leadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _leadImageView.userInteractionEnabled = YES;
        _leadImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leadImageView.clipsToBounds = YES;
        _leadImageView.image = UIImageNamed(@"leadhelp_img");
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leadTap)];
        [_leadImageView addGestureRecognizer:tap];
    }
    return _leadImageView;
}

- (void)leadTap{
    [self.leadImageView removeFromSuperview];
    [NoticeTools setMarkForDraw];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
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
        _navBarView.titleL.text = self.navigationItem.title;
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}



- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH(@"GroundBack", 20, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return (DR_SCREEN_WIDTH- GET_STRWIDTH(@"GroundBack", 20, 18)*3)/4;
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
        return self.mineVC;
    }else if (index == 2){
        return self.supportVC;
    }
    else{
        return self.qiuzhuVC;
    }
}

- (NoticeHelpListController *)mineVC{
    if (!_mineVC) {
        
        _mineVC = [[NoticeHelpListController alloc] init];
        _mineVC.isMine = YES;
    }
    return _mineVC;
}

- (NoticeHelpListController *)qiuzhuVC{
    if (!_qiuzhuVC) {
        _qiuzhuVC = [[NoticeHelpListController alloc] init];
    }
    return _qiuzhuVC;
}

- (NoticeSupportedHelpController *)supportVC{
    if(!_supportVC){
        _supportVC = [[NoticeSupportedHelpController alloc] init];
    }
    return _supportVC;
}

@end
