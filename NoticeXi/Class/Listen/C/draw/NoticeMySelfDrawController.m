//
//  NoticeMySelfDrawController.m
//  NoticeXi
//
//  Created by li lei on 2020/6/1.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeMySelfDrawController.h"
#import "SPMultipleSwitch.h"
#import "NoticeDrawShowListController.h"
#import "NoticeZjModel.h"
#import "NoticeDrawViewController.h"
#import "NoticeCustumBackImageView.h"
@interface NoticeMySelfDrawController ()
@property (nonatomic, strong) SPMultipleSwitch *switchButton;
@property (nonatomic, strong) NoticeDrawShowListController *selfVC;
@property (nonatomic, strong) NoticeDrawShowListController *collectionVC;

@end

@implementation NoticeMySelfDrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
    self.menuView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];

    SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[[NoticeTools getLocalStrWith:@"tabbar.mine"],[NoticeTools getLocalStrWith:@"emtion.sc"]]];
    switch1.titleFont = TWOTEXTFONTSIZE;
    switch1.frame = CGRectMake(20,10, 62*2, 24);
    [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
    switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
    switch1.titleColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
    switch1.trackerColor = [UIColor colorWithHexString:@"#F7F8FC"];
    switch1.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.1];

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
        return self.selfVC;
    }else{
        return self.collectionVC;
    }
}

- (NoticeDrawShowListController *)selfVC{
    if (!_selfVC) {
        _selfVC = [[NoticeDrawShowListController alloc] init];
        _selfVC.listType = 3;
        _selfVC.isSelf = YES;
        if (self.isSelf) {
            _selfVC.isFromCenter = YES;
        }
        _selfVC.isFromMyDraw = YES;
        _selfVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _selfVC.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    return _selfVC;
}

- (NoticeDrawShowListController *)collectionVC{
    if (!_collectionVC) {
        _collectionVC = [[NoticeDrawShowListController alloc] init];
        _collectionVC.listType = 4;
        if (self.isSelf) {
            _collectionVC.isFromCenter = YES;
        }
        _collectionVC.isFromMyDraw = YES;
        __weak typeof(self) weakSelf = self;
        _collectionVC.setHotBlock = ^(BOOL goHot) {
            if (weakSelf.setHotBlock) {
                weakSelf.setHotBlock(YES);
            }
        };
        _collectionVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _collectionVC.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    return _collectionVC;
}


@end
