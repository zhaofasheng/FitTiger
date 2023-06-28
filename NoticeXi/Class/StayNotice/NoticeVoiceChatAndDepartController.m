//
//  NoticeVoiceChatAndDepartController.m
//  NoticeXi
//
//  Created by li lei on 2023/3/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceChatAndDepartController.h"
#import "NoticeVoiceDepartController.h"
#import "NoticeQiaoqiaoController.h"
@interface NoticeVoiceChatAndDepartController ()<WMMenuViewDataSource>
@property (nonatomic, strong) NoticeQiaoqiaoController *qiaovc;
@property (nonatomic, strong) NoticeVoiceDepartController *departVC;
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@property (nonatomic, strong) UILabel *redL1;
@property (nonatomic, strong) UILabel *redL2;
@end

@implementation NoticeVoiceChatAndDepartController


- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"em.hs"],[NoticeTools getLocalStrWith:@"cao.liiuyan"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH([NoticeTools chinese:@"收到的" english:@"Received" japan:@"受け取った"], 20, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 18;
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
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];

    self.menuView.backgroundColor = [UIColor whiteColor];
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarView.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.menuView.dataSource = self;
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
        _navBarView.titleL.text = [NoticeTools chinese:@"心情回应" english:@"Replies" japan:@"返信"];
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}



- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT+48, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    if (index == 0) {
        return GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.hs"], 20, 18);
    }else{
        return  GET_STRWIDTH(@"cao.liiuyan", 20, 18);
    }
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return (DR_SCREEN_WIDTH- GET_STRWIDTH(@"GroundBack", 20, 18)*2)/3;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#25262E"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
    }
}

- (UIView *)menuView:(WMMenuView *)menu badgeViewAtIndex:(NSInteger)index{
    if (index == 0) {

        if (self.messageModel.voice_whisperModel.num.intValue) {
            if (GET_STRWIDTH(self.messageModel.voice_whisperModel.num, 9, 14) > 14) {
                self.redL1.frame = CGRectMake(GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.hs"], 20, 18)-2, 3, GET_STRWIDTH(self.messageModel.voice_whisperModel.num, 9, 14)+6, 14);
            }else{
                self.redL1.frame = CGRectMake(GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.hs"], 20, 18)-2, 3, 14, 14);
            }
            self.redL1.text = self.messageModel.voice_whisperModel.num;
            return self.redL1;
        }
        return nil;
    }else{
        if (self.messageModel.comModel.num.intValue) {
            if (GET_STRWIDTH(self.messageModel.comModel.num, 9, 14) > 14) {
                self.redL2.frame = CGRectMake(GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.hs"], 20, 18)-2, 3, GET_STRWIDTH(self.messageModel.comModel.num, 9, 14)+6, 14);
            }else{
                self.redL2.frame = CGRectMake(GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.hs"], 20, 18)-2, 3, 14, 14);
            }
            self.redL2.text = self.messageModel.comModel.num;
            return self.redL2;
        }
        return nil;
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (UILabel *)redL1{
    if (!_redL1) {
        _redL1 = [[UILabel alloc] initWithFrame:CGRectMake(GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.hs"], 20, 18)-2, 3, GET_STRWIDTH(@"99", 9, 14)+6, 14)];
        _redL1.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        _redL1.layer.cornerRadius = 7;
        _redL1.layer.masksToBounds = YES;
        _redL1.textAlignment = NSTextAlignmentCenter;
        _redL1.textColor = [UIColor whiteColor];
        _redL1.font = [UIFont systemFontOfSize:9];
       
    }
    return _redL1;
}

- (UILabel *)redL2{
    if (!_redL2) {
        _redL2 = [[UILabel alloc] initWithFrame:CGRectMake(GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.hs"], 20, 18), 3, GET_STRWIDTH(@"99", 9, 14)+6, 14)];
        _redL2.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        _redL2.layer.cornerRadius = 7;
        _redL2.layer.masksToBounds = YES;
        _redL2.textAlignment = NSTextAlignmentCenter;
        _redL2.textColor = [UIColor whiteColor];
        _redL2.font = [UIFont systemFontOfSize:9];
    
    }
    return _redL2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 1) {
        return self.departVC;
    }else{
        return self.qiaovc;
    }
}

- (NoticeVoiceDepartController *)departVC{
    if (!_departVC) {
        _departVC = [[NoticeVoiceDepartController alloc] init];
        __weak typeof(self) weakSelf = self;
        _departVC.clearUnreadBlock = ^(BOOL clear) {
            weakSelf.messageModel.comModel.num = @"0";
            weakSelf.redL2.hidden = YES;
        };
    }
    return _departVC;
}

- (NoticeQiaoqiaoController *)qiaovc{
    if (!_qiaovc) {
        _qiaovc = [[NoticeQiaoqiaoController alloc] init];
        __weak typeof(self) weakSelf = self;
        _qiaovc.clearUnreadBlock = ^(BOOL clear) {
            if (weakSelf.messageModel.voice_whisperModel.num.intValue) {
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                    if (success) {
                        if ([dict[@"data"] isEqual:[NSNull null]]) {
                            return ;
                        }
                        NoticeStaySys *stay = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];
                        weakSelf.messageModel = stay;
                        if (weakSelf.messageModel.voice_whisperModel.num.intValue) {
                            weakSelf.redL1.hidden = NO;
                            weakSelf.redL1.text = weakSelf.messageModel.voice_whisperModel.num;
                        }else{
                            weakSelf.redL1.hidden = YES;
                        }
                    }
                } fail:^(NSError *error) {
                }];
            }
        };
    }
    return _qiaovc;
}

@end
