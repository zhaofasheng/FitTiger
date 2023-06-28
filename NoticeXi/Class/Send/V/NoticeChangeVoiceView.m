//
//  NoticeChangeVoiceView.m
//  NoticeXi
//
//  Created by li lei on 2022/3/25.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeVoiceView.h"

@implementation NoticeChangeVoiceView
{
    NSOperationQueue *soundTouchQueue;
    AVAudioPlayer *audioPalyer;
}
- (LGAudioPlayer *)voicePlayer
{
    if (!_voicePlayer) {
        _voicePlayer = [[LGAudioPlayer alloc] init];
        ;__weak typeof(self) weakSelf = self;
        _voicePlayer.playComplete = ^{
            weakSelf.currentModel.isPalying = NO;
            weakSelf.currentModel.isRePaly = YES;
            [weakSelf.collectionView reloadData];
        };
    }
    return _voicePlayer;
}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,80,self.frame.size.width,self.keyView.frame.size.height-120-90-BOTTOM_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;          // 隐藏垂直方向滚动条
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        // 注册cell
        [_collectionView registerClass:[NoticeVoiceTypeCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 20;
        self.keyView.layer.masksToBounds = YES;
        
        UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.keyView.frame.size.height)];
        tapV.userInteractionEnabled = YES;
        tapV.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        [self addSubview:tapV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [tapV addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.text = [NoticeTools getLocalStrWith:@"luy.changet"];
        label.textAlignment = NSTextAlignmentCenter;
        [self.keyView addSubview:label];
        self.titleL = label;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50,0,50, 50)];
        [cancelBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [self.keyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.keyView addSubview:self.collectionView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.collectionView.frame), DR_SCREEN_WIDTH-40, 40)];
        button.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = YES;
        [button setTitle:[NoticeTools getLocalStrWith:@"photo.next"] forState:UIControlStateNormal];
        button.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        [self.keyView addSubview:button];
        
        self.keyView.userInteractionEnabled = YES;
        self.upLeveL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame)+10, DR_SCREEN_WIDTH, 20)];
        self.upLeveL.font = FOURTHTEENTEXTFONTSIZE;
        self.upLeveL.textAlignment = NSTextAlignmentCenter;
        self.upLeveL.textColor = [UIColor colorWithHexString:@"#5C5F66"];

        NSString *str1 = [NoticeTools getLocalStrWith:@"luy.levlemark"];
        NSString *str2 = [NoticeTools getLocalStrWith:@"luy.levelonline"];
        NSString *allStr = [NSString stringWithFormat:@"*%@%@",str1,str2];
        self.upLeveL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:str2 beginSize:str1.length+1];
        [self.keyView addSubview:self.upLeveL];
        
        if ([[[NoticeSaveModel getUserInfo] level] intValue] > 0) {
            self.upLeveL.hidden = YES;
        }
        
        self.upLeveL.userInteractionEnabled = YES;
        UITapGestureRecognizer *upTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upLeave)];
        [self.upLeveL addGestureRecognizer:upTap];
        
        self.dataArr = [NSMutableArray new];
        for (int i = 0; i < 9; i++) {
            NoticeVoiceTypeModel *model = [[NoticeVoiceTypeModel alloc] init];
            model.type = i;
            if (i >2) {
                model.needLeavel = 1;
            }else{
                model.needLeavel = 0;
            }
            [self.dataArr addObject:model];
        }
        [self.collectionView reloadData];
               
        soundTouchQueue = [[NSOperationQueue alloc] init];
        soundTouchQueue.maxConcurrentOperationCount = 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"REFRESHUUSERINFOFORNOTICATION" object:nil];
    }
    return self;
}

- (void)nextClick{

    if (self.currentModel) {
        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
        if (self.currentModel.needLeavel > userM.level.intValue && self.currentModel.needLeavel > 0) {
            __weak typeof(self) weakSelf = self;
            NSString *str = nil;
            if ([NoticeTools getLocalType] == 2) {
                str = [NSString stringWithFormat:@"Lv%ldへのアップグレードを使用できる〜",self.currentModel.needLeavel];
            }else if ([NoticeTools getLocalType] == 1){
                str = [NSString stringWithFormat:@"Limited to Lv%ld or higher",self.currentModel.needLeavel];
            }else{
                str = [NSString stringWithFormat:@"升级至Lv%ld可使用哦~",self.currentModel.needLeavel];
            }
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.golv"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    [weakSelf upLeave];
                }
            };
            [alerView showXLAlertView];
            return;
        }
        if (self.typeModelBlock) {
            self.typeModelBlock(self.currentModel);
        }
        if (self.newVoiceBlock) {
            self.newVoiceBlock(self.currentPath, self.timeLen);
        }
    }
    
    [self cancelClick];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.currentModel = self.dataArr[indexPath.row];
    
    if (!self.currentModel.isChoice) {
        for (NoticeVoiceTypeModel *model in self.dataArr) {
            model.isChoice = NO;
            model.isPalying = NO;
            model.isRePaly = YES;
        }
        [self playEditVoice];

        self.currentModel.isChoice = YES;
    }else{
        if (self.currentModel.isRePaly) {
  
            [self playEditVoice];
        }else{
            if (self.currentModel.isPalying) {
                [self.voicePlayer pause:YES];
                self.currentModel.isPalying = NO;
            }else{
                [self.voicePlayer pause:NO];
                self.currentModel.isPalying = YES;
            }
        }
        [self.collectionView reloadData];
    }
}
    
- (void)playEditVoice{
    [self.showView show];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"guanfang" ofType:@"aac"];
    
    NSString *filePath = self.locaPath.length?self.locaPath:path;
    //[NSURL fileURLWithPath:urlStr ? urlStr : @""];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    MySountTouchConfig config;
    config.sampleRate = self.currentModel.cRate;
    config.tempoChange = self.currentModel.speed;
    config.pitch = self.currentModel.fenbei;
    config.rate = self.currentModel.rate;
    
    SoundTouchOperation *sdop = [[SoundTouchOperation alloc] initWithTarget:self
                                                                     action:@selector(soundMusicFinish:)
                                                           SoundTouchConfig:config soundFile:data];
    [soundTouchQueue cancelAllOperations];
    [soundTouchQueue addOperation:sdop];
}
    
#pragma mark - 处理音频文件结束
- (void)soundMusicFinish:(NSString *)path {
    NSURL *url = [NSURL URLWithString:path];
    [self.showView disMiss];
    [self.voicePlayer startPlayWithUrl:path isLocalFile:YES];
    self.currentModel.isPalying = YES;
    self.currentModel.isRePaly = NO;
    [self.collectionView reloadData];
    
    audioPalyer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.timeLen = [NSString stringWithFormat:@"%.f",audioPalyer.duration];
    self.currentPath = path;
}

    //设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeVoiceTypeCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.typeModel = self.dataArr[indexPath.row];
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(72,96);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(26,(DR_SCREEN_WIDTH-104 - 72*3)/2,26,(DR_SCREEN_WIDTH-104 - 72*3)/2);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 52;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 26;
}

// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)upLeave{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    // iTunesConnect 苹果后台配置的产品ID
//    [NoticeSaveModel clearPayInfo];
//    NoticePaySaveModel *payInfo = [[NoticePaySaveModel alloc] init];
//    payInfo.productId = @"com.gmdoc.xi";
//    payInfo.userId = [NoticeTools getuserId];
//    [NoticeSaveModel savePayInfo:payInfo];

    [appdel.payManager startPurchWithID:@"com.gmdoc.xi" money:nil toUserId:[NoticeTools getuserId] userNum:nil isNiming:nil completeHandle:^(SIAPPurchType type, NSData *data) {
                            
    }];
}

- (void)show{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.keyView.frame.size.height+20, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    }];
}

- (void)cancelClick{
    self.currentModel.isChoice = NO;
    self.currentModel.isPalying = NO;
    [self.collectionView reloadData];
    [self.voicePlayer stopPlaying];
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NoticeActShowView *)showView{
    if (!_showView) {
        _showView = [[NoticeActShowView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }

    return _showView;
}

- (void)refresh{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            if (userIn.token) {
                [NoticeSaveModel saveToken:userIn.token];
            }
            [NoticeSaveModel saveUserInfo:userIn];
            [self.collectionView reloadData];
            self.upLeveL.hidden = userIn.level.intValue?YES:NO;
        }
        
    } fail:^(NSError *error) {
        
    }];
}
@end
