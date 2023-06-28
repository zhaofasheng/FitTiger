//
//  NoticeAllMBSController.m
//  NoticeXi
//
//  Created by li lei on 2021/7/30.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeAllMBSController.h"
#import "NoticeMyMovieComController.h"
#import "NoticeCustumeNavView.h"
#import "NoticeCustumBackImageView.h"
@interface NoticeAllMBSController ()
@property (nonatomic, strong) NoticeMyMovieComController *allVC;
@property (nonatomic, strong) NoticeMyMovieComController *mVC;
@property (nonatomic, strong) NoticeMyMovieComController *bVC;
@property (nonatomic, strong) NoticeMyMovieComController *yVC;
@property (nonatomic, strong) UIView *mbsView;
@property (nonatomic, strong) NoticeCustumBackImageView *backGroundImageView;
@end

@implementation NoticeAllMBSController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"py.allPy"],[NoticeTools getLocalStrWith:@"main.book"],[NoticeTools getLocalStrWith:@"main.movie"],[NoticeTools getLocalStrWith:@"main.song"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"好好", 18, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 18;
        self.progressViewBottomSpace = 0;
        self.progressColor = [UIColor colorWithHexString:@"#05A8FA"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.7];
        self.titleColorSelected = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return self;
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.userId?[NoticeTools getLocalStrWith:@"syy.he"]:[NoticeTools getLocalStrWith:@"minee.syy"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,47, DR_SCREEN_WIDTH, 1)];
    
    [self.menuView addSubview:line];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.alphaValue >0 && appdel.alphaValue < 0.9) {
        self.backGroundImageView = [[NoticeCustumBackImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [self.view addSubview:self.backGroundImageView];
        self.backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backGroundImageView.clipsToBounds = YES;
        self.backGroundImageView.hidden = YES;
        
        UIView *mbV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        mbV.backgroundColor = [[UIColor colorWithHexString:@"#14151A"]colorWithAlphaComponent:appdel.alphaValue>0?appdel.alphaValue:0.2];
        [self.backGroundImageView addSubview:mbV];
        self.mbsView = mbV;
        
        self.mbsView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"]colorWithAlphaComponent:appdel.alphaValue>0?appdel.alphaValue:0.3];
        if (appdel.backImg) {
            self.backGroundImageView.hidden = NO;
            self.backGroundImageView.image = [UIImage boxblurImage:appdel.backImg withBlurNumber:appdel.effect];
        }else{
            self.backGroundImageView.hidden = YES;
        }
        line.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.1];
        [self.view sendSubviewToBack:self.backGroundImageView];
    }else{
        line.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    }

    
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

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH(@"喜欢的", 18, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{

    return (DR_SCREEN_WIDTH- GET_STRWIDTH(@"喜欢的", 18, 18)*4)/5;
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
        return self.allVC;
    }else if(index == 1){
        return self.bVC;
    }else if(index == 2) {
        return self.mVC;
    }else{
        return self.yVC;
    }
}

- (NoticeMyMovieComController *)allVC{
    if (!_allVC) {
        _allVC = [[NoticeMyMovieComController alloc] init];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.alphaValue >0 && appdel.alphaValue < 0.9) {
            _allVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _allVC.tableView.backgroundColor = _allVC.view.backgroundColor;
        }

        _allVC.userId = self.userId;
        _allVC.type = 0;
        _allVC.fromUserCenter = YES;
    }
    return _allVC;
}

- (NoticeMyMovieComController *)mVC{
    if (!_mVC) {
        _mVC = [[NoticeMyMovieComController alloc] init];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.alphaValue >0 && appdel.alphaValue < 0.9) {
            _mVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _mVC.tableView.backgroundColor = _allVC.view.backgroundColor;
        }
 
        _mVC.userId = self.userId;
        _mVC.type = 1;
        _mVC.fromUserCenter = YES;
    }
    return _mVC;
}

- (NoticeMyMovieComController *)bVC{
    if (!_bVC) {
        _bVC = [[NoticeMyMovieComController alloc] init];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.alphaValue >0 && appdel.alphaValue < 0.9) {
            _bVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _bVC.tableView.backgroundColor = _allVC.view.backgroundColor;
        }
   
        _bVC.userId = self.userId;
        _bVC.type = 2;
        _bVC.fromUserCenter = YES;
    }
    return _bVC;
}

- (NoticeMyMovieComController *)yVC{
    if (!_yVC) {
        _yVC = [[NoticeMyMovieComController alloc] init];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.alphaValue >0 && appdel.alphaValue < 0.9) {
            _yVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _yVC.tableView.backgroundColor = _allVC.view.backgroundColor;
        }
       
        _yVC.userId = self.userId;
        _yVC.type = 3;
        _yVC.fromUserCenter = YES;
    }
    return _yVC;
}


@end
