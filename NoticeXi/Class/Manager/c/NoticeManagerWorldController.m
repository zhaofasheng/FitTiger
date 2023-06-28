//
//  NoticeManagerWorldController.m
//  NoticeXi
//
//  Created by li lei on 2019/8/29.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerWorldController.h"
#import "NoticeDrawCell.h"
#import "NoticeManagerModel.h"
#define STATICEHEIGHT 180
@interface NoticeManagerWorldController ()<NoticeManagerVoiceListClickDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, strong) NSString *readId;
@end

@implementation NoticeManagerWorldController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-58-BOTTOM_HEIGHT);
    [self.tableView registerClass:[NoticeManagerWorldCell class] forCellReuseIdentifier:@"voiceCell"];
    if (self.voiceM) {
        self.navigationItem.title = @"被举报的心情";
        [self.dataArr addObject:self.voiceM];
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
        [self.tableView reloadData];
        return;
    }else if (self.drawM){
        [self.tableView registerClass:[NoticeDrawCell class] forCellReuseIdentifier:@"cell"];
        self.navigationItem.title = @"被举报的灵魂画手";
        [self.dataArr addObject:self.drawM];
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
        [self.tableView reloadData];
        return;
    }else if (self.tuYaModel){
        [self.tableView registerClass:[NoticeDrawCell class] forCellReuseIdentifier:@"cell"];
        self.navigationItem.title = @"被举报的涂鸦";
        [self.dataArr addObject:self.tuYaModel];
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
        [self.tableView reloadData];
        return;
    }
    [self createRefesh];
    self.tableView.rowHeight = STATICEHEIGHT;
    self.isDown = YES;
    [self pointRequest];
}

- (void)stopPlay{
    [self.audioPlayer stopPlaying];
    [self.tableView reloadData];
}

- (void)pointRequest{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/%@/point/worldVoicePoint",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
            url = [NSString stringWithFormat:@"admin/voices/type/2?confirmPasswd=%@&lastId=%@",self.mangagerCode,self.readId];
        }else{
            url = [NSString stringWithFormat:@"admin/voices/type/2?confirmPasswd=%@",self.mangagerCode];
        }
        
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"admin/voices/type/2?confirmPasswd=%@&lastId=%@",self.mangagerCode,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"admin/voices/type/2?confirmPasswd=%@",self.mangagerCode];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                
                self.isReplay = YES;
                [self.audioPlayer pause:YES];
                self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                if (model) {
                    model.resource_content = model.resource_content.length? model.resource_content : @"转文字失败";
                    [self.dataArr addObject:model];
                }
            }
            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.lastShareId;
                if (self.isDown) {
                    self.isDown = NO;
                    if (self.readId.integerValue) {//如果存在审阅点，第一个就是上次审阅位置
                        NoticeVoiceListModel *model1 = self.dataArr[0];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.drawM || self.tuYaModel) {
        NoticeDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (self.drawM) {
            cell.drawModel = self.dataArr[indexPath.row];
        }else if (self.tuYaModel){
            cell.isTuYaManager = YES;
            cell.tuModel = self.dataArr[indexPath.row];
        }
        cell.passCode = self.mangagerCode;
        cell.index = indexPath.row;
        cell.isEdit = YES;
        return cell;
    }else{
        NoticeManagerWorldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voiceCell"];
        cell.index = indexPath.section;
        cell.delegate = self;
        cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
        cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
        [cell.playerView.playButton setImage:GETUIImageNamed([self.dataArr[indexPath.section] isPlaying] ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
        cell.worldM = self.dataArr[indexPath.section];
        cell.playerView.timeLen = [self.dataArr[indexPath.section] voice_len];
        cell.code = self.mangagerCode;
        cell.isEdit = self.voiceM ? YES : NO;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.drawM || self.tuYaModel) {
        return 65+DR_SCREEN_WIDTH+50+8;
    }
    NoticeVoiceListModel *model = self.dataArr[indexPath.section];
    if (model.img_list.count) {
        return STATICEHEIGHT + (DR_SCREEN_WIDTH-12)/3 + (model.resource_content.length? model.contentHeight+15 : 0)+model.textHeight;
    }else if (model.resource){
        return STATICEHEIGHT + 83 + (model.resource_content.length? model.contentHeight+15 : 0)+model.textHeight;
    }
    return STATICEHEIGHT + (model.resource_content.length? model.contentHeight: -15)+model.textHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.drawM || self.tuYaModel) {
        return 0;
    }
    NoticeVoiceListModel *model1 = self.dataArr[section];
    return model1.hasRead ? DR_SCREEN_WIDTH/375*35 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.drawM || self.tuYaModel) {
        return nil;
    }
    NoticeVoiceListModel *model1 = self.dataArr[section];
    if (model1.hasRead) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH/375*35)];
        imgView.image = UIImageNamed(@"readsetimg");
        return imgView;
    }else{
        return [[UIView alloc] init];
    }
}

- (void)readPointSetSuccess:(NSInteger)index{
    if (index == 0) {
        [self showToastWithText:@"已经是第一条，无需设置审阅标记"];
        return;
    }
    
    for (NoticeVoiceListModel *model in self.dataArr) {
        model.hasRead = NO;
    }
    
    NoticeVoiceListModel *modelC = self.dataArr[index-1];
    LCActionSheet *sheet2 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex2) {
        
        if (buttonIndex2 == 1) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"worldVoicePoint" forKey:@"pointKey"];
            [parm setObject:modelC.lastShareId forKey:@"pointValue"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/%@/point",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    NoticeVoiceListModel *model1 = self.dataArr[index];
                    model1.hasRead = YES;
                    self.readId = modelC.lastShareId;
                    [self.tableView reloadData];
                }
            } fail:^(NSError *error) {
                
            }];
        }
    } otherButtonTitleArray:@[@"标记审阅进度"]];
    [sheet2 show];
}


- (void)editSuccess:(NSInteger)index{
    if (self.dataArr.count > index) {
        [self.dataArr removeObjectAtIndex:index];
        [self.tableView reloadData];
    }
}
- (void)createRefesh{
    __weak NoticeManagerWorldController *ctl = self;
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
        DRLog(@"播放结束");
        [weakSelf.tableView reloadData];
    };
    
    //-0.045715
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:tag];
        NoticeManagerWorldCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.voice_len.integerValue) {
            currentTime = model.voice_len.integerValue;
        }
        
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1)) {
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
                //weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                cell.playerView.timeLen = model.voice_len;
                [weakSelf.tableView reloadData];
            };
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        cell.playerView.slieView.progress = weakSelf.progross>0? weakSelf.progross : currentTime/model.voice_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        model.nowPro = currentTime/model.voice_len.floatValue;
    };
}

@end
