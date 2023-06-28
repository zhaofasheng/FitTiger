//
//  NoticeSendSysMessageManagerController.m
//  NoticeXi
//
//  Created by li lei on 2021/5/24.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendSysMessageManagerController.h"
#import "NoticeManagerSendController.h"
@interface NoticeSendSysMessageManagerController ()
@property (nonatomic, strong) NoticeManagerSendController *tsVC;
@property (nonatomic, strong) NoticeManagerSendController *bkVC;
@property (nonatomic, strong) NoticeManagerSendController *htVC;
@property (nonatomic, strong) NoticeManagerSendController *hdVC;
@property (nonatomic, strong) NoticeManagerSendController *sxjVC;
@property (nonatomic, strong) NoticeManagerSendController *fkVC;
@property (nonatomic, strong) NoticeManagerSendController *bbVC;
@property (nonatomic, strong) NoticeManagerSendController *zbVC;
@end

@implementation NoticeSendSysMessageManagerController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[@"图书",[NoticeTools getLocalStrWith:@"liten.bk"],[NoticeTools getLocalStrWith:@"search.topic"],@"活动",[NoticeTools getLocalStrWith:@"system.mark"],@"反馈",[NoticeTools getLocalStrWith:@"version.title"],@"声昔小铺"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        //self.progressWidth = GET_STRWIDTH(@"首3条私聊", 16, 16);
        self.automaticallyCalculatesItemWidths = YES;
        self.progressHeight = 2;
        self.titleSizeNormal = 13;
        self.titleSizeSelected = 16;
        self.progressViewBottomSpace = 5;
        self.progressColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        self.titleColorNormal = GetColorWithName(VMainTextColor);
        self.titleColorSelected = GetColorWithName(VMainTextColor);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.navigationItem.title = @"新系统消息";
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,0, DR_SCREEN_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,58, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-58);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 10;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:WHITEMAINCOLOR];
        case WMMenuItemStateNormal: return GetColorWithName(VMainTextColor);
    }
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.tsVC;
    }
    else if (index == 1) {
        return self.bkVC;
    }else if(index == 2){
        return self.htVC;
    }else if(index == 3){
        return self.hdVC;
    }else if(index == 4){
        return self.sxjVC;
    }else if(index == 5){
        return self.fkVC;
    }else if(index == 6){
        return self.bbVC;
    }else if(index == 7){
        return self.zbVC;
    }    else{
        return self.bbVC;
    }
}

- (NoticeManagerSendController *)tsVC{
    if (!_tsVC) {
        _tsVC = [[NoticeManagerSendController alloc] init];
        _tsVC.managerCode = self.managerCode;
        _tsVC.type = 1;
    }
    return _tsVC;
}

- (NoticeManagerSendController *)bkVC{
    if (!_bkVC) {
        _bkVC = [[NoticeManagerSendController alloc] init];
        _bkVC.type = 2;
        _bkVC.managerCode = self.managerCode;
    }
    return _bkVC;
}

- (NoticeManagerSendController *)htVC{
    if (!_htVC) {
        _htVC = [[NoticeManagerSendController alloc] init];
        _htVC.type = 3;
        _htVC.managerCode = self.managerCode;
    }
    return _htVC;
}

- (NoticeManagerSendController *)hdVC{
    if (!_hdVC) {
        _hdVC = [[NoticeManagerSendController alloc] init];
        _hdVC.type = 4;
        _hdVC.managerCode = self.managerCode;
    }
    return _hdVC;
}

- (NoticeManagerSendController *)sxjVC{
    if (!_sxjVC) {
        _sxjVC = [[NoticeManagerSendController alloc] init];
        _sxjVC.type = 5;
        _sxjVC.managerCode = self.managerCode;
    }
    return _sxjVC;
}
- (NoticeManagerSendController *)fkVC{
    if (!_fkVC) {
        _fkVC = [[NoticeManagerSendController alloc] init];
        _fkVC.type = 6;
        _fkVC.managerCode = self.managerCode;
    }
    return _fkVC;
}

- (NoticeManagerSendController *)bbVC{
    if (!_bbVC) {
        _bbVC = [[NoticeManagerSendController alloc] init];
        _bbVC.type = 7;
        _bbVC.managerCode = self.managerCode;
    }
    return _bbVC;
}
- (NoticeManagerSendController *)zbVC{
    if (!_zbVC) {
        _zbVC = [[NoticeManagerSendController alloc] init];
        _zbVC.type = 8;
        _zbVC.managerCode = self.managerCode;
    }
    return _zbVC;
}
@end
