//
//  NoticeVoiceCommentNewsController.m
//  NoticeXi
//
//  Created by li lei on 2022/2/26.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceCommentNewsController.h"
#import "NoticeVoiceViewController.h"
#import "NoticeGetlikeListController.h"
@interface NoticeVoiceCommentNewsController ()
@property (nonatomic, strong) NoticeGetlikeListController *likeVC;
@property (nonatomic, strong) NoticeVoiceViewController *tietieVC;
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@end

@implementation NoticeVoiceCommentNewsController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools chinese:@"收到的" english:@"Received" japan:@"受け取った"],[NoticeTools chinese:@"贴过的" english:@"Liked" japan:@"気に入った"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH([NoticeTools chinese:@"收到的" english:@"Received" japan:@"受け取った"], 20, 18);
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
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];

    self.menuView.backgroundColor = [UIColor whiteColor];
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
        _navBarView.titleL.text = [NoticeTools chinese:@"贴贴和点赞" english:@"Likes" japan:@"気に入った"];
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}



- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT+48, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH(@"GroundBack", 20, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return (DR_SCREEN_WIDTH- GET_STRWIDTH(@"GroundBack", 20, 18)*2)/3;
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
    if (index == 1) {
        return self.tietieVC;
    }else{
        return self.likeVC;
    }
}

- (NoticeVoiceViewController *)tietieVC{
    if (!_tietieVC) {
        _tietieVC = [[NoticeVoiceViewController alloc] init];
        _tietieVC.isTietie = YES;
    }
    return _tietieVC;
}

- (NoticeGetlikeListController *)likeVC{
    if (!_likeVC) {
        _likeVC = [[NoticeGetlikeListController alloc] init];
    }
    return _likeVC;
}
@end
