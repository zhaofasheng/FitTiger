//
//  NoticeMyCareController.m
//  NoticeXi
//
//  Created by li lei on 2019/12/26.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyCareController.h"
#import "NoticeMyCareListController.h"
@interface NoticeMyCareController ()
@property (nonatomic, strong) NoticeMyCareListController *movieVC;
@property (nonatomic, strong) NoticeMyCareListController *bookVC;
@property (nonatomic, strong) NoticeMyCareListController *songVC;
@end

@implementation NoticeMyCareController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getTextWithSim:@"电影" fantText:@"電影"],[NoticeTools getTextWithSim:@"书籍" fantText:@"書籍"],[NoticeTools isSimpleLau] ?@"唱回忆":@"唱回憶"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"好", 14, 14);
        self.progressHeight = 2;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.progressViewBottomSpace = 5;
        self.progressColor = GetColorWithName(VMainThumeColor);
        self.titleColorNormal = GetColorWithName(VMainTextColor);
        self.titleColorSelected = GetColorWithName(VMainTextColor);

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.needCellScrool = YES;
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.navigationItem.title = [NoticeTools getTextWithSim:@"我的欣赏" fantText:@"我的關註"];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 35, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [btn setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_listenkf_b":@"Image_listenkf_y") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(kefuClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self setSelectIndex:(int)self.type-1];
}

- (void)kefuClick{
    [NoticeComTools connectXiaoer];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,0, DR_SCREEN_WIDTH,35);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,35, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-35);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return GET_STRWIDTH(@"喜欢哈", 14, 14);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return (DR_SCREEN_WIDTH-GET_STRWIDTH(@"喜欢哈", 14, 14)*4)/4;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return GetColorWithName(VMainThumeColor);
        case WMMenuItemStateNormal: return GetColorWithName(VMainTextColor);
    }
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.movieVC;
    }else if(index == 1){
        return self.bookVC;
    }else {
        return self.songVC;
    }
}

- (NoticeMyCareListController *)movieVC{
    if (!_movieVC) {
        _movieVC = [[NoticeMyCareListController alloc] init];
        _movieVC.type = 1;
    }
    return _movieVC;
}

- (NoticeMyCareListController *)bookVC{
    if (!_bookVC) {
        _bookVC = [[NoticeMyCareListController alloc] init];
        _bookVC.type = 2;
    }
    return _bookVC;
}

- (NoticeMyCareListController *)songVC{
    if (!_songVC) {
        _songVC = [[NoticeMyCareListController alloc] init];
        _songVC.type = 3;
    }
    return _songVC;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer.state != 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
