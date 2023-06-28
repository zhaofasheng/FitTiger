//
//  NoticePayAndSendRecoderController.m
//  NoticeXi
//
//  Created by li lei on 2022/5/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticePayAndSendRecoderController.h"
#import "NoticePayRecodController.h"
#import "NoticeCustumeNavView.h"
@interface NoticePayAndSendRecoderController ()
@property (nonatomic, strong) NoticePayRecodController *payVC;
@property (nonatomic, strong) NoticePayRecodController *sendVC;
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;
@end

@implementation NoticePayAndSendRecoderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"zb.chjilu"];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundEffect = nil;
        appperance.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];//设置导航条颜色
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = [[UIColor greenColor] colorWithAlphaComponent:0];
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#25262E"],NSFontAttributeName:XGTwentyBoldFontSize}];
        UINavigationBar *navgationBar = self.navigationController.navigationBar;
        navgationBar.standardAppearance = appperance;
        navgationBar.scrollEdgeAppearance = appperance;
        //透明
        self.navigationController.navigationBar.translucent = YES;
    }else{
    
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];//设置阴影图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //透明
        self.navigationController.navigationBar.translucent = YES;
    }
    self.navBarView.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];//设置导航条颜色
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = nil;
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#25262E"],NSFontAttributeName:XGTwentyBoldFontSize}];
        UINavigationBar *navgationBar = self.navigationController.navigationBar;;
        navgationBar.standardAppearance = appperance;
        navgationBar.scrollEdgeAppearance = appperance;
        //不透明
        self.navigationController.navigationBar.translucent = NO;
        
    }else{
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];//设置阴影图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = NO;
    }
}


- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [self.view addSubview:_navBarView];
        _navBarView.titleL.text = self.navigationItem.title;
        _navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"send.buyself"],[NoticeTools getLocalStrWith:@"send.buyre"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH([NoticeTools getLocalStrWith:@"send.buyre"], 18, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 16;
        self.progressViewBottomSpace = 0;
        self.progressColor = [UIColor colorWithHexString:@"#0099E6"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
        self.titleColorSelected = [UIColor colorWithHexString:@"#25262E"];
    }
    return self;
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH([NoticeTools getLocalStrWith:@"send.buyre"], 18, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return (DR_SCREEN_WIDTH- GET_STRWIDTH([NoticeTools getLocalStrWith:@"send.buyre"], 18, 18)*2)/3;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#25262E"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
    }
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.payVC;
    }else{
        return self.sendVC;
    }
}

- (NoticePayRecodController *)payVC{
    if (!_payVC) {
        _payVC = [[NoticePayRecodController alloc] init];
    }
    return _payVC;
}

- (NoticePayRecodController *)sendVC{
    if (!_sendVC) {
        _sendVC = [[NoticePayRecodController alloc] init];
        _sendVC.isSend = YES;
    }
    return _sendVC;
}
@end
