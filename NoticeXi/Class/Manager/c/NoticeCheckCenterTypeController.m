//
//  NoticeCheckCenterTypeController.m
//  NoticeXi
//
//  Created by li lei on 2020/6/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeCheckCenterTypeController.h"
#import "NoticeCheckCenterCell.h"
#import "NoticeSCViewController.h"
#import "NoticeChats.h"
#import "NoticeVoiceListCell.h"
#import "NoticeBackVoiceViewController.h"
@interface NoticeCheckCenterTypeController ()<NoticeVoiceListClickDelegate>
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) NoticeUserInfoModel *userInfo;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) UIButton *footBtn;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) NoticeDrawList *drawM;
@property (nonatomic, strong) UIView *footView;
@end

@implementation NoticeCheckCenterTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.tableView.frame = CGRectMake(0, 1, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeCheckCenterCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[NoticeVoiceListCell class] forCellReuseIdentifier:@"Cell1"];
    self.tableView.rowHeight = 70+DR_SCREEN_WIDTH-47*2;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 60)];
    self.tableView.tableFooterView = footView;
    self.footView = footView;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-120)/2, 15, 120, 30)];
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [button setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickFun) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    self.footBtn = button;
    if (self.juModel.data_type.intValue == 3) {
        self.navigationItem.title = self.juModel.chat_type.intValue == 1?@"审核悄悄话对话": @"审核私聊对话";
        button.backgroundColor = GetColorWithName(VMainThumeColor);
        [button setTitle:@"查看完整对话" forState:UIControlStateNormal];
        
        if (self.juModel.chat_type.intValue == 1) {
            [self requestVoice];
            UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 15,70, 33)];
            [addBtn setTitle:@"查看心情" forState:UIControlStateNormal];
            [addBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            addBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            [addBtn addTarget:self action:@selector(addWordClick) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
        }
    }else if (self.juModel.data_type.intValue == 1){
        self.tableView.tableFooterView = nil;
        self.navigationItem.title = @"审核用户信息";
    }else if (self.juModel.data_type.intValue == 6){
        self.navigationItem.title = @"审核画";
        button.backgroundColor = [GetColorWithName(VMainThumeColor) colorWithAlphaComponent:0];
        [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }else if (self.juModel.data_type.intValue == 2){
        button.backgroundColor = [GetColorWithName(VMainThumeColor) colorWithAlphaComponent:0];
        self.navigationItem.title = @"审核心情";
        self.contentL = [[UILabel alloc] init];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentL.numberOfLines = 0;
        [footView addSubview:self.contentL];
        [self requestVoice];
        [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }else if (self.juModel.data_type.intValue == 7){
        self.tableView.tableFooterView = nil;
        self.navigationItem.title = @"审核用户词条";
    }
    NSArray *arr = @[];
    arr = @[@"忽略",@"替换图片",@"设为仙人掌",@"封号"];
    if (self.juModel.data_type.intValue == 1) {
        arr = @[@"忽略",@"替换图片",@"设为仙人掌",@"封号"];
    }
    if (self.juModel.data_type.intValue == 3) {
        [self requestDiaLog];
        arr = @[@"忽略",@"删对话",@"设为仙人掌",@"封号"];
    }   if (self.juModel.data_type.intValue == 6) {
         [self requestDraw];
         arr = @[@"忽略",@"删除画",@"设为仙人掌",@"封号"];
     }
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/4*i, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT-45, DR_SCREEN_WIDTH/4, 45)];
        btn.titleLabel.font = ELEVENTEXTFONTSIZE;
        [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = i;
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            self.btn1 = btn;
        }else if (i == 1){
            self.btn2 = btn;
        }else if (i == 2){
            self.btn3 = btn;
        }else{
            self.btn4 = btn;
        }
    }
    if (self.juModel.operation_type.intValue == 2) {
        [self.btn1 setTitle:@"已忽略" forState:UIControlStateNormal];
    }
    [self requestUser];
}

- (void)addWordClick{
    NoticeBackVoiceViewController *ctl = [[NoticeBackVoiceViewController alloc] init];
    ctl.voiceM = self.voiceM;
    ctl.voiceId = self.voiceM.voice_id;
    ctl.isManager = YES;
    ctl.voiceUserId = self.voiceM.subUserModel.userId;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)requestVoice{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",self.juModel.voice_id?self.juModel.voice_id:self.juModel.resource_id] Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.juModel.data_type.intValue != 2) {
                return;
            }
            self.voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
            
            self.footBtn.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, GET_STRHEIGHT(self.voiceM.contentStr, 14, DR_SCREEN_WIDTH-20)+60);
            self.contentL.frame = CGRectMake(10, 0, DR_SCREEN_WIDTH-20, GET_STRHEIGHT(self.voiceM.contentStr, 14, DR_SCREEN_WIDTH-20));
            self.footBtn.frame = CGRectMake((DR_SCREEN_WIDTH-120)/2, CGRectGetMaxY(self.contentL.frame)+15, 120, 30);
            
            self.contentL.text = self.voiceM.contentStr;
            [self.footBtn setTitle:self.voiceM.hide_at.integerValue? @"已隐藏" : @"隐藏" forState:UIControlStateNormal];
            [self.btn2 setTitle:[self.voiceM.voice_status isEqualToString:@"1"]? @"删除心情" : [NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)requestUser{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",self.juModel.user_id] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
       
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            self.userInfo = userIn;
            [self.btn4 setTitle:self.userInfo.userStatus.intValue == 3?@"解封":@"封号" forState:UIControlStateNormal];
            [self.btn3 setTitle:self.userInfo.flag.integerValue?@"解除仙人掌状态": @"设为仙人掌" forState:UIControlStateNormal];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)requestDiaLog{

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/dialogs/%@?confirmPasswd=%@",self.juModel.data_id,self.mangagerCode] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
       
        if (success) {
            NoticeChats *userIn = [NoticeChats mj_objectWithKeyValues:dict1[@"data"]];
            [self.btn2 setTitle:userIn.dialog_status.intValue == 1?@"删对话":[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
            self.juModel.image_url = userIn.resource_url;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

- (void)requestDraw{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"artworks/%@",self.juModel.data_id] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
       
        if (success) {
           self.drawM = [NoticeDrawList mj_objectWithKeyValues:dict[@"data"]];
            [self.footBtn setTitle:self.drawM.hide_at.integerValue?@"已隐藏":@"隐藏" forState:UIControlStateNormal];
            [self.btn2 setTitle:self.drawM.artwork_status.intValue == 1?@"删除画":[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
        }
    } fail:^(NSError *error) {
    }];
}

- (void)btnClick:(UIButton*)btn{
    if (self.juModel.data_type.intValue == 1 || self.juModel.data_type.intValue == 7) {
        if (btn.tag == 2) {
            [self setXrenz];
        }else if (btn.tag == 3){
            [self setFenghao];
        }else if (btn.tag == 0){
            [self setIngore];
        }else if (btn.tag == 1){
            [self changeData];
        }
    }
    if (self.juModel.data_type.intValue == 3) {
        if (btn.tag == 2) {
            [self setXrenz];
        }else if (btn.tag == 3){
            [self setFenghao];
        }else if (btn.tag == 0){
            [self setIngore];
        }else if (btn.tag == 1){
            [self deleteDilog];
        }
    }
    if (self.juModel.data_type.intValue == 2) {
        if (btn.tag == 2) {
            [self setXrenz];
        }else if (btn.tag == 3){
            [self setFenghao];
        }else if (btn.tag == 0){
            [self setIngore];
        }else if (btn.tag == 1){
            [self deleVoice];
        }
    }
}

- (void)deleVoice{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    if ([_voiceM.voice_status isEqualToString:@"1"]) {
        [self showHUD];
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/voices/%@",_voiceM.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                [self.btn2 setTitle:[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
                self.voiceM.voice_status = @"5";
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }else{
        [parm setObject:@"1" forKey:@"voiceStatus"];
        [self showHUD];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/voices/%@",_voiceM.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                [self.btn2 setTitle:@"删除心情" forState:UIControlStateNormal];
                self.voiceM.voice_status = @"1";
                
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }
}

- (void)deleDraw{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/artwork/%@",self.juModel.data_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.drawM.artwork_status = @"3";
            [self.btn2 setTitle:self.drawM.artwork_status.intValue == 1?@"删除画":[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
            
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)deleteDilog{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/dialog/%@",self.juModel.data_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.btn2 setTitle:[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)changeData{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"6" forKey:@"operationType"];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/suspiciousDatas/%@",self.juModel.jubaoId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:@"操作已执行"];
            [self.btn1 setTitle:@"已替换" forState:UIControlStateNormal];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

//忽略
- (void)setIngore{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"2" forKey:@"operationType"];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/suspiciousDatas/%@",self.juModel.jubaoId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:@"操作已执行"];
            [self.btn1 setTitle:@"已忽略" forState:UIControlStateNormal];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

//解封号
- (void)setFenghao{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.userInfo.userStatus.intValue == 3?@"1": @"3" forKey:@"userStatus"];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/users/%@",self.juModel.user_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:@"操作已执行"];
            self.userInfo.userStatus = self.userInfo.userStatus.intValue == 3?@"1": @"3";
            [self.btn4 setTitle:self.userInfo.userStatus.intValue == 3?@"解封":@"封号" forState:UIControlStateNormal];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

//设为仙人掌
- (void)setXrenz{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.userInfo.flag.integerValue?@"0" : @"1" forKey:@"flag"];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/users/%@",self.juModel.user_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:@"操作已执行"];
            self.userInfo.flag = self.userInfo.flag.integerValue?@"0" : @"1";
            [self.btn3 setTitle:self.userInfo.flag.integerValue?@"解除仙人掌状态": @"设为仙人掌" forState:UIControlStateNormal];
        }else{
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)clickFun{
    if (self.juModel.data_type.intValue == 3) {
        NoticeSCViewController *ctl = [[NoticeSCViewController alloc] init];
        ctl.managerCode = self.mangagerCode;
        ctl.chatDetailId = self.juModel.chat_id;
        ctl.navigationItem.title = self.juModel.chat_type.intValue == 1?@"悄悄话完整对话": @"私聊完整对话";
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (self.juModel.data_type.intValue == 6){
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.drawM.hide_at.integerValue?@"0":@"1" forKey:@"isHidden"];
        [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
        [self showHUD];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/artwork/%@",self.juModel.data_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                self.drawM.hide_at = self.drawM.hide_at.integerValue?@"0":@"1";
                [self.footBtn setTitle:self.drawM.hide_at.integerValue?@"已隐藏":@"隐藏" forState:UIControlStateNormal];
                
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }if (self.juModel.data_type.intValue == 2) {
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
        [parm setObject:_voiceM.hide_at.integerValue?@"0":@"1" forKey:@"isHidden"];
        [self showHUD];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/voices/%@",_voiceM.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                [self.footBtn setTitle:self.voiceM.hide_at.integerValue? @"隐藏":@"已隐藏" forState:UIControlStateNormal];
                self.voiceM.hide_at = self.voiceM.hide_at.integerValue?@"0":@"6879";
                
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.juModel.data_type.intValue == 2){
        NoticeVoiceListModel *model = self.voiceM;
        return [NoticeComTools voiceCellHeight:model needFavie:NO];
    }
    return 70+DR_SCREEN_WIDTH-47*2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.juModel.data_type.intValue == 2) {
        NoticeVoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        cell.worldM = self.voiceM;
        cell.delegate = self;
        cell.index = indexPath.section;
        cell.isWorld = YES;
        cell.delegate = self;
        cell.playerView.backgroundColor = GetColorWithName(VMainThumeColor);
        cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
        [cell.playerView.playButton setImage:GETUIImageNamed([self.voiceM isPlaying] ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
        
        cell.buttonView.line.hidden = NO;
        cell.playerView.timeLen = self.voiceM.voice_len;

        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        cell.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        cell.buttonView.hidden = YES;
        return cell;
    }else{
        NoticeCheckCenterCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell1.passCode =self.mangagerCode;
        cell1.jubaoM = self.juModel;
        
        return cell1;
    }

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopPlay];
}

- (void)stopPlay{
    [self.audioPlayer stopPlaying];
    [self.tableView reloadData];
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

    NoticeVoiceListModel *model = self.voiceM;
    if (self.isReplay) {
        NoticeVoiceListModel *oldM = self.voiceM;
        oldM.nowTime = oldM.voice_len;
        oldM.nowPro = 0;
        [self.tableView reloadData];
        [self.audioPlayer startPlayWithUrl:model.voice_url isLocalFile:NO];
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
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            model.isPlaying = !weakSelf.isPasue;
            [weakSelf.tableView reloadData];
        }
    };
    

    self.audioPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        DRLog(@"播放结束");
        [weakSelf.tableView reloadData];
    };
    //-0.045715
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:tag];
        NoticeVoiceListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.voice_len.integerValue) {
            currentTime = model.voice_len.integerValue;
        }
        
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1) || (model.voice_len.intValue == 120 && [[NSString stringWithFormat:@"%.f",currentTime]integerValue] >= 118)) {
            cell.playerView.timeLen = model.voice_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            if ((model.voice_len.integerValue-currentTime)<-3) {
                [weakSelf.audioPlayer stopPlaying];
            }
            weakSelf.audioPlayer.playComplete = ^{
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
                model.nowPro = 0;
                cell.playerView.timeLen = model.voice_len;
                cell.playerView.timeLen = model.voice_len;
      
                [weakSelf.tableView reloadData];
            };
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        cell.playerView.slieView.progress = weakSelf.progross>0? weakSelf.progross : currentTime/model.voice_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        model.nowPro = currentTime/model.voice_len.floatValue;
 
        if (model.moveSpeed > 0) {
            [cell.playerView refreshMoveFrame:model.moveSpeed*currentTime];
        }
    };
}

@end
