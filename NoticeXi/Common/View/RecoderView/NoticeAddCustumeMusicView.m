//
//  NoticeAddCustumeMusicView.m
//  NoticeXi
//
//  Created by li lei on 2021/8/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeAddCustumeMusicView.h"
#import "NoticeCustumeMusiceCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeAddCustumeMusicView
{
    UILabel *titleL;
    UIButton *_howBtn;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.userInteractionEnabled = YES;
        
        self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [self addSubview:self.navView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NoticeTools getLocalStrWith:@"gedan.add"];
        [self.navView addSubview:label];
        
        UIButton *howBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-GET_STRWIDTH([NoticeTools getLocalStrWith:@"zj.howadd"], 14,40)-20, STATUS_BAR_HEIGHT,GET_STRWIDTH([NoticeTools getLocalStrWith:@"zj.howadd"], 14,40) , NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [howBtn addTarget:self action:@selector(howClick) forControlEvents:UIControlEventTouchUpInside];
        [howBtn setTitle:[NoticeTools getLocalStrWith:@"songList.how"] forState:UIControlStateNormal];
        [howBtn setTitleColor:[[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1] forState:UIControlStateNormal];
        howBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.navView addSubview:howBtn];
        _howBtn = howBtn;
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(10, STATUS_BAR_HEIGHT, 42, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"Image_blackBack"] forState:UIControlStateNormal];
        [self.navView addSubview:backButton];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 30+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-30, 20)];
        label1.font = FOURTHTEENTEXTFONTSIZE;
        label1.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        titleL = label1;
        if (self.isFromeCenter) {
            label1.text = [NoticeTools getLocalStrWith:@"songList.up"];
        }else{
            label1.attributedText = [DDHAttributedMode setSizeAndColorString:@"上传歌曲 如何上传?" setColor:[[UIColor colorWithHexString:@"#0099E6"] colorWithAlphaComponent:1] setSize:11 setLengthString:@"如何上传?" beginSize:5];
            label1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(howClick)];
            [label1 addGestureRecognizer:tap];
        }
        [self addSubview:label1];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label1.frame)+20, DR_SCREEN_WIDTH-20-20-40-10, 40)];
        backV.layer.cornerRadius = 20;
        backV.layer.masksToBounds = YES;
        backV.layer.borderColor = [UIColor colorWithHexString:@"#25262E"].CGColor;
        backV.layer.borderWidth = 1;
        backV.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        [self addSubview:backV];
        
        self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(10,2,backV.frame.size.width-20, 36)];
        self.inputField.font = FOURTHTEENTEXTFONTSIZE;
        self.inputField.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.inputField.tintColor = [UIColor colorWithHexString:@"#0099E6"];
        [backV addSubview:self.inputField];
        self.inputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"songList.copy"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1]}];
        self.inputField.delegate = self;
        
        UIButton *downBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backV.frame)+10, backV.frame.origin.y, 40, 40)];
        [downBtn setImage:UIImageNamed(@"Image_downmusic") forState:UIControlStateNormal];
        [downBtn addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:downBtn];
        
        self.erroL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backV.frame)+8, DR_SCREEN_WIDTH-30, 14)];
        self.erroL.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
//        self.erroL.text = @"仅支持网易云，不支持收费VIP歌曲";
        self.erroL.font = ELEVENTEXTFONTSIZE;
        [self addSubview:self.erroL];
        
        self.dataArr = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] init];

        self.tableView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.frame = CGRectMake(0,CGRectGetMaxY(self.erroL.frame)+10,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-CGRectGetMaxY(self.erroL.frame)-10);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[NoticeCustumeMusiceCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.rowHeight = 56;
        [self addSubview:self.tableView];
        
        [self createRefesh];
        [self.tableView.mj_header beginRefreshing];
    }
    return self;
}

- (void)setIsFromeCenter:(BOOL)isFromeCenter{
    _isFromeCenter = isFromeCenter;
    if (isFromeCenter) {
        titleL.text = [NoticeTools getLocalStrWith:@"songList.up"];
    }
}

- (void)setIsFromRecodering:(BOOL)isFromRecodering{
    _isFromRecodering = isFromRecodering;
    if (isFromRecodering) {
        titleL.text = [NoticeTools getLocalStrWith:@"songList.up"];
        _howBtn.frame = CGRectMake(GET_STRWIDTH([NoticeTools getLocalStrWith:@"zj.howadd"], 14,40)+10, 30+NAVIGATION_BAR_HEIGHT, 20, 20);
        [_howBtn setTitle:@"" forState:UIControlStateNormal];
        [_howBtn setImage:UIImageNamed(@"Image_howupmusic") forState:UIControlStateNormal];
        [self addSubview:_howBtn];
    }
}

- (void)downClick{
    if (!self.inputField.text.length) {
        [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"songList.pleasecopy"]];
        return;
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"checkMusic" Accept:nil isPost:0 parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self addMusic];
        }else{
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dict[@"msg"]]] message:nil sureBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.golv"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    XLAlertView *alertView1 = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"songList.detail"] message:nil cancleBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"]];
                    [alertView1 showXLAlertView];
                }
            };
            [alerView showXLAlertView];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)addMusic{
    [self.inputField resignFirstResponder];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.inputField.text forKey:@"linkString"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"getmusic" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.isDown = YES;
            [self requestMusiceList];
            self.erroL.text = @"";
        }else{
            self.erroL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
            self.erroL.text = [NoticeTools getLocalStrWith:@"songList.nosupport"];
        }
        self.inputField.text = @"";
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)createRefesh{
    
    __weak NoticeAddCustumeMusicView *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl requestMusiceList];
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl requestMusiceList];
    }];
}

- (void)requestMusiceList{
    NSString *url = @"";
    if (self.isDown) {
        url = @"getmusic?pageNo=1";
    }else{
        url = [NSString stringWithFormat:@"getmusic?pageNo=%ld",self.pageNo];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeCustumMusiceModel *model = [NoticeCustumMusiceModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
//            if (self.requestMusicBlock) {
//                self.requestMusicBlock(YES);
//            }
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCustumMusiceModel *model = self.dataArr[indexPath.row];
    [self clickWith:model];
}

- (void)clickWith:(NoticeCustumMusiceModel*)curM{
    NoticeCustumMusiceModel *model = curM;
    self.noRefresh = YES;
    if (model.status < 1) {//没有播放则执行播放
        self.currentModel.status = 0;
        self.currentModel.isSelect = NO;
        model.isSelect = YES;
        self.currentModel = model;
        
        if (!model.isRequest) {
            model.isRequest = YES;
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
         
            [nav.topViewController showHUD];
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"parsingMusic/%@/1",model.songId] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    NoticeCustumMusiceModel *cuM = [NoticeCustumMusiceModel mj_objectWithKeyValues:dict[@"data"]];
                    model.song_url = cuM.songUrl;
                    model.isRequest = NO;
                    model.status = 1;
                    [self.audioPlayer startPlayWithUrlandRecoding:model.song_url isLocalFile:NO];
                    [self.tableView reloadData];
                    if (!self.isFromeCenter) {
                        if (self.useMusicBlock) {
                            self.useMusicBlock(model);
                        }
                    }
                }
                [nav.topViewController hideHUD];
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
        }
    }else if (self.currentModel.status == 1){//播放中，则执行暂停
        self.currentModel.status = 2;
        [self.audioPlayer pause:YES];
        [self.tableView reloadData];
        if (!self.isFromeCenter) {
            if (self.useMusicBlock) {
                self.useMusicBlock(model);
            }
        }
    }else if (self.currentModel.status == 2){//暂停中，则执行播放
        self.currentModel.status = 1;
        [self.audioPlayer pause:NO];
        [self.tableView reloadData];
        if (!self.isFromeCenter) {
            if (self.useMusicBlock) {
                self.useMusicBlock(model);
            }
        }
    }
}

- (void)refresh{
    self.currentModel.status = 0;
    self.currentModel.isSelect = NO;
    [self.tableView reloadData];
    [self.audioPlayer stopPlaying];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCustumeMusiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isAddToMusicList = self.isFromeCenter;
    cell.musicModel = self.dataArr[indexPath.row];
    if (self.isFromRecodering) {
        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    __weak typeof(self) weakSelf = self;
    
    cell.deletesMusicBlock = ^(NoticeCustumMusiceModel * _Nonnull model) {
        [weakSelf deleteMusicM:model];
    };
    
    cell.addMusicBlock = ^(BOOL add) {
        if (weakSelf.addMusicBlock) {
            weakSelf.addMusicBlock(YES);
        }
    };
    
    return cell;
}

- (void)deleteMusicM:(NoticeCustumMusiceModel *)model{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"songList.suredele"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"getmusic/%@",model.songId] Accept:nil parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    for (NoticeCustumMusiceModel *models in weakSelf.dataArr) {
                        if (models.songId.intValue == model.songId.intValue) {
                            [weakSelf.dataArr removeObject:models];
                            break;
                        }
                    }
                    [weakSelf.tableView reloadData];
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
        }
    };
    [alerView showXLAlertView];
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;

        _audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (status == AVPlayerItemStatusFailed) {
                weakSelf.erroL.text = [NoticeTools getLocalStrWith:@"songList.cannptplay"];
            }
        };
        _audioPlayer.playComplete = ^{
            if (!weakSelf.noRefresh) {
                weakSelf.currentModel.status = 0;
                [weakSelf.tableView reloadData];
            }
            if (weakSelf.noRefresh) {
                weakSelf.noRefresh = NO;
            }
        };
    }
    return _audioPlayer;
}

- (void)howClick{
    [self.inputField resignFirstResponder];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self.howView];
}

- (NoticeHowAddMusicView *)howView{
    if (!_howView) {
        _howView = [[NoticeHowAddMusicView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
   
    }
    return _howView;
}

- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
   
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {

    }];
}

- (void)backToPageAction{
    [_audioPlayer stopPlaying];
    [self.inputField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

@end
