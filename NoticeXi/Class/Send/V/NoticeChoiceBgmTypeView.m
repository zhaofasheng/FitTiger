//
//  NoticeChoiceBgmTypeView.m
//  NoticeXi
//
//  Created by li lei on 2022/4/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoiceBgmTypeView.h"
#import "NoticeBgmTypeCell.h"
#import "NoticeCustumeMusiceCell.h"
@implementation NoticeChoiceBgmTypeView

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 横方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,40,self.frame.size.width,68*2+45);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        // 注册cell
        [_collectionView registerClass:[NoticeBgmTypeCell class] forCellWithReuseIdentifier:@"Cell"];
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
        label.text = [NoticeTools getLocalStrWith:@"luy.choiceBGM"];
        label.textAlignment = NSTextAlignmentCenter;
        [self.keyView addSubview:label];
        self.titleL = label;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50,0,50, 50)];
        [cancelBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [self.keyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton = cancelBtn;
        
        [self.keyView addSubview:self.collectionView];
        
        self.howButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-94, 0, 94, 50)];
        [self.howButton setTitle:[NoticeTools getLocalStrWith:@"songList.how"] forState:UIControlStateNormal];
        self.howButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.howButton setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        [self.howButton addTarget:self action:@selector(howClick) forControlEvents:UIControlEventTouchUpInside];
        [self.keyView addSubview:self.howButton];
        self.howButton.hidden = YES;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, self.keyView.frame.size.height-20-BOTTOM_HEIGHT-40, DR_SCREEN_WIDTH-40, 40)];
        button.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = YES;
        [button setTitle:[NoticeTools getLocalStrWith:@"luy.addBGN"] forState:UIControlStateNormal];
        button.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [self.keyView addSubview:button];
        self.addButton = button;
        
        self.keyView.userInteractionEnabled = YES;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,68*2+45+40)];
        [headerView addSubview:self.collectionView];
        self.tuijianHeadereView = headerView;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH, 40)];
        label1.font = XGEightBoldFontSize;
        label1.textColor = [UIColor colorWithHexString:@"#25262E"];
        label1.text = [NoticeTools getLocalStrWith:@"luy.tuijian"];
        [headerView addSubview:label1];
        

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"REFRESHUUSERINFOFORNOTICATION" object:nil];
        
        self.dataArr = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] init];

        self.tableView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, self.keyView.frame.size.height-50-BOTTOM_HEIGHT-20-40);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[NoticeCustumeMusiceCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.rowHeight = 56;
        [self.keyView addSubview:self.tableView];
        
        self.tableView.tableHeaderView = headerView;
        
        self.userM = [NoticeSaveModel getUserInfo];
        
        [self createRefesh];
        self.isDown = YES;
        self.pageNo = 1;
        [self requestMusiceList];
        [self requestBgm];
        
        UIView *headerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
        label2.font = XGEightBoldFontSize;
        label2.text = [NoticeTools getLocalStrWith:@"tabbar.mine"];
        label2.textColor = [UIColor colorWithHexString:@"#25262E"];
        [headerView1 addSubview:label2];
        self.sectionView = headerView1;
    }
    return self;
}

- (void)setCurrentStatus:(NSInteger)currentStatus{
    _currentStatus = currentStatus;
    self.tableView.bounces = NO;
    [self.inputField resignFirstResponder];
    if (currentStatus == 0) {
        self.tableView.bounces = YES;
        self.titleL.text = [NoticeTools getLocalStrWith:@"luy.choiceBGM"];
        self.tableView.tableHeaderView = self.tuijianHeadereView;
        self.howButton.hidden = YES;
        self.cancelButton.hidden = NO;
        self.backButton.hidden = YES;
        self.addButton.hidden = NO;
    }else if (currentStatus == 1){
        self.addButton.hidden = YES;
        self.titleL.text = [NoticeTools getLocalStrWith:@"luy.addBGN"];
        self.howButton.hidden = NO;
        self.cancelButton.hidden = YES;
        self.tableView.tableHeaderView = self.addHeaderView;
        self.backButton.hidden = NO;
    }else if (currentStatus == 2){
        self.backButton.hidden = NO;
        self.addButton.hidden = YES;
        self.howButton.hidden = YES;
        self.cancelButton.hidden = YES;
        self.tableView.tableHeaderView = self.howHeaderView;
        self.titleL.text = [NoticeTools getLocalStrWith:@"songList.how"];
    }
    [self.audioPlayer stopPlaying];
    [self.tableView reloadData];
}

- (void)howClick{
    self.currentStatus = 2;
}

- (void)addClick{
    self.currentStatus = 1;
}

- (void)backClick{
    if (self.currentStatus > 0) {
        self.currentStatus = self.currentStatus-1;
    }
}

- (UIView *)howHeaderView{
    if (!_howHeaderView) {
        _howHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 690+40)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-318)/2, 20, 318, 690)];
        [_howHeaderView addSubview:imageView];
        
        imageView.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"ly_howimg"]);
    }
    return _howHeaderView;
}

- (UIView *)addHeaderView{
    if (!_addHeaderView) {
        _addHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 90)];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20,20, DR_SCREEN_WIDTH-20-20-40-10, 40)];
        backV.layer.cornerRadius = 20;
        backV.layer.masksToBounds = YES;
        backV.layer.borderColor = [UIColor colorWithHexString:@"#5C5F66"].CGColor;
        backV.layer.borderWidth = 1;
        [_addHeaderView addSubview:backV];
        
        self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(10,2,backV.frame.size.width-20, 36)];
        self.inputField.font = FOURTHTEENTEXTFONTSIZE;
        self.inputField.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.inputField.tintColor = [UIColor colorWithHexString:@"#0099E6"];
        [backV addSubview:self.inputField];
        self.inputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"songList.copy"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1]}];
        self.inputField.delegate = self;
        
        UIButton *downBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backV.frame)+10, backV.frame.origin.y, 40, 40)];
        [downBtn setImage:UIImageNamed(@"ly_download") forState:UIControlStateNormal];
        [downBtn addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
        [_addHeaderView addSubview:downBtn];
        
        self.erroL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backV.frame)+8, DR_SCREEN_WIDTH-30, 14)];
        self.erroL.textColor = [[UIColor colorWithHexString:@"#EE4B4E"] colorWithAlphaComponent:1];
        self.erroL.font = ELEVENTEXTFONTSIZE;
        [_addHeaderView addSubview:self.erroL];
        
    }
    return _addHeaderView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self.keyView addSubview:_backButton];
        _backButton.hidden = YES;
    }
    return _backButton;
}

- (void)downClick{
    if (!self.inputField.text.length) {
        self.erroL.text = [NoticeTools getLocalStrWith:@"songList.pleasecopy"];
        return;
    }
    [self.showView show];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"checkMusic" Accept:nil isPost:0 parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self addMusic];
        }else{
            [self.showView disMiss];
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
        [self.showView disMiss];
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
        [self.showView disMiss];
        self.inputField.text = @"";
    } fail:^(NSError * _Nullable error) {
        [self.showView disMiss];
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


- (void)createRefesh{
    
    __weak NoticeChoiceBgmTypeView *ctl = self;
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
    if (self.currentStatus == 2) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    NSString *url = @"";
    if (self.isDown) {
        [self.audioPlayer stopPlaying];
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

        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.currentStatus == 2 || self.userM.level.intValue < 1) {
        return 0;
    }
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCustumMusiceModel *model = self.dataArr[indexPath.row];
    [self clickWith:model];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && self.currentStatus == 0) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.currentStatus > 0) {
        return [UIView new];
    }
    return self.sectionView;
}

- (void)clickWith:(NoticeCustumMusiceModel*)curM{
    NoticeCustumMusiceModel *model = curM;

    if (model.status < 1) {//没有播放则执行播放
        self.currentModel.isSelect = NO;
        self.currentModel.status = 0;
        [self.audioPlayer stopPlaying];
        [self.showView show];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"parsingMusic/%@/1",model.songId] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeCustumMusiceModel *cuM = [NoticeCustumMusiceModel mj_objectWithKeyValues:dict[@"data"]];
                model.song_url = cuM.songUrl;
                [self.audioPlayer startPlayWithUrl:model.song_url isLocalFile:NO];
                model.status = 1;
                model.isSelect = YES;
                self.currentModel = model;
                [self.tableView reloadData];
                [self.collectionView reloadData];
            }
            [self.showView disMiss];
        } fail:^(NSError * _Nullable error) {
            [self.showView disMiss];
        }];
    }else if (self.currentModel.status == 1){//播放中，则执行暂停
        self.currentModel.status = 2;
        [self.audioPlayer pause:YES];
        [self.tableView reloadData];

    }else if (self.currentModel.status == 2){//暂停中，则执行播放
        self.currentModel.status = 1;
        [self.audioPlayer pause:NO];
        [self.tableView reloadData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTextZJMusicModel *model = self.tuiArr[indexPath.row];
    if (!model.isSelect) {
        self.currentMusicModel.isSelect = NO;
        self.currentMusicModel.isPlaying = NO;
        [self.audioPlayer stopPlaying];
        
        [self.audioPlayer startPlayWithUrl:model.bgmM.audio_url isLocalFile:NO];
        
        model.isSelect = YES;
        model.isPlaying = YES;
        self.currentMusicModel = model;
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }else{
        self.currentMusicModel.isPlaying = !self.currentMusicModel.isPlaying;
        [self.audioPlayer pause:!self.currentMusicModel.isPlaying];
        [self.collectionView reloadData];
    }
}

- (void)refreshCell{
    self.currentModel.isSelect = NO;
    self.currentModel.status = 0;
    self.currentMusicModel.isSelect = NO;
    self.currentMusicModel.isPlaying = NO;
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCustumeMusiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isAddToMusicList = NO;
    cell.isSend = YES;
    cell.musicModel = self.dataArr[indexPath.row];
    cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    __weak typeof(self) weakSelf = self;
    
    cell.deletesMusicBlock = ^(NoticeCustumMusiceModel * _Nonnull model) {
        [weakSelf deleteMusicM:model];
    };
    
    cell.useMusicBlock = ^(NoticeCustumMusiceModel * _Nonnull model) {
        [weakSelf.showView show];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"parsingMusic/%@/1",model.songId] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeCustumMusiceModel *cuM = [NoticeCustumMusiceModel mj_objectWithKeyValues:dict[@"data"]];
                model.song_url = cuM.songUrl;
                if (weakSelf.useMusicBlock) {
                    weakSelf.useMusicBlock(model.song_url, model.songId,2,model.song_tile);
                }
                [weakSelf.audioPlayer stopPlaying];
                [weakSelf cancelClick];
            }
            [weakSelf.showView disMiss];
        } fail:^(NSError * _Nullable error) {
            [weakSelf.showView disMiss];
        }];
    };

    return cell;
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeBgmTypeCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.model = self.tuiArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    merchentCell.useMusicBlock = ^(NoticeTextZJMusicModel * _Nonnull model) {
        if (weakSelf.useMusicBlock) {
            weakSelf.useMusicBlock(model.bgmM.audio_url, model.bgmM.bgmId,1,model.bgmM.tips);
        }
        [weakSelf.audioPlayer stopPlaying];
        [weakSelf cancelClick];
    };
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.tuiArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-60)/2,68);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15,20,15,20);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)deleteMusicM:(NoticeCustumMusiceModel *)model{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"songList.suredele"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf.showView show];
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
                [weakSelf.showView disMiss];
            } fail:^(NSError * _Nullable error) {
                [weakSelf.showView disMiss];
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
               
            }
        };
        _audioPlayer.playComplete = ^{
            weakSelf.currentModel.isSelect = NO;
            weakSelf.currentModel.status = 0;
            weakSelf.currentMusicModel.isSelect = NO;
            weakSelf.currentMusicModel.isPlaying = NO;
            [weakSelf.tableView reloadData];
            [weakSelf.collectionView reloadData];
        };
    }
    return _audioPlayer;
}

- (void)refresh{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            if (userIn.token) {
                [NoticeSaveModel saveToken:userIn.token];
            }
            [NoticeSaveModel saveUserInfo:userIn];
            self.userM = userIn;
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)requestBgm{
    self.tuiArr = [[NSMutableArray alloc] init];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"bgms" Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeTextZJMusicModel *model = [NoticeTextZJMusicModel mj_objectWithKeyValues:dic];
                model.hasListen =  [NoticeComTools getHasbmgMp4:model.bgmM.bgmId];
                if (self.tuiArr.count < 4) {
                    [self.tuiArr addObject:model];
                }
                
                [self.collectionView reloadData];
            }
        }
    } fail:^(NSError * _Nullable error) {
        
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
    [self.audioPlayer stopPlaying];
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

- (void)setUserM:(NoticeUserInfoModel *)userM{
    _userM = userM;
    if (_userM.level.intValue < 1) {
        [self.addButton removeFromSuperview];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 160)];
        self.tableView.tableFooterView = footView;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2, 0, 335, 160)];
        [footView addSubview:imageView];
        imageView.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"ly_footerLevel"]);
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payClick)];
        [imageView addGestureRecognizer:tap];
    }else{
        [self.addButton removeFromSuperview];
        [self.keyView addSubview:self.addButton];
        self.tableView.tableFooterView = nil;
    }
}

- (void)payClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // iTunesConnect 苹果后台配置的产品ID
//    [NoticeSaveModel clearPayInfo];
//    NoticePaySaveModel *payInfo = [[NoticePaySaveModel alloc] init];
//    payInfo.productId = @"com.gmdoc.xi";
//    payInfo.userId = [NoticeTools getuserId];
//    [NoticeSaveModel savePayInfo:payInfo];
    [appdel.payManager startPurchWithID:@"com.gmdoc.xi" money:nil toUserId:[NoticeTools getuserId] userNum:nil isNiming:nil completeHandle:^(SIAPPurchType type, NSData *data) {
                            
    }];
}
@end
