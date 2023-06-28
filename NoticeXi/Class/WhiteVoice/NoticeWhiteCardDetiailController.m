//
//  NoticeWhiteCardDetiailController.m
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeWhiteCardDetiailController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "JWProgressView.h"
#import "ZFSDateFormatUtil.h"
@interface NoticeWhiteCardDetiailController ()
@property (nonatomic, assign) BOOL contuine;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isStop;
@property (nonatomic, assign) BOOL needAnamitong;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIImageView *titleCardImageView;
@property (nonatomic, strong) UIImageView *fgImageView;
@property (nonatomic, strong) UIImageView *textImageView;
@property (nonatomic, assign) CGFloat time;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger allTime;
@property (nonatomic, assign) NSInteger secondTime;
@property (nonatomic, assign) NSInteger roadNumTime;//转的圈数
@property (nonatomic, assign) NSInteger time1;
@property (nonatomic, assign) NSInteger time2;
@property (nonatomic, strong) UIImageView *zzView;
@property (nonatomic, strong) UIView *zzButtonView;
@property (nonatomic, strong) JWProgressView *progressView;
@property (nonatomic, assign) CGFloat provalue;
@property (nonatomic, assign) CGFloat addprovalue;
@property (nonatomic, strong) UIView *zZRoadView;
@property (nonatomic, strong) UIButton *begInButton;
@property (nonatomic, strong) UIImageView *qqView;
@property (nonatomic, strong) UIImageView *breathView;
@property (nonatomic, strong) UIView *breathButtonView;
@property (nonatomic, strong) YYAnimatedImageView *centerV;
@property (nonatomic, strong) UIView *choiceView;
@property (nonatomic, assign) BOOL showType;
@property (nonatomic, assign) BOOL stopAn;
@property (nonatomic, assign) BOOL isBeginZz;
@property (nonatomic, strong) UIButton *typeBtn1;
@property (nonatomic, strong) UIButton *typeBtn2;
@property (nonatomic, strong) UIButton *typeBtn3;
@property (nonatomic, assign) BOOL isNosetBackBtn;
@property (nonatomic, assign) NSInteger type;//0正常模式，1专注模式，2呼吸模式

@property (nonatomic, strong) UILabel *xhTimeL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *statusL;
@property (nonatomic, strong) UILabel *topTiL;
@property (nonatomic, assign) NSInteger choiceTime;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) UIButton *stopAnBtn;
@property (nonatomic, strong) UIButton *statAnBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *choiceBtn;
@property (nonatomic, strong) UIView *inputBtn;
@property (nonatomic, strong) UILabel *namesL;
@property (nonatomic, strong) UILabel *titL;
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIImageView *zhuziImage;
@property (nonatomic, strong) UIImageView *yeziImage;
@property (nonatomic, strong) UIImageView *renImageView;
@property (nonatomic, strong) UILabel *showTimeL;
@property (nonatomic, strong) UIView *yyView;
@end

@implementation NoticeWhiteCardDetiailController
{
    CABasicAnimation* rotationAnimation;
}

 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.showType = NO;
    
    [self choicerealx];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    self.backBtn = backBtn;
    
    [self setupLockScreenControlInfo];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isReplay = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}


//放松模式
- (void)choicerealx{
    UIImageView *cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH/270)*354)];
    cardImageView.userInteractionEnabled = YES;
    [self.view addSubview:cardImageView];
    self.titleCardImageView = cardImageView;
    
    UIView *fgView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(cardImageView.frame)-cardImageView.frame.size.height/9, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-cardImageView.frame.size.height+cardImageView.frame.size.height/9)];
    fgView.backgroundColor = self.whiteModel.backColor?[UIColor colorWithHexString:self.whiteModel.backColor]: [UIColor blackColor];
    [self.view addSubview:fgView];
    self.coverView = fgView;
    
    CGFloat textHeight = GET_STRHEIGHT(self.whiteModel.card_intro, 16, DR_SCREEN_WIDTH-80);
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(40,ISIPHONEXORLATER? (30+50+10):(50), DR_SCREEN_WIDTH-80, textHeight)];
    titleL.numberOfLines = 0;
    titleL.font = SIXTEENTEXTFONTSIZE;
    [fgView addSubview:titleL];
    titleL.text = self.whiteModel.card_intro;
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(40,fgView.frame.size.height-30-20, DR_SCREEN_WIDTH-80,20)];
    nameL.textAlignment = NSTextAlignmentRight;
    nameL.font = SIXTEENTEXTFONTSIZE;
    nameL.textColor = self.whiteModel.textColor?[UIColor colorWithHexString:self.whiteModel.textColor]: [UIColor whiteColor];
    [fgView addSubview:nameL];
    nameL.text = [NSString stringWithFormat:@"— %@",self.whiteModel.card_author];
    titleL.textColor = nameL.textColor;
    
    self.namesL = nameL;
    self.titL = titleL;

    UIImageView *fuhaoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, nameL.frame.origin.y, 20, 20)];
    fuhaoImageView.image = UIImageNamed(@"Image_fuhao");
    [fgView addSubview:fuhaoImageView];
    
    if (self.cardNo) {

    }else{
        [cardImageView sd_setImageWithURL:[NSURL URLWithString:self.whiteModel.card_url] placeholderImage:GETUIImageNamed(@"img_empty")];
    }
    
    self.isPasue = NO;
    self.tableView.hidden = YES;
    self.contuine = YES;
    
    // 后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apllicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
    // 进入前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apllicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-72)/2, ((cardImageView.frame.size.height/9*8)-72)/2, 72, 72)];
    [self.playBtn setImage:UIImageNamed(@"Image_cardplay_b") forState:UIControlStateNormal];
    [self.view addSubview:self.playBtn];
    [self.playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setWhiteModel:(NoticeWhiteVoiceListModel *)whiteModel{
    _whiteModel = whiteModel;

    CGFloat textHeight = GET_STRHEIGHT(self.whiteModel.card_intro, 16, DR_SCREEN_WIDTH-80);
    self.namesL.frame = CGRectMake(40,30, DR_SCREEN_WIDTH-80, textHeight);
    self.namesL.frame = CGRectMake(40,CGRectGetMaxY(self.titL.frame)+10, DR_SCREEN_WIDTH-80,25);
    self.titL.text = self.whiteModel.card_intro;
    self.namesL.text = [NSString stringWithFormat:@"— %@",self.whiteModel.card_author];
    
    self.coverView.backgroundColor = self.whiteModel.backColor?[UIColor colorWithHexString:self.whiteModel.backColor]: [UIColor blackColor];
    self.namesL.textColor = self.whiteModel.textColor?[UIColor colorWithHexString:self.whiteModel.textColor]: [UIColor whiteColor];
    self.titL.textColor = self.namesL.textColor;

}


- (void)playClick{
    if (!self.isPlaying) {
        [self showHUD];
        self.isPasue = NO;
        self.contuine = YES;
        [self.audioPlayer startPlayWithUrl:self.whiteModel.audio_url isLocalFile:NO];
    }else{
        self.isPasue = !self.isPasue;
        if (self.isPasue) {
            [self.playBtn setImage:UIImageNamed(@"Image_cardplay_b") forState:UIControlStateNormal];
        }else{
            [self.playBtn setImage:UIImageNamed(@"Image_whitestop_b") forState:UIControlStateNormal];
        }
        DRLog(@"%d",self.isPasue);
        [self.audioPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf hideHUD];
            [weakSelf showToastWithText:@"音频文件加载失败~"];
        }else{//播放
            weakSelf.isPlaying = YES;
            [weakSelf.playBtn setImage:UIImageNamed(@"Image_whitestop_b") forState:UIControlStateNormal];
            [weakSelf hideHUD];
        }
    };
    self.audioPlayer.playComplete = ^{
        weakSelf.isPlaying = NO;
        [weakSelf.playBtn setImage:UIImageNamed(@"Image_cardplay_b") forState:UIControlStateNormal];
        if (weakSelf.contuine) {
            weakSelf.isPasue = NO;
            [weakSelf.audioPlayer startPlayWithUrl:weakSelf.whiteModel.audio_url isLocalFile:NO];
        }
    };
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noNeedStop = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.needAnamitong = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noNeedStop = NO;
    self.contuine = NO;
    [self.audioPlayer stopPlaying];
    self.needAnamitong = NO;
    self.stopAn = YES;

}

- (void)next{

    if (self.currentItem >= self.dataArr.count-1) {
        self.currentItem = 0;
    }else{
        self.currentItem++;
    }

    self.whiteModel = self.dataArr[self.currentItem];
    [self.titleCardImageView sd_setImageWithURL:[NSURL URLWithString:self.whiteModel.card_url] placeholderImage:GETUIImageNamed(@"img_empty")];
    self.isPasue = NO;
    [self.audioPlayer startPlayWithUrl:self.whiteModel.audio_url isLocalFile:NO];
    [self setupLockScreenMediaInfo];
}

- (void)pre{
    
    if (self.currentItem <= 0) {
        self.currentItem = self.dataArr.count-1;
    }else{
        self.currentItem--;
    }
    
    self.whiteModel = self.dataArr[self.currentItem];
    [self.titleCardImageView sd_setImageWithURL:[NSURL URLWithString:self.whiteModel.card_url] placeholderImage:GETUIImageNamed(@"img_empty")];
    self.isPasue = NO;
    [self.audioPlayer startPlayWithUrl:self.whiteModel.audio_url isLocalFile:NO];
    [self setupLockScreenMediaInfo];
}

- (void)controllerPauseOrPlay{
    
    if (self.isPasue) {
        [self.playBtn setImage:UIImageNamed(@"Image_cardplay_b") forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:UIImageNamed(@"Image_whitestop_b") forState:UIControlStateNormal];
    }

    [self.audioPlayer pause:self.isPasue];
}

- (void)setupLockScreenControlInfo {
    
    [self setupLockScreenMediaInfo];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    __weak typeof(self) weakSelf = self;
    appdel.backPlayBlock = ^(BOOL play) {
        DRLog(@"开始播放");
        weakSelf.isPasue = play;
        [weakSelf controllerPauseOrPlay];
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

//更新通知中心控制台媒体信息
- (void)setupLockScreenMediaInfo {
    
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *playingInfo = [NSMutableDictionary new];
    //标题
    playingInfo[MPMediaItemPropertyTitle] = self.whiteModel.card_title;
    
    playingInfo[MPMediaItemPropertyArtist] = self.whiteModel.card_intro;

    //封面图片
    UIImageView *coverImageView = [[UIImageView alloc] init];
    
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:self.whiteModel.banner_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
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

#pragma mark - 通知方法实现
 
/// 进入后台
- (void)apllicationWillResignActiveNotification:(NSNotification *)n
{
    if (!self.needAnamitong) {
        return;
    }
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
    CGFloat textHeight = GET_STRHEIGHT(self.whiteModel.card_intro, 16, DR_SCREEN_WIDTH-80);
    self.namesL.frame = CGRectMake(40,30, DR_SCREEN_WIDTH-80, textHeight);
    self.namesL.frame = CGRectMake(40,CGRectGetMaxY(self.titL.frame)+10, DR_SCREEN_WIDTH-80,25);
    self.titL.text = self.whiteModel.card_intro;
    self.namesL.text = [NSString stringWithFormat:@"— %@",self.whiteModel.card_author];
    
    self.coverView.backgroundColor = self.whiteModel.backColor?[UIColor colorWithHexString:self.whiteModel.backColor]: [UIColor blackColor];
    self.namesL.textColor = self.whiteModel.textColor?[UIColor colorWithHexString:self.whiteModel.textColor]: [UIColor whiteColor];
    self.titL.textColor = self.namesL.textColor;
}

- (void)dealloc{
    // 后台通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
@end
