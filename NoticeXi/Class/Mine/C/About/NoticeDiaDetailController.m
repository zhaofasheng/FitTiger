//
//  NoticeDiaDetailController.m
//  NoticeXi
//
//  Created by li lei on 2021/4/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDiaDetailController.h"
#import "NoticeAddZjController.h"
#import "NoticeSayToSelfCell.h"
#import "NoticeZjDialogModel.h"
@interface NoticeDiaDetailController ()<LCActionSheetDelegate,NoticeSayToSelfClickDelegate,TZImagePickerControllerDelegate,NoticeMovieZjChatDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UIView *titleHeadView;
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) NoticeSayToSelf *oldModel;
@property (nonatomic, strong) UIImageView *zJimageView;
@property (nonatomic, strong) UILabel *zjNameL;
@property (nonatomic, strong) UILabel *numL;
@end

@implementation NoticeDiaDetailController

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
    [self.audioPlayer stopPlaying];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isReplay = YES;
    self.pageNo = 1;
    
    [self.navBarView.rightButton setImage:UIImageNamed(@"morebuttonimg") forState:UIControlStateNormal];
    [self.navBarView.rightButton addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self.tableView registerClass:[NoticeSayToSelfCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    self.tableView.rowHeight = 85;
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    
    self.tableView.tableHeaderView = self.sectionView;
    [self.tableView.mj_header beginRefreshing];
    
    self.needBackGroundView = YES;
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    
    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    [iamgeView sd_setImageWithURL:[NSURL URLWithString:self.zjModel.album_cover_url] placeholderImage:UIImageNamed(@"Image_addzjdefault")];
    iamgeView.contentMode = UIViewContentModeScaleAspectFill;
    iamgeView.clipsToBounds = YES;
 
    UIView *fgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    fgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [iamgeView addSubview:fgView];
    self.zJimageView = iamgeView;
    [self.view addSubview:iamgeView];
    
    [self.view sendSubviewToBack:self.zJimageView];
}

- (void)createRefesh{
    
    __weak NoticeDiaDetailController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl requestList];
    }];
    
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl requestList];
    }];
}


- (void)requestList{
    NSString *url = nil;
    if (!self.isDown) {
        url = [NSString stringWithFormat:@"dialogAlbums/%@/dialog?pageNo=%ld",self.zjModel.albumId,self.pageNo];
    }else{
       url= [NSString stringWithFormat:@"dialogAlbums/%@/dialog?pageNo=1",self.zjModel.albumId];
    }

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
                self.isPushMoreToPlayer = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeZjDialogModel *diaLogM = [NoticeZjDialogModel mj_objectWithKeyValues:dic];
                NoticeSayToSelf *selfM = [[NoticeSayToSelf alloc] init];
                selfM.created_at = diaLogM.created_at;
                selfM.deleteId = diaLogM.collictionId;
                selfM.note_url = diaLogM.resource_url;
                selfM.note_len = diaLogM.resource_len;
                selfM.noteId = diaLogM.dialog_id;
                selfM.source_type = diaLogM.source_type;
                [self.dataArr addObject:selfM];
            }
            if (self.dataArr.count) {
                NoticeSayToSelf *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.noteId;
            }
  
            if ([NoticeTools isFirstknowdhdeledhOnThisDeveice] && self.dataArr.count) {
                self.sectionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+147);
                [self.titleHeadView removeFromSuperview];
                [self.sectionView addSubview:self.titleHeadView];
            }
            if (!self.dataArr.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
 
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = YES;
    [self.audioPlayer pause:self.isPasue];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    // 跳转
    [self.audioPlayer.player seekToTime:CMTimeMake(dratNum, 1) completionHandler:^(BOOL finished) {
        if (finished) {
        }
    }];
}

- (void)userstartRePlayer:(NSInteger)tag{
    [self.audioPlayer stopPlaying];
    //self.audioPlayer = nil;
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    [self userstartPlayAndStop:tag];
}

- (void)userstartPlayAndStop:(NSInteger)tag{
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        if (self.dataArr.count && self.oldModel) {
            NoticeSayToSelf *oldM = self.oldModel;
            oldM.nowTime = oldM.note_len;
            oldM.nowPro = 0;
            [self.tableView reloadData];
        }
        
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }
    
    NoticeSayToSelf *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.note_url isLocalFile:NO];
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
        model.nowPro = 0;
        //weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        [weakSelf.tableView reloadData];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        NoticeSayToSelfCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.note_len.integerValue) {
            currentTime = model.note_len.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.note_len.integerValue-currentTime] isEqualToString:@"0"]||[[NSString stringWithFormat:@"%.f",model.note_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.note_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.note_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.note_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            if ((model.note_len.integerValue-currentTime)<-3) {
                [weakSelf.audioPlayer stopPlaying];
            }
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.note_len.integerValue-currentTime];
        cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.note_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.note_len.integerValue-currentTime];
        model.nowPro = currentTime/model.note_len.floatValue;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSayToSelfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isDiaLog = YES;
    cell.needLongTap = YES;
    cell.sayModel = self.dataArr[indexPath.row];
    cell.delegate = self;
    cell.index = indexPath.row;
    [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UIView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,NAVIGATION_BAR_HEIGHT+91)];
        _sectionView.userInteractionEnabled = YES;
       
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 22+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-20-30, 30)];
        self.zjNameL = label;
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.font = XGTwentyTwoBoldFontSize;
        [_sectionView addSubview:label];
        
        self.zjNameL.text = self.zjModel.album_name;
        
        CGFloat width = GET_STRWIDTH(self.zjNameL.text, 23, 30);
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20+width,27+NAVIGATION_BAR_HEIGHT, 20, 20)];
        imageV.image = UIImageNamed(@"Image_zjsuo");
        [_sectionView addSubview:imageV];
        
        UILabel *numlabel = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(label.frame)+4, DR_SCREEN_WIDTH-20, 20)];
        numlabel.text = [NSString stringWithFormat:@"%@%@",self.zjModel.dialog_num,[NoticeTools getLocalStrWith:@"zj.num"]];
        numlabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        numlabel.font = FOURTHTEENTEXTFONTSIZE;
        [_sectionView addSubview:numlabel];
        self.numL = numlabel;
    }
    return _sectionView;
}

- (UIView *)titleHeadView{
    if (!_titleHeadView) {
        _titleHeadView = [[UIView alloc] initWithFrame:CGRectMake(20,NAVIGATION_BAR_HEIGHT+91, DR_SCREEN_WIDTH-40, 41)];
        _titleHeadView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
        _titleHeadView.layer.cornerRadius = 5;
        _titleHeadView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,DR_SCREEN_WIDTH-50, 40)];
        label.font = TWOTEXTFONTSIZE;
        label.text = [NoticeTools getLocalStrWith:@"zj.daimark"];
        label.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.7];
        label.numberOfLines = 0;

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg) {
            _titleHeadView.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0.2];
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_titleHeadView.frame.size.width-5-40, 0, 43, 40)];
        [button setImage:UIImageNamed(appdel.backImg?@"Image_sendXXtm": @"Image_sendXX") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickXX) forControlEvents:UIControlEventTouchUpInside];
        [_titleHeadView addSubview:button];
        [_titleHeadView addSubview:label];
    }
    return _titleHeadView;
}

- (void)clickXX{
    [NoticeTools setMarkForknowdeledh];

    [self.titleHeadView removeFromSuperview];
    self.sectionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+91);
    [self.tableView reloadData];
}

- (NoticeNoDataView *)footView{
    if (!_footView) {
        _footView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.sectionView.frame.size.height)];

        _footView.titleL.text = [NoticeTools chinese:@"欸 这里空空的" english:@"Nothing yet" japan:@"まだ何もありません"];
        _footView.titleL.frame = CGRectMake(0, (_footView.frame.size.height-20)/2-56, DR_SCREEN_WIDTH, 20);
        _footView.titleL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        
        _footView.actionButton.titleLabel.font = EIGHTEENTEXTFONTSIZE;
        [_footView.actionButton setTitle:[NoticeTools getLocalStrWith:@"zj.howadd"] forState:UIControlStateNormal];
        _footView.actionButton.frame = CGRectMake((DR_SCREEN_WIDTH-240)/2,CGRectGetMaxY(_footView.titleL.frame)+20, 240, 56);
        _footView.actionButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [_footView.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footView.actionButton addTarget:self action:@selector(knowTap) forControlEvents:UIControlEventTouchUpInside];

    }
    return _footView;
}

- (void)knowTap{
    XLAlertView *alertView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"zj.abouthow"] message:nil cancleBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"]];
    [alertView showXLAlertView];
}

- (void)moreBtnClick{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"zj.editzj"],[NoticeTools getLocalStrWith:@"zj.changeback"],[NoticeTools getLocalStrWith:@"groupManager.del"]]];
    sheet.delegate = self;
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NoticeAddZjController *ctl = [[NoticeAddZjController alloc] init];
        ctl.isEditAblum = YES;
        ctl.isDiaAblum = YES;
        ctl.zjmodel = self.zjModel;
        __weak typeof(self) weakSelf = self;
        ctl.editSuccessBlock = ^(NoticeZjModel * _Nonnull zjmodel) {
            weakSelf.zjModel = zjmodel;
            weakSelf.zJimageView.image = zjmodel.image;
            weakSelf.zjNameL.text = weakSelf.zjModel.album_name;
            if (weakSelf.editSuccessBlock) {
                weakSelf.editSuccessBlock(weakSelf.zjModel);
                
            }
        };
        ctl.deleteSuccessBlock = ^(NoticeZjModel * _Nonnull zjmodel) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if (weakSelf.deleteSuccessBlock) {
                weakSelf.deleteSuccessBlock(zjmodel.albumId);
            }
            
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if(buttonIndex == 3){
        //在这里添加点击事件
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"zj.delthiszj"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.del"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"dialogAlbums/%@",self.zjModel.albumId] Accept:@"application/vnd.shengxi.v4.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if (success) {
                        [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
                 
                        if (weakSelf.deleteSuccessBlock) {
                            weakSelf.deleteSuccessBlock(weakSelf.zjModel.albumId);
                        }
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                    [weakSelf hideHUD];
                } fail:^(NSError * _Nullable error) {
                    [weakSelf hideHUD];
                }];
            }
        };
        [alerView showXLAlertView];
    }else if (buttonIndex == 2){
        [self changeBack];
    }
}

- (void)deleteVoiceWithModel:(NoticeSayToSelf *)model{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"py.issueredel"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"main.sure"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            //在这里添加点击事件
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"albumDialogs/%@",model.deleteId] Accept:@"application/vnd.shengxi.v4.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"emtion.deleSuc"]];
                    for (NoticeSayToSelf *oldM in weakSelf.dataArr) {
                        if ([oldM.deleteId isEqualToString:model.deleteId]) {
                            if (oldM.isPlaying) {
                                [weakSelf.audioPlayer stopPlaying];
                                weakSelf.isReplay = YES;
                            }
                            [weakSelf.dataArr removeObject:oldM];
                            break;
                        }
                    }
                    weakSelf.zjModel.dialog_num = [NSString stringWithFormat:@"%d",weakSelf.zjModel.dialog_num.intValue-1];
                    weakSelf.numL.text = [NSString stringWithFormat:@"%@%@",weakSelf.zjModel.dialog_num,[NoticeTools getLocalStrWith:@"zj.numvoice"]];
                    [weakSelf.tableView reloadData];
                }
                [weakSelf hideHUD];
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
}

- (void)moveVoiceWithModel:(NoticeSayToSelf *)model{
    NoticeZjListView* _listView = [[NoticeZjListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT) isLimit:YES];
    _listView.dialogId = model.noteId;
    _listView.currentAlbumId = self.zjModel.albumId;
    _listView.delegate = self;
    _listView.isGroup = model.source_type;
    _listView.isMove = YES;
    [_listView show];
}

- (void)moveAndCreateNewdiaiD:(NSString *)dialogId parm:(NSMutableDictionary *)parm{
    NoticeSayToSelf *reM = nil;
    for (NoticeSayToSelf *oldM in self.dataArr) {
        if ([oldM.noteId isEqualToString:dialogId]) {
            reM = oldM;
            break;
        }
    }
    if (reM.source_type) {
        [parm setObject:reM.source_type forKey:@"sourceType"];
    }else{
        [parm setObject:@"1" forKey:@"sourceType"];
    }
    
    [self showHUD];
    NSString *url = nil;
    url = [NSString stringWithFormat:@"albumDialogs/%@",reM.deleteId];
    [[DRNetWorking shareInstance]requestWithDeletePath:url Accept:@"application/vnd.shengxi.v4.3+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"dialogAlbums" Accept:@"application/vnd.shengxi.v4.7.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    [self showToastWithText:[NoticeTools getLocalStrWith:@"zj.hasduih"]];
                }
                [self hideHUD];
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
            [self.dataArr removeObject:reM];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)moveToZjId:(NSString *)zjId diaiD:(nonnull NSString *)dialogId{
    NoticeSayToSelf *reM = nil;
    for (NoticeSayToSelf *oldM in self.dataArr) {
        if ([oldM.noteId isEqualToString:dialogId]) {
            reM = oldM;
            break;
        }
    }
   
    [self showHUD];
    NSString *url = nil;
    url = [NSString stringWithFormat:@"albumDialogs/%@",reM.deleteId];
    [[DRNetWorking shareInstance]requestWithDeletePath:url Accept:@"application/vnd.shengxi.v4.3+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self moveDialId:reM.noteId toAlumId:zjId isGroup:reM.source_type.intValue == 2?YES:NO];
            [self.dataArr removeObject:reM];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}
- (void)moveDialId:(NSString *)dialogId toAlumId:(NSString *)alumId isGroup:(BOOL)isGroup{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setValue:dialogId forKey:@"dialogId"];
    [parm setValue:isGroup?@"2":@"1" forKey:@"sourceType"];
    [self showHUD];
    NSString *url = nil;
    url = [NSString stringWithFormat:@"albumDialogs/%@",alumId];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.7.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            [self showToastWithText:[NoticeTools getLocalStrWith:@"zj.hasduih"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;//关闭右滑返回

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;//开启右滑返回
}

- (void)changeBack{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = false;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = false;
    imagePicker.allowCrop = true;
    imagePicker.cropRect = CGRectMake(0,(DR_SCREEN_HEIGHT-DR_SCREEN_WIDTH)/2,DR_SCREEN_WIDTH,DR_SCREEN_WIDTH);
    [self presentViewController:imagePicker animated:YES completion:nil];

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
            filePath = [NSString stringWithFormat:@"%@-%u",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99098999];
            [self upLoadHeader:choiceImage path:filePath];
        }else{
            [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
        }
    }];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }

    [self.tableView reloadData];
    NSString *iamgeP = [NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"18" forKey:@"resourceType"];
    [parm1 setObject:iamgeP forKey:@"resourceContent"];
    [self showHUD];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:Message forKey:@"albumCoverUri"];
       
            [parm setObject:bucketId?bucketId:@"0" forKey:@"bucketId"];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"dialogAlbums/%@",self.zjModel.albumId] Accept:@"application/vnd.shengxi.v4.3+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    self.zJimageView.image = image;
    
                    if (self.editSuccessBlock) {
                        self.editSuccessBlock(self.zjModel);
                        
                    }
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self hideHUD];
            [self showToastWithText:Message];
        }
    }];
}
@end
