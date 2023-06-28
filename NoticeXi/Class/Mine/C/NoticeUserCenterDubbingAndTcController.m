//
//  NoticeUserCenterDubbingAndTcController.m
//  NoticeXi
//
//  Created by li lei on 2023/2/27.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserCenterDubbingAndTcController.h"
#import "NoticeMyDownloadPyController.h"
#import "NoticeTcController.h"
#import "SPMultipleSwitch.h"
@interface NoticeUserCenterDubbingAndTcController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) NoticeMyDownloadPyController *pyVC;
@property (nonatomic, strong) NoticeTcController *lineVC;
@property (nonatomic, strong) SPMultipleSwitch *switchButton;
@property (nonatomic, strong) UIButton *paixuButton;
@property (nonatomic, assign) BOOL isHot;
@end

@implementation NoticeUserCenterDubbingAndTcController

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    !self.scrollCallback ?: self.scrollCallback(scrollView);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *apdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:apdel.backImg?0:1];
    self.menuView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:apdel.backImg?0:1];

    SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[[NoticeTools getLocalStrWith:@"main.py"],[NoticeTools getLocalStrWith:@"py.tc"]]];
    switch1.titleFont = TWOTEXTFONTSIZE;
    switch1.frame = CGRectMake(20,10, 62*2, 24);
    [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
    switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
    switch1.titleColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
    switch1.trackerColor = [UIColor colorWithHexString:@"#F7F8FC"];
    switch1.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.1];
    _switchButton = switch1;
    [self.menuView addSubview:_switchButton];

    self.paixuButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-60, 10, 60, 24)];
    [self.paixuButton setImage:UIImageNamed(@"pypaixu_img") forState:UIControlStateNormal];
    [self.paixuButton setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
    self.paixuButton.titleLabel.font = TWOTEXTFONTSIZE;
    [self.menuView addSubview:self.paixuButton];
    [self.paixuButton setTitle:[NoticeTools getLocalStrWith:@"py.zuixin"] forState:UIControlStateNormal];
    [self.paixuButton addTarget:self action:@selector(paixuClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)paixuClick{
    self.isHot = !self.isHot;
    if (self.isHot) {
        [self.paixuButton setTitle:[NoticeTools getLocalStrWith:@"py.zuihot"] forState:UIControlStateNormal];
    }else{
        [self.paixuButton setTitle:[NoticeTools getLocalStrWith:@"py.zuixin"] forState:UIControlStateNormal];
    }
    self.pyVC.isOrderByHot = self.isHot;
    self.lineVC.isOrderByHot = self.isHot;
    [self.pyVC.tableView.mj_header beginRefreshing];
    [self.lineVC.tableView.mj_header beginRefreshing];
}

- (void)changeVale:(SPMultipleSwitch *)swithbtn{
    self.selectIndex = (int)swithbtn.selectedSegmentIndex;
}

- (void)getCurrentScrollSet:(CGFloat)contentXset{

    CGFloat bilX = (115 /2) / DR_SCREEN_WIDTH;
    _switchButton.tracker.frame = CGRectMake(bilX*contentXset, 0,_switchButton.frame.size.width/2, _switchButton.frame.size.height);
}

- (void)getCurrentIndex:(NSInteger)currentIndex{

    _switchButton.selectedSegmentIndex = currentIndex;

}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    return CGRectMake(0,0, DR_SCREEN_WIDTH,44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,44, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-44-48);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.pyVC;
    }else{
        return self.lineVC;
    }
}

- (NoticeTcController *)lineVC{
    if (!_lineVC) {
        _lineVC = [[NoticeTcController alloc] init];
        _lineVC.needBackGround = YES;
        _lineVC.isUserCenter = YES;
        _lineVC.userId = self.userId;
        _lineVC.isOther = self.isOther;
        _lineVC.isUserLine = YES;
        _lineVC.type = 1;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg) {
            _lineVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _lineVC.tableView.backgroundColor = _lineVC.view.backgroundColor;
        }
    }
    return _lineVC;
}

- (NoticeMyDownloadPyController *)pyVC{
    if (!_pyVC) {
        _pyVC = [[NoticeMyDownloadPyController alloc] init];
        _pyVC.needBackGround = YES;
        _pyVC.isUserCenter = YES;
        _pyVC.isOther = self.isOther;
        _pyVC.isUserPy = YES;
        _pyVC.isFromUserCenter = YES;
        _pyVC.userId = self.userId;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg) {
            _pyVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _pyVC.tableView.backgroundColor = _pyVC.view.backgroundColor;
        }
    }
    return _pyVC;
}

@end
