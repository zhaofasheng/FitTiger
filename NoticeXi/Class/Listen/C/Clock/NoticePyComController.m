//
//  NoticePyComController.m
//  NoticeXi
//
//  Created by li lei on 2020/11/24.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticePyComController.h"
#import "NoticeChatTitleView.h"
#import "NoticeWhitePyCell.h"
#import "NoticeBBSComentCell.h"
@interface NoticePyComController ()<NoticewhiteClockClickDelegate,NoticeBBSComentInputDelegate>
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSMutableArray *comArr;
@property (nonatomic, strong) NoticeBBSComentInputView *inputView;
@property (nonatomic, strong) NoticeBBSComentInputView *replyView;
@property (nonatomic, strong) UIView *titleHeadView;
@property (nonatomic, strong) NoticeClockPyModel *oldModel;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation NoticePyComController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.inputView showJustComment:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.inputView.contentView resignFirstResponder];
    [self.inputView clearView];
    [self.replyView.contentView resignFirstResponder];
    [self.replyView clearView];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    [self.audioPlayer stopPlaying];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"py.pydetail"];
        
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-0.5-50-BOTTOM_HEIGHT);
    [self.tableView registerClass:[NoticeWhitePyCell class] forCellReuseIdentifier:@"pyCell"];
    [self.tableView registerClass:[NoticeBBSComentCell class] forCellReuseIdentifier:@"comentCell"];
    
    self.dataArr = [NSMutableArray new];
    
    if (self.pyMOdel) {
        [self.dataArr addObject:self.pyMOdel];
    }
    
    self.floatView.hidden = YES;
    
    self.comArr = [NSMutableArray new];
    
    if (!self.jubaoComM) {//来自举报就不需要输入框
       [self createRefesh];
        if (self.pyId) {
            self.pyMOdel = [NoticeClockPyModel new];
            self.pyMOdel.pyId = self.pyId;
            [self getPy];
        }
        if ([NoticeTools isFirstknowpeiypinglOnThisDeveice]) {
            self.titleHeadView.hidden = NO;
            self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+50, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-0.5-50-BOTTOM_HEIGHT-50);
        }else{
            self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+10, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-0.5-50-BOTTOM_HEIGHT-10);
        }
        
        [self.tableView.mj_header beginRefreshing];
        self.inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        self.inputView.delegate = self;
        self.inputView.limitNum = 50;
        self.inputView.ispy = YES;
        self.inputView.plaStr = [NoticeTools getLocalStrWith:@"py.wantsay"];
        if (!self.pyMOdel.comArr.count && !self.pyId && !self.noBecomFirst  && !self.pyMOdel.comment_num.intValue ) {
            [self.inputView.contentView becomeFirstResponder];
        }
        
        if (self.pyMOdel) {
            if (self.pyMOdel.is_anonymous.boolValue) {
                [self.inputView.contentView resignFirstResponder];
                self.inputView.hidden = YES;
            }
        }
        self.inputView.saveKey = [NSString stringWithFormat:@"pycom%@%@",[NoticeTools getuserId],self.pyMOdel.dubbing_id.intValue?self.pyMOdel.dubbing_id:self.pyMOdel.pyId];
        self.inputView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.inputView.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.inputView.frame.size.height);
        UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT- BOTTOM_HEIGHT, DR_SCREEN_WIDTH, BOTTOM_HEIGHT)];
        bottomV.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.view addSubview:bottomV];
        
    }else{
        [self.comArr addObject:self.jubaoComM];
        [self.tableView reloadData];
        if (self.type.intValue == 132) {
            self.jubaoComM.comment_status = self.jubaoComM.replyM.comment_status;
        }
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        [self.deleteBtn setTitle:self.jubaoComM.comment_status.intValue == 1?[NoticeTools getLocalStrWith:@"groupManager.del"]:[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.deleteBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        [self.view addSubview:self.deleteBtn];
        [self.deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.isPicker) {

        self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"py.todaypicker"];
        UILabel *headL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
        headL.font = TWOTEXTFONTSIZE;
        headL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        headL.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableHeaderView = headL;
        self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"dubbings/%@/pickStatus",self.pyId] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dict[@"data"]];
                if (model.pick_status.intValue == 2) {
                    headL.text = [NoticeTools getLocalStrWith:@"py.showpicked"];
                }else{
                    headL.text = [NoticeTools getLocalStrWith:@"py.showpick"];
                }
            }
        } fail:^(NSError * _Nullable error) {
        }];
    }
    
    if (self.autoPlay) {
        [self startPlayAndStop:0];
    }
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
    [self.audioPlayer stopPlaying];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.inputView.contentView resignFirstResponder];
}


- (void)deleteClick{
    if (self.jubaoComM.comment_status.intValue == 1) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"py.issueredel"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:self.managerCode?self.managerCode:@"0" forKey:@"confirmPasswd"];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/dubbingComment/%@",(weakSelf.type.intValue == 132)?weakSelf.jubaoComM.replyM.commentId: weakSelf.jubaoComM.commentId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [weakSelf hideHUD];
                    if (success) {
                        weakSelf.jubaoComM.comment_status = @"2";
                        [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"emtion.deleSuc"]];
                        [weakSelf.deleteBtn setTitle:[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
                    }
                } fail:^(NSError * _Nullable error) {
                    [weakSelf hideHUD];
                }];
            }
        };
        [alerView showXLAlertView];
    }
}

- (void)getPy{

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"dubbings/%@",self.pyId] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dict[@"data"]];
            self.pyMOdel = model;
            if (!self.pyMOdel.dubbing_len.intValue) {
                [UIView animateWithDuration:1 animations:^{
                    [self showToastWithText:[NoticeTools getLocalStrWith:@"py.thepyhasdel"]];
                } completion:^(BOOL finished) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                return;
            }
            if (self.pyMOdel.is_anonymous.boolValue) {
                [self.inputView.contentView resignFirstResponder];
                self.inputView.hidden = YES;
            }
            [self.dataArr addObject:self.pyMOdel];
            [self.tableView reloadData];
            [self.tableView.mj_header beginRefreshing];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)setPyMOdel:(NoticeClockPyModel *)pyMOdel{
    _pyMOdel = pyMOdel;
    self.inputView.saveKey = [NSString stringWithFormat:@"pycom%@%@",[NoticeTools getuserId],pyMOdel.dubbing_id.intValue?pyMOdel.dubbing_id:pyMOdel.pyId];
    
}

- (void)createRefesh{
    
    __weak NoticePyComController *ctl = self;
    
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
        ctl.isDown = NO;
        ctl.pageNo++;
        [ctl requestList];
    }];
}

- (void)requestList{
    if (self.pyMOdel.is_anonymous.intValue) {
        [self.comArr removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    NSString *url = @"";
    if (self.isDown) {
        url = [NSString stringWithFormat:@"dubbing/%@/comment?sortType=2",self.pyMOdel.dubbing_id.intValue?self.pyMOdel.dubbing_id: self.pyMOdel.pyId];
    }else{
        url = [NSString stringWithFormat:@"dubbing/%@/comment?lastId=%@&pageNo=%ld&sortType=2",self.pyMOdel.dubbing_id.intValue?self.pyMOdel.dubbing_id: self.pyMOdel.pyId,self.lastId,self.pageNo];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            
            if (self.isDown) {
                self.isDown = NO;
                [self.comArr removeAllObjects];
                self.pageNo = 1;
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeBBSComent *comM = [NoticeBBSComent mj_objectWithKeyValues:dic];
                [self.comArr addObject:comM];
            }
            if (self.comArr.count) {
                NoticeBBSComent *lastM = self.comArr[self.comArr.count-1];
                self.lastId = lastM.commentId;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//点击发送
- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:comment forKey:@"commentContent"];
    [parm setObject:self.pyMOdel.dubbing_id.intValue?self.pyMOdel.dubbing_id: self.pyMOdel.pyId forKey:@"dubbingId"];
    [parm setObject:commentId?commentId: @"0" forKey:@"commentId"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"dubbingComment" Accept:@"application/vnd.shengxi.v4.8.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if (!commentId) {
                [self showToastWithText:[NoticeTools getLocalStrWith:@"py.comsus"]];
                self.pyMOdel.comment_num = [NSString stringWithFormat:@"%d",self.pyMOdel.comment_num.intValue+1];
                [self.tableView reloadData];
                if (self.comArr.count < 10) {
                    self.isDown = YES;
                    [self requestList];
                }
            }else{
                NoticeMJIDModel *idModel = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
                NSMutableDictionary *reply = [NSMutableDictionary new];
                [reply setObject:idModel.allId forKey:@"id"];
                NSMutableDictionary *fromUser = [NSMutableDictionary new];
                [fromUser setObject:self.pyMOdel.pyUserInfo.nick_name forKey:@"nick_name"];
                [fromUser setObject:self.pyMOdel.pyUserInfo.user_id forKey:@"id"];
                [reply setObject:fromUser forKey:@"from_user_info"];
                [reply setObject:comment forKey:@"comment_content"];
                for (NoticeBBSComent *comM in self.comArr) {
                    if ([comM.commentId isEqualToString:commentId]) {
                        comM.reply = reply;
                        break;
                    }
                }
                [self.tableView reloadData];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArr.count;
    }
    return self.comArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NoticeWhitePyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pyCell"];
        cell.noNeedPush = YES;
        cell.index = indexPath.row;
        cell.isTcPage = NO;
        cell.playerView.tag = indexPath.row;
        cell.delegate = self;
        cell.pyModel = self.dataArr[indexPath.row];
        [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];

        __weak typeof(self) weakSelf = self;
        cell.setNimingBlock = ^(BOOL isNIming) {
            [weakSelf.comArr removeAllObjects];
            [weakSelf.tableView reloadData];
        };
        
        return cell;
    }else{
        NoticeBBSComentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comentCell"];
        cell.isSelfPy = [self.pyMOdel.pyUserInfo.user_id isEqualToString:[NoticeTools getuserId]]?YES:NO;
        cell.pyCommentM = self.comArr[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        cell.deleteBlock = ^(NoticeBBSComent * _Nonnull commentM) {
            for (NoticeBBSComent *comM in self.comArr) {
                if ([comM.commentId isEqualToString:commentM.commentId]) {
                    [self.comArr removeObject:comM];
                    break;
                }
            }
            weakSelf.pyMOdel.comment_num = [NSString stringWithFormat:@"%d",weakSelf.pyMOdel.comment_num.intValue-1];
            [weakSelf.tableView reloadData];
        };
        
        cell.deleteReplyBlock = ^(NoticeBBSComent * _Nonnull commentM) {
            [weakSelf.tableView reloadData];
        };
        return cell;
    }
}

- (void)delegateSuccess:(NSInteger)index{
    if (self.deletePyBlock && self.pyMOdel) {
        self.deletePyBlock(self.pyMOdel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NoticeBBSComent *model = self.comArr[indexPath.row];
        return 65+model.textHeight+10 + (model.reply?(model.replyM.replyTextHeight+40):5);
    }
    return 185+[self.dataArr[indexPath.row] contentHeight]+20+20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && [self.pyMOdel.pyUserInfo.user_id isEqualToString:[NoticeTools getuserId]]) {

        NoticeBBSComent *comM = self.comArr[indexPath.row];
        if (comM.reply) {
            return;
        }

        
        self.replyView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        _replyView.isHelp = YES;
        _replyView.needReplyL = YES;
        _replyView.limitNum = 50;
        _replyView.ispy = YES;
        _replyView.delegate = self;
        _replyView.plaStr = [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"py.whatyousay"] fantText:@"妳想說點啥"];
        self.replyView.saveKey = [NSString stringWithFormat:@"pycomreply%@%@%@",[NoticeTools getuserId],self.pyMOdel.dubbing_id.intValue?self.pyMOdel.dubbing_id:self.pyMOdel.pyId,comM.commentId];
        
        self.replyView.commentId = comM.commentId;
        [self.replyView showJustComment:comM.commentId];
        [self.replyView.contentView becomeFirstResponder];
        self.replyView.replyToView.replyLabel.text = [NSString stringWithFormat:@"回复 %@:%@",comM.userInfo.nick_name,comM.comment_content];
    }
}


- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro{
    self.progross = pro;
    self.tableView.scrollEnabled = YES;
    __weak typeof(self) weakSelf = self;
    [self.audioPlayer pause:NO];
    [self.audioPlayer.player seekToTime:CMTimeMake(self.draFlot, 1) completionHandler:^(BOOL finished) {
        if (finished) {
            weakSelf.progross = 0;
        }
    }];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    
    self.draFlot = dratNum;
}


#pragma Mark - 音频播放模块
- (void)startRePlayer:(NSInteger)tag{//重新播放
    [self.audioPlayer stopPlaying];
    //self.audioPlayer = nil;
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    [self startPlayAndStop:tag];
}
//播放暂停
- (void)startPlayAndStop:(NSInteger)tag{
    
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
        NoticeClockPyModel *oldM = self.pyMOdel;
         oldM.nowTime = oldM.dubbing_len;
         oldM.nowPro = 0;
         [self.tableView reloadData];
    }else{
        DRLog(@"点击的是当前视图");
    }
    
    NoticeClockPyModel *model = self.dataArr[tag];
    

    if (self.isReplay) {
        
        [self.audioPlayer startPlayWithUrl:model.dubbing_url isLocalFile:NO];
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
        weakSelf.lastPlayerTag = tag;
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:@"语音正在加载中，请耐心等一下哦~"];
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
        NoticeWhitePyCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.dubbing_len.integerValue) {
            currentTime = model.dubbing_len.integerValue;
        }
        
        if ([[NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.dubbing_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.dubbing_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.dubbing_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            if ((model.dubbing_len.integerValue-currentTime)<-3) {
                [weakSelf.audioPlayer stopPlaying];
            }
            weakSelf.audioPlayer.playComplete = ^{
                cell.playerView.timeLen = model.dubbing_len;
                cell.playerView.slieView.progress = 0;
                model.nowPro = 0;
                model.nowTime = model.dubbing_len;
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
                weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                [weakSelf.tableView reloadData];
           
                if (weakSelf.isrefreshNewToPlayer) {
                    weakSelf.isrefreshNewToPlayer = NO;
                }
            };
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime];
        cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.dubbing_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime];
        model.nowPro = currentTime/model.dubbing_len.floatValue;
    };
}

- (void)deleteSuccessFor:(NoticeClockPyModel *)deleM{
    NoticeClockPyModel *tcModel = deleM;
    if (tcModel.isPlaying) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.floatView.isPlaying) {
            appdel.floatView.noRePlay = YES;
            [appdel.floatView.audioPlayer stopPlaying];
        }
        
    }
    if (self.dataArr.count) {
        NSInteger num1 = 0;
        for (NoticeClockPyModel *tcM in self.dataArr) {
            if ([tcModel.tcId isEqualToString:tcM.tcId]) {
                if (self.dataArr.count >= num1+1) {
                    [self.dataArr removeObjectAtIndex:num1];
                }
                break;
            }
            num1++;
        }
    }
    [self.tableView reloadData];
}

- (void)backToPageAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)titleHeadView{
    if (!_titleHeadView) {
        
        _titleHeadView = [[UIView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 40)];
        _titleHeadView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        _titleHeadView.layer.cornerRadius = 5;
        _titleHeadView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,DR_SCREEN_WIDTH-60, 40)];
        label.font = TWOTEXTFONTSIZE;
        label.text = [NoticeTools getLocalStrWith:@"py.only"];
        label.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        label.numberOfLines = 0;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_titleHeadView.frame.size.width-5-40, 0, 43, 40)];
        [button setImage:UIImageNamed(@"Image_sendXXtm") forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(clickXX) forControlEvents:UIControlEventTouchUpInside];
        [_titleHeadView addSubview:button];
        [_titleHeadView addSubview:label];
        [self.view addSubview:_titleHeadView];
    }
    
    return _titleHeadView;
}

- (void)clickXX{
    [self.titleHeadView removeFromSuperview];
    [NoticeTools setMarkForknowpeiypingl];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+10, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-0.5-50-BOTTOM_HEIGHT);

}

@end
