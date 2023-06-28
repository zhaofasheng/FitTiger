//
//  NoticeOtherUserInfoViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/31.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeOtherUserInfoViewController.h"
#import "NoticeStatus.h"
#import "NoticeOtherHeaderViewController.h"
#import "LGAudioPlayer.h"
#import "YYImageCoder.h"
#import "NoticeChangeNameViewController.h"
#import "SCImageView.h"
#import "AppDelegate.h"
#import "NoticeSCViewController.h"
#import "HDAlertView.h"
#import "NoticeSendViewController.h"
#import "NoticeManager.h"
#import "NoticeXi-Swift.h"
#import "NoticeRainSnow.h"
#import "NoticeAbout.h"
#import "NoticeCoverModel.h"
#import "NoticeNoticenterModel.h"
#import "NoticeWhiteVoiceController.h"
@interface NoticeOtherUserInfoViewController ()<LCActionSheetDelegate,NoticeManagerUserDelegate>
@property (nonatomic, strong) NoticeUserInfoModel *userInfo;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UIButton *loveButton;
@property (nonatomic, strong) LCActionSheet *isFriendSheet;
@property (nonatomic, strong) LCActionSheet *notFriendSheet;
@property (nonatomic, assign) BOOL isLahei;
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, assign) BOOL relationLH;
@property (nonatomic, assign) BOOL canNotiLook;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, assign) NSInteger managerType;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *setButton;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) SCImageView *playImageView;
@property (nonatomic, strong) NoticeStatus *status;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong) UIView *coverV;
@property (nonatomic, assign) BOOL isLager;
@property (nonatomic, assign) BOOL isMangeer;//是否是管理员
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UIButton *buttonb;
@property (nonatomic, strong) NSString *typere;
@property (nonatomic, strong) SCImageView *playSjImageView;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) NoticeAbout *about;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) NSString *timeLen;
@property (nonatomic, strong) NoticeRainSnow *rainsView;
@property (nonatomic, assign) BOOL isSgj;
@property (nonatomic, assign) BOOL canChat;
@property (nonatomic, assign) BOOL noPlay;//退出视图不再播放
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) FSCustomButton *bzsButton;
@end

@implementation NoticeOtherUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadButtonStatus:YES];
    [self requestCheckChat];
    self.isMangeer = [NoticeTools isManager];
    
    if (self.cardTitle) {
        XLAlertView *alertView = [[XLAlertView alloc] initWithTitle:@"被举报卡片" message:self.cardTitle cancleBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"]];
        [alertView showXLAlertView];
    }
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-44)];
    self.backImageView.contentMode =  UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    self.backImageView.userInteractionEnabled = YES;
    self.backImageView.backgroundColor = GetColorWithName(VBackColor);
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    longPressGesture.minimumPressDuration = 0.7f;//设置长按 时间
    [self.backImageView addGestureRecognizer:longPressGesture];
    [self.view addSubview:self.backImageView];
    
    self.setButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50-5, STATUS_BAR_HEIGHT, 50, 50)];
    [self.setButton setImage:UIImageNamed(@"Imageuseroth") forState:UIControlStateNormal];
    [self.setButton addTarget:self action:@selector(saveCode) forControlEvents:UIControlEventTouchUpInside];
    [self.backImageView addSubview:self.setButton];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 50, 50)];
    [backBtn setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backImageView addSubview:backBtn];
    
    self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(15, self.backImageView.frame.size.height-160-20, DR_SCREEN_WIDTH-30, 18)];
    self.nickNameL.textColor = [UIColor whiteColor];
    self.nickNameL.font = EIGHTEENTEXTFONTSIZE;
    [self.backImageView addSubview:self.nickNameL];
    
    self.infoL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nickNameL.frame)+15, DR_SCREEN_WIDTH-30, 14)];
    self.infoL.textColor = [UIColor whiteColor];
    self.infoL.font = TWOTEXTFONTSIZE;
    self.infoL.text = [[NoticeSaveModel getUserInfo] self_intro] ? [[NoticeSaveModel getUserInfo] self_intro] : GETTEXTWITE(@"set.nojianjie");
    [self.backImageView addSubview:self.infoL];
    
    self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.infoL.frame)+10, 0, 21)];
    self.contentL.font = THRETEENTEXTFONTSIZE;
    self.contentL.textColor = [UIColor whiteColor];
    self.contentL.textAlignment = NSTextAlignmentCenter;
    self.contentL.backgroundColor = [[UIColor colorWithHexString:@"#999999"] colorWithAlphaComponent:0.6];
    self.contentL.layer.cornerRadius = 21/2;
    self.contentL.layer.masksToBounds = YES;
    [self.backImageView addSubview:self.contentL];
    
    self.playImageView = [[SCImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.contentL.frame)+20, 55, 55)];
    self.playImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playTap)];
    [self.playImageView addGestureRecognizer:tap];
    self.playImageView.image = UIImageNamed(@"ImageuserPlay");
    [self.backImageView addSubview:self.playImageView];
    
    self.bzsButton = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-10-45,NAVIGATION_BAR_HEIGHT+23, 45, 45)];
    [self.bzsButton setImage:UIImageNamed(@"Image_bazaos_b") forState:UIControlStateNormal];
    [self.bzsButton addTarget:self action:@selector(bzsClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backImageView addSubview:self.bzsButton];
    self.bzsButton.hidden = YES;
    
    UIButton *buttonb = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-145-30, CGRectGetMaxY(self.contentL.frame)+26, 145, 48)];
    [buttonb setTitle:@"进入Ta的心情簿 >>" forState:UIControlStateNormal];
    [buttonb setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
    buttonb.titleLabel.font = THRETEENTEXTFONTSIZE;
    [buttonb setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centerxqb_b":@"Image_centerxqb_y") forState:UIControlStateNormal];
    _buttonb = buttonb;
    [self.backImageView addSubview:buttonb];
    
    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-104-30, CGRectGetMaxY(self.contentL.frame)+26, 134,42)];
    [clickBtn addTarget:self action:@selector(nextPush) forControlEvents:UIControlEventTouchUpInside];
    [self.backImageView addSubview:clickBtn];
    
    self.isReplay = YES;
    self.isPasue = NO;
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.backImageView.frame.size.height)];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    _coverV = coverView;
    [self.backImageView addSubview:coverView];
    [self.backImageView sendSubviewToBack:coverView];
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-44, DR_SCREEN_WIDTH, BOTTOM_HEIGHT+44)];
    backV.backgroundColor = GetColorWithName(VBackColor);
    _backV = backV;
    NSArray *titleArr = @[@" +欣赏",@" 交流",[NoticeTools isSimpleLau]?@"为你加油！":@"為妳加油！"];
    for (int i = 0; i < 3; i++) {
        UIButton *butotn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/3*i,0, DR_SCREEN_WIDTH/3, 44)];
        [butotn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        butotn .titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        butotn.tag = i;
        [butotn setTitle:titleArr[i] forState:UIControlStateNormal];
        [butotn addTarget:self action:@selector(funClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            _addButton = butotn;
        }else if (i == 1){
            _chatButton = butotn;
        }else{
            _loveButton = butotn;
        }
        [backV addSubview:butotn];
        
        if (i < 2) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/3+DR_SCREEN_WIDTH/3*i, 12, 1, 20)];
            line.backgroundColor = [NoticeTools isWhiteTheme]? GetColorWithName(VlineColor):[UIColor colorWithHexString:@"3e3e4a"];
            [backV addSubview:line];
        }
    }
    [self.view addSubview:backV];
    
    self.isLager = YES;
    UITapGestureRecognizer *lagerTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lagerTap)];
    [self.backImageView addGestureRecognizer:lagerTaps];
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.backImageView addGestureRecognizer:self.leftSwipeGestureRecognizer];
    
    [self upVisitors];
}

//白噪声
- (void)bzsClick{
    NoticeWhiteVoiceController *ctl = [[NoticeWhiteVoiceController alloc] init];
    ctl.userId = self.userId;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)requestCheckChat{
    self.canChat = YES;
    [[DRNetWorking shareInstance] requestCheckPathWith:[NSString stringWithFormat:@"chats/check/%@/2/0",self.userId] Accept:@"application/vnd.shengxi.v4.6.3+json" success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.canChat = YES;
        }else{
            self.errorMessage = [NSString stringWithFormat:@"%@",dict[@"msg"]];
            self.canChat = NO;
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

//提交访客记录
- (void)upVisitors{
    if ([[NoticeTools getuserId] isEqualToString:@"4795"] || [[NoticeTools getuserId] isEqualToString:@"1"]) {
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"1" forKey:@"position"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/visitors",self.userId] Accept:@"application/vnd.shengxi.v4.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextPush];
    }
}

- (void)lagerTap{
    __weak typeof(self) weakSelf = self;
    self.isLager = !self.isLager;

    [UIView animateWithDuration:0.3 animations:^{
        if (weakSelf.isLager) {
            weakSelf.backImageView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-44);
            weakSelf.backV.frame = CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-44, DR_SCREEN_WIDTH, BOTTOM_HEIGHT+44);
        }else{
            weakSelf.backImageView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
            weakSelf.backV.frame = CGRectMake(0, DR_SCREEN_HEIGHT,DR_SCREEN_WIDTH, BOTTOM_HEIGHT+44);
        }
        weakSelf.coverV.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, weakSelf.backImageView.frame.size.height);
    }];
}

- (void)nextPush{
    if (self.relationLH) {
        [self showToastWithText:[self.typere isEqualToString:@"4"]?@"由于对方在你的黑名单中，你不能进行该操作" :@"由于对方权限设置，您不能进行该操作"];
        return;
    }
    if (self.status.be_in_allowed.boolValue) {
        self.isFriend = YES;
    }
    
    if (!self.status.close_border.integerValue) {
        [self showToastWithText:@"闭关中，请之后访问"];
        return;
    }
    
    NoticeOtherHeaderViewController *ctl = [[NoticeOtherHeaderViewController alloc] init];
    ctl.isOther = YES;
    ctl.userId = self.userId;
    ctl.isFriend = self.isFriend;
    ctl.nickName = self.userInfo.nick_name;
    ctl.userInfo = self.userInfo;
    __weak typeof(self) weakSelf = self;
    ctl.refreshBlock = ^(BOOL refresh) {
        [weakSelf loadButtonStatus:NO];
    };
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"pageCurl"
                                                                    withSubType:kCATransitionFromTop
                                                                       duration:0.5f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:ctl animated:NO];
}

- (void)playTap{
    if (self.isSgj) {//如果上次是播放迷你时光机
        [self.audioPlayer stopPlaying];
        [self.playSjImageView stopRotating];
        self.isReplay = YES;
    }
    self.isSgj = NO;
    [self playStatus:nil];
}

- (void)playStatus:(NSString *)url{
    if (self.noPlay) {
        return;
    }
    if (!self.isSgj) {
        if (!self.userInfo) {
             return;
         }
    }
    
    if (self.isReplay) {
        DRLog(@"重头播放");
        [self.audioPlayer stopPlaying];
        [self.audioPlayer startPlayWithUrl:self.isSgj? url : self.userInfo.wave_url isLocalFile:NO];
        self.isPasue = NO;
        self.isReplay = NO;
        if (self.isSgj) {
            [self.playSjImageView resumeRotate];
        }else{
            [self.playImageView resumeRotate];
        }
    }else{
        self.isPasue = !self.isPasue;
        if (!self.isPasue) {
            DRLog(@"开始");
            if (self.isSgj) {
                [self.playSjImageView resumeRotate];
            }else{
                [self.playImageView resumeRotate];
            }
        }else{
            DRLog(@"暂停");
            if (self.isSgj) {
                [self.playSjImageView stopRotating];
            }else{
                [self.playImageView stopRotating];
            }
        }
        
        [self.audioPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.audioPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        [weakSelf.playSjImageView stopRotating];
        [weakSelf.playImageView stopRotating];
    };
}

- (void)cellLongPress:(UILongPressGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {//执行一次
        __weak typeof(self) weakSelf = self;
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf.backImageView.image saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
                    [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"yl.baocsus"]];
                }];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"mineme.saveimg"]]];
        [sheet show];
    }
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (status == AVPlayerItemStatusFailed) {
                [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
                weakSelf.isReplay = YES;
                weakSelf.isPasue = NO;
                [weakSelf.playImageView stopRotating];
                [weakSelf.playSjImageView stopRotating];
            }
        };
    }
    return _audioPlayer;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)likeOrNoLikeClcik{
    if (self.status.friendStatus.status.intValue == 2) {//已是好友，不存在欣赏与否
        return;
    }

    if (!self.status.admired_id.intValue) {//已欣赏就取消欣赏
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"加欣赏，彼将知\n互欣赏，成学友" message:nil sureBtn:@"+欣赏" cancleBtn:[NoticeTools getLocalStrWith:@"bz.dcl"]];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:self.userId forKey:@"toUserId"];
                [weakSelf showHUD];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admires" Accept:@"application/vnd.shengxi.v4.6.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [weakSelf hideHUD];
                    if (success) {
                        NoticeStatus *status = [NoticeStatus mj_objectWithKeyValues:dict[@"data"]];
                        weakSelf.status.admired_id = status.AdmiredId;
                        [self.addButton setTitle:[NoticeTools getLocalType]?@"Following":@" 已欣赏" forState:UIControlStateNormal];
                    }
                } fail:^(NSError * _Nullable error) {
                    [weakSelf hideHUD];
                }];
            }
        };
        [alerView showXLAlertView];
    }else{
        [self showHUD];
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admires/%@",self.status.admired_id] Accept:@"application/vnd.shengxi.v4.6.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                self.status.admired_id = @"0";
                [self.addButton setTitle:@" +欣赏" forState:UIControlStateNormal];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }
}

- (void)funClick:(UIButton *)button{
    if (button.tag == 0) {//加学友
        if (self.isYourBlack) {
            [self showToastWithText:@"对方在你的黑名单里，请先将其移除黑名单再进行此操作"];
            return;
        }
        [self likeOrNoLikeClcik];
    }else if (button.tag == 2){//表白
        button.enabled = NO;
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"confessions?toUserId=%@",self.userId] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            button.enabled = YES;
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                if ([dict[@"data"][@"confess_id"] isEqual:[NSNull null]]) {
                    return ;
                }
                NSString *conFessId = [NSString stringWithFormat:@"%@",dict[@"data"][@"confess_id"]];
                if ([conFessId isEqualToString:@"0"]) {//判断是否表白过
                    __weak typeof(self) weakSelf = self;
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"觉得你很棒，请继续加油！" message:nil sureBtn:@"加油" cancleBtn:[NoticeTools getLocalStrWith:@"bz.dcl"]];
                    alerView.resultIndex = ^(NSInteger index) {
                        if (index == 1) {
                            NSMutableDictionary *parm = [NSMutableDictionary new];
                            [parm setObject:self.userId forKey:@"toUserId"];
                            [parm setObject:@"-1" forKey:@"openDay"];
                            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"confessions" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                                
                                if (success) {
                                    [weakSelf showToastWithText:@"已为ta加油"];
                                }
                            } fail:^(NSError *error) {
                            }];
                        }
                    };
                    [alerView showXLAlertView];

                }else{
                    [self showToastWithText:@"您今天已经加油过了哦"];
                }
            }
        } fail:^(NSError *error) {
            button.enabled = YES;
        }];
    
    }else if (button.tag == 1){
        
        if ([[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"]) {//客服不受干扰
            NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
            vc.toUser = self.userInfo.socket_id;
            vc.toUserId = self.userInfo.user_id;
            vc.identType = self.userInfo.identity_type;
            vc.navigationItem.title = self.userInfo.nick_name;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        if (self.isFromChat) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if (!self.userInfo.socket_id) {
            [self showToastWithText:@"对方处于离线状态"];
            return;
        }
        if (self.isYourBlack) {
            [self showToastWithText:@"对方在你的黑名单里，请先将其移除黑名单再进行此操作"];
            return;
        }

        if (!self.canChat) {
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:self.errorMessage message:nil cancleBtn:@"好的，知道了"];
            [alerView showXLAlertView];
            return;
        }
        NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
        vc.toUser = self.userInfo.socket_id;
        vc.identType = self.userInfo.identity_type;
        vc.toUserId = self.userInfo.user_id;
        vc.lelve = self.userInfo.levelImgName;
        vc.navigationItem.title = self.userInfo.nick_name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//右上角按钮
- (void)saveCode{
    NSString *titleLh = [self.userInfo.relation_status isEqualToString:@"2"]? @"移除屏蔽":[NoticeTools getLocalStrWith:@"chat.hide"];
    NSArray *arr = self.isMangeer?@[@"发警告",self.userInfo.isClose?@"解除禁闭状态" : @"关禁闭",self.userInfo.flag.integerValue?@"解除仙人掌状态": @"设为仙人掌",@"封号",GETTEXTWITE(@"myfriend.beizhu"),titleLh,GETTEXTWITE(@"set.deleateF"),[NoticeTools getLocalStrWith:@"chat.jubao"]]:@[GETTEXTWITE(@"myfriend.beizhu"),titleLh,GETTEXTWITE(@"set.deleateF"),[NoticeTools getLocalStrWith:@"chat.jubao"]];
    NSArray *arr1 = nil;
    
    arr1 = self.isMangeer?@[@"发警告",self.userInfo.isClose?@"解除禁闭状态" : @"关禁闭",self.userInfo.flag.integerValue?@"解除仙人掌状态": @"设为仙人掌",@"封号",titleLh,self.userInfo.in_whitelist.integerValue?@"移出白名单": @"加入白名单",[NoticeTools getLocalStrWith:@"chat.jubao"]]:@[titleLh,self.userInfo.in_whitelist.integerValue?@"移出白名单": @"加入白名单",[NoticeTools getLocalStrWith:@"chat.jubao"]];
    
    if ([self.status.friendStatus.status isEqualToString:@"2"]) {//是好友
        __weak typeof(self) weakSelf = self;
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (weakSelf.isMangeer) {
                if (buttonIndex == 5) {
                    NoticeChangeNameViewController *ctl = [[NoticeChangeNameViewController alloc] init];
                    ctl.isBeizhu = YES;
                    ctl.userId = weakSelf.userId;
                    ctl.name = weakSelf.userInfo.nick_name;
                    ctl.trueName = self.userInfo.nick_name_true;
                    ctl.navigationItem.title = [NSString stringWithFormat:@"修改%@",GETTEXTWITE(@"myfriend.beizhu")];
                    [weakSelf.navigationController pushViewController:ctl animated:YES];
                }
                else if (buttonIndex == 6) {
                    if ([weakSelf.userInfo.relation_status isEqualToString:@"2"]) {
                        weakSelf.isLahei = NO;
                        weakSelf.relationLH = NO;
                        [weakSelf outlahei];
                    }else{
                        weakSelf.isLahei = YES;
                    }
                }
            }else{
                if (buttonIndex == 1) {
                    NoticeChangeNameViewController *ctl = [[NoticeChangeNameViewController alloc] init];
                    ctl.isBeizhu = YES;
                    ctl.trueName = self.userInfo.nick_name_true;
                    ctl.userId = weakSelf.userId;
                    ctl.name = weakSelf.userInfo.nick_name;
                    ctl.navigationItem.title = [NSString stringWithFormat:@"修改%@",GETTEXTWITE(@"myfriend.beizhu")];
                    [weakSelf.navigationController pushViewController:ctl animated:YES];
                }
                else if (buttonIndex == 2) {
                    if ([weakSelf.userInfo.relation_status isEqualToString:@"2"]) {
                        weakSelf.isLahei = NO;
                        weakSelf.relationLH = NO;
                        [weakSelf outlahei];
                    }else{
                        weakSelf.isLahei = YES;
                    }
                }
            }
    
        } otherButtonTitleArray:arr];
        self.isFriendSheet = sheet;
        sheet.delegate = self;
        [sheet show];

    }else{
        __weak typeof(self) weakSelf = self;
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (weakSelf.isMangeer) {
                if(buttonIndex == 5){
                    if ([weakSelf.userInfo.relation_status isEqualToString:@"2"]) {
                        weakSelf.isLahei = NO;
                        weakSelf.relationLH = NO;
                        [weakSelf outlahei];
                    }else{
                        weakSelf.isLahei = YES;
                    }
                }
            }else{
                if(buttonIndex == 1){
                    if ([weakSelf.userInfo.relation_status isEqualToString:@"2"]) {
                        weakSelf.isLahei = NO;
                        weakSelf.relationLH = NO;
                        [weakSelf outlahei];
                    }else{
                        weakSelf.isLahei = YES;
                    }
                }
            }
        
        } otherButtonTitleArray:arr1];
        self.notFriendSheet = sheet;
        sheet.delegate = self;
        [sheet show];
    }
}

- (void)jubao{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = self.userId;
    juBaoView.reouceType = @"4";
    [juBaoView showView];
}

//加入或者移除白名单
- (void)joinWhiteList{
    if (!self.userId) {
        return;
    }
    if ([self.userInfo.relation_status isEqualToString:@"2"]) {
        [self showToastWithText:@"对方被你屏蔽了，请先解除屏蔽"];
        return;
    }
    if (self.userInfo.in_whitelist.integerValue) {
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/whitelist/%@",[[NoticeSaveModel getUserInfo]user_id],self.userId] Accept:@"application/vnd.shengxi.v3.6+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                self.userInfo.in_whitelist = @"0";
                [self showToastWithText:@"已将对方移出白名单"];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"加入白名单的用户在未来3天内可以浏览你的全部记忆和相册(设为仅自己可见的内容除外)，确定将对方加入白名单吗?" sureBtn:@"加入白名单" cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"]];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {

            [weakSelf showHUD];
            NSMutableDictionary *parms = [NSMutableDictionary new];
            [parms setObject:self.userId forKey:@"toUserId"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/whitelist",[[NoticeSaveModel getUserInfo]user_id ]] Accept:@"application/vnd.shengxi.v3.6+json" isPost:YES parmaer:parms page:0 success:^(NSDictionary *dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    self.userInfo.in_whitelist = @"1";
                    NoticePinBiView *pinTostView = [[NoticePinBiView alloc] initWithTostViewString:[NSString stringWithFormat:@"%@白名单，白名单可\n以在「隐私设置」中管理",[NoticeTools getLocalStrWith:@"each.each.hasjoinGroup"]]];
                    [pinTostView showTostView];
                }
            } fail:^(NSError *error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
}

- (void)manangerUserWith:(NSInteger)type{
    if (!type) {
        return;
    }
    NSArray *arr = @[@"发警告",self.userInfo.isClose?@"解除禁闭状态" : @"关禁闭",self.userInfo.flag.integerValue?@"解除仙人掌状态": @"设为仙人掌",@"封号"];
    self.managerType = type;
    self.magager.type = arr[type-1];
    [self.magager show];
}

- (void)sureManagerClick:(NSString *)code{
    
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (self.managerType == 1) {//发警告
        [parm setObject:@"1" forKey:@"warn"];
    }else if (self.managerType == 2){//关禁闭
        [parm setObject:self.userInfo.isClose?@"0": @"1" forKey:@"confine"];
    }else if (self.managerType == 3){//仙人掌
        [parm setObject:self.userInfo.flag.integerValue?@"0" : @"1" forKey:@"flag"];
    }else if (self.managerType == 4){
        [parm setObject:@"3" forKey:@"userStatus"];
    }
    [parm setObject:code forKey:@"confirmPasswd"];
    
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/users/%@",self.userId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            if (self.managerType == 3) {
                if (self.userInfo.flag.integerValue) {
                    self.userInfo.flag = @"0";
                }else{
                    self.userInfo.flag = @"1";
                }
            }else if (self.managerType == 2){
                self.userInfo.isClose = !self.userInfo.isClose;
            }
            [self showToastWithText:@"操作已执行"];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if ((actionSheet != self.isFriendSheet) && (actionSheet != self.notFriendSheet)) {
        return;
    }
    if (self.isMangeer) {
        if (buttonIndex < 5) {
            [self manangerUserWith:buttonIndex];
        }else{
            if (actionSheet == self.isFriendSheet) {
                if (buttonIndex == 6) {
                    if (self.isLahei) {
                        [self lahei];
                    }
                }else if (buttonIndex == 7){
                    __weak typeof(self) weakSelf = self;
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:GETTEXTWITE(@"sure.deletefriend") message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"]];
                    alerView.resultIndex = ^(NSInteger index) {
                        if (index == 1) {
                            [weakSelf deleFriend];
                        }
                    };
                    [alerView showXLAlertView];
                }else if (buttonIndex == 8){
                    [self jubao];
                }
            }else if (actionSheet == self.notFriendSheet){
                if (buttonIndex == 5) {
                    if (self.isLahei) {
                        [self lahei];
                    }
                }else if (buttonIndex == 6){
                    [self joinWhiteList];
                }else if (buttonIndex == 7){
                    [self jubao];
                }
            }
        }
        
    }else{
        if (actionSheet == self.isFriendSheet) {
            if (buttonIndex == 2) {
                if (self.isLahei) {
                    [self lahei];
                }
            }else if (buttonIndex == 3){
                __weak typeof(self) weakSelf = self;
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:GETTEXTWITE(@"sure.deletefriend") message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"]];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 1) {
                        weakSelf.isFriend = NO;
                        [weakSelf deleFriend];
                    }
                };
                [alerView showXLAlertView];
            }else if (buttonIndex == 4){
                [self jubao];
            }
        }else if (actionSheet == self.notFriendSheet){
            if (buttonIndex == 1) {
                if (self.isLahei) {
                    [self lahei];
                }
            }else if (buttonIndex == 2){
                [self joinWhiteList];
            }else if (buttonIndex == 3){//举报
                [self jubao];
            }
        }
    }

}

- (void)deleFriend{
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/friends/%@",[[NoticeSaveModel getUserInfo]user_id],self.userId] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:@"已删除学友"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)lahei{
    
    __weak typeof(self) weakSelf = self;
    NoticePinBiView *pinView = [[NoticePinBiView alloc] initWithPinBiView];
    pinView.ChoiceType = ^(NSInteger type) {
        [weakSelf showHUD];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.userId forKey:@"toUserId"];
        [parm setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"reasonType"];
        [parm setObject:@"4" forKey:@"resourceType"];
        [parm setObject:self.userId forKey:@"resourceId"];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/shield",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v3.4+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [weakSelf hideHUD];
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICION" object:nil];//刷新私聊会话列表
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICIONHS" object:nil];//刷新悄悄话会话列表
                [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"intro.yibp"]];
                [weakSelf loadButtonStatus:YES];
                weakSelf.userInfo.relation_status = @"2";
                NoticePinBiView *pinTostView = [[NoticePinBiView alloc] initWithTostViewType:type];
                [pinTostView showTostView];
            }
        } fail:^(NSError *error) {
            [weakSelf hideHUD];
        }];
        
    };
    [pinView showPinbView];

}

- (void)outlahei{
    if (!self.userId) {
        return;
    }
    [self showHUD];
  
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/blacklist/%@",[[NoticeSaveModel getUserInfo]user_id],self.userId] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:@"已移除黑名单"];
            self.userInfo.relation_status = @"0";
            [self loadButtonStatus:YES];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)request{
    if (!self.userId) {
        return;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",self.userId] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
       
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            NSString *str = [NSString stringWithFormat:@"记录了%@天，心情总时长%@",userIn.comeHereDays,userIn.allVoiceTime];
            self.contentL.text = str;
            self.contentL.frame = CGRectMake(15, CGRectGetMaxY(self.infoL.frame)+10,GET_STRWIDTH(str, 13, 13)+10, 21);
            self.userInfo = userIn;
            
            self.nickNameL.text = self.userInfo.nick_name;
            self.infoL.text = self.userInfo.self_intro.length ? self.userInfo.self_intro : GETTEXTWITE(@"set.nojianjie");
        }
    } fail:^(NSError *error) {

    }];
    
    //获取封面
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/covers?coverName=moodbook_cover",self.userId] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
        if (success1) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NSMutableArray *arr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeCoverModel *model = [NoticeCoverModel mj_objectWithKeyValues:dic];
                [arr addObject:model];
            }
            if (arr.count) {
                int tag = arc4random() % arr.count;
                [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:[arr[tag] coverUrl]]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image && !error) {
                        
                    }else{
                        self.backImageView.image = UIImageNamed(@"Image_userCenter");
                    }
                }];
            }else{
                self.backImageView.image = UIImageNamed( @"Image_userCenter");
            }                }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)loadButtonStatus:(BOOL)needShowTosat{
    if (!self.userId) {
        return;
    }
    
    if (needShowTosat) {
        [self showHUD];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/bottom",self.userId] Accept:@"application/vnd.shengxi.v4.6.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeStatus *statusM = [NoticeStatus mj_objectWithKeyValues:dict[@"data"]];
            self.status = statusM;
            if (statusM.friendStatus.status.intValue != 2 && !self.status.admired_id.intValue) {//不是室友并且未有欣赏
                [self.addButton setTitle:@" +欣赏" forState:UIControlStateNormal];
            }else if (statusM.friendStatus.status.intValue !=2 && self.status.admired_id.intValue){
                [self.addButton setTitle:[NoticeTools getLocalType]?@"Following":@" 已欣赏" forState:UIControlStateNormal];
            }
            if ([statusM.friendStatus.status isEqualToString:@"2"]){
                [self.addButton setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
                [self.addButton setTitle:@"已是学友" forState:UIControlStateNormal];
                self.isFriend = YES;
            }
            
            if ([statusM.chatStatus.status isEqualToString:@"0"]) {
                self.chatButton.enabled = YES;
                [self.chatButton setTitle:[NoticeTools getLocalStrWith:@"message.chat"] forState:UIControlStateNormal];
            }else if ([statusM.chatStatus.status isEqualToString:@"1"]){
                if ([statusM.friendStatus.status isEqualToString:@"2"]) {
                    self.chatButton.enabled = YES;
                    [self.chatButton setTitle:[NoticeTools getLocalStrWith:@"message.chat"] forState:UIControlStateNormal];
                }else{
                    if (![[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"]) {
                        self.chatButton.enabled = NO;
                    }
                    [self.chatButton setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
                    [self.chatButton setTitle:@"交流限学友" forState:UIControlStateNormal];
                }
            }
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingTag=moodbook",self.userId] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dicts, BOOL successs) {
                if (successs) {
                    if ([dicts[@"data"] isEqual:[NSNull null]]) {
                        return ;
                    }
                    self.about = [NoticeAbout new];
                    for (NSDictionary *dic in dicts[@"data"]) {
                        NoticeAbout *setM = [NoticeAbout mj_objectWithKeyValues:dic];
                        if ([setM.setting_name isEqualToString:@"cover_brightness"]) {
                            self.about.cover_brightness = setM.setting_value;
                        }else if ([setM.setting_name isEqualToString:@"cover_efficacy"]){
                            self.about.cover_efficacy = setM.setting_value;
                        }else if ([setM.setting_name isEqualToString:@"minimachine_visibility"]){
                            self.about.minimachine_visibility = setM.setting_value;
                        }
                    }
                    
                    if ([self.about.cover_brightness isEqualToString:@"2"]) {//原图亮度
                        self.coverView.hidden = YES;
                    }else{
                        self.coverView.hidden = NO;
                    }
                    
                    if (self.about.cover_efficacy.intValue) {//是否需要动效
                        [self getAminationWithTag:0];
                        [self getAminationWithTag:self.about.cover_efficacy.integerValue];
                    }else{
                        [self getAminationWithTag:0];
                    }
                    if (self.relationLH) {
                        self.playSjImageView.hidden = YES;
                    }else{
                        if ([self.about.minimachine_visibility isEqualToString:@"2"]) {//迷你时光机
                            self.playSjImageView.hidden = NO;
                        }else{
                            if ([statusM.friendStatus.status isEqualToString:@"2"]) {
                                self.playSjImageView.hidden = NO;
                            }else{
                                self.playSjImageView.hidden = YES;
                            }
                        }
                    }
                    
                    
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
    
    [[DRNetWorking shareInstance] requestNoTosat:[NSString stringWithFormat:@"relations/%@",self.userId] Accept:@"application/vnd.shengxi.v2.2+json" parmaer:nil success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            if ([dict1[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if ([dict1[@"data"][@"friend_status"] isEqual:[NSNull null]]) {
                return ;
            }
            NSString *friend_status = [NSString stringWithFormat:@"%@",dict1[@"data"][@"friend_status"]];
            self.typere = friend_status;
            if ([friend_status isEqualToString:@"3"] || [friend_status isEqualToString:@"4"]) {
                self.relationLH = YES;
                self.playSjImageView.hidden = YES;
                self.bzsButton.hidden = YES;
            }else{
                self.relationLH = NO;
                self.bzsButton.hidden = NO;
            }
        }
    }];
    
}

- (NoticeRainSnow *)rainsView{
    if (!_rainsView) {
        _rainsView = [[NoticeRainSnow alloc] init];
    }
    return _rainsView;
}

- (void)getAminationWithTag:(NSInteger)tag{
    if (tag == 0) {
        [self.rainsView dissAllLayer];
    }else if (tag ==1){//下雨
        [self.rainsView rainIn:self.view];
    }else if (tag ==2){//下雪
        [self.rainsView snowIn:self.view];
    } else if (tag ==3){//落叶
        [self.rainsView yeziIn:self.view];
    }
    else if (tag ==4){//落花
        [self.rainsView flowerIn:self.view];
    } else if (tag ==5){//枫叶
        [self.rainsView fengyeIn:self.view];
    }
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.noPlay = NO;
    self.navigationController.navigationBar.hidden = YES;
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self->_buttonb.frame = CGRectMake(DR_SCREEN_WIDTH-15-146, CGRectGetMaxY(self.contentL.frame)+26, 145, 48);
        
    } completion:^(BOOL finished) {
        
    }];
    [self request];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [_audioPlayer pause:YES];
    [_audioPlayer stopPlaying];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.noPlay = YES;
    _buttonb.frame = CGRectMake(DR_SCREEN_WIDTH-15-145-30, CGRectGetMaxY(self.contentL.frame)+26, 145, 48);
    [_audioPlayer pause:YES];
    [_audioPlayer stopPlaying];
    self.isReplay = YES;
    self.playImageView.layer.timeOffset = 0;
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}

@end
