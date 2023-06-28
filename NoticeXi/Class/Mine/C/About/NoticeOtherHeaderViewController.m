//
//  NoticeOtherHeaderViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeOtherHeaderViewController.h"
#import "NoticeVoiceViewController.h"
#import "NoticeSeasonViewController.h"
#import "NoticeUserCenter.h"
#import "UIView+Frame.h"
#import "NoticeSendViewController.h"
#import "NoticeAboutView.h"
#import "NoticeTopicModel.h"
#import "NoticeMyMovieController.h"
#import "NoticeMySongController.h"
#import "NoticeMyBookController.h"
#import "NoticeNearPerson.h"
#import "NoticeNoticenterModel.h"
#import "NoticeMyMovieController.h"
#import "NoticeMySongController.h"
#import "NoticeMyBookController.h"
#import "NoticeVoiceListCell.h"
#import "NoticeMyDownloadPyController.h"
#import "NoticeDrawShowListController.h"
#import "NoticeUserDubbingAndLineController.h"
#import "NoticeStatus.h"
@interface NoticeOtherHeaderViewController ()<NoticeUserCenterManagerDelegate,NoticeVoiceListClickDelegate>
@property (nonatomic, strong) UIButton *lenBtn;
@property (nonatomic, strong) NoticeAbout *about;
@property (nonatomic, strong) NoticeAbout *realisAbout;
@property (nonatomic, strong) NoticeAboutView *aboutView;
@property (nonatomic, strong) NoticeUserCenter *centerView;
@property (nonatomic, strong) NSMutableArray *topicArr;
@property (nonatomic, assign) BOOL isShowAbout;
@property (nonatomic, assign) BOOL isShowShare;
@property (nonatomic, assign) BOOL noTimeLen;
@property (nonatomic, strong) NSString *WhiteList;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) BOOL canTapCenterButton;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UILabel *footLabel;
@property (nonatomic, strong) NoticeNoticenterModel *noticeM;
@property (nonatomic, strong) NoticeHasCenterData *hasDataModel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) NoticeStatus *statusM;
@end

@implementation NoticeOtherHeaderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;//开启右滑返回
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self requestAbout];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestTopicSet];
    [NoticeComTools saveNoTost:@"1"];
    
    UILabel *itemlabeL = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    itemlabeL.textAlignment = NSTextAlignmentCenter;
    itemlabeL.font = EIGHTEENTEXTFONTSIZE;
    itemlabeL.textColor = GetColorWithName(VMainTextColor);
    itemlabeL.text = @"Ta的心情簿";
    [self.view addSubview:itemlabeL];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:[UIImage imageNamed:[NoticeTools isWhiteTheme]?@"btn_nav_back":@"btn_nav_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.view.backgroundColor = GetColorWithName(VBigLineColor);
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-21, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-21)/2, 21, 21)];
    iconImageView.layer.cornerRadius = 21/2;
    iconImageView.layer.masksToBounds = YES;
    [iconImageView setImageWithURL:[NSURL URLWithString:self.userInfo.avatar_url] placeholder:UIImageNamed(@"Image_jynohe")];
    iconImageView.userInteractionEnabled = YES;
    if (![NoticeTools isWhiteTheme]) {
        UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
        mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [iconImageView addSubview:mbView];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAbout)];
    [iconImageView addGestureRecognizer:tap];
    [self.view addSubview:iconImageView];
    
    self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-21-15-60, iconImageView.frame.origin.y, 60, 21)];
    self.likeButton.layer.cornerRadius = 21/2;
    self.likeButton.layer.masksToBounds = YES;
    [self.view addSubview:self.likeButton];
    self.likeButton.hidden = YES;
    self.likeButton.titleLabel.font = TWOTEXTFONTSIZE;
    [self.likeButton addTarget:self action:@selector(likeOrNoLikeClcik) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.dataArr = [NSMutableArray new];
    [self.tableView registerClass:[NoticeVoiceListCell class] forCellReuseIdentifier:@"voiceCell"];
    
    NoticeUserCenter *centerHeader = [[NoticeUserCenter alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 205+(49+32+(DR_SCREEN_WIDTH-60-16)/3)+20+ (49+32+(DR_SCREEN_WIDTH-60-16)/3+15)) isOther:YES];
    centerHeader.delegate = self;
    centerHeader.userId = self.userId;
    centerHeader.isFriend = self.isFriend;
    self.centerView = centerHeader;
    self.tableView.tableHeaderView = centerHeader;
    
    [self requestIfLike];
    [self requestSet];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriend) name:@"addFriendNotice" object:nil];
    
    self.isShowShare = YES;
 
    self.canShowAssest = YES;
    [self requestMBSSet];
    self.aboutView.isOther = YES;
    [self.aboutView requestAch];
}

- (void)requestSet{
    if (self.isFriend) {
        [self requesifHasData];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingTag=moodbook",self.userId] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
       
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self.noticeM = [[NoticeNoticenterModel alloc] init];
            //设置默认值，防止服务器未有返回
            self.noticeM.minimachine_visibility = @"1";
            self.noticeM.strange_view = @"7";
            self.noticeM.movie_voice_visibility = @"1";
            self.noticeM.book_voice_visibility = @"1";
            self.noticeM.song_voice_visibility = @"1";
            self.noticeM.share_voice_visibility = @"2";
            self.noticeM.dubbing_visibility = @"1";
            self.noticeM.artwork_visibility = @"1";
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeAbout *setM = [NoticeAbout mj_objectWithKeyValues:dic];
                if ([setM.setting_name isEqualToString:@"minimachine_visibility"]) {//封面迷你时光机
                    self.noticeM.minimachine_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"voice_visible_days"]){//谁可见好友
                    self.noticeM.strange_view = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"movie_voice_visibility"]){//电影可见性
                    self.noticeM.movie_voice_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"book_voice_visibility"]){//书籍可见性
                    self.noticeM.book_voice_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"song_voice_visibility"]){//歌曲可见性
                    self.noticeM.song_voice_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"share_voice_visibility"]){//共享心情可见性
                    self.noticeM.share_voice_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"dubbing_visibility"]){//配音可见性
                    self.noticeM.dubbing_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"artwork_visibility"]){//画可见性
                    self.noticeM.artwork_visibility = setM.setting_value;
                }
            }
            
            self.centerView.noticeM = self.noticeM;
            if (!self.isFriend) {
                [self requesifHasData];
            }
            
        }else{
            self.canTapCenterButton = YES;
        }
    } fail:^(NSError * _Nullable error) {
        self.canTapCenterButton = YES;
    }];
}

- (void)requesifHasData{
    self.centerView.noticeM = self.noticeM;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/modules/statistics",self.userId] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            BOOL hasPy = NO;
            BOOL hasTc = NO;
            self.hasDataModel = [NoticeHasCenterData new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeHasCenterData *model = [NoticeHasCenterData mj_objectWithKeyValues:dic];
                if (model.typeId.intValue == 1) {
                    self.hasDataModel.hasVoice = model.total.intValue?YES:NO;
                }else if (model.typeId.intValue == 2){
                    self.hasDataModel.hasPhoto = model.total.intValue?YES:NO;
                }else if (model.typeId.intValue == 3){
                    self.hasDataModel.hasTime = model.total.intValue?YES:NO;
                }else if (model.typeId.intValue == 4){
                    self.hasDataModel.hasMovie = model.total.intValue?YES:NO;
                }else if (model.typeId.intValue == 5){
                    self.hasDataModel.hasBook = model.total.intValue?YES:NO;
                }else if (model.typeId.intValue == 6){
                    self.hasDataModel.hasSong = model.total.intValue?YES:NO;
                }else if (model.typeId.intValue == 7){
                    self.hasDataModel.hasDraw = model.total.intValue?YES:NO;
                }
                else if (model.typeId.intValue == 8){
                    
                    hasPy = model.total.intValue?YES:NO;
                    
                }else if ( model.typeId.intValue == 9){
                    hasTc = model.total.intValue?YES:NO;
                }
            }
            if (hasTc || hasPy) {
                self.hasDataModel.hasPy = YES;
            }else{
                self.hasDataModel.hasPy = NO;
            }
            self.centerView.hasDataModel = self.hasDataModel;
        }else{
            self.noticeM = [NoticeNoticenterModel new];
        }
    } fail:^(NSError * _Nullable error) {
        self.noticeM = [NoticeNoticenterModel new];
    }];
}

#pragma 信息流助手方法

- (void)stopOrPlayerForAssest{
    if (!self.dataArr.count) {
        return;
    }
    if (self.oldSelectIndex > 200 || self.lastPlayerTag == 0) {
        self.oldSelectIndex = 0;
    }
    if (self.oldSelectIndex > self.dataArr.count-1) {
        return;
    }
    [self startPlayAndStop:self.oldSelectIndex];
}
- (void)clickChangeVoiceType:(NSInteger)type{
    [self.tableView.mj_header beginRefreshing];
}
- (void)nextForAssest{
    if (self.isPlayFromFirst) {
        self.isPlayFromFirst = NO;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self startRePlayer:0];
        return;
    }
    if (self.stopAutoPlayerForDissapear) {
        return;
    }
    if (!self.dataArr.count ||[NoticeTools voiceType] == 2) {
         return;
     }
    if (self.dataArr.count-1 <= self.lastPlayerTag+1) {//不能越界
        self.isPushMoreToPlayer = YES;
        [self.tableView.mj_footer beginRefreshing];
        return;
    }
    NoticeVoiceListModel *model = self.dataArr[self.lastPlayerTag+1];
    if (model.content_type.intValue == 2) {
        self.lastPlayerTag++;
        [self nextForAssest];
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPlayerTag+1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self startRePlayer:self.lastPlayerTag+1];
}

- (void)proForAssest{
    if (self.lastPlayerTag == 0) {
        return;
    }
    if (!self.dataArr.count ||[NoticeTools voiceType] == 2) {
         return;
     }
    if (!self.lastPlayerTag) {
        self.lastPlayerTag = 1 ;
    }
    NoticeVoiceListModel *model = self.dataArr[self.lastPlayerTag-1];
    if (model.content_type.intValue == 2) {
        self.lastPlayerTag--;
        [self proForAssest];
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPlayerTag-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self startRePlayer:self.lastPlayerTag-1];
}

- (void)autoOrNoAutoForAssest{
    self.isAutoPlayer = [NoticeTools isAutoPlayer];
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickAbout{
    self.aboutView.userInfo = self.userInfo;
    self.aboutView.isOther = YES;
    self.aboutView.aboutM = self.about;
    [self.aboutView showTostView];
}

- (void)likeOrNoLikeClcik{
    if (self.statusM.friendStatus.status.intValue == 2) {//已是好友，不存在欣赏与否
        return;
    }
    if (!self.statusM.admired_id.intValue) {//已欣赏就取消欣赏
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"加欣赏，彼将知\n互欣赏，成学友" message:nil sureBtn:@"欣赏ta" cancleBtn:[NoticeTools getLocalStrWith:@"bz.dcl"]];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:self.userId forKey:@"toUserId"];
                [weakSelf showHUD];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admires" Accept:@"application/vnd.shengxi.v4.6.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [weakSelf hideHUD];
                    if (success) {
                        NoticeStatus *status = [NoticeStatus mj_objectWithKeyValues:dict[@"data"]];
                        weakSelf.statusM.admired_id = status.AdmiredId;
                        weakSelf.likeButton.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#212137"];
                        [weakSelf.likeButton setTitleColor:[NoticeTools getWhiteColor:@"#999999" NightColor:@"#3D3D49"] forState:UIControlStateNormal];
                        [weakSelf.likeButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
                        if (weakSelf.refreshBlock) {
                            weakSelf.refreshBlock(YES);
                        }
                    }
                } fail:^(NSError * _Nullable error) {
                    [weakSelf hideHUD];
                }];
            }
        };
        [alerView showXLAlertView];
    }else{
        [self showHUD];
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admires/%@",self.statusM.admired_id] Accept:@"application/vnd.shengxi.v4.6.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                self.statusM.admired_id = @"0";
                self.likeButton.backgroundColor = GetColorWithName(VMainThumeColor);
                [self.likeButton setTitle:@"+欣赏" forState:UIControlStateNormal];
                [self.likeButton setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
                if (self.refreshBlock) {
                    self.refreshBlock(YES);
                }
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }
}

//判断是否已经欣赏
- (void)requestIfLike{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/bottom",self.userId] Accept:@"application/vnd.shengxi.v4.6.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self.likeButton.hidden = NO;
            NoticeStatus *statusM = [NoticeStatus mj_objectWithKeyValues:dict[@"data"]];
            self.statusM = statusM;
            if (self.statusM.admired_id.intValue || self.statusM.friendStatus.status.intValue == 2) {
                self.likeButton.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#212137"];
                [self.likeButton setTitleColor:[NoticeTools getWhiteColor:@"#999999" NightColor:@"#3D3D49"] forState:UIControlStateNormal];
                [self.likeButton setTitle:self.statusM.friendStatus.status.intValue == 2?@"学友":[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
            }else{
                self.likeButton.backgroundColor = GetColorWithName(VMainThumeColor);
                [self.likeButton setTitle:@"+欣赏" forState:UIControlStateNormal];
                [self.likeButton setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
            }
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
    
}

- (void)pushControllerWithType:(NSInteger)type{
    if (type == 6 && !self.noticeM) {//配音的时候必须获取到设置才可以点击
        return;
    }
    
    if (!self.isFriend && !self.noticeM) {//如果不是好友关系的时候，必须获取到设置才可以点击
        return;
    }
    
    if (!self.canTapCenterButton && !self.noticeM) {//在获取到设置以及是否存在内容之前，不允许点击
        return;
    }
    
    if (type == 0) {
        if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
            NoticeVoiceViewController *ctl = [[NoticeVoiceViewController alloc] init];
            ctl.isOther = YES;
            ctl.userId = self.userId;
            ctl.realisAbout = self.realisAbout;
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
        if (!self.isFriend) {
            if (self.noticeM.strange_view.intValue == 0) {
                [self showToastWithText:[NoticeTools getLocalStrWith:@"zj.justxueyou"]];
                return;
            }
        }
        if (!self.hasDataModel.hasVoice) {
            [self showToastWithText:@"还没有心情"];
            return;
        }
        NoticeVoiceViewController *ctl = [[NoticeVoiceViewController alloc] init];
        ctl.isOther = YES;
        ctl.userId = self.userId;
        ctl.realisAbout = self.realisAbout;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (type == 1){

    }else if (type == 2){

    }else if (type == 3){
        if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
            NoticeMyMovieController *ctl = [[NoticeMyMovieController alloc] init];
            ctl.userId = self.userId;
            ctl.isOther = YES;
            ctl.realisAbout = self.realisAbout;
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
        if (!self.isFriend) {
            if (self.noticeM.movie_voice_visibility.intValue == 2) {
                [self showToastWithText:[NoticeTools getLocalStrWith:@"zj.justxueyou"]];
                return;
            }
        }
        if (!self.hasDataModel.hasMovie) {
             [self showToastWithText:@"还没有电影心情"];
             return;
         }
        NoticeMyMovieController *ctl = [[NoticeMyMovieController alloc] init];
        ctl.userId = self.userId;
        ctl.isOther = YES;
        ctl.realisAbout = self.realisAbout;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (type == 4){
        if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
            NoticeMyBookController *ctl = [[NoticeMyBookController alloc] init];
            ctl.userId = self.userId;
            ctl.isOther = YES;
            ctl.realisAbout = self.realisAbout;
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
        if (!self.isFriend) {
            if (self.noticeM.book_voice_visibility.intValue == 2) {
                [self showToastWithText:[NoticeTools getLocalStrWith:@"zj.justxueyou"]];
                return;
            }
        }
        if (!self.hasDataModel.hasBook) {
             [self showToastWithText:@"还没有书籍心情"];
             return;
         }
        NoticeMyBookController *ctl = [[NoticeMyBookController alloc] init];
        ctl.userId = self.userId;
        ctl.isOther = YES;
        ctl.realisAbout = self.realisAbout;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (type == 5){
        if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
            NoticeMySongController *ctl = [[NoticeMySongController alloc] init];
            ctl.userId = self.userId;
            ctl.isOther = YES;
            ctl.realisAbout = self.realisAbout;
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
        if (!self.isFriend) {
            if (self.noticeM.song_voice_visibility.intValue == 2) {
                [self showToastWithText:[NoticeTools getLocalStrWith:@"zj.justxueyou"]];
                return;
            }
        }
        if (!self.hasDataModel.hasSong) {
             [self showToastWithText:@"还没有唱歌心情"];
             return;
         }
        NoticeMySongController *ctl = [[NoticeMySongController alloc] init];
        ctl.userId = self.userId;
        ctl.isOther = YES;
        ctl.realisAbout = self.realisAbout;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (type == 6){
        if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
            NoticeUserDubbingAndLineController *ctl = [[NoticeUserDubbingAndLineController alloc] init];
            ctl.isUserPy = YES;
            ctl.userId = self.userId;
            ctl.isOther = YES;
            ctl.needBackGround = YES;
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
        if (!self.isFriend) {
            if (self.noticeM.dubbing_visibility.intValue == 2 || self.noticeM.dubbing_visibility.intValue == 3) {
                [self showToastWithText:self.noticeM.dubbing_visibility.intValue == 2? [NoticeTools getLocalStrWith:@"zj.justxueyou"]:[NoticeTools getLocalStrWith:@"n.onlyself"]];
                return;
            }
        }else{
            if (self.noticeM.dubbing_visibility.intValue == 3) {
                [self showToastWithText:[NoticeTools getLocalStrWith:@"n.onlyself"]];
                return;
            }
        }
        if (!self.hasDataModel.hasPy) {
             [self showToastWithText:[NoticeTools getLocalStrWith:@"hh.nozupp"]];
             return;
         }
        NoticeUserDubbingAndLineController *ctl = [[NoticeUserDubbingAndLineController alloc] init];
        ctl.isUserPy = YES;
        ctl.userId = self.userId;
        ctl.isOther = YES;
        ctl.needBackGround = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (type == 7){

        if (!self.isFriend) {
            if (self.noticeM.artwork_visibility.intValue == 2 || self.noticeM.artwork_visibility.intValue == 3) {
                [self showToastWithText:self.noticeM.artwork_visibility.intValue == 2? [NoticeTools getLocalStrWith:@"zj.justxueyou"]:[NoticeTools getLocalStrWith:@"n.onlyself"]];
                return;
            }
        }else{
            if (self.noticeM.artwork_visibility.intValue == 3) {
                [self showToastWithText:[NoticeTools getLocalStrWith:@"n.onlyself"]];
                return;
            }
        }
        if (!self.hasDataModel.hasDraw) {
             [self showToastWithText:[NoticeTools getLocalStrWith:@"hh.nozupp"]];
             return;
         }
        NoticeDrawShowListController *ctl = [[NoticeDrawShowListController alloc] init];
        ctl.userId = self.userId;
        ctl.listType = 5;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)createRefesh{

    __weak NoticeOtherHeaderViewController *ctl = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestVoice];
    }];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestVoice];
    }];
}

- (void)requestVoice{
    NSString *url = nil;
    NSString *userId = self.userId;
    if (self.isDown) {
        [self reSetPlayerData];
        if ([NoticeTools voiceType]) {
               url = [NSString stringWithFormat:@"users/%@/voices?moduleId=4&contentType=%ld",userId,[NoticeTools voiceType]];
        }else{
          url = [NSString stringWithFormat:@"users/%@/voices?moduleId=4",userId];
        }
        
    }else{
        if ([NoticeTools voiceType]) {
            url = [NSString stringWithFormat:@"users/%@/voices?lastId=%@&moduleId=4&contentType=%ld",userId,self.lastId,[NoticeTools voiceType]];
        }else{
            url = [NSString stringWithFormat:@"users/%@/voices?lastId=%@&moduleId=4",userId,self.lastId];
        }
        
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.isrefreshNewToPlayer = NO;
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown == YES) {
                self.isReplay = YES;
                [self.audioPlayer pause:YES];
                self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                [self.dataArr removeAllObjects];
                self.isPushMoreToPlayer = NO;
                self.isDown = NO;
            }
            BOOL hasNewData = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                hasNewData = YES;
            }
            
            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.share_id;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.footLabel;
            }
            if (hasNewData && self.isPushMoreToPlayer) {
                self.isPushMoreToPlayer = NO;
                [self nextForAssest];
            }else if (!hasNewData && self.isPushMoreToPlayer){
                if (self.dataArr.count) {
                    self.isPlayFromFirst = YES;
                    [self nextForAssest];
                }
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)refreshFriend{
    self.about.friend_status = @"1";
    [self requestsub];
}

- (void)requestTopicSet{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting/favoriteTopic",self.userId] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            NoticeNoticenterModel *noticeOtherM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            if (noticeOtherM.favorite_topic.integerValue && !noticeOtherM.is_friend.integerValue) {//喜欢话题仅限好友可看
                self.aboutView.isJustFriend = YES;
            }else{
                [self requestTopic];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

//获取用户可见性设置
- (void)requestMBSSet{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"relations/%@",self.userId] Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self.realisAbout = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            if ([self.realisAbout.friend_status isEqualToString:@"2"]) {
                self.centerView.zjAll.isFriend = YES;
            }
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingTag=moodbook",self.userId] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    if ([dict[@"data"] isEqual:[NSNull null]]) {
                        return ;
                    }
                    BOOL hasValue = NO;
                    for (NSDictionary *dic in dict[@"data"]) {
                        NoticeAbout *setM = [NoticeAbout mj_objectWithKeyValues:dic];
                        if ([setM.setting_name isEqualToString:@"movie_voice_visibility"]){//电影可见性
                            if ([setM.setting_value isEqualToString:@"2"]) {
                                self.realisAbout.mLimit = YES;
                            }else{
                                self.realisAbout.mLimit = NO;
                            }
                        }else if ([setM.setting_name isEqualToString:@"book_voice_visibility"]){//书籍可见性
                            if ([setM.setting_value isEqualToString:@"2"]) {
                                self.realisAbout.bLimit = YES;
                            }else{
                                self.realisAbout.bLimit = NO;
                            }
                        }else if ([setM.setting_name isEqualToString:@"song_voice_visibility"]){//歌曲可见性
                            if ([setM.setting_value isEqualToString:@"2"]) {
                                self.realisAbout.sLimit = YES;
                            }else{
                                self.realisAbout.sLimit = NO;
                            }
                        }else if ([setM.setting_name isEqualToString:@"voice_visible_days"]){//好友可见心情和相册
                            hasValue = YES;
                            self.realisAbout.strange_view = setM.setting_value;
                        }
                        else if ([setM.setting_name isEqualToString:@"share_voice_visibility"]){//共享心情可见性
                            if ([setM.setting_value isEqualToString:@"1"]) {
                                self.isShowShare = NO;
                            }else{
                                self.isShowShare = YES;
                            }
                        }
                    }
                    
                    if (!hasValue) {//如果接口没返回，则默认7天
                        self.realisAbout.strange_view = @"7";
                    }
                    
                    if (self.isShowShare) {
                        self.footLabel.text = @"ta还没有共享内容";
                        [self createRefesh];
                        [self.tableView.mj_header beginRefreshing];
                    }else{
                        self.footLabel.text = [NoticeTools getTextWithSim:@"ta设置了共享心情不显示" fantText:@"ta設置了共享心情不顯示"];
                        self.tableView.tableFooterView = self.footLabel;
                    }
                }
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];

}

//获取用户可见性话题
- (void)requestTopic{
    self.topicArr = [NSMutableArray new];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/favorite/topic",self.isOther ? self.userId : [[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
    
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeTopicModel *model = [NoticeTopicModel mj_objectWithKeyValues:dic];
                [self.topicArr addObject:model];
            }
            if (!self.topicArr.count) {//没有设置喜欢话题
                self.aboutView.isOtherNodata = YES;
                return;
            }
            self.aboutView.topicArr = self.topicArr;
        }
    } fail:^(NSError *error) {
    }];
}

//获取用户关系
- (void)requestsub{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"relations/%@",self.userId] Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeAbout *about = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            self.realisAbout.friend_status = about.friend_status;
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

//获取用心情数据
- (void)requestAbout{
    [[DRNetWorking shareInstance] requestNoTosat:[NSString stringWithFormat:@"users/%@/about",self.userId] Accept:@"application/vnd.shengxi.v2.2+json" parmaer:nil success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeAbout *aboutM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            self.about = aboutM;
            self.aboutView.aboutM = self.about;
            [self.lenBtn setTitle:[NSString stringWithFormat:@"共%@",aboutM.voice_total_len] forState:UIControlStateNormal];
            NSString *str = [NSString stringWithFormat:@"共%@",aboutM.voice_total_len];
            self.lenBtn.frame = CGRectMake(DR_SCREEN_WIDTH-GET_STRWIDTH(str, 13, 40)-15,STATUS_BAR_HEIGHT,GET_STRWIDTH(str, 13, 40),NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        }
    }];
}

- (NoticeAboutView *)aboutView{
    if (!_aboutView) {
        _aboutView = [[NoticeAboutView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _aboutView.userId = self.userId;
    }
    return _aboutView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voiceCell"];
    cell.isOtherShare = YES;
    cell.isShowShareTime = YES;
    if ((indexPath.row <= self.dataArr.count-1) && self.dataArr.count) {
        cell.worldM= self.dataArr[indexPath.row];
        cell.playerView.timeLen = [self.dataArr[indexPath.row] voice_len];
        cell.index = indexPath.row;
        cell.playerView.tag = indexPath.row;
        cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
        cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
        [cell.playerView.playButton setImage:GETUIImageNamed([self.dataArr[indexPath.row] isPlaying] ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
    }

    cell.delegate = self;
    if (indexPath.row == self.dataArr.count-1) {
        cell.buttonView.line.hidden = YES;
    }else{
        cell.buttonView.line.hidden = NO;
    }
    
    cell.movieView.backgroundColor = [NoticeTools getWhiteColor:@"#ffffff" NightColor:@"#181828"];
    cell.contentView.backgroundColor = self.view.backgroundColor;
    cell.buttonView.line.backgroundColor =[NoticeTools isWhiteTheme]? GetColorWithName(VlineColor):[UIColor colorWithHexString:@"#181828"];
    cell.buttonView.line.frame = CGRectMake(15, cell.buttonView.line.frame.origin.y, DR_SCREEN_WIDTH-30, 1);
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    return [NoticeComTools voiceCellHeight:model needFavie:NO]-7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 45)];
    view.backgroundColor = self.view.backgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-15, 45)];
    label.font = FIFTHTEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VMainTextColor);
    label.text = @"共享的心情";
    [view addSubview:label];
    return view;
}
#pragma 共享和取消共享
- (void)hasClickShareWith:(NSInteger)tag{

    [self.tableView reloadData];
}

//屏蔽成功回调
- (void)otherPinbSuccess{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self.audioPlayer stopPlaying];
    [self.dataArr removeObjectAtIndex:self.choicemoreTag];
    [self.tableView reloadData];
}
//点击更多删除成功回调
- (void)moreClickDeleteSucess{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self.audioPlayer stopPlaying];
    [self.dataArr removeObjectAtIndex:self.choicemoreTag];
    [self.tableView reloadData];
}
//点击更多设置私密回调
- (void)moreClickSetPriSucess{
    [self.tableView reloadData];
}

//点击更多
- (void)hasClickMoreWith:(NSInteger)tag{
    if (tag > self.dataArr.count-1) {
        return;
    }
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.choicemoreTag = tag;
    if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是别人
        return;
    }
    
    [self.clickMore voiceClickMoreWith:model];
    
}

- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro{
    self.progross = pro;
    self.tableView.scrollEnabled = YES;
    __weak typeof(self) weakSelf = self;
    [self.audioPlayer pause:NO];
    [self.audioPlayer.player seekToTime:CMTimeMake(self.draFlot, 1) completionHandler:^(BOOL finished) {
        if (finished) {
            weakSelf.progross = 0;
        }
    }];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    
    self.draFlot = dratNum;
}


#pragma Mark - 音频播放模块
- (void)startRePlayer:(NSInteger)tag{//重新播放
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    [self startPlayAndStop:tag];
}

//增加收听数
- (void)addNumbers:(NoticeVoiceListModel *)choiceModel{
    NoticeVoiceListModel *model = choiceModel;
    NSString *url = [NSString stringWithFormat:@"users/%@/voices/%@",choiceModel.subUserModel.userId,model.voice_id];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
    
    } fail:^(NSError *error) {
    }];
}

//播放暂停
- (void)startPlayAndStop:(NSInteger)tag{
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        if (self.dataArr.count && self.oldModel) {
            NoticeVoiceListModel *oldM = self.oldModel;
            oldM.nowTime = oldM.voice_len;
            oldM.nowPro = 0;
            [self.tableView reloadData];
        }
        
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }
    
    NoticeVoiceListModel *model = self.dataArr[tag];
    
    self.oldModel = model;
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.voice_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
        [self addNumbers:model];
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
        if (!self.isPasue) {
            [self addNumbers:model];
        }
    }
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        weakSelf.lastPlayerTag = tag;
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            model.isPlaying = YES;
            [weakSelf.tableView reloadData];
        }
    };
    self.audioPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        //weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        [weakSelf.tableView reloadData];
    };
   
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        NoticeVoiceListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.voice_len.integerValue) {
            currentTime = model.voice_len.integerValue;
        }
   
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1) || (model.voice_len.intValue == 120 && [[NSString stringWithFormat:@"%.f",currentTime]integerValue] >= 118)) {
            cell.playerView.timeLen = model.voice_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            if ((model.voice_len.integerValue-currentTime)<-3) {
                [weakSelf.audioPlayer stopPlaying];
            }
            weakSelf.audioPlayer.playComplete = ^{
                [weakSelf.tableView reloadData];
                if (weakSelf.isAutoPlayer && !self.isrefreshNewToPlayer) {
                    [weakSelf nextForAssest];
                }
                if (weakSelf.isrefreshNewToPlayer) {
                    weakSelf.isrefreshNewToPlayer = NO;
                }
            };
 
            [weakSelf.tableView reloadData];
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.voice_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        model.nowPro = currentTime/model.voice_len.floatValue;

        if (model.moveSpeed > 0) {
            [cell.playerView refreshMoveFrame:model.moveSpeed*currentTime];
        }
    };
}

- (UILabel *)footLabel{
    if (!_footLabel) {
        _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 130)];
        _footLabel.textAlignment = NSTextAlignmentCenter;
        _footLabel.font = FOURTHTEENTEXTFONTSIZE;
        _footLabel.textColor = GetColorWithName(VDarkTextColor);
    }
    return _footLabel;
}
@end
