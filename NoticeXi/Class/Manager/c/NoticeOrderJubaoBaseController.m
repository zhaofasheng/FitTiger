//
//  NoticeOrderJubaoBaseController.m
//  NoticeXi
//
//  Created by li lei on 2022/7/20.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeOrderJubaoBaseController.h"
#import "NoticeOrderJubaoCheckController.h"
@interface NoticeOrderJubaoBaseController ()
@property (nonatomic, strong) NoticeOrderJubaoCheckController *magVC;
@property (nonatomic, strong) NoticeOrderJubaoCheckController *magedVC;
@end

@implementation NoticeOrderJubaoBaseController


- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[@"待处理",@"已处理"];
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

}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,0, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-50);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH(@"已完成", 20, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{

    return (DR_SCREEN_WIDTH- GET_STRWIDTH(@"已完成", 20, 18)*2)/3;
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
        return self.magVC;
    }else{
        return self.magedVC;
    }
}

- (NoticeOrderJubaoCheckController *)magVC{
    if (!_magVC) {
        _magVC = [[NoticeOrderJubaoCheckController alloc] init];
        _magVC.mangagerCode = self.mangagerCode;
    }
    return _magVC;
}

- (NoticeOrderJubaoCheckController *)magedVC{
    if (!_magedVC) {
        _magedVC = [[NoticeOrderJubaoCheckController alloc] init];
        _magedVC.mangagerCode = self.mangagerCode;
        _magedVC.hasChuli = YES;
    }
    return _magedVC;
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
