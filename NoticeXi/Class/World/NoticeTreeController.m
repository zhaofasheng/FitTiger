//
//  NoticeTreeController.m
//  NoticeXi
//
//  Created by li lei on 2021/9/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
////
//  NoticeTreeController.m
//  NoticeXi
//
//  Created by li lei on 2021/9/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTreeController.h"
#import "NoticeCollectionVoiceController.h"
#import "NoticeTopicViewController.h"
#import "NoticeStaySys.h"
#import "NoticeSCListViewController.h"
#import "NoticeDesTroyView.h"
@interface NoticeTreeController ()

@property (nonatomic, strong) NoticeCollectionVoiceController *voiceVC;
@property (nonatomic, strong) NoticeCollectionVoiceController *sameVC;
@property (nonatomic, strong) NoticeDesTroyView *ruleView;
@property (nonatomic, strong) NSMutableArray *hotArr;

@property (nonatomic, strong) UILabel *topiceL;
@property (nonatomic, strong) NSString *topicName;


@end

@implementation NoticeTreeController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools chinese:@"大家的" english:@"All" japan:@"みんなの"],[NoticeTools chinese:@"欣赏" english:@"Follow" japan:@"フォロー"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH([NoticeTools chinese:@"大家" english:@"Sharing" japan:@"キョウユウ"], 20, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 16;
        self.progressViewBottomSpace = 10;
        self.progressColor = [UIColor colorWithHexString:@"#25262E"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        self.titleColorSelected = [UIColor colorWithHexString:@"#25262E"];
  
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
    
    UIButton *rulBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-35, 58+NAVIGATION_BAR_HEIGHT, 20, 20)];
    [rulBtn setBackgroundImage:UIImageNamed(@"rulImage_img") forState:UIControlStateNormal];
    [self.view addSubview:rulBtn];
    [rulBtn addTarget:self action:@selector(rulClick) forControlEvents:UIControlEventTouchUpInside];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshData) name:@"RECLICKREFRESHDATA" object:nil];//重复点击刷新数据

    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-20-20-15-24, 28)];
    searchBtn.layer.cornerRadius = 14;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    UIImageView *searImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 16, 16)];
    searImg.image = UIImageNamed(@"Image_newsearchss");
    [searchBtn addSubview:searImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, searchBtn.frame.size.width-40, 28)];
    label.text = [NoticeTools getLocalStrWith:@"hot.ssearch"];
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
    self.topiceL = label;
    [searchBtn addSubview:label];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchBtn];

    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
}

- (void)rulClick{
    [self.ruleView showDestroyView];
}

- (void)searchClick{
    
    NoticeTopicViewController *ctl = [[NoticeTopicViewController alloc] init];
    ctl.isSearch = YES;
    ctl.topicName = self.topicName;
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:ctl animated:NO];
}

- (void)requestHotTopic{
    self.hotArr = [[NSMutableArray alloc] init];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topics/hot/1" Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.hotArr removeAllObjects];
            NSMutableArray *arrary = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                if (!self.hotArr.count) {
                    NoticeTopicModel *topicM = [NoticeTopicModel mj_objectWithKeyValues:dic];
                    [arrary addObject:topicM.name];
                    [self.hotArr addObject:topicM];
                }else{
                    break;
                }
            }
            if (self.hotArr.count) {
                NoticeTopicModel *topicM = self.hotArr[0];
                self.topiceL.text = [NSString stringWithFormat:@"%@：%@",[NoticeTools chinese:@"大家在参与" english:@"Hot" japan:@"人気"],topicM.topic_name];
                self.topicName = topicM.topic_name;
            }
           
        }
    } fail:^(NSError *error) {
    }];
}


- (NoticeCollectionVoiceController *)sameVC{
    if (!_sameVC) {
        _sameVC = [[NoticeCollectionVoiceController alloc] init];
        _sameVC.isSame = YES;
    }
    return _sameVC;
}


- (NoticeCollectionVoiceController *)voiceVC{
    if (!_voiceVC) {
        _voiceVC = [[NoticeCollectionVoiceController alloc] init];
    }
    return _voiceVC;
}

//重复点击刷新数据
- (void)freshData{

    if (self.selectIndex == 0) {
        if (!_voiceVC.canAutoLoad) {
            return;
        }
        [_voiceVC.collectionView.mj_header beginRefreshing];
    }else if(self.selectIndex == 1){
        if (!_sameVC.canAutoLoad) {
            return;
        }
        [_sameVC.collectionView.mj_header beginRefreshing];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestHotTopic];

}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(10,15+28+NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH/2,50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,50+28+15+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-28-15);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH(self.titles[index], 18, 50);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    if(index == 0){
        return 0;
    }
    return 30;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#25262E"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 1) {
        return self.sameVC;
    }
    else{
        return self.voiceVC;
    }
}

- (NoticeDesTroyView *)ruleView{
    if(!_ruleView){
        _ruleView = [[NoticeDesTroyView alloc] initWithShowRule];
    }
    return _ruleView;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundEffect = nil;
        appperance.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];//设置导航条颜色
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = [[UIColor greenColor] colorWithAlphaComponent:0];
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"],NSFontAttributeName:XGTwentyBoldFontSize}];
        UINavigationBar *navgationBar = self.navigationController.navigationBar;
        navgationBar.standardAppearance = appperance;
        navgationBar.scrollEdgeAppearance = appperance;
        //透明
        self.navigationController.navigationBar.translucent = YES;
    }else{
    
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];//设置阴影图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //透明
        self.navigationController.navigationBar.translucent = YES;
    }

}

@end
  
