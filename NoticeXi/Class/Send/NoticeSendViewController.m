//
//  NoticeSendViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendViewController.h"
#import "NoticeChoicePhotoCell.h"
#import "NoticeUpdateImage.h"
#import "RTDragCellTableView.h"
#import "DDHAttributedMode.h"
#import "NoticeTopicViewController.h"
#import "NoticeVoiceListModel.h"
#import "UIImage+Color.h"
#import <SDWebImage/UIImage+GIF.h>
#import <Photos/Photos.h>
#import "AppDelegate.h"
#import "NoticeTabbarController.h"
#import "NoticeSaveVoiceTools.h"
#import "NoticeCaoGaoController.h"
#import "NoticeWhiteVoiceListModel.h"
#import "NoticeSysMeassageTostView.h"
#import "NoticeAudioJoinToAudioModel.h"
#import "NoticeVoiceImageView.h"
#import "NoticeSendStatusView.h"
#import "NoticeTextTopicView.h"
#import "JWProgressView.h"
#import "NoticeGetPhotosFromLibary.h"
#import "NoticeKeyBordTopView.h"
#import "NoticeAudioJoinToAudioModel.h"
#import "NoticeActShowView.h"
#import "NoticeChoiceBgmTypeView.h"
#import "NoticeAudioJoinToAudioModel.h"
#import "NoticeBgmHasChoiceShowView.h"
#define Locapaths  @"locapath"
#define ImageDatas  @"ImageDatas"
@interface NoticeSendViewController ()<TZImagePickerControllerDelegate,NoticePlayerNumbersDelegate>
@property (nonatomic, strong) NoticeKeyBordTopView *toolsView;
@property (nonatomic, strong) UIButton *reButton;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, assign) BOOL hasChangeSave;
@property (nonatomic, strong) NSMutableArray *phassetArr;
@property (nonatomic, strong) NSString *imageJsonString;
@property (nonatomic, assign) BOOL isHasTostsave;
@property (nonatomic, assign) BOOL isOnlySelf;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, assign) NSInteger timePercent;
@property (nonatomic, assign) NSInteger timeOutNum;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) BOOL isHasTostProgross;
@property (nonatomic, assign) NSInteger needClickSendTag;//新手任务语音点击发布前i提示
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) JWProgressView *progressView;
@property (nonatomic, assign) CGFloat provalue;
@property (nonatomic, strong) NSTimer *retimer;
@property (nonatomic, assign) CGFloat draFlot;
@property (nonatomic, strong) NSString *bucket_id;
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *videoUpStr;
@property (nonatomic, strong) UIImage *videoCoverImage;

@property (nonatomic, strong) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIScrollView *backView;
@property (nonatomic, strong) NoticeVoiceImageView *imageViewS;
@property (nonatomic, strong) NoticeTextTopicView *topicView;
@property (nonatomic, strong) NoticeSendStatusView *statusView;
@property (nonatomic, strong) NoticeActShowView *showView;
@property (nonatomic, strong) NoticeChoiceBgmTypeView *bgmView;
@property (nonatomic, strong) NoticeBgmHasChoiceShowView *bgmChoiceView;
@property (nonatomic, strong) NSString *bgmId;
@property (nonatomic, assign) NSInteger bgmType;
@property (nonatomic, strong) NSString *bgmName;
@property (nonatomic, strong) NoticeAudioJoinToAudioModel *audioToAudio;

@property (nonatomic, strong) UIImageView *clickRecoImageView;
@property (nonatomic, strong) UIImageView *clickFinishImageView;
@property (nonatomic, assign) BOOL hasChangeImg;
@property (nonatomic, assign) NSInteger oldImgNum;
@end

@implementation NoticeSendViewController
{
    UIView *_proview;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self timerinvalidate];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    appdel.floatView.noRePlay = YES;
    [appdel.audioPlayer stopPlaying];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSEASSEST" object:nil];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];//设置导航条颜色
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = nil;
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#25262E"],NSFontAttributeName:XGTwentyBoldFontSize}];
        UINavigationBar *navgationBar = self.navigationController.navigationBar;
        navgationBar.standardAppearance = appperance;
        navgationBar.scrollEdgeAppearance = appperance;
        //不透明
        self.navigationController.navigationBar.translucent = NO;
        
    }else{
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];//设置阴影图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = NO;
    }
    
    if (self.isLead) {//如果是新手指南，以下都不执行
        appdel.noPop = YES;
        self.clickRecoImageView.hidden = NO;
        
        self.clickRecoImageView.frame = CGRectMake(self.playerView.frame.origin.x+20, CGRectGetMaxY(self.backView.frame)+30, 290, 82);
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.clickRecoImageView.frame = CGRectMake(self.playerView.frame.origin.x+20, CGRectGetMaxY(self.backView.frame)-10, 290, 82);
        } completion:^(BOOL finished) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"106" ofType:@"m4a"];
            [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            self.clickFinishImageView.hidden = NO;
            self.clickFinishImageView.frame = CGRectMake((DR_SCREEN_WIDTH - 262)/2, self.sendBtn.frame.origin.y-113-30, 262, 113);
            [UIView animateWithDuration: 1 delay:1 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
                self.clickFinishImageView.frame = CGRectMake((DR_SCREEN_WIDTH - 262)/2, self.sendBtn.frame.origin.y-113, 262, 113);
            } completion:nil];
        }];
    }else{
        appdel.noPop = NO;
    }
}

- (UIImageView *)clickRecoImageView{
    if (!_clickRecoImageView) {
        _clickRecoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.playerView.frame.origin.x+20, CGRectGetMaxY(self.backView.frame), 290, 82)];
        _clickRecoImageView.image = UIImageNamed(@"Image_shiring");
        [self.view addSubview:_clickRecoImageView];
        _clickRecoImageView.hidden = YES;
    }
    return _clickRecoImageView;
}

- (UIImageView *)clickFinishImageView{
    if (!_clickFinishImageView) {
        _clickFinishImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH - 262)/2, self.sendBtn.frame.origin.y-113, 262, 113)];
        _clickFinishImageView.image = UIImageNamed(@"Image_leadwanc");
        [self.view addSubview:_clickFinishImageView];
        _clickFinishImageView.hidden = YES;
    }
    return _clickFinishImageView;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLongTime = YES;
    self.timeOutNum = 0;
    [self setNav];
 
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    
    if (!self.moveArr.count) {
        self.moveArr = [NSMutableArray new];
    }
    
    self.backView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+10, DR_SCREEN_WIDTH-40, 70)];
    self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.masksToBounds = YES;
    [self.view addSubview:self.backView];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];

    self.playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(15,15,145, 40)];
    self.playerView.delegate = self;
    UIView *dragView = [[UIView alloc] initWithFrame:CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height)];
    dragView.userInteractionEnabled = YES;
    dragView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
    [self.playerView addSubview:dragView];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    longPress.minimumPressDuration = 0.17;
    [dragView addGestureRecognizer:longPress];
    
    self.toolsView = [[NoticeKeyBordTopView alloc] initWithFrame:CGRectMake(0,self.sendBtn.frame.origin.y-45-8-17-5, DR_SCREEN_WIDTH, 45)];
    [self.view addSubview:self.toolsView];
    [self.toolsView.topicBtn addTarget:self action:@selector(insertClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.photoBtn addTarget:self action:@selector(openPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.shareButton addTarget:self action:@selector(typeVClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.statusBtn addTarget:self action:@selector(bgmClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.statusBtn setBackgroundImage:UIImageNamed((self.isEditVoice || self.isSave)?@"ly_bgmn": @"ly_bgm") forState:UIControlStateNormal];
    for (int i = 0; i < 3; i++) {
        UILabel *btnL = [[UILabel alloc] initWithFrame:CGRectMake(10+60*i, CGRectGetMaxY(self.toolsView.frame)+8, 60, 17)];
        btnL.font = TWOTEXTFONTSIZE;
        btnL.textAlignment = NSTextAlignmentCenter;
        btnL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.view addSubview:btnL];
        if (i==0) {
            btnL.text = [NoticeTools getLocalStrWith:@"group.imgs"];
        }else if (i == 1){
            btnL.text = [NoticeTools getLocalStrWith:@"search.topic"];
           
        }else if (i == 2){
            if (self.isEditVoice) {
                btnL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
            }
            btnL.text = @"BGM";
        }
    }
        
    self.reButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playerView.frame)+5,self.playerView.frame.origin.y,40, 40)];
    [self.reButton setImage:UIImageNamed(@"ly_rechonlu") forState:UIControlStateNormal];
   
    [self.reButton addTarget:self action:@selector(recodClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.reButton];
    

    [self.backView addSubview:self.playerView];
    
    if (self.isSave) {
        [self sendSaveData];
    }
    
    
    if (self.isEditVoice) {//如果是编辑心情
        self.topicName = self.voiceM.topic_name;
        self.topicId = self.voiceM.topic_id;
        if (self.voiceM.voiceIdentity.intValue) {
            [self setOpen:self.voiceM.voiceIdentity.intValue];
        }
        [self.reButton removeFromSuperview];

        [_sendBtn setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1] forState:UIControlStateNormal];
        self.playerView.isLocal = NO;
        self.playerView.timeLen = self.voiceM.voice_len;
        self.playerView.voiceUrl = self.voiceM.voice_url;
        if (self.voiceM.voiceIdentity.intValue) {
            self.status = self.voiceM.voiceIdentity.intValue;
        }
        self.oldImgNum = self.voiceM.img_list.count;
        if (self.voiceM.img_list.count) {
            for (int i = 0; i < self.voiceM.img_list.count; i++) {
                [self showHUD];
                
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.voiceM.img_list[i]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (image) {
                        NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
                        NSMutableDictionary *imagerDic = [NSMutableDictionary new];
                        [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
                        UIImage *ciImage = image;
                        [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
                        [self.moveArr addObject:imagerDic];
                        self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
                        self.imageViewS.hidden = NO;
                        [self refreshUI];
                    }
                    [self hideHUD];
                }];
            }
        }
    }else{
        if (self.topicM || self.moveArr || self.status > 0) {
            if (self.topicM) {
                self.topicView.hidden = NO;
                self.topicView.topicM = self.topicM;
            }
            if (self.moveArr.count) {
                self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
                self.imageViewS.hidden = NO;
            }
            [self setOpen:self.status];
            [self refreshUI];
        }else{
            self.status = 1;
        }
    }
    
    [self setTopicWith];

    if (self.locaPath) {
        [self recoderSureWithPath:self.locaPath time:self.timeLen musiceId:self.musicId];
    }
}

- (void)sendSaveData{
    self.topicName = self.saveModel.topName;
    self.topicId = self.saveModel.topicId;
    if (self.saveModel.voiceIdentity.intValue) {
        [self setOpen:self.saveModel.voiceIdentity.intValue];
    }
    [self.reButton removeFromSuperview];
    self.locaPath = self.saveModel.voiceFilePath;
    self.timeLen = self.saveModel.voiceTimeLen;
    [_sendBtn setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1] forState:UIControlStateNormal];
    [self recoderSureWithPath:self.locaPath time:self.timeLen musiceId:self.musicId];
    if (self.saveModel.voiceIdentity.intValue) {
        self.status = self.saveModel.voiceIdentity.intValue;
    }
    
    self.moveArr = [[NSMutableArray alloc] init];
    if (self.saveModel.img1Path || self.saveModel.img2Path || self.saveModel.img3Path) {
        [self showHUD];
        
        if (self.saveModel.img1Path) {
            [self getsaveimg1];
        }
    }else{
        [self refreshUI];
    }
}

- (void)getsaveimg1{
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [imgView sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",self.saveModel.img1Path]]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
            NSMutableDictionary *imagerDic = [NSMutableDictionary new];
            [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
            UIImage *ciImage = image;
            [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
            [self.moveArr addObject:imagerDic];
            if (self.saveModel.img2Path) {
                [self getsaveimg2];
            }else{
                self.imageViewS.imgArr = self.moveArr;
                self.imageViewS.hidden = NO;
                self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
                self.imageViewS.hidden = NO;
                [self refreshUI];
                [self hideHUD];
            }
        }else{
            [self hideHUD];
        }
    }];
}

- (void)getsaveimg2{
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    [imgView sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",self.saveModel.img2Path]]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
            NSMutableDictionary *imagerDic = [NSMutableDictionary new];
            [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
            UIImage *ciImage = image;
            [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
            [self.moveArr addObject:imagerDic];
            if (self.saveModel.img3Path) {
                [self getsaveimg3];
            }else{
                self.imageViewS.imgArr = self.moveArr;
                self.imageViewS.hidden = NO;
                self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
                [self refreshUI];
                [self hideHUD];
            }
        }else{
            [self hideHUD];
        }
    }];
}

- (void)getsaveimg3{
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    [imgView sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",self.saveModel.img3Path]]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
            NSMutableDictionary *imagerDic = [NSMutableDictionary new];
            [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
            UIImage *ciImage = image;
            [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
            [self.moveArr addObject:imagerDic];
            self.imageViewS.imgArr = self.moveArr;
            self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
            self.imageViewS.hidden = NO;
            [self refreshUI];
            [self hideHUD];
        }else{
            [self hideHUD];
        }
    }];
}

//设置bgm
- (void)bgmClick{
    if (self.isEditVoice || self.isSave) {
        return;
    }
    AppDelegate *apple = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [apple.audioPlayer stopPlaying];
    self.bgmView.currentStatus = 0;
    [self.bgmView show];
}

- (NoticeChoiceBgmTypeView *)bgmView{
    if (!_bgmView) {
        _bgmView = [[NoticeChoiceBgmTypeView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _bgmView.useMusicBlock = ^(NSString * _Nonnull url, NSString * _Nonnull bgmId, NSInteger bgmType, NSString * _Nonnull bgmName) {
            weakSelf.bgmType = bgmType;
            weakSelf.bgmChoiceView.title = bgmName;
            weakSelf.bgmChoiceView.hidden = NO;
            [weakSelf refreshUI];
            weakSelf.bgmId = bgmId;
            weakSelf.bgmChoiceView.frame = CGRectMake(0, (weakSelf.topicView.hidden?CGRectGetMaxY(weakSelf.playerView.frame):CGRectGetMaxY(weakSelf.topicView.frame))+10, DR_SCREEN_WIDTH-40, 20);
            [weakSelf.showView show];
            [weakSelf.audioToAudio recoderAudioPath:weakSelf.resourcePath bgmPath:url isTuijian:NO];
        };
    }
    return _bgmView;
}

- (NoticeAudioJoinToAudioModel *)audioToAudio{
    if (!_audioToAudio) {
        _audioToAudio = [[NoticeAudioJoinToAudioModel alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioToAudio.audioBlock = ^(NSString * _Nonnull currentAudioPath, NSInteger reuslt) {
            if (reuslt == 0) {
                weakSelf.locaPath = currentAudioPath;
                weakSelf.playerView.voiceUrl = currentAudioPath;
            }else{
                [weakSelf showToastWithText:@"音频合成失败"];
            }
            [weakSelf.showView disMiss];
        };
    }
    return _audioToAudio;
}

//公开程度
- (void)typeVClick{
    __weak typeof(self) weakSelf = self;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        [weakSelf setOpen:buttonIndex];
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"n.open"],[NoticeTools getLocalType]? [NoticeTools getLocalStrWith:@"n.tpkjian"]:@"同频(互相欣赏)可见",[NoticeTools getLocalStrWith:@"n.onlyself"]]];

    [sheet show];
}

- (void)setOpen:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.toolsView.shareButton.frame = CGRectMake(DR_SCREEN_WIDTH-20-66,10, 66, 25);
        [self.toolsView.shareButton setTitle:[NoticeTools getLocalStrWith:@"n.open"] forState:UIControlStateNormal];
        self.status = 1;
    }else if (buttonIndex == 2){
        self.toolsView.shareButton.frame = CGRectMake(DR_SCREEN_WIDTH-20-90,10, 90, 25);
        [self.toolsView.shareButton setTitle:[NoticeTools getLocalStrWith:@"n.tpkjian"] forState:UIControlStateNormal];
        self.status = 2;
    }else if (buttonIndex == 3){
        self.toolsView.shareButton.frame = CGRectMake(DR_SCREEN_WIDTH-20-102,10, 102, 25);
        [self.toolsView.shareButton setTitle:[NoticeTools getLocalStrWith:@"n.onlyself"] forState:UIControlStateNormal];
        self.status = 3;
    }
}

- (void)closeTopicClick{
    self.topicM = nil;
    self.topicView.hidden = YES;
    [self refreshUI];
    self.hasChangeSave = YES;
}

//插入话题
- (void)insertClick{

    NoticeTopicViewController *ctl = [[NoticeTopicViewController alloc] init];
    ctl.isJustTopic = YES;
     __weak typeof(self) weakSelf = self;
    ctl.topicBlock = ^(NoticeTopicModel * _Nonnull topic) {
        weakSelf.isActivity = NO;
        weakSelf.hasChangeSave = YES;
        if (!topic.topic_id) {
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:topic.topic_name forKey:@"topicName"];
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topics" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    NSString *topicId = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                    topic.topic_id = topicId;
                    weakSelf.topicM = topic;
                    weakSelf.topicView.hidden = NO;
                    weakSelf.topicView.topicM = weakSelf.topicM;
                    [weakSelf refreshUI];
                }
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
            return ;
        }
        weakSelf.topicM = topic;
        weakSelf.topicView.hidden = NO;
        weakSelf.topicView.topicM = weakSelf.topicM;
        [weakSelf refreshUI];

    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NoticeVoiceImageView *)imageViewS{
    if (!_imageViewS) {
        _imageViewS = [[NoticeVoiceImageView alloc] initWithFrame:CGRectMake(15, 15, self.backView.frame.size.width-30, self.backView.frame.size.width-30)];
        _imageViewS.isLocaImage = YES;
        _imageViewS.layer.cornerRadius = 10;
        _imageViewS.layer.masksToBounds = YES;
        [self.backView addSubview:_imageViewS];
        _imageViewS.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _imageViewS.imgBlock = ^(NSInteger tag) {
            weakSelf.hasChangeSave = YES;
            if (tag <= weakSelf.moveArr.count-1) {
                [weakSelf.moveArr removeObjectAtIndex:tag];
                if (weakSelf.moveArr.count) {
                    weakSelf.imageViewS.imgArr = [NSArray arrayWithArray:weakSelf.moveArr];
                }else{
                    weakSelf.imageViewS.hidden = YES;
                    [weakSelf refreshUI];
                }
                [weakSelf.toolsView.photoBtn setBackgroundImage:UIImageNamed(weakSelf.moveArr.count==3? @"Image_textchoiceimgn":@"Image_textchoiceimg") forState:UIControlStateNormal];
            }
            
        };
    }
    return _imageViewS;
}

- (NoticeTextTopicView *)topicView{
    if (!_topicView) {
        _topicView = [[NoticeTextTopicView alloc] initWithFrame:CGRectMake(0,(CGRectGetMaxY(self.playerView.frame)+10), DR_SCREEN_WIDTH-40, 20)];
        [self.backView addSubview:_topicView];
        _topicView.hidden = YES;
        [_topicView.closeBtn addTarget:self action:@selector(closeTopicClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topicView;
}

- (NoticeBgmHasChoiceShowView *)bgmChoiceView{
    if (!_bgmChoiceView) {
        _bgmChoiceView = [[NoticeBgmHasChoiceShowView alloc] initWithFrame:CGRectMake(0, (self.topicView.hidden?CGRectGetMaxY(self.playerView.frame):CGRectGetMaxY(self.topicView.frame))+10, DR_SCREEN_WIDTH-40, 20)];
        [self.backView addSubview:_bgmChoiceView];
        _bgmChoiceView.isReedit = self.isEditVoice;
        _bgmChoiceView.hidden = YES;
        [_bgmChoiceView.closeBtn addTarget:self action:@selector(closeBgmClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgmChoiceView;
}


- (void)closeBgmClick{
    self.locaPath = self.resourcePath;
    self.playerView.voiceUrl = self.locaPath;
    self.bgmId = nil;
    self.bgmName = nil;
    self.bgmChoiceView.hidden = YES;
    [self refreshUI];
}

//刷新UI位置
- (void)refreshUI{

    self.backView.frame = CGRectMake(20, NAVIGATION_BAR_HEIGHT+10, DR_SCREEN_WIDTH-40, 70 +(self.imageViewS.hidden?0:(DR_SCREEN_WIDTH-70+15)) + (self.topicView.hidden?0:30)+ (self.bgmChoiceView.hidden?0:30));
    
    if (self.backView.frame.size.height > (self.toolsView.frame.origin.y-10-15-NAVIGATION_BAR_HEIGHT)) {
        self.backView.frame = CGRectMake(20, NAVIGATION_BAR_HEIGHT+10, DR_SCREEN_WIDTH-40,self.toolsView.frame.origin.y-10-15-NAVIGATION_BAR_HEIGHT);
        self.backView.contentSize = CGSizeMake(0, 70 +(self.imageViewS.hidden?0:DR_SCREEN_WIDTH-70+15) + (self.topicView.hidden?0:30));
    }
    
    self.playerView.frame = CGRectMake(15,15 + (self.imageViewS.hidden?0:CGRectGetMaxY(self.imageViewS.frame)),145, 40);
    self.reButton.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame)+5,self.playerView.frame.origin.y,70, 40);
    self.topicView.frame = CGRectMake(0,(CGRectGetMaxY(self.playerView.frame)+10), DR_SCREEN_WIDTH-40, 20);
    self.bgmChoiceView.frame = CGRectMake(0, (self.topicView.hidden?CGRectGetMaxY(self.playerView.frame):CGRectGetMaxY(self.topicView.frame))+10, DR_SCREEN_WIDTH-40, 20);
    [self.toolsView.photoBtn setBackgroundImage:UIImageNamed(self.moveArr.count==3? @"Image_textchoiceimgn":@"Image_textchoiceimg") forState:UIControlStateNormal];
}

- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength musiceId:(nonnull NSString *)musicId{
    self.locaPath = locaPath;
    self.timeLen = timeLength;
    self.playerView.isLocal = YES;
    self.playerView.timeLen = timeLength;
    self.playerView.voiceUrl = locaPath;
    self.musicId = musicId;
    [_sendBtn setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1] forState:UIControlStateNormal];
    _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];

}


- (void)setTopicWith{
    if (self.topicName) {
        NoticeTopicModel *topic = [[NoticeTopicModel alloc] init];
        topic.topic_name = self.topicName;
        topic.topic_id = self.topicId;
        self.topicM = topic;

        if (!self.topicId.intValue) {
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:topic.topic_name forKey:@"topicName"];
            [self showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topics" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    NSString *topicId = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                    self.topicM.topic_id = topicId;
                    self.topicView.hidden = NO;
                    self.topicView.topicM = self.topicM;
                    [self refreshUI];
                }
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
        }else{
            self.topicView.hidden = NO;
            self.topicView.topicM = self.topicM;
            [self refreshUI];
        }
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    self.hasChangeImg = YES;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    dispatch_queue_t queue = dispatch_queue_create("com.itheima.queue", DISPATCH_QUEUE_SERIAL);
    for (PHAsset *asset in assets) {
        dispatch_sync(queue, ^{
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                if (!imageData) {
                    [self showToastWithText:@"图片选择失败"];
                    return ;
                }
                self.hasChangeSave = YES;
                NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
                NSMutableDictionary *imagerDic = [NSMutableDictionary new];
                if ([[TZImageManager manager] getAssetType:asset] == TZAssetModelMediaTypePhotoGif) {//如果是gif图片
                    [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
                    [imagerDic setObject:imageData forKey:ImageDatas];
                    [imagerDic setObject:@"1" forKey:@"type"];
                    self.isVideo = NO;
                }
                else{
                    [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
                    UIImage *ciImage = [UIImage imageWithData:imageData];
                    [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
                    [imagerDic setObject:@"0" forKey:@"type"];
                    self.isVideo = NO;
                }
                [self.moveArr addObject:imagerDic];
                
                self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
                self.imageViewS.hidden = NO;
                [self refreshUI];
            }];
        });
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset{
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset success:^(NSString *outputPath) {
        self.isVideo = YES;
        self.videoPath = outputPath;
        self.videoCoverImage = coverImage;
    } failure:^(NSString *errorMessage, NSError *error) {
        
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset{
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (!imageData) {
            [self showToastWithText:@"图片选择失败"];
            return ;
        }
        self.hasChangeImg = YES;
        NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
        NSMutableDictionary *imagerDic = [NSMutableDictionary new];
        [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
        [imagerDic setObject:imageData forKey:ImageDatas];
        [imagerDic setObject:@"1" forKey:@"type"];
        self.isVideo = NO;
        self.hasChangeSave = YES;
        [self.moveArr addObject:imagerDic];
        self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
        self.imageViewS.hidden = NO;
        [self refreshUI];
    }];
}

#pragma Action

- (void)recodClick{
    if (self.reEditVoiceBlock) {
        self.reEditVoiceBlock(self.topicM, self.moveArr,self.status);
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)changeProgressValue{
    self.provalue += 0.02;
    if (self.provalue >1.02) {
        self.provalue = 0;
    }
    self.progressView.progressValue = self.provalue;
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioPlayer.playComplete = ^{
            if (weakSelf.isLead && weakSelf.needClickSendTag < 1) {
                weakSelf.needClickSendTag = 1;
                return;
            }
        };
    }
    return _audioPlayer;
}

- (void)sendClick{
    if (self.isLead) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":@"101"}];
        return;
    }
    if (self.isEditVoice) {
        if (self.moveArr.count) {
            [self updateImage];
            return;
        }
        [self editVoiceSure];
        return;
    }
    if (!self.timeLen.integerValue) {
        return;
    }
    
    if (self.locaPath && self.locaPath.length > 5) {
        if (self.moveArr.count && !self.isVideo) {//判断是否有图片并且非视频
            [self updateImage];
        }else if (self.isVideo){
            [self upVideo];
        }
        else{
            [self updateVoice];
        }
    }
}

- (void)upVideo{
    [self showHUD];
    self.timePercent = 0;
    self.timeOutNum = 0;
    self.isHasTostProgross = NO;
    self.isHasTostsave = NO;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    _sendBtn.enabled = NO;
    NSString *pathMd5 =[NSString stringWithFormat:@"%@%@.mp4",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,self.videoPath]]];
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"5" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];
    DRLog(@"视频地址%@  md5:%@",self.videoPath,pathMd5);
    _sendBtn.enabled = NO;
    
    [[XGUploadDateManager sharedManager] uploadNoToastVoiceWithVoicePath:self.videoPath parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            
            if (self.timeOutNum >= 35 || self.isHasTostsave) {
                [self timerinvalidate];
                return ;
            }
            self.bucket_id = bucketId;
            self.videoUpStr = Message;
            [self updateVoice];
        }else{
            [self showToastWithText:@"上传视频失败"];
        }
    }];
}

//编辑心情
- (void)editVoiceSure{
    
    self.voiceM.topic_name = self.topicM.topic_name;
    self.voiceM.topic_id = self.topicM.topic_id;
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (!self.voiceM.topic_name) {
        [parm setObject:@"0" forKey:@"topicId"];
    }else{
        if (self.voiceM.topic_name && self.voiceM.topic_name.length) {
            [parm setObject:(self.voiceM.topic_name && self.voiceM.topic_name.length)?self.voiceM.topic_name:@"" forKey:@"topicName"];
        }
        if (self.voiceM.topic_id && self.voiceM.topic_id.length) {
            [parm setObject:self.voiceM.topic_id forKey:@"topicId"];
        }
    }
    if (self.status > 0) {
        [parm setObject:[NSString stringWithFormat:@"%ld",self.status] forKey:@"voiceIdentity"];
    }
    
    if (self.imageJsonString) {
        [parm setObject:self.imageJsonString forKey:@"voiceImg"];
        [parm setObject:!self.bucket_id?@"0":self.bucket_id forKey:@"bucketId"];
    }
    [parm setObject:[NSString stringWithFormat:@"%ld",self.status] forKey:@"voiceIdentity"];
    
    [self timerinvalidate];
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"voices/%@",self.voiceM.voice_id] Accept:@"application/vnd.shengxi.v5.2.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATIONvoice" object:nil];
            NSDictionary *dic = dict[@"data"];
            if (dic) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"NOTICEREEDITVOICENotification" object:self userInfo:@{@"data":dic}];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)timeChange{
    
    if (self.isHasTostProgross) {
        self.timeOutNum = 0;
        [self.timer invalidate];
        return;
    }
    
    self.timeOutNum ++;
    if (self.timeOutNum >= 10  && self.timeOutNum <= 35) {
        [self showHUDWithText:[NSString stringWithFormat:@"%ld%%",self.timePercent+=4]];
    }
    
    if (self.timeOutNum >= 35) {
        [self.timer invalidate];
        [self hideHUD];
        [self caaceSave];
        return;
    }
}

- (void)updateImage{
    [self showHUD];
    self.timePercent = 0;
    self.timeOutNum = 0;
    self.isHasTostProgross = NO;
    self.isHasTostsave = NO;
    [self.timer invalidate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    _sendBtn.enabled = NO;
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableArray *arr1 = [NSMutableArray new];
    for (NSMutableDictionary *dic in self.moveArr) {
        [arr addObject:[dic objectForKey:Locapaths]];
        [arr1 addObject:[dic objectForKey:ImageDatas]];
    }
    
    NSString *pathMd5 = [NoticeTools arrayToJSONString:arr];//多个文件用数组,单个用字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"5" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
 
    [[XGUploadDateManager sharedManager] uploadMoreWithImageArr:arr1 noNeedToast:YES parm:parm progressHandler:^(CGFloat progress) {
      
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (!sussess) {
            [self hideHUD];
            if (self.isSave) {
                if (self.deleteSaveModelBlock) {
                    self.deleteSaveModelBlock(self.index,NO);
                }
             
                [self saveTocaogao];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            if (!self.isEditVoice) {
                self.isHasTostProgross = YES;
                [self.timer invalidate];
                [self caaceSave];
            }
        
            return ;
        }else{
            self.bucket_id = bucketId;
            if (self.timeOutNum >= 35 || self.isHasTostsave) {
                [self timerinvalidate];
                return ;
            }
            self.imageJsonString = Message;
            if (self.isEditVoice) {
                [self editVoiceSure];
            }else{
                [self updateVoice];
            }
        }
    }];
}

- (void)updateVoice{
    
    if (self.timeOutNum >= 35 || self.isHasTostsave) {
        [self hideHUD];
        [self timerinvalidate];
        return ;
    }
    
    if (!(self.timeOutNum > 0)) {
        [self showHUD];
        self.isHasTostsave = NO;
        self.timePercent = 0;
        self.timeOutNum = 0;
        self.isHasTostProgross = NO;
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    }
    
    if (!self.locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        [self timerinvalidate];
        return;
    }
    //
    NSString *pathMd5 =[NSString stringWithFormat:@"%@%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,self.locaPath]],[self.locaPath pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"2" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];
    DRLog(@"地址%@  md5:%@",self.locaPath,pathMd5);
    _sendBtn.enabled = NO;
    
    [[XGUploadDateManager sharedManager] uploadNoToastVoiceWithVoicePath:self.locaPath parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject: @"2" forKey:@"voiceType"];
            [parm setObject:@"1" forKey:@"contentType"];
            [parm setObject:self.timeLen forKey:@"contentLen"];
            [parm setObject:Message forKey:@"voiceContent"];
            [parm setObject:[NSString stringWithFormat:@"%ld",self.status] forKey:@"voiceIdentity"];
            
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
                self.bucket_id = bucketId;
            }else{
                self.bucket_id = @"0";
                [parm setObject:@"0" forKey:@"bucketId"];
            }
            if (self.isVideo) {
                [parm setObject:self.videoUpStr forKey:@"voiceImg"];
                [parm setObject:@"2" forKey:@"attrType"];
            }else{
                if (self.moveArr.count && self.imageJsonString) {
                    [parm setObject:self.imageJsonString forKey:@"voiceImg"];
                    [parm setObject:@"1" forKey:@"attrType"];
                    UIImage *image =  [UIImage sd_imageWithGIFData:[self.moveArr[0] objectForKey:@"ImageDatas"]];
                    if (image.size.height > 0 && image.size.width > 0) {
                        [parm setObject:[NSString stringWithFormat:@"%f",image.size.height/image.size.width] forKey:@"scale"];
                    }else{
                        [parm setObject:@"1" forKey:@"scale"];
                    }
                    
                }
            }
            if (self.readId) {
                [parm setObject:self.readId forKey:@"readAloudId"];
            }
            if (self.voiceById) {
                [parm setObject:self.voiceById forKey:@"changeVoiceId"];
            }
            
            if (self.topicM) {
                if (self.topicM.topic_id) {
                     [parm setObject:self.topicM.topic_id forKey:@"topicId"];
                }
            }
            
            if (self.zjId) {
                [parm setObject:self.zjId forKey:@"albumId"];
            }
            
            if (self.bgmId) {
                [parm setObject:self.bgmId forKey:@"bgmId"];
                [parm setObject:[NSString stringWithFormat:@"%ld",self.bgmType] forKey:@"bgmType"];
            }

            if (self.timeOutNum >= 35 || self.isHasTostsave) {
                [self timerinvalidate];
                [self caaceSave];
                return ;
            }
            
            __weak typeof(self) weakSelf = self;
            [self.timer invalidate];
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices" Accept:@"application/vnd.shengxi.v5.3.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self timerinvalidate];
                if (success) {
                    if ([dict[@"data"] isEqual:[NSNull null]]) {
                        [self backSucdess];
                        return ;
                    }
                    if (self.isSave) {
                        if (self.deleteSaveModelBlock) {
                            self.deleteSaveModelBlock(self.index,YES);
                        }
                    }
                    if (self.isFromAddFriend) {
                        NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
                        userInfo.voice_total_len = self.timeLen;
                        [NoticeSaveModel saveUserInfo:userInfo];
                    }
                    
                    if (!self.isOnlySelf) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATION" object:nil];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETNEWSHENGXINOTICETION" object:nil];
                    [self backSucdess];
                    
                    NoticeWhiteVoiceListModel *whitem = [NoticeWhiteVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                    [self getWhiteCard:whitem.card_no];
                }
            } fail:^(NSError *error) {
                [self timerinvalidate];
                self->_sendBtn.enabled = YES;
                if (self.isSave) {
                    if (self.deleteSaveModelBlock) {
                        self.deleteSaveModelBlock(self.index,NO);
                    }
                 
                    [self saveTocaogao];
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
                [self caaceSave];
            }];
        }
        else{
            [self timerinvalidate];
            if (self.isSave) {
                if (self.deleteSaveModelBlock) {
                    self.deleteSaveModelBlock(self.index,NO);
                }
             
                [self saveTocaogao];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [self caaceSave];
            self->_sendBtn.enabled = YES;
        }
    }];
}

- (void)getWhiteCard:(NSString *)cardId{
    if (!cardId) {
        return;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"famousQuotesCards/%@",cardId] Accept:@"application/vnd.shengxi.v4.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeWhiteVoiceListModel *carM = [NoticeWhiteVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
            if (!carM.card_url) {
                return;
            }
            NoticeTostWhtieVoiceView *tostView = [[NoticeTostWhtieVoiceView alloc] initWithShow:carM];
            [tostView showCardView];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)backSucdess{
    
    [self showToastWithText:[NoticeTools getLocalStrWith:@"py.sendsus"]];
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        if (weakSelf.isActivity && weakSelf.status != 3) {
            if (weakSelf.refreshBlock) {
                weakSelf.refreshBlock(YES);
            }
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGETHEROOTSELECT" object:self userInfo:@{@"voiceStatus":[NSString stringWithFormat:@"%ld",self.status]}];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        
    });
}

- (void)timerinvalidate{
    self.timeOutNum = 0;
    [self.timer invalidate];
    self.timePercent = 20;
    self.isHasTostProgross = NO;
    [self hideHUD];
}

- (void)longPressGestureRecognized:(id)sender{

    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    if (!self.playerView.isPlaying) {
  
        return;
    }
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
        
            [self beginDrag:0];
            [self dragWithPoint:p];
            break;
        }
        case UIGestureRecognizerStateChanged:{
        
            [self dragWithPoint:p];
            break;
        }
        default: {
            [self endDrag:0 progross:p.x/self.playerView.frame.size.width];

            break;
        }
    }
}

- (void)beginDrag:(NSInteger)tag{

    AppDelegate *apple = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [apple.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro{
    AppDelegate *apple = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [apple.audioPlayer pause:YES];

    [apple.audioPlayer pause:NO];
    [self.playerView.playButton setImage:UIImageNamed(@"newbtnplay") forState:UIControlStateNormal];
    [apple.audioPlayer.player seekToTime:CMTimeMake(self.draFlot, 1) completionHandler:^(BOOL finished) {
     
    }];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    
    self.draFlot = dratNum;
}

- (void)dragWithPoint:(CGPoint)p{
    self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;
    if ((self.timeLen.floatValue/self.playerView.frame.size.width)*p.x < self.timeLen.length/5) {
        return;
    }
    [self dragingFloat:(self.timeLen.floatValue/self.playerView.frame.size.width)*p.x index:0];
}

- (void)setNav{

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(60,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-120, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    titleL.font = XGTwentyBoldFontSize;
    titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    titleL.text = self.isEditVoice?[NoticeTools getLocalStrWith:@"sendTextt.reSend"]:[NoticeTools getLocalStrWith:@"py.send"];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleL];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, DR_SCREEN_HEIGHT-40-BOTTOM_HEIGHT-10, DR_SCREEN_WIDTH-40, 40);
    [btn setTitle:[NoticeTools getLocalStrWith:@"py.send"] forState:UIControlStateNormal];
    btn.titleLabel.font = XGEightBoldFontSize;
    btn.layer.cornerRadius = 40/2;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn = btn;
    [self.view addSubview:btn];
    [_sendBtn setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    
    UIButton *webBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [webBtn setImage:UIImageNamed(@"ywh_black") forState:UIControlStateNormal];
    [webBtn addTarget:self action:@selector(webClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webBtn];
    
    if (self.isLead) {
        UIButton *closBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 52, 28)];
        [closBtn setBackgroundImage:UIImageNamed(@"Image_leaclose") forState:UIControlStateNormal];
        [closBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closBtn];
    }else{

        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [backBtn setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
        if (self.isEditVoice) {
            [_sendBtn setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1] forState:UIControlStateNormal];
            _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        }
        [self.view addSubview:backBtn];
    }
    
}

- (void)closeClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定放弃任务吗" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":@"100"}];
        }
    };
    [alerView showXLAlertView];
}

- (void)webClick{
    NoticeSysMeassageTostView *tostV = [[NoticeSysMeassageTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    NoticeMessage *messM = [[NoticeMessage alloc] init];
    messM.type = @"19";
    messM.title = [NoticeTools getLocalStrWith:@"em.sx"];
    messM.content = [NoticeTools getLocalStrWith:@"em.content"];
    tostV.message = messM;
    [tostV showActiveView];
}

- (void)backToPageAction{
    if (self.isSave) {
        if (self.hasChangeSave || self.saveModel.voiceIdentity.intValue != self.status) {
            if (self.locaPath.length > 5) {
                [self tosastSave];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    if (self.isEditVoice) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.locaPath.length > 5) {
        [self tosastSave];
        return;
    }
    if (self.isFromOpen) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLEFROMOPENRNOTICATION" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tosastSave{
    __weak typeof(self) weakSelf = self;
    
    LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
        if (buttonIndex1 == 2) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        if (buttonIndex1 == 1){
            if (weakSelf.isSave) {
                if (weakSelf.deleteSaveModelBlock) {
                    weakSelf.deleteSaveModelBlock(weakSelf.index, NO);
                }
            }
            [weakSelf saveTocaogao];
            
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.save"]];
      
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController popViewControllerAnimated:NO];
            });
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"cao.savecao"],[NoticeTools getLocalStrWith:@"cao.nosave"]]];
    [sheet1 show];
}

//打开相册
- (void)openPhotoClick{

    if (self.moveArr.count >= 3) {
        [self showToastWithText:@"最多只允许三张图片哦~"];
        return;
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3-self.moveArr.count delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = YES;
    imagePicker.allowPickingMultipleVideo = YES;
    if ([NoticeTools isManager]) {
        imagePicker.allowPickingVideo = YES;
        imagePicker.allowPickingMultipleVideo = NO;
    }
    
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.allowCrop = NO;
    imagePicker.showSelectBtn = YES;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)caaceSave{//缓存发送失败的心情
    if (self.isHasTostsave) {
        return;
    }
    self.isHasTostsave = YES;
    __weak typeof(self) weakSelf = self;
    NSString *str = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"sendTextt.cace"]:@"是否將心情保留到離線緩存?\n(重新發布：設置-草稿箱)";
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"em.fail"]:@"心情發布失敗" message:str sureBtn:[NoticeTools getLocalStrWith:@"em.save"] cancleBtn:[NoticeTools getLocalStrWith:@"py.dele"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf saveTocaogao];
            [weakSelf cachaSuccdss];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [alerView showXLAlertView];
}

- (void)saveTocaogao{
    NSMutableArray *alreadyArr = [NoticeSaveVoiceTools getVoiceArrary];
    NSString *timeS = [NoticeSaveVoiceTools getNowTmp];
    if (self.isSave) {
        NoticeVoiceSaveModel *saveM = [[NoticeVoiceSaveModel alloc] init];
        saveM.sendTime = [NoticeSaveVoiceTools getTimeString];
        saveM.pathName = self.saveModel.pathName;
        saveM.voiceTimeLen = self.timeLen;
        saveM.contentType = @"1";
        saveM.voiceIdentity = [NSString stringWithFormat:@"%ld",self.status];
        saveM.voiceFilePath = self.saveModel.voiceFilePath;
        if (self.topicM) {
            saveM.topName = self.topicM.topic_name;
            if (self.topicM.topic_id) {
                saveM.topicId = self.topicM.topic_id;
            }
        }
        if (self.moveArr.count) {
            for (int i = 0; i < self.moveArr.count; i++) {
                UIImage * imgsave = [UIImage imageWithData:[self.moveArr[i] objectForKey:ImageDatas]];
                NSString *pathName = [NSString stringWithFormat:@"/%@",[self.moveArr[i] objectForKey:Locapaths]];
                NSString * Pathimg = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:pathName];
                [UIImagePNGRepresentation(imgsave) writeToFile:Pathimg atomically:YES];
                if (i == 0) {
                    saveM.img1Path = [self.moveArr[i] objectForKey:Locapaths];
                }else if (i == 1){
                    saveM.img2Path = [self.moveArr[i] objectForKey:Locapaths];
                }else if (i == 2){
                    saveM.img3Path = [self.moveArr[i] objectForKey:Locapaths];
                }
            }
        }
        [alreadyArr insertObject:saveM atIndex:0];
        [NoticeSaveVoiceTools saveVoiceArr:alreadyArr];
    }else{
        if ([NoticeSaveVoiceTools copyItemAtPath:self.locaPath toPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",timeS,[self.locaPath pathExtension]]]]) {
            NoticeVoiceSaveModel *saveM = [[NoticeVoiceSaveModel alloc] init];
            saveM.sendTime = [NoticeSaveVoiceTools getTimeString];
            saveM.pathName = [NSString stringWithFormat:@"%@.%@",timeS,[self.locaPath pathExtension]];
            saveM.voiceTimeLen = self.timeLen;
            saveM.contentType = @"1";
            saveM.voiceIdentity = [NSString stringWithFormat:@"%ld",self.status];
            saveM.voiceFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[NoticeSaveVoiceTools getNowTmp],[self.locaPath pathExtension]]];
            if (self.topicM) {
                saveM.topName = self.topicM.topic_name;
                if (self.topicM.topic_id) {
                    saveM.topicId = self.topicM.topic_id;
                }
            }
            if (self.moveArr.count) {
                for (int i = 0; i < self.moveArr.count; i++) {
                    UIImage * imgsave = [UIImage imageWithData:[self.moveArr[i] objectForKey:ImageDatas]];
                    NSString *pathName = [NSString stringWithFormat:@"/%@",[self.moveArr[i] objectForKey:Locapaths]];
                    NSString * Pathimg = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:pathName];
                    [UIImagePNGRepresentation(imgsave) writeToFile:Pathimg atomically:YES];
                    if (i == 0) {
                        saveM.img1Path = [self.moveArr[i] objectForKey:Locapaths];
                    }else if (i == 1){
                        saveM.img2Path = [self.moveArr[i] objectForKey:Locapaths];
                    }else if (i == 2){
                        saveM.img3Path = [self.moveArr[i] objectForKey:Locapaths];
                    }
                }
            }
            [alreadyArr insertObject:saveM atIndex:0];
            [NoticeSaveVoiceTools saveVoiceArr:alreadyArr];
        }
    }

}

- (void)cachaSuccdss{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"sendTextt.save"] message:[NoticeTools getLocalStrWith:@"sendTextt.tosetlook"] sureBtn:[NoticeTools getLocalStrWith:@"sendTextt.look"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            NoticeCaoGaoController *ctl = [[NoticeCaoGaoController alloc] init];
            ctl.backToRoot = YES;
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [alerView showXLAlertView];
}

- (NoticeActShowView *)showView{
    if (!_showView) {
        _showView = [[NoticeActShowView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _showView.titleL.text = @"音频合成中，请耐心等待...";
    }

    return _showView;
}
@end
