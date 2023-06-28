//
//  NoticeSendMovieViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendMovieViewController.h"
#import "NoticeMovieDetail.h"
#import "DDHAttributedMode.h"
#import "NoticeSaveVoiceTools.h"
#import "NoticeVoiceSaveModel.h"
#import "AppDelegate.h"
#import "JWProgressView.h"
#import "NoticeCacheManagerController.h"
#import "NoticeTextVoiceController.h"
#import "NoticeGetPhotosFromLibary.h"
#import "NoticeWhiteVoiceListModel.h"
#import "NoticeMoivceInCell.h"
#import "NoticeSysMeassageTostView.h"
@interface NoticeSendMovieViewController ()<NoticeRecordDelegate,NoticePlayerNumbersDelegate>
@property (nonatomic, strong) UIButton *reButton;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) NSString *isTuijian;
@property (nonatomic, strong) UIButton *goodBtn;
@property (nonatomic, strong) UIButton *midBtn;
@property (nonatomic, strong) UIButton *badBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *phassetArr;
@property (nonatomic, assign) BOOL isSong;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *titleHeadView;
@property (nonatomic, strong) JWProgressView *progressView;
@property (nonatomic, assign) CGFloat provalue;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong) UIButton *onlySelfButton;
@property (nonatomic, assign) BOOL isOnlySelf;
@property (nonatomic, strong) NoticeMoivceInCell *movieView;
@end

@implementation NoticeSendMovieViewController
{
    UIView *_proview;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.sendVoice = NO;
}

- (void)chcaeNotice{
    self.rightBtn.enabled = YES;
    [self caaceSave];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NONETWORKINGGEGCACHE" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.sendVoice = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chcaeNotice) name:@"NONETWORKINGGEGCACHE" object:nil];
    
    self.isTuijian = nil;

    self.navigationItem.title = self.type == 2?[NoticeTools getLocalStrWith:@"em.sendsong"]: (self.type == 1?[NoticeTools getLocalStrWith:@"em.sendbook"]: [NoticeTools getLocalStrWith:@"em.sendmovie"]);
    self.tableView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    if (self.type == 2) {
        self.isSong = YES;
    }
    self.phassetArr = [NSMutableArray new];
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        
        [self showToastWithText:[NoticeTools getLocalStrWith:@"em.noPhotoquanxian"]];
    }
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
    }];
    
    [self getAllPhoto];
    
    [self initUI];
    
    if (self.locaPath) {
        [self recoderSureWithPath:self.locaPath time:self.timeLen];
    }
    
    if (self.soonRecoder) {
        [self recodClick];
    }
    
    UIButton *webBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [webBtn setImage:UIImageNamed(@"Image_yiwenhao") forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:webBtn];
    [webBtn addTarget:self action:@selector(webClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 42, 44);
    [backButton setTitle:@"    " forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"btn_nav_white"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backToPageAction{
    if (self.locaPath.length > 5) {
        
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"xl.suregp"] message:[NoticeTools getLocalStrWith:@"xl.nosavenr"] sureBtn:[NoticeTools getLocalStrWith:@"xl.suresure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        [alerView showXLAlertView];
        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideRecoderView{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)sendClick{
   
    if (self.locaPath && self.locaPath.length > 5) {
        if (self.isTuijian == nil) {
            [self showToastWithText:self.type == 2? [NoticeTools getLocalStrWith:@"em.songtost"]: (self.type == 1?[NoticeTools getLocalStrWith:@"em.booktost"]: [NoticeTools getLocalStrWith:@"em.movietost"])];
            return;
        }
       [self updateVoice];
    }
}

- (void)updateVoice{
    if (!self.locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,self.locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"2" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];
    _rightBtn.enabled = NO;
    
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:self.locaPath parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject: @"3" forKey:@"voiceType"];
            [parm setObject:self.timeLen forKey:@"contentLen"];
            [parm setObject:Message forKey:@"voiceContent"];
            [parm setObject:@"1" forKey:@"contentType"];
            [parm setObject:self.isOnlySelf?@"1":@"0" forKey:@"isPrivate"];
            [parm setObject:self.isLongTime?@"2":@"1" forKey:@"lengthType"];
            [parm setObject:@"0" forKey:@"titleId"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            if (self.type == 1) {
                [parm setObject: self.book.bookId forKey:@"resourceId"];
            }else if (self.type == 2){
                [parm setObject: self.song.albumId forKey:@"resourceId"];
            }else{
                [parm setObject: self.movice.movie_id forKey:@"resourceId"];
            }
            [parm setObject:self.isTuijian forKey:@"score"];
            [parm setObject:self.type == 2?@"3": (self.type == 1?@"2":@"1") forKey:@"resourceType"];
            
            [self showHUDWithText:@"发布中"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices" Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    NoticeWhiteVoiceListModel *whitem = [NoticeWhiteVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                    [self getWhiteCard:whitem.card_no];
                    [UIView animateWithDuration:0.5 animations:^{
                        [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.hassend"]];
                    } completion:^(BOOL finished) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFREDETAILSHUSERINFORNOTICATION" object:nil];
                }else{
                    self.rightBtn.enabled = YES;
                }
            } fail:^(NSError *error) {
                self.rightBtn.enabled = YES;
                [self caaceSave];
                [self hideHUD];
            }];
        }
        else{
            [self caaceSave];
            self.rightBtn.enabled = YES;
            [self hideHUD];
            [self showToastWithText:Message];
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
                return ;
            }
            NoticeTostWhtieVoiceView *tostView = [[NoticeTostWhtieVoiceView alloc] initWithShow:carM];
            [tostView showCardView];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)caaceSave{//缓存发送失败的心情
    
    __weak typeof(self) weakSelf = self;
    NSString *str = nil;
    if (self.type == 1) {
        str = [NoticeTools isSimpleLau]?@"是否将书评保留到离线缓存?\n(等网络较好的时候再次发布)":@"是否將书評保留到離線緩存?\n(等網絡較好的時候再次發布)";
    }else if (self.type == 2){
        str = [NoticeTools isSimpleLau]?@"是否将唱回忆保留到离线缓存?\n(等网络较好的时候再次发布)":@"是否將唱回忆保留到離線緩存?\n(等網絡較好的時候再次發布)";
    }else{
        str = [NoticeTools isSimpleLau]?@"是否将影评保留到离线缓存?\n(等网络较好的时候再次发布)":@"是否將影評保留到離線緩存?\n(等網絡較好的時候再次發布)";
    }
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"em.fail"]:@"心情發布失敗" message:str sureBtn:[NoticeTools getLocalStrWith:@"em.save"] cancleBtn:[NoticeTools getLocalStrWith:@"py.dele"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            NSMutableArray *alreadyArr = [NoticeSaveVoiceTools getVoiceArrary];
            if ([NoticeSaveVoiceTools copyItemAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:@"temporaryRadio.aac"] toPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",[NoticeSaveVoiceTools getNowTmp]]]]) {
                NoticeVoiceSaveModel *saveM = [[NoticeVoiceSaveModel alloc] init];
                saveM.sendTime = [NoticeSaveVoiceTools getTimeString];
                saveM.pathName = [NSString stringWithFormat:@"%@.aac",[NoticeSaveVoiceTools getNowTmp]];
                saveM.voiceTimeLen = weakSelf.timeLen;
                saveM.voiceType = @"3";
                saveM.contentType = @"1";
                saveM.voiceFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",[NoticeSaveVoiceTools getNowTmp]]];
                saveM.resourceType = self.type == 2?@"3": (self.type == 1?@"2":@"1");
                if (self.type == 1) {
                    saveM.bookId = self.book.bookId;
                }else if (self.type == 2){
                    saveM.songId = self.song.albumId;
                }else{
                    saveM.movieId = self.movice.movie_id;
                }
                saveM.score = self.isTuijian;
        
                [alreadyArr addObject:saveM];
                [NoticeSaveVoiceTools saveVoiceArr:alreadyArr];
                [weakSelf cachaSuccdss];
            }
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [alerView showXLAlertView];
}

- (void)cachaSuccdss{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"sendTextt.save"] message:[NoticeTools getLocalStrWith:@"sendTextt.tosetlook"] sureBtn:[NoticeTools getLocalStrWith:@"sendTextt.look"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            NoticeCacheManagerController *ctl = [[NoticeCacheManagerController alloc] init];
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [alerView showXLAlertView];
}
- (void)reRecoderLocalVoice{
    [self recodClick];
}

- (void)recodClick{
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWithSong:self.isSong];
    recodeView.hideCancel = YES;
    //recodeView.needLongTap = YES;
    recodeView.isLongTime = self.isLongTime;
    recodeView.delegate = self;
    recodeView.isSendTextMBS = YES;
    recodeView.isSong = self.isSong;
    recodeView.isSend = YES;
    [recodeView show];
}

- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    self.locaPath = locaPath;
    self.timeLen = timeLength;
    [self.reButton removeFromSuperview];
    self.playerView.isLocal = YES;
    self.playerView.timeLen = timeLength;
    self.playerView.voiceUrl = locaPath;
    [self.backView addSubview:self.playerView];
    
    if (!self.isTuijian) {
        _rightBtn.alpha = 1;//
        _rightBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    }else{
        _rightBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        _rightBtn.alpha = 0.5;
    }
}

- (void)longTapToSendText{
    NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
    ctl.song = self.song;
    ctl.movice = self.movice;
    ctl.book = self.book;
    ctl.type = self.type;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)deleteVoice{
    _rightBtn.alpha = 0.5;
    self.timeLen = nil;
    self.locaPath = nil;
    [self.playerView removeFromSuperview];
    [self.view addSubview:self.reButton];
}

- (void)initUI{

    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-76-40-BOTTOM_HEIGHT-34-NAVIGATION_BAR_HEIGHT)];
    self.backView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.backView];
    
    if (!self.type && [NoticeTools isKnowSendMovie]) {
        [self.view addSubview:self.titleHeadView];
        self.backView.frame = CGRectMake(0,76, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-76-40-BOTTOM_HEIGHT-34-NAVIGATION_BAR_HEIGHT);
    }
    
    if (self.type == 1 && [NoticeTools isKnowSendBook]) {
        [self.view addSubview:self.titleHeadView];
        self.backView.frame = CGRectMake(0,76, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-76-40-BOTTOM_HEIGHT-34-NAVIGATION_BAR_HEIGHT);
    }
    
    if (self.type == 2 && [NoticeTools isKnowSendSong]) {
        [self.view addSubview:self.titleHeadView];
        self.backView.frame = CGRectMake(0,76, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-76-40-BOTTOM_HEIGHT-34-NAVIGATION_BAR_HEIGHT);
    }
    
    self.reButton = [[UIButton alloc] initWithFrame:CGRectMake(20,20, 100, 40)];
    [self.reButton addTarget:self action:@selector(recodClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.reButton];
    
    if ([NoticeTools getLocalType]) {
        [self.reButton setBackgroundImage:UIImageNamed(@"Image_luyinpincn") forState:UIControlStateNormal];
    }else{
        if (!self.type) {
            [self.reButton setBackgroundImage:UIImageNamed(@"Image_luyinpin") forState:UIControlStateNormal];
        }else if (self.type == 1){
            [self.reButton setBackgroundImage:UIImageNamed(@"img_lushuping") forState:UIControlStateNormal];
        }else{
            [self.reButton setBackgroundImage:UIImageNamed(@"img_luge") forState:UIControlStateNormal];
        }
    }

    
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-44-34, DR_SCREEN_WIDTH-40, 44)];
    [_rightBtn setTitle:[NoticeTools getLocalStrWith:@"py.send"] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    _rightBtn.layer.cornerRadius = 22;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    [_rightBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _rightBtn.alpha = 0.5;
    [_rightBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBtn];
    
    self.playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(20, 20,125, 40)];
    self.playerView.delegate = self;
    UIView *dragView = [[UIView alloc] initWithFrame:CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height)];
    dragView.userInteractionEnabled = YES;
    dragView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
    [self.playerView addSubview:dragView];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    longPress.minimumPressDuration = 0.17;
    [dragView addGestureRecognizer:longPress];
    
    _movieView = [[NoticeMoivceInCell alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_playerView.frame)+15, self.backView.frame.size.width-40, 78)];
    [self.backView addSubview:_movieView];
    _movieView.scoreImageView.hidden = YES;
    _movieView.userInteractionEnabled = NO;
    
    if (self.movice) {
        _movieView.movie = self.movice;
    }else if (self.song){
        _movieView.song = self.song;
    }else{
        _movieView.book = self.book;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.movieView.frame)+20, DR_SCREEN_WIDTH-30, 21)];
    label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    label.font = FIFTHTEENTEXTFONTSIZE;
    label.text = self.type == 2? [NoticeTools getLocalStrWith:@"em.likesong"] : (self.type == 1?[NoticeTools getLocalStrWith:@"em.likebook"]: [NoticeTools getLocalStrWith:@"em.likemovie"]);
    [self.backView addSubview:label];
    
    _goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _badBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSArray *btnArr = @[_goodBtn,_midBtn,_badBtn];
    NSArray *titleArr = self.type == 2? (@[[NoticeTools getLocalStrWith:@"em.mostlove"],[NoticeTools getLocalStrWith:@"em.love"],[NoticeTools getLocalStrWith:@"em.nomerl"]]): (@[[NoticeTools getLocalStrWith:@"em.love"],[NoticeTools getLocalStrWith:@"em.verylike"],[NoticeTools getLocalStrWith:@"em.so"]]);
    NSArray *imagArr = self.type == 2?@[@"Image_cg200N",@"Image_cg150N",@"Image_cg100N"] : @[@"tuijiangood",@"tuiianzl",@"tuijinabad"];
    NSArray *imageArrChoice = self.type == 2?@[@"Image_cg200",@"Image_cg150",@"Image_cg100"] : @[@"good_select",@"normal_select",@"bad_select"];
 
    for (int i = 0; i < 3; i++) {
        UIButton *tbtn = btnArr[i];
        tbtn.frame = CGRectMake(20+((DR_SCREEN_WIDTH-80)/3+20)*i, CGRectGetMaxY(label.frame)+15, (DR_SCREEN_WIDTH-80)/3, 44);
        tbtn.layer.cornerRadius = 22;
        tbtn.layer.masksToBounds = YES;
        tbtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        tbtn.layer.borderWidth = 1;
        tbtn.layer.borderColor =  [UIColor colorWithHexString:@"#25262E"].CGColor;
        [tbtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
        [tbtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [tbtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
        [tbtn setImage:UIImageNamed(imageArrChoice[i]) forState:UIControlStateSelected];
        [tbtn setImage:UIImageNamed(imagArr[i]) forState:UIControlStateNormal];
        [self.backView addSubview:tbtn];
        tbtn.tag = i;
        [tbtn addTarget:self action:@selector(scorClick:) forControlEvents:UIControlEventTouchUpInside];
    }
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
    self.tableView.scrollEnabled = NO;
    AppDelegate *apple = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [apple.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro{
    AppDelegate *apple = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [apple.audioPlayer pause:YES];

    [apple.audioPlayer pause:NO];
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


- (void)scorClick:(UIButton *)button{
 
    if (self.locaPath && self.timeLen.intValue) {
        _rightBtn.alpha = 1;//
        _rightBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    }else{
        _rightBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        _rightBtn.alpha = 0.5;
    }
    
    if (button.tag == 0) {
        self.isTuijian =self.type == 2? @"200": @"100";
        _goodBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        _goodBtn.selected = YES;
        
        _badBtn.selected = NO;
        _badBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
        _midBtn.selected = NO;
        _midBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
    }else if (button.tag == 1){
        self.isTuijian =self.type == 2? @"150": @"50";
        _midBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        _midBtn.selected = YES;
        
        _goodBtn.selected = NO;
        _goodBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
        _badBtn.selected = NO;
        _badBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    }else{
        self.isTuijian =self.type == 2? @"100": @"0";
        _badBtn.backgroundColor=[UIColor colorWithHexString:@"#25262E"];
        _badBtn.selected = YES;
        
        _midBtn.selected = NO;
        _midBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
        _goodBtn.selected = NO;
        _goodBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    }
}

- (void)changeProgressValue{
    self.provalue += 0.02;
    if (self.provalue >1.02) {
        self.provalue = 0;
    }
    self.progressView.progressValue = self.provalue;
}

- (void)getAllPhoto{

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
      self.phassetArr = [NoticeGetPhotosFromLibary getPhotos];
  });
   
}

- (UIView *)titleHeadView{
    if (!_titleHeadView) {
        _titleHeadView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, DR_SCREEN_WIDTH-40, 40)];
        _titleHeadView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
        _titleHeadView.layer.cornerRadius = 5;
        _titleHeadView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,DR_SCREEN_WIDTH-50, 40)];
        label.font = TWOTEXTFONTSIZE;
        
        if (self.type == 2) {
            label.text = [NoticeTools getLocalStrWith:@"em.shanresong"];
        }
        if (self.type == 1) {
            label.text = [NoticeTools getLocalStrWith:@"em.sharebook"];
        }
        if (!self.type) {
            label.text = [NoticeTools getLocalStrWith:@"em.sharemovie"];
        }
        label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        label.numberOfLines = 0;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_titleHeadView.frame.size.width-5-40, 0, 43, 40)];
        [button setImage:UIImageNamed(@"Image_sendXX") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickXX) forControlEvents:UIControlEventTouchUpInside];
        [_titleHeadView addSubview:button];
        [_titleHeadView addSubview:label];
    }
    return _titleHeadView;
}

- (void)clickXX{
    [self.titleHeadView removeFromSuperview];
    if (self.type == 1) {
        [NoticeTools setKnowSendBook];
    }
    if (self.type == 2) {
        [NoticeTools setKnowSendSong];
    }
    if (!self.type) {
        [NoticeTools setKnowSendMovie];
    }
    self.backView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-76-40-BOTTOM_HEIGHT-34-NAVIGATION_BAR_HEIGHT);
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
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;

    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}
@end
