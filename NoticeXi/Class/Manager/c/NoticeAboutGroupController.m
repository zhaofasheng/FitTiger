//
//  NoticeAboutGroupController.m
//  NoticeXi
//
//  Created by li lei on 2023/6/27.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeAboutGroupController.h"
#import "NoticeTeamWorkShowController.h"
@interface NoticeAboutGroupController ()
@property (nonatomic, strong) NoticeTeamWorkShowController *outVC;
@property (nonatomic, strong) NoticeTeamWorkShowController *manVC;
@end

@implementation NoticeAboutGroupController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[@"踢人记录",@"管理记录"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"踢人记录", 20, 18);
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


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,0, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-50);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH(@"已完成的", 20, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{

    return (DR_SCREEN_WIDTH- GET_STRWIDTH(@"已完成的", 20, 18)*2)/3;
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
        return self.outVC;
    }else{
        return self.manVC;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.menuView.backgroundColor = self.view.backgroundColor;

}

- (NoticeTeamWorkShowController *)outVC{
    if(!_outVC){
        _outVC = [[NoticeTeamWorkShowController alloc] init];
        _outVC.mangagerCode = self.mangagerCode;
        _outVC.isOut = YES;
    }
    return _outVC;
}

- (NoticeTeamWorkShowController *)manVC{
    if(!_manVC){
        _manVC = [[NoticeTeamWorkShowController alloc] init];
        _manVC.mangagerCode = self.mangagerCode;
    }
    return _manVC;
}
@end
