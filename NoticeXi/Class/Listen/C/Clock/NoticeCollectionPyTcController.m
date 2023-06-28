//
//  NoticeCollectionPyTcController.m
//  NoticeXi
//
//  Created by li lei on 2021/5/6.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCollectionPyTcController.h"
#import "NoticeMyDownloadPyController.h"
#import "NoticeTcController.h"
#import "SPMultipleSwitch.h"
@interface NoticeCollectionPyTcController ()
@property (nonatomic, strong) NoticeMyDownloadPyController *pyVC;
@property (nonatomic, strong) NoticeTcController *lineVC;
@property (nonatomic, strong) SPMultipleSwitch *switchButton;
@end

@implementation NoticeCollectionPyTcController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *apdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:apdel.backImg?0:1];
    self.menuView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:apdel.backImg?0:1];

    SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[[NoticeTools getLocalStrWith:@"main.py"],[NoticeTools getLocalStrWith:@"py.tc"]]];
    switch1.titleFont = TWOTEXTFONTSIZE;
    switch1.frame = CGRectMake(20,10, 62*2, 24);
    [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
    if (self.needBackGround) {
        switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
        switch1.titleColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        switch1.trackerColor = [UIColor colorWithHexString:@"#F7F8FC"];
        switch1.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.1];
    }else{
        switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
        switch1.titleColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
        switch1.trackerColor = [UIColor colorWithHexString:@"#FFFFFF"];
        switch1.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:1];
    }

    _switchButton = switch1;
    [self.menuView addSubview:_switchButton];
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
        _lineVC.needBackGround = self.needBackGround;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg && self.needBackGround) {
            _lineVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _lineVC.tableView.backgroundColor = _lineVC.view.backgroundColor;
        }
        _lineVC.isCollection = YES;
    }
    return _lineVC;
}

- (NoticeMyDownloadPyController *)pyVC{
    if (!_pyVC) {
        _pyVC = [[NoticeMyDownloadPyController alloc] init];
        _pyVC.needBackGround = self.needBackGround;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg && self.needBackGround) {
            _pyVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _pyVC.tableView.backgroundColor = _pyVC.view.backgroundColor;
        }
        _pyVC.isDownload = YES;
    }
    return _pyVC;
}
@end
