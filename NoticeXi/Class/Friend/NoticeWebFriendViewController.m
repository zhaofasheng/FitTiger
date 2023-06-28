//
//  NoticeWebFriendViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/12.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeWebFriendViewController.h"
#import "NoticeOtherUserInfoViewController.h"
#import "NoticeMineViewController.h"
#import "NoticeFriendNumListCell.h"
#import "NoticeSendViewController.h"
#import "FSCustomButton.h"
#import "NoticeMyFriendViewController.h"
#import "NoticeNoticenterModel.h"
#import "DDHAttributedMode.h"
@interface NoticeWebFriendViewController ()<FriendListDelegate,TZImagePickerControllerDelegate,NoticeRecordDelegate>

@property (nonatomic, strong) UIButton *myButton;
@property (nonatomic, strong) NoticeFriendNum *myModel;
@property (nonatomic, assign) NSInteger selfIndex;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isUP;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, strong) UILabel *headL;
@property (nonatomic, strong) UILabel *subheadL1;
@property (nonatomic, strong) UISwitch* switchButton;
@end

@implementation NoticeWebFriendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"唱歌榜";
    [self getUserSet];
    self.page = 1;
    self.dataArr = [NSMutableArray new];
    self.isDown = YES;
    self.view.backgroundColor = [NoticeTools isWhiteTheme] ? GetColorWithName(VBackColor) : GetColorWithName(VlistColor);
    self.tableView.backgroundColor = self.view.backgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 30)];
    label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]? @"#C2D8D8":@"#72727F"];
    label.font = ELEVENTEXTFONTSIZE;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NoticeTools isSimpleLau]?@"自己的名片卡支持背景自定义，点击卡片更换背景":@"自己的名片卡支持背景自定義，點擊卡片更換背景";
    [self.view addSubview:label];
    
    [self initShadowUI];
    
    FSCustomButton *btn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0,30, 40)];
    [btn setImage:[UIImage imageNamed:[NoticeTools isWhiteTheme]?@"img_no_upset":@"img_no_upsetye"] forState:UIControlStateNormal];
    [btn setTitle:@"  " forState:UIControlStateNormal];
    [btn setButtonImagePosition:FSCustomButtonImagePositionRight];
    [btn addTarget:self action:@selector(noUpClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.tableView.frame = CGRectMake(0, 30, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-30-NAVIGATION_BAR_HEIGHT-74-BOTTOM_HEIGHT);
    [self.tableView registerClass:[NoticeFriendNumListCell class] forCellReuseIdentifier:@"fcell"];
    self.tableView.rowHeight = 180+15;
    
    _myButton = [[UIButton alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH-12, 74)];
    [_myButton setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme] ? @"Image_hybtzc":@"Image_hybtzcy") forState:UIControlStateNormal];
    [_myButton setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
    _myButton.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [_myButton addTarget:self action:@selector(goMyCardClick) forControlEvents:UIControlEventTouchUpInside];
    _myButton.enabled = NO;
    [self.view addSubview:_myButton];
    
    __weak NoticeWebFriendViewController *ctl = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.page = 1;
        [ctl requestList];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

//重新上传语音
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]],[locaPath pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"1" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    

    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:Message forKey:@"waveUri"];
            [parm setObject:timeLength forKey:@"waveLen"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
              [self showHUD];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success1) {
                [self hideHUD];
                if (success1) {
                    [self.tableView.mj_header beginRefreshing];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self showToastWithText:Message];
            [self hideHUD];
        }
    }];
    
}

- (void)initShadowUI{
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.shadowView.userInteractionEnabled = YES;
    
    self.actionView = [[UIView alloc] initWithFrame:CGRectMake(0,-415, DR_SCREEN_WIDTH,158)];
    self.actionView.backgroundColor = [NoticeTools isWhiteTheme]?[UIColor whiteColor]:[UIColor colorWithHexString:@"#181828"];
    [self.shadowView addSubview:self.actionView];
    
    CGFloat titiWidth = GET_STRWIDTH(@"不上榜", 17, 17);
    self.headL = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-titiWidth-37)/2,50,titiWidth, 17)];
    self.headL.textColor = GetColorWithName(VMainTextColor);
    self.headL.textAlignment = NSTextAlignmentCenter;
    self.headL.font = SEVENTEENTEXTFONTSIZE;
    self.headL.text = @"不上榜";
    [self.actionView addSubview:self.headL];
    
    CGFloat titleHeight = GET_STRHEIGHT(GETTEXTWITE(@"newlxp.titl1"), 14, DR_SCREEN_WIDTH-48)+6;
    
    self.subheadL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headL.frame)+25,DR_SCREEN_WIDTH,titleHeight)];
    self.subheadL1.numberOfLines = 0;
    self.subheadL1.font = FOURTHTEENTEXTFONTSIZE;
    self.subheadL1.textColor = GetColorWithName(VDarkTextColor);
    self.subheadL1.textAlignment = NSTextAlignmentCenter;
    self.subheadL1.text = [NoticeTools isSimpleLau]?@"开启之后唱歌榜上将不会显示你的名片卡":@"開啟之後唱歌榜上將不會顯示妳的名片卡";
    [self.actionView addSubview:self.subheadL1];
    
    UISwitch* switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headL.frame)+7, self.headL.frame.origin.y-7,30,17)];
    _switchButton = switchButton;
    if (![NoticeTools isWhiteTheme]) {
        _switchButton.tintColor = [UIColor colorWithHexString:@"404054"];
        _switchButton.thumbTintColor = [UIColor colorWithHexString:@"#72727f"];
    }
    _switchButton.onTintColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
    [switchButton addTarget:self action:@selector(changeOnVale:) forControlEvents:UIControlEventValueChanged];
    switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [self.actionView addSubview:switchButton];
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0,self.actionView.frame.size.height, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.actionView.frame.size.height)];
    tapView.backgroundColor = [UIColor clearColor];
    tapView.userInteractionEnabled = YES;
    [self.shadowView addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissShadowView)];
    [tapView addGestureRecognizer:tap];
}

- (void)disMissShadowView{
    [UIView animateWithDuration:0.5 animations:^{
        self.actionView.frame = CGRectMake(0, -self.actionView.frame.size.height, DR_SCREEN_WIDTH, self.actionView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
    }];
}

- (void)noUpClick{

    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self.shadowView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.actionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.actionView.frame.size.height);
    }];
}

- (void)changeOnVale:(UISwitch *)switchbutton{
    
    NSString *strVal = nil;
    if (switchbutton.isOn) {
        strVal = @"0"; 
        self.isUP = YES;
    }else{
        self.isUP = NO;
        strVal = @"1";
    }
    
    if (self.isUP) {
        _myButton.enabled = YES;
        [_myButton setTitle:[NoticeTools isSimpleLau]?@"当前选择了不上榜":@"當前選擇了不上榜" forState:UIControlStateNormal];
    }else{
        if (self.myModel.is_on.integerValue) {
            _myButton.enabled = YES;
            [_myButton setTitle:GETTEXTWITE(@"sx3.1.myc") forState:UIControlStateNormal];
        }else{
            _myButton.enabled = NO;
            NSString *str = [NoticeTools isSimpleLau]?@"首唱回忆":@"首唱回憶";
            [_myButton setTitle:[NSString stringWithFormat:@"你当前有%ld%@，还有%ld首就上榜啦",self.myModel.song_num.integerValue,str,5-self.myModel.song_num.integerValue] forState:UIControlStateNormal];
        }
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:strVal forKey:@"joinSingRanking"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.tableView.mj_header beginRefreshing];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    self.oldSelectIndex = 1000000;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NoticeUserInfoModel *selfM = [NoticeSaveModel getUserInfo];
    if (self.dataArr.count) {
        for (NoticeFriendNum *model in self.dataArr) {
            if ([model.userId isEqualToString:selfM.user_id]) {
                model.nick_name = selfM.nick_name;
                model.avatar_url = selfM.avatar_url;
                model.self_intro = selfM.self_intro;
                [self.tableView reloadData];
                break;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeFriendNum *model = self.dataArr[indexPath.row];
    if ([model.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeMineViewController *ctl = [[NoticeMineViewController alloc] init];
        ctl.isFromOther = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeOtherUserInfoViewController *ctl = [[NoticeOtherUserInfoViewController alloc] init];
        ctl.userId = model.userId;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeFriendNumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fcell"];
    cell.people = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;
    NoticeFriendNum *model = self.dataArr[indexPath.row];
    if (model.isPlaying) {
        [cell.whiteV startPulseWithColor:[UIColor colorWithHexString:WHITEBACKCOLOR] animation:YGPulseViewAnimationTypeRadarPulsing];
    }else{
        [cell.whiteV stopPulse];
    }
    return cell;
}

- (void)goMyCardClick{
    if (self.isUP) {
        UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
        [rootWindow addSubview:self.shadowView];

        [UIView animateWithDuration:0.5 animations:^{
            self.actionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.actionView.frame.size.height);
        }];
        return;
    }
    
    self.selfIndex = 0;
    for (int i = 0; i < self.dataArr.count; i++) {
        NoticeFriendNum *selfM = self.dataArr[i];
        if ([selfM.userId isEqualToString:[NoticeTools getuserId]]) {
            self.selfIndex = i;
            if ((self.dataArr.count-1) >= self.selfIndex) {
               [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selfIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
            break;
        }
    }
}

- (void)clickButtonInCellWith:(NSInteger)index{
    NoticeFriendNum *model = self.dataArr[index];
    if ([model.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePicker.sortAscendingByModificationDate = false;
        imagePicker.allowPickingOriginalPhoto = false;
        imagePicker.alwaysEnableDoneBtn = true;
        imagePicker.allowPickingVideo = false;
        imagePicker.allowPickingGif = false;
        imagePicker.allowCrop = true;
        imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-192/2,DR_SCREEN_WIDTH, 192);
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:model.userId forKey:@"toUserId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/friendslog",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                model.friend_status = @"1";
                [self.tableView reloadData];
                [self showToastWithText:@"学友申请已发送"];
                [NoticeAddFriendTools addFriendWithUserId:model.userId];
            }else{
                [self showToastWithText:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
            }
        
        } fail:^(NSError *error) {
            
        }];
    }
}

- (void)playVoiceWith:(NSInteger)index{
    if (index != self.oldSelectIndex) {//判断点击的是否是当前视图
        self.oldSelectIndex = index;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }
    
    NoticeFriendNum *model = self.dataArr[index];
    if (!model.wave_len.integerValue) {
        if ([model.userId isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {
            NoticeRecoderView * recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
            recodeView.needCancel = YES;
            recodeView.delegate = self;
            recodeView.isDb = YES;
            [recodeView show];
            return;
        }
        [self showToastWithText:@"ta还没有录封面独白"];
        return;
    }
    
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.wave_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
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
        
        //weakSelf.oldSelectIndex = 1000000;
        [weakSelf.tableView reloadData];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
       // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
      //  NoticeFriendNumListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ((model.wave_len.integerValue-currentTime) <= 0) {
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;
            [weakSelf.tableView reloadData];
        }
    };
}

- (void)getUserSet{
    __weak typeof(self) weakSelf = self;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeNoticenterModel*noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            if (!noticeM.join_sing_ranking.integerValue) {
                weakSelf.isUP = YES;
                [weakSelf.switchButton setOn:YES];
                self->_myButton.enabled = YES;
                [self->_myButton setTitle:[NoticeTools isSimpleLau]?@"当前选择了不上榜":@"當前選擇了不上榜" forState:UIControlStateNormal];
            }
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)requestList{
    if (!self.isDown) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    self.oldSelectIndex = 1000000;
    [self.tableView reloadData];

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"leaderboard/users/songs?pageNo=%ld",self.page] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if ([dict[@"data"][@"other"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown) {
               [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            self.myModel = [NoticeFriendNum mj_objectWithKeyValues:dict[@"data"][@"self"]];
            if (self.isUP) {
                self->_myButton.enabled = YES;
                [self->_myButton setTitle:[NoticeTools isSimpleLau]?@"当前选择了不上榜":@"當前選擇了不上榜" forState:UIControlStateNormal];
            }else{
                if (self.myModel.is_on.integerValue) {
                    self->_myButton.enabled = YES;
                    [self->_myButton setTitle:GETTEXTWITE(@"sx3.1.myc") forState:UIControlStateNormal];
                }else{
                    self->_myButton.enabled = NO;
                    NSString *str = [NoticeTools isSimpleLau]?@"首唱回忆":@"首唱回憶";
                    [self->_myButton setTitle:[NSString stringWithFormat:@"你当前有%ld%@，还有%ld首就上榜啦",self.myModel.song_num.integerValue,str,5-self.myModel.song_num.integerValue] forState:UIControlStateNormal];
                }
            }
   
            
            for (NSDictionary *dic in dict[@"data"][@"other"]) {
                NoticeFriendNum *model = [NoticeFriendNum mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
    
            NSInteger tag = 1;
            for (NoticeFriendNum *model in self.dataArr) {
                if ([model.userId isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {
                    self.selfIndex = tag-1;
                }
                model.paiHang = [NSString stringWithFormat:@"%ld",tag];
                if (tag > 7) {
                    model.yushu = [NSString stringWithFormat:@"%ld",tag % 7];
                }
                else{
                    model.yushu = model.paiHang;
                }
                
                if (tag % 7 == 0){
                    model.yushu = @"7";
                }
                tag++;
            }
            
            if (self.dataArr.count) {
                [self getMoreLy];
            }
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)getMoreLy{
    NSMutableArray *arr = [NSMutableArray new];
    self.page++;
    self.isDown = NO;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"leaderboard/users/songs?pageNo=%ld",self.page] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if ([dict[@"data"][@"other"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            self.myModel = [NoticeFriendNum mj_objectWithKeyValues:dict[@"data"][@"self"]];
            if (self.isUP) {
                self->_myButton.enabled = YES;
                [self->_myButton setTitle:[NoticeTools isSimpleLau]?@"当前选择了不上榜":@"當前選擇了不上榜" forState:UIControlStateNormal];
            }else{
                if (self.myModel.is_on.integerValue) {
                    self->_myButton.enabled = YES;
                    [self->_myButton setTitle:GETTEXTWITE(@"sx3.1.myc") forState:UIControlStateNormal];
                }else{
                    self->_myButton.enabled = NO;
                    NSString *str = [NoticeTools isSimpleLau]?@"首唱回忆":@"首唱回憶";
                    [self->_myButton setTitle:[NSString stringWithFormat:@"你当前有%ld%@，还有%ld首就上榜啦",self.myModel.song_num.integerValue,str,5-self.myModel.song_num.integerValue] forState:UIControlStateNormal];
                }
            }
            
            
            for (NSDictionary *dic in dict[@"data"][@"other"]) {
                NoticeFriendNum *model = [NoticeFriendNum mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                [arr addObject:model];
            }
            
            NSInteger tag = 1;
            for (NoticeFriendNum *model in self.dataArr) {
                if ([model.userId isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {
                    self.selfIndex = tag-1;
                }
                model.paiHang = [NSString stringWithFormat:@"%ld",tag];
                if (tag > 7) {
                    model.yushu = [NSString stringWithFormat:@"%ld",tag % 7];
                }
                else{
                    model.yushu = model.paiHang;
                }
                
                if (tag % 7 == 0){
                    model.yushu = @"7";
                }
                tag++;
            }
            
            if (arr.count && self.dataArr.count < 50) {
                [self getMoreLy];
            }else if (self.dataArr.count >= 50){
                if (self.myModel.is_on.boolValue) {
                    BOOL isOn = NO;
                    for (NoticeFriendNum *model in self.dataArr) {
                        if ([model.userId isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {
                            self.selfIndex = tag-1;
                            isOn = YES;
                            break;
                        }
                    }
                    if (!isOn) {
                        self.myModel.paiHang = @"51";
                        self.myModel.yushu = [NSString stringWithFormat:@"%d",51 % 7];
                        [self.dataArr addObject:self.myModel];
                        [self.tableView reloadData];
                    }
                }
                
            }
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
            [self upLoadHeader:choiceImage path:filePath withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }else{
            [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""] withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }
    }];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path withDate:(NSString *)date{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"12" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:Message forKey:@"friendCardUri"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            [self showHUD];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success1) {
                [self hideHUD];
                if (success1) {
                    NoticeUserInfoModel *selfM = [NoticeSaveModel getUserInfo];
                    if (self.dataArr.count) {
                        for (NoticeFriendNum *model in self.dataArr) {
                            if ([model.userId isEqualToString:selfM.user_id]) {
                                model.cardImage = image;
                                [self.tableView reloadData];
                                break;
                            }
                        }
                    }
                    [self.tableView reloadData];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self showToastWithText:Message];
        }
    }];
}
@end
