//
//  NoticeNowViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/7.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeNowViewController.h"
#import "NoticeNoDataView.h"
#import "NoticeVoiceListCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NoticeTestViewController.h"
#import "JWProgressView.h"
@interface NoticeNowViewController ()<NoticeVoiceListClickDelegate,LCActionSheetDelegate>

@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, strong) NoticeVoiceListModel *priModel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) JWProgressView *progressView;
@property (nonatomic, assign) CGFloat timeNum;
@property (nonatomic, assign) CGFloat provalue;
@property (nonatomic, assign) BOOL hasStart;
@property (nonatomic, assign) BOOL isAuto;

@end

@implementation NoticeNowViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.audioPlayer stopPlaying];
    self.tableView.tableFooterView = self.dataArr.count? nil : self.footView;
    [self.tableView reloadData];
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:@"CHANGETHEMCOLORNOTICATION" object:nil];
    //  让此控制器成为第一响应者
    [self becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasTestNotice) name:@"HASTESTNOTICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"HASCLICKREADERSHOW" object:nil];
    self.navigationItem.title = GETTEXTWITE(@"listen.who");
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    view.backgroundColor = GetColorWithName(VBigLineColor);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-15, 40)];
    label.text = [NoticeTools getTextWithSim:@"摇一摇，你会发现欣赏过你的人藏在其中哦" fantText:@"搖壹搖，妳會發現欣賞過妳的人藏在其中哦"];
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    [view addSubview:label];
    [self.view addSubview:view];
    
    self.dataArr = [NSMutableArray new];
    
    self.tableView.frame = CGRectMake(0,40, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40);
    [self.tableView registerClass:[NoticeVoiceListCell class] forCellReuseIdentifier:@"voiceCell"];
 
    self.footView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height)];
    self.footView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
    self.footView.titleImageV.frame = CGRectMake((DR_SCREEN_WIDTH-120)/2, 130, 120,120);
    self.footView.titleImageV.image = UIImageNamed([NoticeTools isWhiteTheme]? @"Image_shake_b":@"Image_shake_y");
    self.footView.titleL.frame = CGRectMake(0, CGRectGetMaxY(self.footView.titleImageV.frame)+30, DR_SCREEN_WIDTH, 20);
    self.footView.titleL.text = [NoticeTools getTextWithSim:@"试着摇一下" fantText:@"試著搖壹下"];
    self.footView.titleL.textColor = GetColorWithName(VDarkTextColor);
    self.footView.actionButton.hidden = YES;
    self.tableView.tableFooterView = self.footView;
    self.tableView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
    
    self.progressView = [[JWProgressView alloc]initWithFrame:CGRectMake((DR_SCREEN_WIDTH-50)/2,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-58-50-NAVIGATION_BAR_HEIGHT, 50, 50)];
    [self.view addSubview:self.progressView];
    
    self.timeNum = 5;
    self.progressView.progressValue = 0;
    self.progressView.hidden = YES;
    self.progressView.userInteractionEnabled = YES;
    UITapGestureRecognizer *stopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopAutoTap)];
    [self.progressView addGestureRecognizer:stopTap];
    
    [self.line removeFromSuperview];
}

- (void)stopAutoTap{
    [self stopTimer];
}

- (void)stopTimer{
    self.isAuto = NO;
    self.progressView.hidden = YES;
    self.provalue = 0;
    self.timeNum = 5;
    [self.timer invalidate];
}

- (void)changeProgressValue
{
    self.provalue += 0.02;
    if (self.provalue >1.02) {
        self.provalue = 0;
    }
    if (self.timeNum>0.01) {
        self.timeNum -= 0.1;
    }else{
        [self stopTimer];
        self.isAuto = YES;
        [self request];
    }
    self.progressView.timeL.text = [NSString stringWithFormat:@"%.f秒后自动播放下一条",self.timeNum];
    self.progressView.progressValue = self.provalue;
}

- (void)changeColor{
    [self.tableView reloadData];
    self.footView.titleImageV.image = UIImageNamed([NoticeTools isWhiteTheme]? @"Image_shake_b":@"Image_shake_y");
    self.footView.titleL.text = [NoticeTools getTextWithSim:@"试着摇一下" fantText:@"試著搖壹下"];
    self.footView.titleL.textColor = GetColorWithName(VDarkTextColor);
    self.line.backgroundColor = [GetColorWithName(VlineColor) colorWithAlphaComponent:[NoticeTools getType] == 0?1:0];
    //设置颜色
    self.progressView.timeL.textColor = GetColorWithName(VMainThumeColor);
    self.progressView.frontFillLayer.strokeColor = GetColorWithName(VMainThumeColor).CGColor;
    self.progressView.backGroundLayer.strokeColor = [NoticeTools getWhiteColor:@"#F2F2F2" NightColor:@"#222238"].CGColor;
    self.progressView.contentLabel.textColor = GetColorWithName(VMainThumeColor);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self changeColor];
}

- (void)hasTestNotice{
//    self.hasTest = YES;
//    self.footView.actionButton.hidden = self.hasTest;
//    self.footView.titleImageV.image = UIImageNamed(self.hasTest? @"Imageshake":@"ImageshakeN");
}

/**
 *  摇动结束
 */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self stopTimer];
    NSLog(@"摇动结束");
    if (motion != UIEventSubtypeMotionShake) return;
    [self request];
}

- (void)testClick{
    NoticeTestViewController *controller = [[NoticeTestViewController alloc] init];
    controller.isFromShake = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma 共享和取消共享
- (void)hasClickShareWith:(NSInteger)tag{
  [self.tableView reloadData];
}

//屏蔽成功回调
- (void)otherPinbSuccess{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self.audioPlayer stopPlaying];
    [self.dataArr removeObjectAtIndex:self.choicemoreTag];
    [self.tableView reloadData];
}
//点击更多删除成功回调
- (void)moreClickDeleteSucess{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self.audioPlayer stopPlaying];
    [self.dataArr removeObjectAtIndex:self.choicemoreTag];
    [self.tableView reloadData];
}
//点击更多设置私密回调
- (void)moreClickSetPriSucess{
    [self.tableView reloadData];
}

//点击更多
- (void)hasClickMoreWith:(NSInteger)tag{
    [self stopTimer];
    if (tag > self.dataArr.count-1) {
        return;
    }
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.choicemoreTag = tag;
    if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是别人
        return;
    }
    
    [self.clickMore voiceClickMoreWith:model];
}

- (void)hasClickReplyWith:(NSInteger)tag{
    [self stopTimer];
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
    [self stopTimer];
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        if (self.dataArr.count && self.oldModel) {
            NoticeVoiceListModel *oldM = self.oldModel;
            oldM.nowTime = oldM.voice_len;
            oldM.nowPro = 0;
            [self.tableView reloadData];
        }
        
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }
    
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.voice_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
        [self addNumbers:model];
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
        if (!self.isPasue) {
            [self addNumbers:model];
        }
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
        NoticeVoiceListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1) || (model.voice_len.intValue == 120 && [[NSString stringWithFormat:@"%.f",currentTime]integerValue] >= 118)) {
            cell.playerView.timeLen = model.voice_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            if ((model.voice_len.integerValue-currentTime)<-3) {
                //[weakSelf.audioPlayer stopPlaying];
            }

            [weakSelf.tableView reloadData];
            weakSelf.audioPlayer.playComplete = ^{
                
                cell.playerView.timeLen = model.voice_len;
                cell.playerView.slieView.progress = 0;
                model.nowPro = 0;
                model.nowTime = model.voice_len;
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
                weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                [weakSelf.tableView reloadData];
                //weakSelf.progressView.hidden = NO;
                //weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:weakSelf selector:@selector(changeProgressValue) userInfo:nil repeats:YES];
            };
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        cell.playerView.slieView.progress =weakSelf.progross>0?weakSelf.progross: currentTime/model.voice_len.floatValue;
        //cell.playerView.lineImageView.frame = CGRectMake(cell.playerView.slieView.progress*cell.playerView.frame.size.width, 0, 10, cell.playerView.frame.size.width);
        model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        model.nowPro = currentTime/model.voice_len.floatValue;

        if (model.moveSpeed > 0) {
            [cell.playerView refreshMoveFrame:model.moveSpeed*currentTime];
        }
    };
}

//增加收听数
- (void)addNumbers:(NoticeVoiceListModel *)choiceModel{
    
    NoticeVoiceListModel *model = choiceModel;
    
    NSString *url = [NSString stringWithFormat:@"users/%@/voices/%@",choiceModel.subUserModel.userId,model.voice_id];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
                return;
            }
            model.played_num = [NSString stringWithFormat:@"%d",model.played_num.intValue+1];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeVoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voiceCell"];
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
    cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
    cell.worldM = self.dataArr[indexPath.row];
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    [cell.playerView.playButton setImage:GETUIImageNamed(model.isPlaying ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
    if (indexPath.row == self.dataArr.count-1) {
        cell.buttonView.line.hidden = YES;
    }else{
        cell.buttonView.line.hidden = NO;
    }
    cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    cell.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    cell.buttonView.backgroundColor = cell.contentView.backgroundColor;
    cell.timeL.hidden = YES;
    if (cell.worldM.topic_name && cell.worldM.topic_name.length) {
        cell.nickNameL.frame = CGRectMake(CGRectGetMaxX(cell.iconImageView.frame)+10, 19, 160, 15);
        cell.topiceLabel.frame = CGRectMake(cell.timeL.frame.origin.x, cell.timeL.frame.origin.y-3,DR_SCREEN_WIDTH-15, 12);
    }else{
        cell.nickNameL.frame = CGRectMake(cell.timeL.frame.origin.x, cell.iconImageView.frame.origin.y+25/2, 160, 15);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    return [NoticeComTools voiceCellHeight:model needFavie:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)request{
    NSString *url;
    url = @"voices/shake";
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                self.tableView.tableFooterView = self.dataArr.count? nil : self.footView;
                return ;
            }
            [self.audioPlayer stopPlaying];
            self.isReplay = YES;
            [self.audioPlayer pause:YES];
            self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            
            NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
            if (!model) {
                return;
            }
            // 3.设置震动
            if (!self.isAuto) {
               AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            
            [self.dataArr removeAllObjects];
            [self.dataArr addObject:model];
            self.tableView.tableFooterView = self.dataArr.count? nil : self.footView;
            [self startRePlayer:0];
            [self.tableView reloadData];
            if (self.isAuto) {
                self.isAuto = NO;
                [self startPlayAndStop:0];
            }
        }else{
            self.tableView.tableFooterView = self.dataArr.count? nil : self.footView;
        }
    } fail:^(NSError *error) {
        self.tableView.tableFooterView = self.dataArr.count? nil : self.footView;
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HASTESTNOTICATION" object:nil];
}

@end
