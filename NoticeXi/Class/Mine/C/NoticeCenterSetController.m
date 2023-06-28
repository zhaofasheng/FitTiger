//
//  NoticeCenterSetController.m
//  NoticeXi
//
//  Created by li lei on 2019/12/18.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeCenterSetController.h"

@interface NoticeCenterSetController ()<NoticeUserSetDelegate>

@end

@implementation NoticeCenterSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.setView.backgroundColor = GetColorWithName(VBackColor);
    self.setView.delegate = self;
    [self.view addSubview:self.setView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIButton alloc] init] ];
    [self requestSet];
    [self requestFengmian];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(5, STATUS_BAR_HEIGHT, 42, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    if ([NoticeTools isWhiteTheme]) {
        [backButton setImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateNormal];
    }else{
        [backButton setImage:[UIImage imageNamed:@"btn_nav_white"] forState:UIControlStateNormal];
    }
    [self.view addSubview:backButton];
}

- (void)backToPageAction{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"reveal"
                                                                    withSubType:kCATransitionFromTop
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)requestFengmian{
    if (self.setView.dataArr.count) {
        return;
    }
    //获取封面
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/covers?coverName=moodbook_cover",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self.setView.dataArr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeCoverModel *model = [NoticeCoverModel mj_objectWithKeyValues:dic];
                [self.setView.dataArr addObject:model];
            }
            [self.setView.merchantCollectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)requestSet{
    if (self.setView.aobut) {
        return;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingTag=moodbook",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeAbout *aboutM = [NoticeAbout new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeAbout *setM = [NoticeAbout mj_objectWithKeyValues:dic];
                if ([setM.setting_name isEqualToString:@"cover_brightness"]) {//封面图亮度
                    aboutM.cover_brightness = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"cover_efficacy"]){//封面氛围
                    aboutM.cover_efficacy = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"minimachine_visibility"]){//迷你时光机
                    aboutM.minimachine_visibility = setM.setting_value;
                }
            }
            self.setView.aobut = aboutM;
            [NoticeSaveModel saveSetCenter:aboutM];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)backClick{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"reveal"
                                                                    withSubType:kCATransitionFromTop
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setNeedCoverView:(BOOL)Need{
    if (self.needMbBlock) {
        self.needMbBlock(Need);
    }
}

- (void)getAminationWithTag:(NSInteger)tag{
    if (self.fenwenBlock) {
        self.fenwenBlock(tag);
    }
}

- (NoticeUserCenterSet *)setView{
    if (!_setView) {
        _setView = [[NoticeUserCenterSet alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _setView.delegate = self;
    }
    return _setView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
