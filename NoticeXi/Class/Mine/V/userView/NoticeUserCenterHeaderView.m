//
//  NoticeUserCenterHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/26.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserCenterHeaderView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "UIView+Shadow.h"
#import "NoticeMyOwnMusicListController.h"
#import "NoticeCurentLeaveController.h"
@implementation NoticeUserCenterHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
           
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(20,30, 60, 60)];
        [self addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 32, 56, 56)];
        _iconImageView.layer.cornerRadius = 56/2;
        _iconImageView.layer.masksToBounds = YES;
        [self addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTapBig)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-15, CGRectGetMaxY(_iconImageView.frame)-20,20, 20)];
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
        [self addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        self.lelveImageView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(_iconImageView.frame)-10+2.5, 52, 16)];
        [self addSubview:self.lelveImageView];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(90,33,DR_SCREEN_WIDTH-90, 25)];
        _nickNameL.font = EIGHTEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:_nickNameL];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(_nickNameL.frame)+9, 93, 16)];
        self.numL.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.1];
        self.numL.layer.cornerRadius = 3;
        self.numL.layer.masksToBounds = YES;
        self.numL.textColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.8];
        self.numL.font = [UIFont systemFontOfSize:10];
        self.numL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.numL];
        self.numL.userInteractionEnabled = YES;
        UITapGestureRecognizer *xhTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyXuehao)];
        [self.numL addGestureRecognizer:xhTap];
        
        UIImageView *copyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numL.frame)+4, CGRectGetMaxY(_nickNameL.frame)+7, 20, 20)];
        copyImageView.image = UIImageNamed(@"Image_fuxuehaow");
        [self addSubview:copyImageView];
        copyImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *xhTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyXuehao)];
        [copyImageView addGestureRecognizer:xhTap1];
        
        _introL = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(_numL.frame)+51,DR_SCREEN_WIDTH-20, 17)];
        _introL.font = TWOTEXTFONTSIZE;
        _introL.text = @"还没填写个人简介";
        _introL.textColor = [UIColor colorWithHexString:@"#E1E4F0"];
        [self addSubview:_introL];
        
        UIImageView *waveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-82,45, 72, 28)];
        waveImageView.image = UIImageNamed(@"wave_image");
        waveImageView.userInteractionEnabled = YES;
        [self addSubview:waveImageView];
        
        self.noWaveL = [[UILabel alloc] initWithFrame:CGRectMake(26, 0,33, 28)];
        self.noWaveL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.noWaveL.font = [UIFont systemFontOfSize:10];
        self.noWaveL.textAlignment = NSTextAlignmentRight;
        self.noWaveL.text = [NoticeTools chinese:@"空" english:@"Empty" japan:@"空"];
        [waveImageView addSubview:self.noWaveL];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [waveImageView addGestureRecognizer:tap];

                
        self.dayL = [[UILabel alloc] init];
        self.dayL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.dayL.font = XGFourthBoldFontSize;
        [self addSubview:self.dayL];
        
        self.timeL = [[UILabel alloc] init];
        self.timeL.font = XGFourthBoldFontSize;
        self.timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.timeL];
        
        self.admireL = [[UILabel alloc] init];
        self.admireL.font = XGTwentyBoldFontSize;
        self.admireL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.admireL];
        
        self.playBackView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.introL.frame)+24,DR_SCREEN_WIDTH-40, 52)];
        [self addSubview:self.playBackView];
        self.playBackView.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.1];
        self.playBackView.layer.cornerRadius = 8;
        self.playBackView.layer.masksToBounds = YES;
        self.playBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *playT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playTap)];
        [self.playBackView addGestureRecognizer:playT];
        
        self.addMusicBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (52-24)/2, 91, 24)];
        self.addMusicBtn.layer.cornerRadius = 12;
        self.addMusicBtn.layer.masksToBounds = YES;
        self.addMusicBtn.layer.borderColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6].CGColor;
        self.addMusicBtn.layer.borderWidth = 1;
        [self.playBackView addSubview:self.addMusicBtn];
        [self.addMusicBtn setTitle:[NoticeTools getLocalStrWith:@"gedan.add"] forState:UIControlStateNormal];
        [self.addMusicBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.addMusicBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [self.addMusicBtn addTarget:self action:@selector(addMusicClick) forControlEvents:UIControlEventTouchUpInside];
        self.addMusicBtn.hidden = YES;
        
        UIButton *musicListBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.playBackView.frame.size.width-20-20, 16, 20, 20)];
        [musicListBtn setBackgroundImage:UIImageNamed(@"Image_musiclist") forState:UIControlStateNormal];
        [self.playBackView addSubview:musicListBtn];
        [musicListBtn addTarget:self action:@selector(musicListClick) forControlEvents:UIControlEventTouchUpInside];
        self.musicListButton = musicListBtn;
        
        SPActivityIndicatorView *activityIndicatorView = [[SPActivityIndicatorView alloc] initWithType:SPActivityIndicatorAnimationTypeLineScale tintColor:[UIColor colorWithHexString:@"#E6C14D"]];
        activityIndicatorView.frame = CGRectMake(20,16,20,20);
        activityIndicatorView.left = YES;
        [self.playBackView addSubview:activityIndicatorView];
        activityIndicatorView.userInteractionEnabled = YES;
        self.leftAct = activityIndicatorView;
        self.leftAct.hidden = YES;
        
        self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 16, 20, 20)];
        [self.playBtn setBackgroundImage:UIImageNamed(@"Image_bfzdyyy") forState:UIControlStateNormal];
        [self.playBackView addSubview:self.playBtn];
        [self.playBtn addTarget:self action:@selector(playTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.songNameL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(20+20+3, 0, self.playBackView.frame.size.width-43-20-20, self.playBackView.frame.size.height)];
        self.songNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.songNameL.font = FOURTHTEENTEXTFONTSIZE;
        [self.playBackView addSubview:self.songNameL];
        self.songNameL.hidden = YES;
        

        self.musicArr = [[NSMutableArray alloc] init];
        
    }
    return self;
}


- (void)musicListClick{
    if (!self.musicArr.count) {
        [self addMusicClick];
        return;
    }

    self.isRefresh = YES;
    self.currentModel.status = 0;
    [self.musicPlayer stopPlaying];

    NoticeMyOwnMusicListController *ctl = [[NoticeMyOwnMusicListController alloc] init];
    ctl.userId = self.userM.user_id;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)addMusicClick{
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if (!userM.level.intValue) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.lvsj"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.golv"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }
                NoticeCurentLeaveController *ctl = [[NoticeCurentLeaveController alloc] init];
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    [self.custumeMusicView show];
}

- (NoticeAddCustumeMusicView *)custumeMusicView{
    if (!_custumeMusicView) {
        _custumeMusicView = [[NoticeAddCustumeMusicView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _custumeMusicView.isFromeCenter = YES;
        __weak typeof(self) weakSelf = self;
        _custumeMusicView.addMusicBlock = ^(BOOL add) {//刷新歌单列表
            weakSelf.isRefresh = YES;
            [weakSelf requestMusicList];
        };
    }
    return _custumeMusicView;
}

- (void)stopPlayingNotice{
    self.isRefresh = YES;
    [self.musicPlayer stopPlaying];
}

- (void)requestMusicList{
    NSString *url = @"";
    url = [NSString stringWithFormat:@"myMusic/%@?pageNo=1",self.userId];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {

        if (success) {
            [self.musicArr removeAllObjects];
            
            [self.musicPlayer stopPlaying];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeCustumMusiceModel *model = [NoticeCustumMusiceModel mj_objectWithKeyValues:dic];
                [self.musicArr addObject:model];
            }
            if (self.musicArr.count) {
                int musixTag = arc4random()%self.musicArr.count;
              
                self.currentIndex = musixTag;
                self.addMusicBtn.hidden = YES;
                self.songNameL.hidden = NO;
                self.playBtn.hidden = NO;
                self.songNameL.text = [self.musicArr[musixTag] song_tile];
                self.currentModel = self.musicArr[musixTag];
            }else{
                self.songNameL.hidden = YES;
                self.addMusicBtn.hidden = NO;
                self.playBtn.hidden = YES;
                self.leftAct.hidden = YES;
                if (self.isOther) {
                    self.addMusicBtn.hidden = YES;
                    self.songNameL.hidden = NO;
                    self.songNameL.text = [NoticeTools getLocalStrWith:@"gedan.nolike"];
                    self.playBtn.hidden = NO;
                    [self.playBtn setBackgroundImage:UIImageNamed(@"Image_sgsxingbf") forState:UIControlStateNormal];
                    self.musicListButton.hidden = YES;
                }
            }
            if (!self.isRefresh && self.musicArr.count) {
                [self playTap];
            }
        }
    } fail:^(NSError * _Nullable error) {
 
    }];
}

- (void)playTap{

    if (self.musicArr.count && self.currentModel) {
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.floatView.isPlaying) {
            appdel.floatView.noRePlay = YES;
            [appdel.floatView.audioPlayer stopPlaying];
        }
        
        if (self.currentModel.status < 1) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
            [nav.topViewController showHUD];
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"parsingMusic/%@/1",self.currentModel.songId] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    NoticeCustumMusiceModel *cuM = [NoticeCustumMusiceModel mj_objectWithKeyValues:dict[@"data"]];
                    self.currentModel.song_url = cuM.songUrl;
                    [self.musicPlayer startPlayWithUrl:self.currentModel.song_url isLocalFile:NO];
                    if (self.playMusic) {
                        self.playMusic(YES);
                    }
                }
                [nav.topViewController hideHUD];
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
        }else if (self.currentModel.status == 1){
            [self.leftAct stopAnimating];
            self.leftAct.hidden = YES;
            self.playBtn.hidden = NO;
            self.currentModel.status = 2;
            [self.musicPlayer pause:YES];
        }else if(self.currentModel.status == 2){
            self.currentModel.status = 1;
            [self.leftAct startAnimating];
            self.leftAct.hidden = NO;
            self.playBtn.hidden = YES;
            [self.musicPlayer pause:NO];
            [self.audioPlayer stopPlaying];
            if (self.playMusic) {
                self.playMusic(YES);
            }
        }
    }
}

- (void)rePlay{
    [self.musicArr removeAllObjects];
    [self.musicPlayer stopPlaying];
    [self requestMusicList];
}

- (LGAudioPlayer *)musicPlayer
{
    if (!_musicPlayer) {
        _musicPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;

        _musicPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (status == AVPlayerItemStatusFailed) {
                
            }else{
                weakSelf.currentModel.status = 1;
                [weakSelf.leftAct startAnimating];
                weakSelf.leftAct.hidden = NO;
                weakSelf.playBtn.hidden = YES;
            }
        };
        _musicPlayer.playComplete = ^{
            if (!weakSelf.musicArr.count) {
                return;
            }
            [weakSelf.leftAct stopAnimating];
            weakSelf.leftAct.hidden = YES;
            weakSelf.playBtn.hidden = NO;
            weakSelf.currentModel.status = 0;
            if (!weakSelf.isRefresh) {
                weakSelf.currentIndex++;
                if (weakSelf.currentIndex > weakSelf.musicArr.count-1) {
                    weakSelf.currentIndex = 0;
                }
                weakSelf.currentModel = weakSelf.musicArr[weakSelf.currentIndex];
                weakSelf.currentModel.status = 0;
                weakSelf.songNameL.text =  [NSString stringWithFormat:@"%@  %@",weakSelf.currentModel.song_tile,weakSelf.listName?weakSelf.listName:@""];
           
                [weakSelf playTap];
            }else{
                weakSelf.isRefresh = NO;
            }
        };
    }
    return _musicPlayer;
}


- (void)setUserM:(NoticeUserInfoModel *)userM{
    _userM = userM;
    
    if ([userM.user_id isEqualToString:@"1"] || [userM.user_id isEqualToString:@"684699"]) {
        self.markImage.hidden = NO;
    }
    self.isReplay = YES;

    self.numL.text = [NSString stringWithFormat:@"声昔学号：%@",userM.frequency_no];
    if ([NoticeTools getLocalType]) {
        self.numL.text = [NSString stringWithFormat:@"Vox ID：%@",userM.frequency_no];
    }
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:userM.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    self.nickNameL.text = userM.nick_name;
    self.introL.text = userM.self_intro? userM.self_intro:(self.isOther?[NoticeTools getLocalStrWith:@"minee.henojianjie"]:[NoticeTools getLocalStrWith:@"minee.nojianjie"]);
    if (!self.introL.text.length) {
        self.introL.text = self.isOther?[NoticeTools getLocalStrWith:@"minee.henojianjie"]:[NoticeTools getLocalStrWith:@"minee.nojianjie"];
    }
    
    if (userM.wave_len.intValue) {
        self.noWaveL.text = [NSString stringWithFormat:@"%@s",userM.wave_len];
    }else{
        self.noWaveL.text = [NoticeTools chinese:@"空" english:@"Empty" japan:@"空"];
    }

    
    NSString *time = [NSString stringWithFormat:@"%@%@",userM.comeHereDays,[NoticeTools getLocalStrWith:@"group.day"]];
    NSString *admireTime = [NSString stringWithFormat:@"%@%@",userM.admire_time,[NoticeTools getLocalStrWith:@"moine.likeeat"]];
    
    self.dayL.attributedText = [DDHAttributedMode setSizeAndColorString:time setColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6] setSize:12 setLengthString:[NoticeTools getLocalStrWith:@"group.day"] beginSize:userM.comeHereDays.length];
    self.dayL.frame = CGRectMake(20, CGRectGetMaxY(self.nickNameL.frame)+43, GET_STRWIDTH(time, 16, 20), 20);
    if (userM.isMoreFiveMin) {
        NSString *str = [NSString stringWithFormat:@"%@%@",userM.allVoiceTime,[NoticeTools getLocalStrWith:@"moine.mins"]];
        self.timeL.attributedText = [DDHAttributedMode setSizeAndColorString:str setColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6] setSize:12 setLengthString:[NoticeTools getLocalStrWith:@"moine.mins"] beginSize:userM.allVoiceTime.length];
        self.timeL.frame = CGRectMake(CGRectGetMaxX(self.dayL.frame)+25, self.dayL.frame.origin.y,GET_STRWIDTH(str, 16, 20), 20);
    }else{
        NSString *str = [NSString stringWithFormat:@"%@%@",userM.allVoiceTime,[NoticeTools getLocalStrWith:@"moine.s"]];
        self.timeL.attributedText = [DDHAttributedMode setSizeAndColorString:str setColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6] setSize:12 setLengthString:[NoticeTools getLocalStrWith:@"moine.s"] beginSize:userM.allVoiceTime.length];
        self.timeL.frame = CGRectMake(CGRectGetMaxX(self.dayL.frame)+25, self.dayL.frame.origin.y,GET_STRWIDTH(str, 16, 20), 20);
    }
    
    self.admireL.hidden = userM.admire_time.intValue?NO:YES;
    self.admireL.attributedText = [DDHAttributedMode setSizeAndColorString:admireTime setColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6] setSize:12 setLengthString:[NoticeTools getLocalStrWith:@"moine.likeeat"] beginSize:userM.admire_time.length];
    self.admireL.frame = CGRectMake(CGRectGetMaxX(self.timeL.frame)+25, self.dayL.frame.origin.y, GET_STRWIDTH(admireTime, 16, 20), 20);
    
  
    
    NSString *imgName1 = userM.levelImgName;
    self.lelveImageView.image = UIImageNamed(imgName1);
    
    NSString *imgName = userM.levelImgIconName;
    self.iconMarkView.image = UIImageNamed(imgName);
    
}

- (void)copyXuehao{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:self.userM.frequency_no];
    [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"moine.hascopyxueh"]];
}

- (void)iconTapBig{
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.iconImageView;
    item.largeImageURL     = [NSURL URLWithString:self.userM.avatar_url];

    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    photoView.ischangeIcon = !self.isOther;
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    __weak typeof(self) weakSelf = self;
    photoView.changeIcon = ^(BOOL changeIcon) {
        if (weakSelf.changeIcon) {
            weakSelf.changeIcon(YES);
        }
    };
    [photoView presentFromImageView:self.iconImageView toContainer:toView animated:YES completion:nil];
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        
        
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

- (void)playNoReplay{

    self.isRefresh = YES;
    [self.musicPlayer stopPlaying];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:self.userM.wave_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
        
    }else{
        self.isPasue = !self.isPasue;
        self.userM.isPlaying = !self.isPasue;
        [self.audioPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
            weakSelf.isReplay = YES;
            DRLog(@"播放失败");
        }
    };
    
    self.audioPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        weakSelf.userM.isPlaying = NO;
        weakSelf.userM.nowPro = 0;
        weakSelf.noWaveL.text = [NSString stringWithFormat:@"%@s",weakSelf.userM.wave_len];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {

        if ([[NSString stringWithFormat:@"%.f",currentTime] integerValue] >= weakSelf.userM.wave_len.integerValue) {
            currentTime = weakSelf.userM.wave_len.integerValue;
        }
        weakSelf.noWaveL.text = [NSString stringWithFormat:@"%.fs",weakSelf.userM.wave_len.integerValue-currentTime];

    };
}

@end
