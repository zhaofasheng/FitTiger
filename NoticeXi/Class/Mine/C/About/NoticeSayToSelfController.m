//
//  NoticeSayToSelfController.m
//  NoticeXi
//
//  Created by li lei on 2019/7/9.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSayToSelfController.h"
#import "NoticeSayToSelfCell.h"
#import "DDHAttributedMode.h"
@interface NoticeSayToSelfController ()<NoticeSayToSelfClickDelegate,NoticeRecordDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeSayToSelf *oldModel;
@end

@implementation NoticeSayToSelfController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"ly.title"]:@"過往留言";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRefesh];
    self.dataArr = [NSMutableArray new];
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerClass:[NoticeSayToSelfCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.frame = CGRectMake(0, 1+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-44-BOTTOM_HEIGHT-25-1);
    self.tableView.rowHeight = 85;
    
    UIButton *sayBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH-30, 44)];
    sayBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    sayBtn.layer.cornerRadius = 22;
    sayBtn.layer.masksToBounds = YES;
    [sayBtn setTitle:[NoticeTools getLocalStrWith:@"more.saytoself"] forState:UIControlStateNormal];
    sayBtn.titleLabel.font = XGEightBoldFontSize;
    [sayBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [sayBtn addTarget:self action:@selector(sayClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sayBtn];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)sayClick{
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    recodeView.isSayToSelf = YES;
    recodeView.hideCancel = NO;
    recodeView.isReply = YES;
    recodeView.delegate = self;
    [recodeView show];
}

- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"13" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            NSMutableDictionary *parm = [NSMutableDictionary new];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            [parm setObject:Message forKey:@"noteUri"];
            [parm setObject:timeLength forKey:@"noteLen"];
            [self showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voice/%@/note",self.voiceId] Accept:@"application/vnd.shengxi.v3.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                [self.tableView.mj_header beginRefreshing];
                self.choiceM.note_num = [NSString stringWithFormat:@"%ld",self.choiceM.note_num.integerValue+1];
                if (self.choiceBlock) {
                    self.choiceBlock(self.choiceM);
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
    cell.sayModel = self.dataArr[indexPath.row];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
    cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
    [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeSayToSelf *sys = self.dataArr[indexPath.row];
    __weak NoticeSayToSelfController *ctl = self;
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:[NoticeTools getLocalStrWith:@"groupManager.del"]handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:[NoticeTools getLocalStrWith:@"ly.suredel"] cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //在这里添加点击事件
                [ctl showHUD];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"voice/%@/note/%@",ctl.voiceId,sys.noteId] Accept:@"application/vnd.shengxi.v3.6+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                    [ctl hideHUD];
                    if (success) {
                        [ctl.dataArr removeObjectAtIndex:indexPath.row];
                        [ctl.tableView reloadData];
                        self.choiceM.note_num = [NSString stringWithFormat:@"%ld",self.choiceM.note_num.integerValue-1];
                        if (!self.dataArr.count) {
                            self.choiceM.note_num = @"0";
                        }
                        if (self.choiceBlock) {
                            self.choiceBlock(self.choiceM);
                        }
                        if (!self.dataArr.count) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                } fail:^(NSError *error) {
                    [ctl hideHUD];
                }];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"groupManager.del"]]];
        [sheet show];
        
    }];
    deleteRowAction.backgroundColor = self.view.backgroundColor;
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction];
}

- (void)deleteVoiceSelf:(NSInteger)index{
    NoticeSayToSelf *sys = self.dataArr[index];
    __weak NoticeSayToSelfController *ctl = self;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:[NoticeTools getLocalStrWith:@"ly.suredel"] cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            //在这里添加点击事件
            [ctl showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"voice/%@/note/%@",ctl.voiceId,sys.noteId] Accept:@"application/vnd.shengxi.v3.6+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [ctl hideHUD];
                if (success) {
                    [ctl.dataArr removeObjectAtIndex:index];
                    [ctl.tableView reloadData];
                    self.choiceM.note_num = [NSString stringWithFormat:@"%ld",self.choiceM.note_num.integerValue-1];
                    if (!self.dataArr.count) {
                        self.choiceM.note_num = @"0";
                    }
                    if (self.choiceBlock) {
                        self.choiceBlock(self.choiceM);
                    }
                    if (!self.dataArr.count) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            } fail:^(NSError *error) {
                [ctl hideHUD];
            }];
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"groupManager.del"]]];
    [sheet show];
}

- (void)createRefesh{
    
    __weak NoticeSayToSelfController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"voice/%@/note",self.voiceId];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"voice/%@/note?lastId=%@",self.voiceId,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"voice/%@/note",self.voiceId];
        }
        
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v3.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeSayToSelf *model = [NoticeSayToSelf mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeSayToSelf *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.noteId;
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
@end
