//
//  NoticeManageBoKeBaseController.m
//  NoticeXi
//
//  Created by li lei on 2022/9/28.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeManageBoKeBaseController.h"
#import "NoticeBoKeManagerController.h"
@interface NoticeManageBoKeBaseController ()
@property (nonatomic, strong) NoticeBoKeManagerController *waitVC;
@property (nonatomic, strong) NoticeBoKeManagerController *workVC;
@property (nonatomic, strong) NoticeBoKeManagerController *whiteVC;
@property (nonatomic, strong) NoticeBoKeManagerController *blackVC;
@end

@implementation NoticeManageBoKeBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.menuView.backgroundColor = self.view.backgroundColor;

}


- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[@"待处理",@"已处理",@"白名单",@"黑名单"];
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
        self.titleColorNormal = [UIColor colorWithHexString:@"#8A8F99"];
        self.titleColorSelected = [UIColor colorWithHexString:@"#14151A"];
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

    return (DR_SCREEN_WIDTH- GET_STRWIDTH(@"喜的欢", 18, 18)*4)/5;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#14151A"];
        case WMMenuItemStateNormal: return [UIColor colorWithHexString:@"#8A8F99"];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return  4;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.waitVC;
    }else if(index == 1){
        return self.workVC;
    }else if(index == 2){
        return self.whiteVC;
    }
    else{
        return self.blackVC;
    }
}

- (NoticeBoKeManagerController *)waitVC{
    if (!_waitVC) {
        _waitVC = [[NoticeBoKeManagerController alloc] init];
        _waitVC.type = 0;
        _waitVC.managerCode = self.managerCode;
    }
    return _waitVC;
}

- (NoticeBoKeManagerController *)workVC{
    if (!_workVC) {
        _workVC = [[NoticeBoKeManagerController alloc] init];
        _workVC.type = 1;
        _workVC.managerCode = self.managerCode;
    }
    return _workVC;
}

- (NoticeBoKeManagerController *)whiteVC{
    if (!_whiteVC) {
        _whiteVC = [[NoticeBoKeManagerController alloc] init];
        _whiteVC.type = 2;
        _whiteVC.managerCode = self.managerCode;
    }
    return _whiteVC;
}

- (NoticeBoKeManagerController *)blackVC{
    if (!_blackVC) {
        _blackVC = [[NoticeBoKeManagerController alloc] init];
        _blackVC.type = 3;
        _blackVC.managerCode = self.managerCode;
    }
    return _blackVC;
}
@end
