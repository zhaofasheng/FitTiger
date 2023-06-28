//
//  NoticeBookComViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBookComViewController.h"
#import "NoticeVoiceListCell.h"
@interface NoticeBookComViewController ()<NoticeVoiceListClickDelegate,LCActionSheetDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeVoiceListModel *priModel;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@end

@implementation NoticeBookComViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray new];
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.navigationItem.title =self.userId ?([NoticeTools isSimpleLau] ?[NoticeTools getLocalStrWith:@"movie.hisbook"]:@"Ta的書籍心情") : ([NoticeTools isSimpleLau] ?[NoticeTools getLocalStrWith:@"movie.mybook"]:@"我的書籍心情");
    [self.tableView registerClass:[NoticeVoiceListCell class] forCellReuseIdentifier:@"cell1"];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.isMovie = YES;
    cell.isSmallLine = YES;
    if (indexPath.row == self.dataArr.count-1) {
        cell.buttonView.line.hidden = YES;
    }else{
        cell.buttonView.line.hidden = NO;
    }
    
    cell.worldM = self.dataArr[indexPath.row];
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
    cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
    [cell.playerView.playButton setImage:GETUIImageNamed(model.isPlaying ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.playerView.timeLen = model.voice_len;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    return [NoticeComTools voiceCellHeight:model needFavie:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticeBookComViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestData];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestData];
    }];
}
- (void)requestData{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"review/users/%@/2/%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.book.bookId];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"review/users/%@/2/%@?lastId=%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.book.bookId,self.lastId];
        }else{
            [NSString stringWithFormat:@"review/users/%@/2/%@",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.book.bookId];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.voice_id;
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
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
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
            
                if (weakSelf.isrefreshNewToPlayer) {
                    weakSelf.isrefreshNewToPlayer = NO;
                }
            };
            [weakSelf.tableView reloadData];
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        cell.playerView.slieView.progress =weakSelf.progross >0?weakSelf.progross: currentTime/model.voice_len.floatValue;
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
            model.played_num = [NSString stringWithFormat:@"%ld",model.played_num.integerValue+1];
            [self.tableView reloadData];
            
        }
    } fail:^(NSError *error) {
    }];
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
    [self.dataArr removeObjectAtIndex:self.choicemoreTag ];
    [self.tableView reloadData];
}
//点击更多设置私密回调
- (void)moreClickSetPriSucess{
    [self.tableView reloadData];
}

//点击更多
- (void)hasClickMoreWith:(NSInteger)tag{
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
@end
