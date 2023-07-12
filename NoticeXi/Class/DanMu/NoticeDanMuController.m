//
//  NoticeDanMuController.m
//  NoticeXi
//
//  Created by li lei on 2021/2/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDanMuController.h"
#import "FDanmakuView.h"
#import "FDanmakuModel.h"
#import "NoticeDanMuHeaderView.h"
#import "NoticeDanMuInputView.h"
#import "NoticeDanMuListModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NoticeBoKeListView.h"
#import "NoticeBBSComentInputView.h"
#import "NoticeJuBaoBoKeTosatView.h"
#import "NoticeChangeIntroduceViewController.h"
@interface NoticeDanMuController ()<FDanmakuViewProtocol,NoticeDanMuDelegate,LCActionSheetDelegate,NoticeBBSComentInputDelegate>
@property(nonatomic,strong)FDanmakuView *danmakuView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NoticeDanMuHeaderView *danmuHeaderView;
@property (nonatomic, strong) NoticeDanMuInputView *inputView;
@property (nonatomic, strong) NSArray *begTimeArr;
@property (nonatomic, strong) NSArray *liveTimeArr;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isNoSetBackButton;//没有设置
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, assign) BOOL isNextOrPre;
@property (nonatomic, assign) BOOL canReplay;//可以自动播放
@property (nonatomic, assign) BOOL firstGetIn;
@property (nonatomic, strong) NSMutableArray *danmArr;
@property (nonatomic, strong) NoticeBBSComentInputView *inputV;
@property (nonatomic, strong) NSMutableArray *shareArr;
@property (nonatomic, assign) CGFloat currentSendTime;
@property (nonatomic, assign) CGFloat sendTime;
@property (nonatomic, assign) NSInteger getTime;
@property (nonatomic, strong) NSMutableDictionary *showParm;
@property (nonatomic, strong,nullable) LGAudioPlayer *bkPlayer;
@property (nonatomic, strong) NoticeBoKeListView *listView;
@property (nonatomic, strong) UIImageView *bkFmimageView;
@property (nonatomic, strong) UIView *sendView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIButton *openBtn;
@end

@implementation NoticeDanMuController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noNeedStop = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noNeedStop = NO;
    self.canReplay = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}

- (void)stopPlayBoke{
    [self.bkPlayer stopPlaying];
    self.isReplay = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.bkPlayer stopPlaying];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.isReplay = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    MPRemoteCommand *playCommand = commandCenter.playCommand;
    MPRemoteCommand *nextCommand = commandCenter.nextTrackCommand;
    MPRemoteCommand *previousCommand = commandCenter.previousTrackCommand;
    [nextCommand removeTarget:self];
    [previousCommand removeTarget:self];
    [playCommand removeTarget:self];
    
}

- (NoticeBoKeListView *)listView{
    if (!_listView) {
        _listView = [[NoticeBoKeListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        
        _listView.choiceBoKeBlock = ^(NoticeDanMuModel * _Nonnull choiceModel) {
            [weakSelf.bkPlayer stopPlaying];
            weakSelf.bokeModel = choiceModel;
            weakSelf.listView.choiceModel = choiceModel;
            [weakSelf refreshBokeUI];
            [weakSelf playClick];
        };
    }
    return _listView;
}

- (void)refreshBokeUI{
    
    [self.bkFmimageView sd_setImageWithURL:[NSURL URLWithString:self.bokeModel.cover_url]];
    self.titleL.text = self.bokeModel.podcast_title;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.bokeModel.background_url] placeholderImage:nil];
    self.danmuHeaderView.bokeModel = self.bokeModel;
    self.danmuHeaderView.listView.bokeM = self.bokeModel;
    
    self.danmuHeaderView.playeBoKeView.slider.value = 0;
    self.danmuHeaderView.playeBoKeView.slider.maximumValue = self.bokeModel.total_time.integerValue;
    self.danmuHeaderView.playeBoKeView.slider.minimumValue = 0;
    self.danmuHeaderView.playeBoKeView.maxTimeLabel.text = [self getMMSSFromSS:self.bokeModel.total_time.integerValue];
    self.isReplay = YES;
    
    [self.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokepause") forState:UIControlStateNormal];
    self.danmuHeaderView.playeBoKeView.minTimeLabel.text = @"00:00";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listView.choiceModel = self.bokeModel;
    
    // 后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apllicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
    // 进入前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apllicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.bkFmimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.bkFmimageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bkFmimageView.clipsToBounds = YES;
    self.bkFmimageView.userInteractionEnabled = YES;
    [self.view addSubview:self.bkFmimageView];
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.frame = self.bkFmimageView.bounds;
    [self.bkFmimageView addSubview:visualView];
    
    self.firstGetIn = YES;
    self.getTime = 0;
    self.danmArr = [NSMutableArray new];
    self.showParm = [NSMutableDictionary new];
    [self requestDanMuWithTime:self.getTime];
    
    self.begTimeArr = @[@"3.2",@"2.6",@"3",@"2.8",@"3.7",@"3.4",@"3.1"];
    self.liveTimeArr = @[@"5",@"6",@"7",@"6.5",@"7.5",@"5.5",@"6.3"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-100, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    self.titleL.font = EIGHTEENTEXTFONTSIZE;
    self.titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.titleL];
    self.titleL.textAlignment = NSTextAlignmentCenter;

    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-10-50, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [moreBtn setImage:UIImageNamed(@"jubaoordelebk_Image") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,NAVIGATION_BAR_HEIGHT+10, DR_SCREEN_WIDTH-40, (((DR_SCREEN_WIDTH-40)*223)/335))];
    [self.view addSubview:self.backImageView];
    self.backImageView.layer.cornerRadius = 5;
    self.backImageView.layer.masksToBounds = YES;
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    self.backImageView.userInteractionEnabled = YES;
    
    FDanmakuView *danmaView = [[FDanmakuView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, ((DR_SCREEN_WIDTH-40)*223)/335-50)];
    danmaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    danmaView.delegate = self;
    self.danmakuView = danmaView;
    [self.view addSubview:danmaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playClick)];
    [self.backImageView addGestureRecognizer:tap];
    
    self.danmuHeaderView = [[NoticeDanMuHeaderView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT+(DR_SCREEN_WIDTH*250)/375+10, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-((DR_SCREEN_WIDTH*250)/375)-10)];
    [self.view addSubview:self.danmuHeaderView];

    
    self.bkPlayer = [[LGAudioPlayer alloc] init];
    self.bkPlayer.oneSecondGo = YES;
    

    __weak typeof(self) weakSelf = self;
    self.danmuHeaderView.hideKeyBordBlock = ^(BOOL isHide) {
        [weakSelf.inputView.contentView resignFirstResponder];
    };
    
    self.danmuHeaderView.playeBoKeView.playBlock = ^(BOOL clickPlay) {
        [weakSelf playClick];
      //
    };
    self.danmuHeaderView.playeBoKeView.preBlock = ^(UISlider * _Nonnull slider) {
        if (weakSelf.isReplay) {//如果还没播放执行播放
            [weakSelf playClick];
            return ;
        }else{
            //如果在播放，执行暂停
            weakSelf.isPasue = YES;
            [weakSelf.bkPlayer pause:weakSelf.isPasue];
            [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(weakSelf.isPasue?@"Image_bokepause": @"Image_bokeplaying") forState:UIControlStateNormal];
        }
        [weakSelf.bkPlayer.player seekToTime:CMTimeMake((slider.value-15)>0?(slider.value-15):0, 1) completionHandler:^(BOOL finished) {
         
            if (finished) {
                weakSelf.isPasue = NO;
                [weakSelf.bkPlayer pause:weakSelf.isPasue];
                [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokeplaying") forState:UIControlStateNormal];
            }
        }];
    };

    self.danmuHeaderView.playeBoKeView.moveBlock = ^(UISlider * _Nonnull slider) {
        if (weakSelf.isReplay) {//如果还没播放执行播放
            [weakSelf playClick];
            return ;
        }else{
            //如果在播放，执行暂停
            weakSelf.isPasue = YES;
            [weakSelf.bkPlayer pause:weakSelf.isPasue];
            [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(weakSelf.isPasue?@"Image_bokepause": @"Image_bokeplaying") forState:UIControlStateNormal];
        }
        [weakSelf.bkPlayer.player seekToTime:CMTimeMake((slider.value+30)>slider.maximumValue?slider.maximumValue:(slider.value+30), 1) completionHandler:^(BOOL finished) {
         
            if (finished) {
                weakSelf.isPasue = NO;
                [weakSelf.bkPlayer pause:weakSelf.isPasue];
                [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokeplaying") forState:UIControlStateNormal];
            }
        }];
    };

    self.danmuHeaderView.playeBoKeView.sliderBlock = ^(UISlider * _Nonnull slider) {
        if (weakSelf.isReplay) {//如果还没播放执行播放
            [weakSelf playClick];
            return ;
        }else{
            //如果在播放，执行暂停
            weakSelf.isPasue = YES;
            [weakSelf.bkPlayer pause:weakSelf.isPasue];
            [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(weakSelf.isPasue?@"Image_bokepause": @"Image_bokeplaying") forState:UIControlStateNormal];
        }
        [weakSelf.bkPlayer.player seekToTime:CMTimeMake(slider.value, 1) completionHandler:^(BOOL finished) {
         
            if (finished) {
                weakSelf.isPasue = NO;
                [weakSelf.bkPlayer pause:weakSelf.isPasue];
                [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokeplaying") forState:UIControlStateNormal];
            }
        }];
    };
    
    self.danmuHeaderView.playeBoKeView.clickListBlock = ^(BOOL list) {
        [weakSelf.listView show];
    };
    
    self.inputView = [[NoticeDanMuInputView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH,50)];
    self.inputView.delegate = self;
    [self.view addSubview:self.inputView];
    self.inputView.hidden = YES;

    [self refreshBokeUI];
    [self setupLockScreenControlInfo];
    
    UIView *btnBackV = [[UIView alloc] initWithFrame:CGRectMake(self.backImageView.frame.size.width-40-76, self.backImageView.frame.size.height-8-32, 86, 32)];
    btnBackV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    btnBackV.layer.cornerRadius = 10;
    btnBackV.layer.masksToBounds = YES;
    [self.backImageView addSubview:btnBackV];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [sendBtn setTitle:@"点我发弹幕" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = TWOTEXTFONTSIZE;
    [btnBackV addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(faClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.isOpen = YES;
    self.openBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backImageView.frame.size.width-40,self.backImageView.frame.size.height-8-32, 32, 32)];
    [self.openBtn setBackgroundImage:UIImageNamed(self.isOpen? @"Image_openDanmu":@"Image_openDanmun") forState:UIControlStateNormal];
    [self.backImageView addSubview:self.openBtn];
    [self.openBtn addTarget:self action:@selector(openClick) forControlEvents:UIControlEventTouchUpInside];
    self.sendView = btnBackV;
    
    //收到语音通话请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayBoke) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
}

//发弹幕输入框
- (void)faClick{
    self.inputView.hidden = NO;
    [self.inputView.contentView becomeFirstResponder];
}

//是否开启弹幕
- (void)openClick{
    self.isOpen = !self.isOpen;
    [self.openBtn setBackgroundImage:UIImageNamed(self.isOpen? @"Image_openDanmu":@"Image_openDanmun") forState:UIControlStateNormal];
    self.danmakuView.hidden = !self.isOpen;
    self.sendView.hidden = self.danmakuView.hidden;
    if (!self.isOpen) {
        [self.inputView.contentView resignFirstResponder];
        self.inputView.hidden = YES;
    }
}

- (void)moreClick{
    if ([NoticeTools isManager]) {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[@"下架",self.bokeModel.is_hot.intValue?@"取消热门": @"设为热门"]];
        sheet.delegate = self;
        [sheet show];
        return;
    }
    NSArray *arr = [self.bokeModel.user_id isEqualToString:[NoticeTools getuserId]]?@[@"修改播客简介",[NoticeTools getLocalStrWith:@"py.dele"]]:@[[NoticeTools getLocalStrWith:@"chat.jubao"]];
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:arr];
    sheet.delegate = self;
    [sheet show];
}


- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"849527" forKey:@"confirmPasswd"];
    [parm setObject:comment forKey:@"remarks"];
    [self showHUD];
    
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/podcast/%@",self.bokeModel.podcast_no] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
    [self.inputV clearView];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    __weak typeof(self) weakSelf = self;
    if (buttonIndex == 1) {
        
        if ([NoticeTools isManager]) {
            if (!self.inputV) {
                NoticeBBSComentInputView *inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
                inputView.delegate = self;
                inputView.isRead = YES;
                inputView.ismanager = YES;
                inputView.limitNum = 100;
                inputView.needClear = YES;
                inputView.plaStr = @"输入下架理由";
                [inputView.sendButton setTitle:@"下架" forState:UIControlStateNormal];
                inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
                inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
                inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
                inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
                [inputView showJustComment:nil];
                self.inputV = inputView;
            }
            [self.inputV showJustComment:nil];
            [self.inputV.contentView becomeFirstResponder];
            [self.inputV.backView removeFromSuperview];
            UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
            [rootWindow addSubview:self.inputV.backView];
            self.inputV.backView.hidden = NO;
            return;
        }
        
        if ([self.bokeModel.user_id isEqualToString:[NoticeTools getuserId]]) {
            [self changeIntro];
        }else{
            NoticeJuBaoBoKeTosatView *jubaoV = [[NoticeJuBaoBoKeTosatView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            [jubaoV showView];
            jubaoV.jubaoBlock = ^(NSString * _Nonnull content) {
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:@"143" forKey:@"resourceType"];
                [parm setObject:self.bokeModel.bokeId forKey:@"resourceId"];
                [parm setObject:content forKey:@"reason"];
                [weakSelf showHUD];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"reports" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [weakSelf hideHUD];
                    if (success) {
                        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"举报成功" message:@"声昔君正火速赶来，你的举报\n将保护更多的小伙伴免受伤害" cancleBtn:@"知道了"];
                        [alerView showXLAlertView];
                    }
                } fail:^(NSError * _Nullable error) {
                    [weakSelf hideHUD];
                }];
            };
        }
    }else if (buttonIndex == 2){
        if ([NoticeTools isManager]) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"849527" forKey:@"confirmPasswd"];
            [parm setObject:self.bokeModel.is_hot.intValue?@"0": @"1" forKey:@"isHot"];
            [self showHUD];
            
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/podcast/hot/%@",self.bokeModel.podcast_no] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    [self showToastWithText:self.bokeModel.is_hot.intValue?@"已取消热门": @"已设置为热门"];
                    self.bokeModel.is_hot = self.bokeModel.is_hot.intValue?@"0":@"5678";
                }
                [self hideHUD];
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
            return;
        }
        if ([self.bokeModel.user_id isEqualToString:[NoticeTools getuserId]]){
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"确定删除此播客吗？" english:@"Delete this podcast?" japan:@"このポッドキャストを削除しますか?"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"py.dele"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                    [[NoticeTools getTopViewController] showHUD];
                    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"podcast/%@",weakSelf.bokeModel.podcast_no] Accept:@"application/vnd.shengxi.v5.4.4+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                        [[NoticeTools getTopViewController] hideHUD];
                        if (success) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"DeleteBoKeNotification" object:self userInfo:@{@"danmuNumber":self.bokeModel.podcast_no}];
                            [weakSelf backClick];
                        }
                    } fail:^(NSError * _Nullable error) {
                        [[NoticeTools getTopViewController] hideHUD];
                    }];
                }
            };
            [alerView showXLAlertView];
        }
    }
}

- (void)changeIntro{
    NoticeChangeIntroduceViewController *ctl = [[NoticeChangeIntroduceViewController alloc] init];
    ctl.isBoKeIntro = YES;
    ctl.bokeId = self.bokeModel.podcast_no;
    ctl.induce = self.bokeModel.podcast_intro;
    __weak typeof(self) weakSelf = self;
    ctl.changeBokeIntroBlock = ^(NSString * _Nonnull intro, NSString * _Nonnull bokeId) {
        weakSelf.bokeModel.podcast_intro = intro;
        [weakSelf refreshBokeUI];
    };
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)playClick{
    if (self.isReplay) {
        [self showHUD];
        self.canReplay = YES;
        [self.bkPlayer startPlayWithUrl:self.bokeModel.audio_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
        DRLog(@"重新播放");
    }else{
        DRLog(@"詹庭或者播放");
        self.canReplay = NO;
        self.isPasue = !self.isPasue;
        [self.bkPlayer pause:self.isPasue];
        [self.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(self.isPasue?@"Image_bokepause": @"Image_bokeplaying") forState:UIControlStateNormal];
    }
    
    __weak typeof(self) weakSelf = self;
    self.bkPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf hideHUD];
            [weakSelf showToastWithText:@"播放失败"];
        }else{
            DRLog(@"播放%@",weakSelf.bokeModel.podcast_title);
            [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokeplaying") forState:UIControlStateNormal];
            [weakSelf hideHUD];
        }
    };
    
    self.bkPlayer.playComplete = ^{
        [weakSelf refreshBokeUI];
        if (weakSelf.isNextOrPre) {
            weakSelf.isNextOrPre = NO;
            return;
        }
        if (weakSelf.canReplay) {
            [weakSelf next];
        }
    };
    
    self.bkPlayer.playingBlock = ^(CGFloat currentTime) {
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > weakSelf.bokeModel.total_time.integerValue) {
            currentTime = weakSelf.bokeModel.total_time.integerValue;
        }
        
        weakSelf.currentSendTime = currentTime;
        if (weakSelf.currentSendTime > weakSelf.bokeModel.total_time.intValue) {
            weakSelf.currentSendTime = weakSelf.bokeModel.total_time.intValue;
        }
        
        if ((currentTime - weakSelf.getTime >= 60) || (weakSelf.getTime-currentTime >= 60)) {//每一分钟秒获取一次
            weakSelf.getTime = currentTime;
            [weakSelf requestDanMuWithTime:weakSelf.getTime];
            DRLog(@"获取弹幕");
        }
        
        if ([[NSString stringWithFormat:@"%.f",weakSelf.bokeModel.total_time.integerValue-currentTime] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%.f",weakSelf.bokeModel.total_time.integerValue-currentTime] isEqualToString:@"-0"] ||  !((weakSelf.bokeModel.total_time.integerValue-currentTime)>0) || [[NSString stringWithFormat:@"%.f",weakSelf.bokeModel.total_time.integerValue-currentTime] isEqualToString:@"-1"] || ([[NSString stringWithFormat:@"%.f",weakSelf.bokeModel.total_time.integerValue-currentTime] isEqualToString:@"0"] && [weakSelf.bokeModel.total_time isEqualToString:@"1"])) {
            weakSelf.danmuHeaderView.playeBoKeView.maxTimeLabel.text = [weakSelf getMMSSFromSS:weakSelf.bokeModel.total_time.integerValue];
            [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokepause") forState:UIControlStateNormal];
            weakSelf.isReplay = YES;
        }
        
        if (currentTime > weakSelf.bokeModel.total_time.integerValue) {
            weakSelf.danmuHeaderView.playeBoKeView.maxTimeLabel.text = [weakSelf getMMSSFromSS:weakSelf.bokeModel.total_time.integerValue];
            weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text = [weakSelf getMMSSFromSS:0];
        }else{
            weakSelf.danmuHeaderView.playeBoKeView.maxTimeLabel.text = [weakSelf getMMSSFromSS:weakSelf.bokeModel.total_time.integerValue-currentTime];
            weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text = [weakSelf getMMSSFromSS:currentTime];
        }
        
        if ([weakSelf.danmuHeaderView.playeBoKeView.maxTimeLabel.text isEqualToString:@"00:00"]) {
            weakSelf.danmuHeaderView.playeBoKeView.slider.value =weakSelf.bokeModel.total_time.integerValue;
            weakSelf.danmuHeaderView.playeBoKeView.maxTimeLabel.text = [weakSelf getMMSSFromSS:weakSelf.bokeModel.total_time.integerValue];
        }
        
        if ([weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text isEqualToString:[weakSelf getMMSSFromSS:weakSelf.bokeModel.total_time.integerValue]]) {
            weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text = @"00:00";
        }
                
        weakSelf.danmuHeaderView.playeBoKeView.slider.value = currentTime;
        
        if ([weakSelf.showParm objectForKey:weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text]) {//如果存在这个时间段的弹幕
           
            NSMutableArray *arr = [weakSelf.showParm objectForKey:weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text];
            
            for (NoticeDanMuListModel *danmM in arr) {
                FDanmakuModel *model1 = [[FDanmakuModel alloc]init];
                int i = arc4random() % weakSelf.begTimeArr.count;
                int j = arc4random() % weakSelf.liveTimeArr.count;
                model1.beginTime = [weakSelf.begTimeArr[i] floatValue];
                model1.liveTime = [weakSelf.liveTimeArr[j] floatValue];
                model1.content = danmM.barrage_content;
                model1.color = danmM.barrage_colour;
                model1.contentId = danmM.danmuId;
                [weakSelf.danmakuView.modelsArr addObject:model1];
            }
        }
    };
}

- (void)requestDanMuWithTime:(NSInteger)time{
    if (self.firstGetIn) {
        [self showHUD];
        self.firstGetIn = NO;
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@/barrage?barrageAt=%ld&type=2&pageSize=100",self.bokeModel.podcast_no,self.getTime] Accept:@"application/vnd.shengxi.v4.9.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.danmArr removeAllObjects];
            [self.shareArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeDanMuListModel *model = [NoticeDanMuListModel mj_objectWithKeyValues:dic];
                [self.danmArr addObject:model];
            
                if (![self.showParm objectForKey:model.barrageTime]) {//如果还没有数据，直接添加一个数组，然后取出数组
                    NSMutableArray *arr = [NSMutableArray new];
                    [arr addObject:model];
                    [self.showParm setObject:arr forKey:model.barrageTime];
                  
                }else{//已经存在当前key值
                    NSMutableArray *arr = [self.showParm objectForKey:model.barrageTime];
                    if (arr.count < 5) {
                        [arr addObject:model];
                    }
                }
            }
//            self.danmuHeaderView.listView.dataArr = self.danmArr;
//            [self.danmuHeaderView.listView.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

//播放模块
-(NSString *)getMMSSFromSS:(NSInteger)totalTime{
    
    NSInteger seconds = totalTime;
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    if (seconds <0) {
        return format_time = @"00:00";
    }
    return format_time;
}

- (void)sendContent:(NSString *)content color:(NSString * _Nullable)color isTop:(BOOL)isTop{
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.bokeModel.podcast_no forKey:@"podcastNo"];
    [parm setObject:@"1" forKey:@"contentType"];
    [parm setObject:content forKey:@"barrageContent"];
    [parm setObject:isTop?@"2":@"1" forKey:@"barragePosition"];
    [parm setObject:color forKey:@"barrageColour"];
    [parm setObject:[NSString stringWithFormat:@"%.f",self.sendTime] forKey:@"barrageAt"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"podcast/barrage" Accept:@"application/vnd.shengxi.v4.9.7+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            FDanmakuModel *model1 = [[FDanmakuModel alloc]init];
            int i = arc4random() % self.begTimeArr.count;
            int j = arc4random() % self.liveTimeArr.count;
            model1.beginTime = [self.begTimeArr[i] floatValue];
            model1.liveTime = [self.liveTimeArr[j] floatValue];
            model1.content = content;
            model1.color = color;
            [self.danmakuView.modelsArr addObject:model1];
            self.danmuHeaderView.listView.isDown = YES;
            [self.danmuHeaderView.listView requestVoice];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)keyboderDidShow{
    self.sendTime = self.currentSendTime;
    self.inputView.timeL.text = self.danmuHeaderView.playeBoKeView.minTimeLabel.text;
}



- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSTimeInterval)currentTime {
    static double time = 0;
    time += 0.1 ;
    return time;
}

//设置弹幕视图
- (UIView *)danmakuViewWithModel:(FDanmakuModel*)model {
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    imageView.image = UIImageNamed(@"Image_wangyiyun");
    UILabel *label = [UILabel new];
    label.text = model.content;
    label.textColor = [UIColor colorWithHexString:model.color?model.color:@"#FFFFFF"];
    [label sizeToFit];
    return label;

}
- (void)danmuViewDidClick:(UIView *)danmuView at:(CGPoint)point {
    DRLog(@"%@ %@",danmuView,NSStringFromCGPoint(point));
}

#pragma mark - 通知方法实现
 
/// 进入后台
- (void)apllicationWillResignActiveNotification:(NSNotification *)n
{
    // *让app接受远程事件控制，及锁屏是控制版会出现播放按钮
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // *后台播放代码
    AVAudioSession*session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 上面代码实现后台播放 几分钟后会停止播放

    [self setupLockScreenMediaInfo];
}
 
// 进入前台通知
- (void) apllicationWillEnterForegroundNotification:(NSNotification *)n {
    // 进前台 设置不接受远程控制
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
 
}

- (void)setupLockScreenControlInfo {
    [self setupLockScreenMediaInfo];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    __weak typeof(self) weakSelf = self;
    appdel.backPlayBlock = ^(BOOL play) {
        DRLog(@"开始播放");
        weakSelf.isPasue = play;
        [weakSelf.bkPlayer pause:self.isPasue];
        [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(self.isPasue?@"Image_bokepause": @"Image_bokeplaying") forState:UIControlStateNormal];
    };
    
    appdel.backnextBlock = ^(BOOL next) {
        DRLog(@"下一曲");
        [weakSelf next];
    };
    appdel.backpreBlock = ^(BOOL pre) {
        DRLog(@"下一曲");
        [weakSelf pre];
    };
    if (appdel.hasYuancheng) {
        return;
    }
    appdel.hasYuancheng = YES;
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // 锁屏播放
    MPRemoteCommand *playCommand = commandCenter.playCommand;
   
    playCommand.enabled = YES;
    [playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if (appdel.backPlayBlock) {
            appdel.backPlayBlock(NO);
        }

        return MPRemoteCommandHandlerStatusSuccess;
    }];
 
    // 播放和暂停按钮
    MPRemoteCommand *playPauseCommand = commandCenter.togglePlayPauseCommand;
    playPauseCommand.enabled = YES;
    [playPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if (appdel.backPlayBlock) {
            appdel.backPlayBlock(YES);
        }

        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 上一曲
    MPRemoteCommand *previousCommand = commandCenter.previousTrackCommand;
    [previousCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if (appdel.backpreBlock) {
            appdel.backpreBlock(YES);
        }
 
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 下一曲
    MPRemoteCommand *nextCommand = commandCenter.nextTrackCommand;
 
    nextCommand.enabled = YES;
    [nextCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if (appdel.backnextBlock) {
            appdel.backnextBlock(YES);
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
}

- (void)pre{
    NSInteger preNum = 0;
    for (int i = 0; i < self.listView.dataArr.count; i++) {
        NoticeDanMuModel *model = self.listView.dataArr[i];
        if ([model.podcast_no isEqualToString:self.bokeModel.podcast_no]) {
            preNum = i - 1;//上一曲
            break;
        }
    }
    if (preNum >= 0) {//有上一曲
     
        self.isNextOrPre = YES;
        self.bokeModel = self.listView.dataArr[preNum];
        [self refreshBokeUI];
        [self.bkPlayer startPlayWithUrl:self.bokeModel.audio_url isLocalFile:NO];
     //   [self refreDanmuText];
        [self setupLockScreenMediaInfo];
        self.listView.choiceModel = self.bokeModel;
    }
    
}

- (void)next{
    NSInteger nextNum = 0;
    for (int i = 0; i < self.listView.dataArr.count; i++) {
        NoticeDanMuModel *model = self.listView.dataArr[i];
        if ([model.podcast_no isEqualToString:self.bokeModel.podcast_no]) {
            nextNum = i + 1;//下一曲
            break;
        }
    }
    if (nextNum < self.listView.dataArr.count) {//有下一曲
    
        self.isNextOrPre = YES;
        self.bokeModel = self.listView.dataArr[nextNum];
        [self refreshBokeUI];
        [self.bkPlayer startPlayWithUrl:self.bokeModel.audio_url isLocalFile:NO];
        [self setupLockScreenMediaInfo];
      //  [self refreDanmuText];
        self.listView.choiceModel = self.bokeModel;
    }
}

- (void)refreDanmuText{
    [self.danmakuView.modelsArr removeAllObjects];
    self.getTime = 0;
    [self requestDanMuWithTime:self.getTime];
}

//更新通知中心控制台媒体信息
- (void)setupLockScreenMediaInfo {
    
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *playingInfo = [NSMutableDictionary new];
    //标题
    playingInfo[MPMediaItemPropertyTitle] = self.bokeModel.podcast_title;
    
    playingInfo[MPMediaItemPropertyArtist] = self.bokeModel.podcast_intro;

    //封面图片
    UIImageView *coverImageView = [[UIImageView alloc] init];
    
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:self.bokeModel.cover_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(100, 100) requestHandler:^UIImage * _Nonnull(CGSize size) {
                return image;
            }];
            playingInfo[MPMediaItemPropertyArtwork] = artwork;
            [playingCenter setNowPlayingInfo:playingInfo];
        });
    }];
    
    UIImage *image = coverImageView.image;
    if (image) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(100, 100) requestHandler:^UIImage * _Nonnull(CGSize size) {
            return image;
        }];
        playingInfo[MPMediaItemPropertyArtwork] = artwork;
    }


    [playingCenter setNowPlayingInfo:playingInfo];
}


- (void)dealloc{
    // 后台通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
@end
