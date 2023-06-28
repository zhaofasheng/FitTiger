//
//  NoticeQiaoqiaoController.m
//  NoticeXi
//
//  Created by li lei on 2023/3/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeQiaoqiaoController.h"
#import "NoticeQiaoCell.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeTextVoiceDetailController.h"

@interface NoticeQiaoqiaoController ()<NoticeQiaoqiaoDeledate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) BOOL needRed;
@property (nonatomic, strong,nullable) LGAudioPlayer *chatPlayer;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) NoticeStaySys *leaveChat;
@property (nonatomic, assign) NSInteger oldtag;
@property (nonatomic, strong) NoticeStaySys *oldChat;

@property (nonatomic, strong) NoticeStaySys *choiceChat;
@end

@implementation NoticeQiaoqiaoController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-40);
    self.dataArr = [NSMutableArray new];
    
    self.tableView.rowHeight = 68;
    [self.tableView registerClass:[NoticeQiaoCell class] forCellReuseIdentifier:@"cell1"];
    
    self.oldtag = 768;
    [self createRefesh];

    [self refreshChatList];

}

- (void)refreshChatList{
    self.isDown = YES;
    [self requestList];
}

- (void)refreshNoUnread{
    for (NoticeStaySys *model in self.dataArr) {
        model.un_read_num = @"0";
    }
    [self.tableView reloadData];
}

- (void)createRefesh{
    
    __weak NoticeQiaoqiaoController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestList];
    }];
    
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    _refreshHeader = header;
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestList];
    }];
}


- (void)requestList{
    
    NSString *url = nil;
    if (self.isDown) {
        url = @"chats/whisper";
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"chats/whisper?lastId=%@",self.lastId];
        }else{
            url = @"chats/whisper";
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
                if (self.clearUnreadBlock) {
                    self.clearUnreadBlock(YES);
                }
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeStaySys *model = [NoticeStaySys mj_objectWithKeyValues:dic];
                
                BOOL alerady = NO;
                
                for (NoticeStaySys *olM in self.dataArr) {//判断是否有重复数据
                    if ([olM.chat_id isEqualToString:model.chat_id]) {
                        alerady = YES;
                        break;
                    }
                }
                if (!alerady) {
                  [self.dataArr addObject:model];
                }
            }
            if (self.dataArr.count) {
                NoticeStaySys *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.last_dialog_id;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.defaultL;
                self.defaultL.text = [NoticeTools chinese:@"啊呀 下次给Ta心情留个悄悄话好了" english:@"No interactions yet" japan:@"まだ返信がありません"];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeStaySys *stay = self.dataArr[indexPath.row];

    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",stay.resource_id] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
            self.leaveChat = stay;
            if (model.content_type.intValue == 2 && model.title) {
                model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
            }
            if (model.resource) {
                if (model.content_type.intValue == 2) {
                    NoticeMbsDetailTextController *ctl = [[NoticeMbsDetailTextController alloc] init];
                    ctl.voiceM = model;
                    ctl.isHs = YES;
                    ctl.stayChat = stay;
                    ctl.toUserName = stay.with_user_name;
                    ctl.toUserId = stay.with_user_id;
                    [self.navigationController pushViewController:ctl animated:NO];
                }else{
                    NoticeMBSDetailVoiceController *ctl = [[NoticeMBSDetailVoiceController alloc] init];
                    ctl.voiceM = model;
                    ctl.toUserName = stay.with_user_name;
                    ctl.isHs = YES;
                    ctl.stayChat = stay;
                    ctl.toUserId = stay.with_user_id;
                    [self.navigationController pushViewController:ctl animated:NO];
                }
                return;
            }
            if (model.content_type.intValue == 2) {
                NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
                ctl.voiceM = model;
                ctl.isHs = YES;
                ctl.stayChat = stay;
                ctl.toUserName = stay.with_user_name;
                ctl.toUserId = stay.with_user_id;
                [self.navigationController pushViewController:ctl animated:NO];
            }else{
                NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
                ctl.voiceM = model;
                ctl.toUserName = stay.with_user_name;
                ctl.isHs = YES;
                ctl.stayChat = stay;
                ctl.toUserId = stay.with_user_id;
                [self.navigationController pushViewController:ctl animated:NO];
            }
            
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeStaySys *chatM = self.dataArr[indexPath.row];
    if (chatM.lastChatModel.content_type.intValue == 1) {//音频
        return 115;
    }else if (chatM.lastChatModel.content_type.intValue == 2) {//信封
        return 115;
    }else if (chatM.lastChatModel.content_type.intValue == 3) {//图片
        return 171;
    }else if (chatM.lastChatModel.content_type.intValue == 5) {//分享的连接
        return 136;
    }
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NoticeQiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.qiaoModel = self.dataArr[indexPath.row];
    [cell.playerView.playButton setImage:UIImageNamed(!cell.qiaoModel.lastChatModel.isPlaying ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    cell.longtapBlock = ^(NoticeStaySys * _Nonnull stay) {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:@"0" forKey:@"isVisible"];
                [[DRNetWorking shareInstance]requestWithPatchPath:[NSString stringWithFormat:@"chats/%@",stay.chat_id] Accept:@"application/vnd.shengxi.v3.1+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    for (NoticeStaySys *model in weakSelf.dataArr) {
                        if ([model.chat_id isEqualToString:stay.chat_id]) {
                            [weakSelf.dataArr removeObject:model];
                            break;
                        }
                        
                    }
                    [weakSelf.tableView reloadData];
                } fail:^(NSError *error) {
                }];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"py.dele"]]];

        [sheet show];
    };
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section{

    if (tag != self.oldtag) {
        if (self.dataArr.count && self.oldChat) {
            NoticeStaySys *oldM = self.oldChat;
            oldM.lastChatModel.isPlaying = NO;
            oldM.lastChatModel.nowPro = 0;
            oldM.lastChatModel.nowTime = oldM.lastChatModel.resource_len;
            [self.tableView reloadData];
        }
        self.oldtag = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }

    NoticeStaySys *model = self.dataArr[tag];
    self.oldChat = model;
    if (self.isReplay) {
        [self.chatPlayer startPlayWithUrl:model.lastChatModel.resource_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        model.lastChatModel.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.chatPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;
    self.chatPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
 
        }else{
            model.lastChatModel.isPlaying = YES;
            [weakSelf.tableView reloadData];
        }
    };
    
    self.chatPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        model.lastChatModel.isPlaying = NO;
        model.lastChatModel.nowPro = 0;
        //weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        [weakSelf.tableView reloadData];
    };
    
    self.chatPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        NoticeQiaoCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.lastChatModel.resource_len.integerValue) {
            currentTime = model.lastChatModel.resource_len.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.lastChatModel.resource_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.lastChatModel.resource_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.lastChatModel.resource_len;
            weakSelf.isReplay = YES;
            model.lastChatModel.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            if ((model.lastChatModel.resource_len.integerValue-currentTime)<-1) {
                [weakSelf.chatPlayer stopPlaying];
            }
            weakSelf.chatPlayer.playComplete = ^{
                [weakSelf.chatPlayer stopPlaying];
                weakSelf.isReplay = YES;
                model.lastChatModel.isPlaying = NO;
                model.lastChatModel.nowPro = 0;
                cell.playerView.timeLen = model.lastChatModel.resource_len;
                //weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                [weakSelf.tableView reloadData];
            };
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.lastChatModel.resource_len.integerValue-currentTime];
        cell.playerView.slieView.progress = currentTime/model.lastChatModel.resource_len.floatValue;
        model.lastChatModel.nowTime = [NSString stringWithFormat:@"%.f",model.lastChatModel.resource_len.integerValue-currentTime];
        model.lastChatModel.nowPro = currentTime/model.lastChatModel.resource_len.floatValue;
    };
}

- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    [self.chatPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = YES;
    [self.chatPlayer pause:self.isPasue];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    // 跳转
    [self.chatPlayer.player seekToTime:CMTimeMake(dratNum, 1) completionHandler:^(BOOL finished) {
        if (finished) {
        }
    }];
}

- (LGAudioPlayer *)chatPlayer
{
    if (!_chatPlayer) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.floatView.isPlaying) {
            appdel.floatView.noRePlay = YES;
            [appdel.floatView.audioPlayer stopPlaying];
        }
        _chatPlayer = [[LGAudioPlayer alloc] init];
    }
    return _chatPlayer;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_chatPlayer stopPlaying];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.leaveChat) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"chat/unRead/%@",self.leaveChat.chat_id] Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeStaySys *stay = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];
                self.leaveChat.un_read_num = stay.un_read_num;
                [self.tableView reloadData];
            }
        } fail:^(NSError * _Nullable error) {
            
        }];
    }

}

@end
