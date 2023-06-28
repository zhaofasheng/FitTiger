//
//  NoticeMangerVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMangerVoiceController.h"
#import "NoticeMangerCell.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeBackVoiceViewController.h"
#import "NoticeSCViewController.h"
#import "NoticeChats.h"
#import "NoticeTuYaChatWithOtherController.h"
@interface NoticeMangerVoiceController ()<NoticeManagerVoiceClickDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSString *readId;
@property (nonatomic, strong) NoticeManagerModel *oldModel;
@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, strong) UIButton *deleteTuYaBtn;
@property (nonatomic, strong) UIView *footBtnView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *hlButton;
@end

@implementation NoticeMangerVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.dataArr = [NSMutableArray new];
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-58-BOTTOM_HEIGHT-300);
    [self.tableView registerClass:[NoticeMangerCell class] forCellReuseIdentifier:@"cell"];
    if (self.managerM) {
        [self requestDetail];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 60+30)];
        self.tableView.tableFooterView = footView;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-120)/2, 15, 120, 30)];
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickFun) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:button];
        button.backgroundColor = GetColorWithName(VMainThumeColor);
        [button setTitle:@"查看完整对话" forState:UIControlStateNormal];
        self.managerM.resource_content = self.managerM.resource_content.length ? self.managerM.resource_content : @"转文字失败";
        [self.dataArr addObject:self.managerM];
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
        [self.tableView reloadData];
        if ([self.managerM.chat_type isEqualToString:@"2"]) {
            self.isNoChat = NO;
            self.navigationItem.title = @"被举报的私聊";
        }else if ([self.managerM.chat_type isEqualToString:@"3"]){
            self.deleteTuYaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 45, DR_SCREEN_WIDTH, 45)];
            [self.deleteTuYaBtn setTitle:self.managerM.dialog_status.intValue == 1 ?[NoticeTools getLocalStrWith:@"groupManager.del"]:[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
            [self.deleteTuYaBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            self.deleteTuYaBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            [self.deleteTuYaBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:self.deleteTuYaBtn];
            self.navigationItem.title = @"被举报的涂鸦";
        }
        else{
            self.navigationItem.title = @"被举报的悄悄话";
        }
        return;
    }
    
    
    if (self.groupM) {
        self.tableView.tableFooterView = self.footBtnView;
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-58-BOTTOM_HEIGHT);
        self.navigationItem.title = self.isFRomCenter?@"审核社团聊天" : @"被举报的社团聊天";
    }
    if (self.danmMu) {
        self.tableView.tableFooterView = self.footBtnView;
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-58-BOTTOM_HEIGHT);
        self.navigationItem.title = @"被举报的弹幕";
    }
    if (self.isFull) {
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-58);
    }
    if (!self.danmMu && !self.groupM) {
        [self createRefesh];
        self.isDown = YES;
        [self pointRequest];
    }

}

- (UIView *)footBtnView{
    if (!_footBtnView) {
        
        _footBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 90)];
        UIButton *sendTCBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-345)/2,23, 345, 44)];
        sendTCBtn.layer.cornerRadius = 22;
        sendTCBtn.layer.masksToBounds = YES;
        [sendTCBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendTCBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [sendTCBtn addTarget:self action:@selector(destoryClick) forControlEvents:UIControlEventTouchUpInside];
        [_footBtnView addSubview:sendTCBtn];
        self.deleteButton = sendTCBtn;
        if (self.groupM) {
            [self.deleteButton setTitle:self.groupM.status.intValue>1?[NoticeTools getLocalStrWith:@"emtion.deleSuc"]:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
        }else if (self.danmMu){
            [self.deleteButton setTitle:self.danmMu.status.intValue>1?[NoticeTools getLocalStrWith:@"emtion.deleSuc"]:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
        }
        
        
        if (self.isFRomCenter) {
            UIButton *TCBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,23, DR_SCREEN_WIDTH/2, 44)];
            TCBtn.layer.cornerRadius = 22;
            TCBtn.layer.masksToBounds = YES;
            [TCBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            TCBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
            [TCBtn addTarget:self action:@selector(hlClick) forControlEvents:UIControlEventTouchUpInside];
            [_footBtnView addSubview:TCBtn];
            self.hlButton = TCBtn;
            self.deleteButton.frame = CGRectMake(DR_SCREEN_WIDTH/2,23, DR_SCREEN_WIDTH/2, 44);
            [self.hlButton setTitle:self.juModel.operation_type.intValue==2? @"已忽略":@"忽略" forState:UIControlStateNormal];
        }
        
    }
    return _footBtnView;
}

- (void)hlClick{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"2" forKey:@"operationType"];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/suspiciousDatas/%@",self.juModel.jubaoId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.juModel.operation_type = @"2";
            [self showToastWithText:@"操作已执行"];
            [self.hlButton setTitle:self.juModel.operation_type.intValue==2? @"已忽略":@"忽略" forState:UIControlStateNormal];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)destoryClick{
    if (self.danmMu) {
        [self showHUD];
        
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/barrage/%@",self.danmMu.danmuId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *_sendDic = [NSMutableDictionary new];
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:self.groupM.chat_id forKey:@"chatLogId"];
    [messageDic setObject:@"1" forKey:@"type"];
    [messageDic setObject:self.mangagerCode forKey:@"confirmPasswd"];
    [_sendDic setObject:@"revoke" forKey:@"action"];
    [_sendDic setObject:@"manyChat" forKey:@"flag"];
    [_sendDic setObject:messageDic forKey:@"data"];
    [appdel.socketManager sendMessage:_sendDic];
    self.groupM.status = @"3";
    [self.deleteButton setTitle:[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
}

- (void)deleteClick{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/dialog/%@",self.managerM.managerId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.deleteTuYaBtn setTitle:[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)clickFun{

    NoticeSCViewController *ctl = [[NoticeSCViewController alloc] init];
    ctl.managerCode = self.mangagerCode;
    ctl.chatDetailId = self.chatId;
    if ([self.managerM.chat_type isEqualToString:@"2"]) {
        ctl.navigationItem.title = @"私聊完整对话";
    }else if ([self.managerM.chat_type isEqualToString:@"3"]){
        NoticeTuYaChatWithOtherController *ctl = [[NoticeTuYaChatWithOtherController alloc] init];
        ctl.drawId = self.managerM.resource_id;
        ctl.chatId = self.chatId;
        ctl.managerCode = self.mangagerCode;
        ctl.fromManager = YES;
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    else{
        ctl.navigationItem.title = @"悄悄话完整对话";
    }

    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)requestDetail{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/dialogs/%@?confirmPasswd=%@",self.managerM.managerId,self.mangagerCode] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeChats *model = [NoticeChats mj_objectWithKeyValues:dict[@"data"]];
            self.chatId = model.chat_id;
        }
    } fail:^(NSError *error) {
        [self hideHUD];
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
            NoticeManagerModel *oldM = self.oldModel;
            oldM.nowTime = oldM.resource_len;
            oldM.nowPro = 0;
            [self.tableView reloadData];
        }
        
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }
    
    NoticeManagerModel *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.resource_url isLocalFile:NO];
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:tag];
        NoticeMangerCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.resource_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.resource_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.resource_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            if ((model.resource_len.integerValue-currentTime)<-3) {
                [weakSelf.audioPlayer stopPlaying];
            }
            [weakSelf.tableView reloadData];
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        cell.playerView.slieView.progress = currentTime/model.resource_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        model.nowPro = currentTime/model.resource_len.floatValue;
    };
}

- (void)pointRequest{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/%@/point/%@",[[NoticeSaveModel getUserInfo] user_id],self.isNoChat?@"chatPoint":@"chatPriPoint"] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeManagerModel *model = [NoticeManagerModel mj_objectWithKeyValues:dict[@"data"]];
            if (model.pointValue.integerValue) {
                self.readId = model.pointValue;
            }
            self.isDown = YES;
            [self request];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        if (self.readId.integerValue) {
            url = [NSString stringWithFormat:@"admin/dialog?confirmPasswd=%@&chatType=%@&lastId=%@",self.mangagerCode,self.isNoChat?@"1":@"2",self.readId];
        }else{
            url = [NSString stringWithFormat:@"admin/dialog?confirmPasswd=%@&chatType=%@",self.mangagerCode,self.isNoChat?@"1":@"2"];
        }
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"admin/dialog?confirmPasswd=%@&chatType=%@&lastId=%@",self.mangagerCode,self.isNoChat?@"1":@"2",self.lastId];
        }else{
            url = [NSString stringWithFormat:@"admin/dialog?confirmPasswd=%@&chatType=%@",self.mangagerCode,self.isNoChat?@"1":@"2"];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeManagerModel *model = [NoticeManagerModel mj_objectWithKeyValues:dic];
                model.resource_content = model.resource_content.length ? model.resource_content : @"转文字失败";
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.lastId = [self.dataArr[self.dataArr.count-1] managerId];
                if (self.isDown) {
                    self.isDown = NO;
                    if (self.readId.integerValue) {//如果存在审阅点，第一个就是上次审阅位置
                        NoticeManagerModel *model1 = self.dataArr[0];
                        model1.hasRead = YES;
                    }
                }
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.groupM) {
        return;
    }
    
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    if (self.danmMu) {
        ctl.userId = self.danmMu.userM.userId;
    }else{
        NoticeManagerModel *model = self.dataArr[indexPath.section];
        ctl.userId = self.managerM? model.to_user_id:model.user_id;
    }
    ctl.isOther = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)otherHeaderWith:(NoticeManagerModel *)model{

    if (self.isNoChat) {
        NoticeBackVoiceViewController *ctl = [[NoticeBackVoiceViewController alloc] init];
        ctl.voiceId = model.voice_id;
        ctl.isManager = YES;
        ctl.voiceUserId = model.voice_user_id;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = model.to_user_id;
        ctl.isOther = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMangerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.groupM) {
        cell.chatModel = self.groupM;
        cell.delegate = self;
    }else if (self.danmMu){
        cell.danMu = self.danmMu;
    }
    else{
        cell.index = indexPath.section;
        cell.ishs = self.isNoChat;
        cell.noTap = self.managerM? YES : NO;
        cell.delegate = self;
        cell.mangerModel = self.dataArr[indexPath.section];
        cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
        cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
        [cell.playerView.playButton setImage:GETUIImageNamed([self.dataArr[indexPath.section] isPlaying] ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.groupM || self.danmMu) {
        return 1;
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.groupM) {
        if (self.groupM.type.intValue == 2) {
            return 60+DR_SCREEN_WIDTH;
        }
        return self.groupM.cellHeight+60;
    }
    if (self.danmMu) {
        return 60+DR_SCREEN_WIDTH;
    }
    NoticeManagerModel *model = self.dataArr[indexPath.section];
    if (self.isNoChat) {
        return 140+model.contentHeight;
    }
    
    if ([model.resource_type isEqualToString:@"1"]) {
        return 140+model.contentHeight;
    }
    return 80+DR_SCREEN_WIDTH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.groupM || self.danmMu) {
        return 0;
    }
    NoticeManagerModel *model1 = self.dataArr[section];
    return model1.hasRead ? DR_SCREEN_WIDTH/375*35 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NoticeManagerModel *model1 = self.dataArr[section];
    if (model1.hasRead) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH/375*35)];
        imgView.image = UIImageNamed(@"readsetimg");
        return imgView;
    }else{
        return [[UIView alloc] init];
    }
}

- (void)pointSetsuccessindex:(NSInteger)tag{
    if (tag == 0) {
        [self showToastWithText:@"已经是第一条，无需设置审阅标记"];
        return;
    }
    
    for (NoticeManagerModel *model in self.dataArr) {
        model.hasRead = NO;
    }
   
    NoticeManagerModel *modelc = self.dataArr[tag-1];
    LCActionSheet *sheet2 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex2) {
        if (buttonIndex2 == 1) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:self.isNoChat ? @"chatPoint" : @"chatPriPoint" forKey:@"pointKey"];
            [parm setObject:modelc.managerId forKey:@"pointValue"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/%@/point",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    NoticeManagerModel *model1 = self.dataArr[tag];
                    model1.hasRead = YES;
                    self.readId = modelc.managerId;
                    [self.tableView reloadData];
                }
            } fail:^(NSError *error) {
            }];
        }
    } otherButtonTitleArray:@[@"标记审阅进度"]];
    [sheet2 show];
}

- (void)createRefesh{
    __weak NoticeMangerVoiceController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}

@end
