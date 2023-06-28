//
//  NoticeBoKeDocumController.m
//  NoticeXi
//
//  Created by li lei on 2022/9/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBoKeDocumController.h"
#import "NoticeBoKeDocumListController.h"
#import "NoticeCustumeNavView.h"
@interface NoticeBoKeDocumController ()
@property (nonatomic, strong) NoticeBoKeDocumListController *listVC1;
@property (nonatomic, strong) NoticeBoKeDocumListController *listVC2;
@property (nonatomic, strong) NoticeBoKeDocumListController *listVC3;
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@end

@implementation NoticeBoKeDocumController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools chinese:@"审核中" english:@"Reviewing" japan:@"レビュー中"],[NoticeTools chinese:@"异常稿件" english:@"Error" japan:@"エラー"],[NoticeTools chinese:@"投稿失败" english:@"Failed" japan:@"失敗した"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"Reviewing", 20, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 17;
        self.titleSizeSelected = 17;
        self.progressViewBottomSpace = 0;
        self.progressColor = [UIColor colorWithHexString:@"#05A8FA"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
        self.titleColorSelected = [UIColor colorWithHexString:@"#25262E"];
  
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.navigationItem.title = [NoticeTools chinese:@"稿件中心" english:@"List" japan:@"リスト"];
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
        _navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
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
    return  GET_STRWIDTH(@"Reviewing", 20, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{

    return (DR_SCREEN_WIDTH- GET_STRWIDTH(@"Reviewing", 20, 18)*3)/4;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#25262E"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 3;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.listVC1;
    }else if (index == 1) {
        return self.listVC2;
    }
    else{
        return self.listVC3;
    }
}

- (NoticeBoKeDocumListController *)listVC1{
    if (!_listVC1) {
        _listVC1 = [[NoticeBoKeDocumListController alloc] init];
        _listVC1.type=1;
    }
    return _listVC1;
}

- (NoticeBoKeDocumListController *)listVC2{
    if (!_listVC2) {
        _listVC2 = [[NoticeBoKeDocumListController alloc] init];
        _listVC2.type = 2;
    }
    return _listVC2;
}

- (NoticeBoKeDocumListController *)listVC3{
    if (!_listVC3) {
        _listVC3 = [[NoticeBoKeDocumListController alloc] init];
        _listVC3.type = 3;
    }
    return _listVC3;
}

@end
