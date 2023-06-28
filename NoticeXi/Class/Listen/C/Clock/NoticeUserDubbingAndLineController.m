//
//  NoticeUserDubbingAndLineController.m
//  NoticeXi
//
//  Created by li lei on 2020/8/18.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserDubbingAndLineController.h"
#import "SPMultipleSwitch.h"
#import "NoticeCllockTagView.h"
#import "NoticeMyDownloadPyController.h"
#import "NoticeTcController.h"
#import "NoticeCollectionPyTcController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeCustumBackImageView.h"
#define globalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define mainQueue dispatch_get_main_queue()
@interface NoticeUserDubbingAndLineController ()

@property (nonatomic, strong) SPMultipleSwitch *switchButton;
@property (nonatomic, strong) NoticeMyDownloadPyController *pyVC;
@property (nonatomic, strong) NoticeTcController *lineVC;
@property (nonatomic, strong) NoticeCollectionPyTcController *collecVC;
@property (nonatomic, strong) UIView *mbsView;
@property (nonatomic, strong) NoticeCustumBackImageView *backGroundImageView;
@end

@implementation NoticeUserDubbingAndLineController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"main.py"],[NoticeTools getLocalStrWith:@"py.tc"],[NoticeTools getLocalStrWith:@"emtion.sc"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH([NoticeTools getLocalStrWith:@"py.tc"], 20, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 18;
        self.progressViewBottomSpace = 0;
        self.progressColor = [UIColor colorWithHexString:@"#05A8FA"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.7];
        self.titleColorSelected = [UIColor colorWithHexString:@"FFFFFF"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.isOther?[NoticeTools getLocalStrWith:@"py.hispy"]:[NoticeTools getLocalStrWith:@"py.mypy"];
    if (!self.needBackGround) {
        self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.navBarView.titleL.text = self.navigationItem.title;
    }else{
        if (!self.isOther) {
            self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
        }
    }
    
    [self reloadData];

    if (self.isFromLine) {
        self.selectIndex = 1;
    }
    
    if (self.needBackGround && self.isOther) {
        self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
        self.backGroundImageView = [[NoticeCustumBackImageView alloc] initWithFrame:CGRectMake(-20, -20, DR_SCREEN_WIDTH+40, DR_SCREEN_HEIGHT+40)];
        [self.view addSubview:self.backGroundImageView];
        [self.view sendSubviewToBack:self.backGroundImageView];
        
        
        // 图片视差效果：水平方向
        UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        effectX.maximumRelativeValue = @(-50);
        effectX.minimumRelativeValue = @(50);
        [self.backGroundImageView addMotionEffect:effectX];

        // 图片视差效果：垂直方向
        UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        effectY.maximumRelativeValue = @(-50);
        effectY.minimumRelativeValue = @(50);
        [self.backGroundImageView addMotionEffect:effectY];
        
        UIView *mbV = [[UIView alloc] initWithFrame:self.backGroundImageView.bounds];
        [self.backGroundImageView addSubview:mbV];
        self.mbsView = mbV;
        self.mbsView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"]colorWithAlphaComponent:0.3];
        [self requestUserInfo];
    }
}

- (void)requestUserInfo{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.isOther) {
        self.mbsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:appdel.alphaValue > 0.8? 0.3:appdel.alphaValue];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",self.userId] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
     
            if (self.isOther) {

                self.backGroundImageView.svagPlayer.hidden = YES;
                [self.backGroundImageView.svagPlayer pauseAnimation];
                
                if (userIn.spec_bg_type.intValue == 1) {//对方是默认背景
                    self.backGroundImageView.hidden = NO;
                    if (appdel.backDefaultImg) {
                        self.backGroundImageView.image = [UIImage boxblurImage:appdel.backDefaultImg withBlurNumber:appdel.effect];
                    }
                    
                    self.backGroundImageView.svagPlayer.hidden = YES;
                    [self.backGroundImageView.svagPlayer stopAnimation];
     
                }else if (userIn.spec_bg_type.intValue == 2 || userIn.spec_bg_type.intValue == 4){//自定义图片
               
                    self.backGroundImageView.hidden = NO;
                    self.backGroundImageView.svagPlayer.hidden = YES;
                    [self.backGroundImageView.svagPlayer pauseAnimation];
                    if (userIn.spec_bg_type.intValue == 4) {
                        [self.backGroundImageView.parser parseWithURL:[NSURL URLWithString: userIn.spec_bg_svg_url] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                            self.backGroundImageView.svagPlayer.videoItem = videoItem;
                            [self.backGroundImageView.svagPlayer startAnimation];
                        } failureBlock:nil];
                        self.backGroundImageView.svagPlayer.hidden = NO;
                    }
                    dispatch_async(globalQueue,^{
                        //子线程下载图片
                        NSURL *url=[NSURL URLWithString:userIn.spec_bg_type.intValue==2? userIn.spec_bg_photo_url:userIn.spec_bg_skin_url];
                        NSData *data=[NSData dataWithContentsOfURL:url];
                        //将网络数据初始化为UIImage对象
                        UIImage *image=[UIImage imageWithData:data];
                        dispatch_async(mainQueue,^{
                            if(image!=nil){
                                //回到主线程设置图片，更新UI界面
                                UIImage *gqImage = image;
                                self.backGroundImageView.hidden = NO;
                                self.backGroundImageView.image = [UIImage boxblurImage:gqImage withBlurNumber:appdel.effect];
                            }else{
                                self.backGroundImageView.hidden = NO;
                                [self.backGroundImageView sd_setImageWithURL:[NSURL URLWithString:userIn.spec_bg_skin_url]];
                            }
                        });
                        
                    });
                
                }
            }
        }
    } fail:^(NSError *error) {
    }];
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
        if (!self.needBackGround) {
            _navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
            [_navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        }
    }
    return _navBarView;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)userCenterClick{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.isOther = YES;
    ctl.userId = self.userId;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH([NoticeTools getLocalStrWith:@"py.tc"], 20, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    if (self.isOther) {
        return (DR_SCREEN_WIDTH- GET_STRWIDTH([NoticeTools getLocalStrWith:@"py.tc"], 20, 18)*2)/3;
    }
    return (DR_SCREEN_WIDTH- GET_STRWIDTH([NoticeTools getLocalStrWith:@"py.tc"], 20, 18)*3)/4;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:self.needBackGround? @"#FFFFFF" :@"#25262E"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:self.needBackGround? @"#FFFFFF" :@"#25262E"] colorWithAlphaComponent:0.7];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return (self.isOther || self.isFromUserCenter)?2: 3;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.pyVC;
    }else if(index == 1){
        return self.lineVC;
    }else{
        return self.collecVC;
    }
}

- (NoticeTcController *)lineVC{
    if (!_lineVC) {
        _lineVC = [[NoticeTcController alloc] init];
        _lineVC.userId = self.userId;
        _lineVC.isOther = self.isOther;
        _lineVC.isUserLine = YES;
        _lineVC.type = 1;
        _lineVC.needBackGround = self.needBackGround;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg && self.needBackGround) {
            _lineVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _lineVC.tableView.backgroundColor = _lineVC.view.backgroundColor;
        }
        
    }
    return _lineVC;
}

- (NoticeMyDownloadPyController *)pyVC{
    if (!_pyVC) {
        _pyVC = [[NoticeMyDownloadPyController alloc] init];
        _pyVC.isOther = self.isOther;
        _pyVC.isUserPy = YES;
        _pyVC.isFromUserCenter = self.isFromUserCenter;
        _pyVC.userId = self.userId;
        _pyVC.needBackGround = self.needBackGround;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg && self.needBackGround) {
            _pyVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _pyVC.tableView.backgroundColor = _pyVC.view.backgroundColor;
        }
    }
    return _pyVC;
}

- (NoticeCollectionPyTcController *)collecVC{
    if (!_collecVC) {
        _collecVC = [[NoticeCollectionPyTcController alloc] init];
        _collecVC.needBackGround = self.needBackGround;
    }
    return _collecVC;
}
@end
