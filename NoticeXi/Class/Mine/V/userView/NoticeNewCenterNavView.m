//
//  NoticeNewCenterNavView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewCenterNavView.h"
#import "NoticeSettingViewController.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"

#import "NoticeSCListViewController.h"
#import "NoticeStaySys.h"
@implementation NoticeNewCenterNavView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0];
          
        UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
        [setBtn setBackgroundImage:UIImageNamed(@"Imageset") forState:UIControlStateNormal];
        [self addSubview:setBtn];
        [setBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
                
        UIButton *lelveBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-15-24-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
        [lelveBtn setBackgroundImage:UIImageNamed(@"Image_levleimg") forState:UIControlStateNormal];
        [self addSubview:lelveBtn];
        [lelveBtn addTarget:self action:@selector(lelveClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *msgBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
        [msgBtn1 setBackgroundImage:UIImageNamed(@"msgClick_img") forState:UIControlStateNormal];
        [self addSubview:msgBtn1];
        [msgBtn1 addTarget:self action:@selector(msgClick1) forControlEvents:UIControlEventTouchUpInside];
        
        self.allNumL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24+17,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2-2, 14, 14)];
        self.allNumL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        self.allNumL.layer.cornerRadius = 7;
        self.allNumL.layer.masksToBounds = YES;
        self.allNumL.textColor = [UIColor whiteColor];
        self.allNumL.font = [UIFont systemFontOfSize:9];
        self.allNumL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.allNumL];
        self.allNumL.hidden = YES;
    }
    return self;
}

- (void)refreshData{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v5.4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            NoticeStaySys *stay = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];
            self.allNumL.hidden = stay.chatpriM.num.intValue?NO:YES;
            CGFloat strWidth = GET_STRWIDTH(stay.chatpriM.num, 9, 14);
            if (stay.chatpriM.num.intValue < 10) {
                strWidth = 14;
            }else{
                strWidth = strWidth+6;
            }
            self.allNumL.text = stay.chatpriM.num;
            self.allNumL.frame = CGRectMake(DR_SCREEN_WIDTH-20-24+17, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2-4, strWidth, 14);
        }
    } fail:^(NSError *error) {
    }];
}

- (void)msgClick1{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:[NoticeTools getTopViewController].navigationController.view];
    [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeSCListViewController *ctl = [[NoticeSCListViewController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
}

- (void)setClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeSettingViewController *ctl = [[NoticeSettingViewController alloc] init];
    [nav.topViewController.navigationController pushViewController:ctl animated:NO];
}

- (void)lelveClick{
    [NoticeComTools connectXiaoer];
}
@end
