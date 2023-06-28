//
//  NoticeQuestionBaseController.m
//  NoticeXi
//
//  Created by li lei on 2021/6/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeQuestionBaseController.h"
#import "NoticeUserQuestionController.h"
@interface NoticeQuestionBaseController ()
@property (nonatomic, strong) NoticeUserQuestionController *allVC;
@property (nonatomic, strong) NoticeUserQuestionController *yiduVC;
@property (nonatomic, strong) NoticeUserQuestionController *bjVC;
@end

@implementation NoticeQuestionBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.menuView.backgroundColor = self.view.backgroundColor;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,47, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    [self.menuView addSubview:line];
}
- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"py.allPy"],[NoticeTools getLocalStrWith:@"listen.noRead"],@"已标记"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"好好的", 18, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 18;
        self.progressViewBottomSpace = 0;
        self.progressColor = [UIColor colorWithHexString:@"#05A8FA"];
        self.titleColorNormal = [UIColor colorWithHexString:@"#FFFFFF"];
        self.titleColorSelected = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return self;
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,0, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-58);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH(@"喜的欢", 18, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{

    return (DR_SCREEN_WIDTH- GET_STRWIDTH(@"喜的欢", 18, 18)*3)/4;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#FFFFFF"];
        case WMMenuItemStateNormal: return [UIColor colorWithHexString:@"#FFFFFF"];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return  3;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.allVC;
    }else if(index == 1){
        return self.yiduVC;
    }else{
        return self.bjVC;
    }
}
- (NoticeUserQuestionController *)allVC{
    if (!_allVC) {
        _allVC = [[NoticeUserQuestionController alloc] init];
        _allVC.managerCode = self.managerCode;
        _allVC.type = 0;
    }
    return _allVC;
}
- (NoticeUserQuestionController *)yiduVC{
    if (!_yiduVC) {
        _yiduVC = [[NoticeUserQuestionController alloc] init];
        _yiduVC.managerCode = self.managerCode;
        _yiduVC.type = 1;
    }
    return _yiduVC;
}
- (NoticeUserQuestionController *)bjVC{
    if (!_bjVC) {
        _bjVC = [[NoticeUserQuestionController alloc] init];
        _bjVC.managerCode = self.managerCode;
        _bjVC.type = 2;
    }
    return _bjVC;
}

@end
