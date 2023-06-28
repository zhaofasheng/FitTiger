//
//  NoticeMyBookController.m
//  NoticeXi
//
//  Created by li lei on 2019/12/24.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyBookController.h"
#import "NoticeMyMovieComController.h"
#import "NoticeNoticenterModel.h"
#import "NoticeMyMovieComController.h"
#import "NoticeCustumBackImageView.h"
#import "NoticeMySelfDrawController.h"
@interface NoticeMyBookController ()
@property (nonatomic, strong) NoticeMyMovieComController *vcAll;
@property (nonatomic, strong) NoticeMyMovieComController *vclike;
@property (nonatomic, strong) NoticeMyMovieComController *vcMid;
@property (nonatomic, strong) NoticeMySelfDrawController *drawVC;
@property (nonatomic, strong) UIView *mbsView;
@property (nonatomic, strong) NoticeCustumBackImageView *backGroundImageView;
@end

@implementation NoticeMyBookController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"main.book"],[NoticeTools getLocalStrWith:@"main.movie"],[NoticeTools getLocalStrWith:@"main.song"],[NoticeTools getLocalStrWith:@"main.draw"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH([NoticeTools getLocalStrWith:@"main.movie"], 20, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 17;
        self.titleSizeSelected = 17;
        self.progressViewBottomSpace = 0;
        self.progressColor = [UIColor colorWithHexString:@"#05A8FA"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.7];
        self.titleColorSelected = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.view.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
    self.navigationItem.title = [NoticeTools getLocalType]==1?@"Past": ([NoticeTools getLocalType]==2?@"過去": @"书影音画");
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarView.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [self.view addSubview:_navBarView];
        _navBarView.hidden = YES;
        _navBarView.titleL.text = self.navigationItem.title;
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH([NoticeTools getLocalStrWith:@"main.movie"], 20, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{

    return (DR_SCREEN_WIDTH- GET_STRWIDTH([NoticeTools getLocalStrWith:@"main.movie"], 20, 18)*4)/5;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#FFFFFF"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.7];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 4;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.vcAll;
    }else if(index == 1){
        return self.vclike;
    }else if(index == 2){
        return self.vcMid;
    }else{
        return self.drawVC;
    }
}
- (NoticeMyMovieComController *)vcAll{
    if (!_vcAll) {
        _vcAll = [[NoticeMyMovieComController alloc] init];
        _vcAll.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _vcAll.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _vcAll.type = 2;
    }
    return _vcAll;
}
- (NoticeMyMovieComController *)vclike{
    if (!_vclike) {
        _vclike = [[NoticeMyMovieComController alloc] init];
        _vclike.type = 1;
        _vclike.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _vclike.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    return _vclike;
}
- (NoticeMyMovieComController *)vcMid{
    if (!_vcMid) {
        _vcMid = [[NoticeMyMovieComController alloc] init];
        _vcMid.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _vcMid.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _vcMid.type = 3;
    }
    return _vcMid;
}

- (NoticeMySelfDrawController *)drawVC{
    if (!_drawVC) {
        _drawVC = [[NoticeMySelfDrawController alloc] init];
    }
    return _drawVC;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.vcAll.isReplay = YES;

    [self.vcAll.audioPlayer stopPlaying];
}

@end
