//
//  NoticeMineViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMineViewController.h"
#import "NoticeNewCenterNavView.h"
#import "NoticeUserNewHeaderView.h"
#import "UIView+Frame.h"

@interface NoticeMineViewController ()

@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, strong) NoticeUserNewHeaderView *headerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NoticeNewCenterNavView *navView;

@end

@implementation NoticeMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userM = [NoticeSaveModel getUserInfo];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.needBackGroundView = YES;

    NoticeNewCenterNavView *navView = [[NoticeNewCenterNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    self.navView = navView;
    [self.view addSubview:navView];
    
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.headerView = [[NoticeUserNewHeaderView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 512+129+80+40)];
    self.tableView.tableFooterView = self.headerView;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMusic) name:@"NOTICESTOPPLAYCENTERMUSIC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frefreshMusic) name:@"NOTICEREFRESHMUSIC" object:nil];
    [self.headerView requestMusicList];
    
    __weak typeof(self) weakSelf = self;
    self.headerView.hasRedViewBlock = ^(BOOL showRed) {
        if(weakSelf.hasRedViewBlock){
            weakSelf.hasRedViewBlock(showRed);
        }
    };
    //收到语音通话请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMusic) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
}

- (void)frefreshMusic{
    [self.headerView requestMusicList];
}

- (void)requestUserInfo{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
       
            self.userM = userIn;
            if (userIn.token) {
              [NoticeSaveModel saveToken:userIn.token];
            }
            [NoticeSaveModel saveUserInfo:userIn];
            self.headerView.userM = self.userM;
            
            NoticeSaveLoginStory *loginInfo = [NoticeSaveModel getLoginInfo];
            loginInfo.nick_name = userIn.nick_name;
            loginInfo.avatar_url = userIn.avatar_url;
            loginInfo.mobile = userIn.mobile;
            [NoticeSaveModel saveLogin:loginInfo];

            [self requestIfHasNew];
        }
    } fail:^(NSError *error) {
        if([NoticeComTools pareseError:error]){
            [self.noNetWorkView show];
        }
    }];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"users/getStatistics" Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *numModel = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            self.headerView.numberDataM = numModel;
        }
        
    } fail:^(NSError *error) {
        if([NoticeComTools pareseError:error]){
            [self.noNetWorkView show];
        }
    }];
}

- (void)requestIfHasNew{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"user/admireDynamic" Accept:@"application/vnd.shengxi.v5.2.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeAbout *aboutM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            if (aboutM.num.intValue) {
                self.headerView.redView.hidden = NO;
            }else{
                self.headerView.redView.hidden = YES;
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestUserInfo];
    [self.navView refreshData];
    [self redCirRequest];
}


- (void)stopMusic{
    self.headerView.isRefresh = YES;
    [self.headerView.musicPlayer stopPlaying];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)redCirRequest{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeStaySys *stay = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];
            self.headerView.messageModel = stay;
            if(stay.likeModel.num.intValue || stay.other_commentModel.num.intValue || stay.comModel.num.intValue || stay.voice_whisperModel.num.intValue || stay.sysM.num.intValue){
                if(self.hasRedViewBlock){
                    self.hasRedViewBlock(YES);
                }
            }else{
                if(self.hasRedViewBlock){
                    self.hasRedViewBlock(NO);
                }
            }
        }
    } fail:^(NSError *error) {
    }];
}

@end
