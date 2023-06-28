//
//  NoticerClockController.m
//  NoticeXi
//
//  Created by li lei on 2019/10/16.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticerClockController.h"
#import "NoticeBdController.h"
#import "NoticeTcController.h"
#import "NoticeClockMyClockController.h"
#import "JXPagerListRefreshView.h"
#import "NoticeClockPyController.h"
#import "NoticeSendTCController.h"
#import "NoticeClockPyModel.h"
#import "NoticeSendTCController.h"
#import "NoticeUserDubbingAndLineController.h"
#import "NoticeCustumBackImageView.h"
@interface NoticerClockController ()
@property (nonatomic, strong) NoticeClockPyController *pyVC;
@property (nonatomic, strong) NoticeTcController *tcVC;
@end

@implementation NoticerClockController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"main.py"],[NoticeTools getLocalStrWith:@"py.tc"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"心情", 20, 20);
        self.progressHeight = 2;
        self.progressViewBottomSpace = 4;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 20;
        self.progressColor = [UIColor colorWithHexString:@"#05A8FA"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
        self.titleColorSelected = [UIColor colorWithHexString:@"#25262E"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(7, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-32, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2, 32, 32)];
    iconImageView.userInteractionEnabled = YES;
    iconImageView.layer.cornerRadius = 16;
    iconImageView.layer.masksToBounds = YES;
    [self.view addSubview:iconImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [iconImageView addGestureRecognizer:tap];
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
    
    UIButton *sendTcBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-68, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-40-68, 68, 68)];
    [sendTcBtn setBackgroundImage:UIImageNamed(@"Image_sendtcnew") forState:UIControlStateNormal];
    [self.view addSubview:sendTcBtn];
    [sendTcBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)sendClick{
    NoticeSendTCController *ctl = [[NoticeSendTCController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)iconTap{
    NoticeUserDubbingAndLineController *ctl = [[NoticeUserDubbingAndLineController alloc] init];
    ctl.isUserPy = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    return CGRectMake(0,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 0;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#25262E"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
    }
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return self.pyVC;
    }else{
        return self.tcVC;
    }
}

- (NoticeClockPyController *)pyVC{
    if (!_pyVC) {
        _pyVC = [[NoticeClockPyController alloc] init];
        _pyVC.isMain = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.alphaValue >0 && appdel.alphaValue < 0.9) {
            _pyVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _pyVC.tableView.backgroundColor = _pyVC.view.backgroundColor;
        }
  
    }
    return _pyVC;
}

- (NoticeTcController *)tcVC{
    if (!_tcVC) {
        _tcVC = [[NoticeTcController alloc] init];
        _tcVC.needTag = YES;
        _tcVC.isMain = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.alphaValue >0 && appdel.alphaValue < 0.9) {
            _tcVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _tcVC.tableView.backgroundColor = _tcVC.view.backgroundColor;
        }
       
    }
    return _tcVC;
}

@end
