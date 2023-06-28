//
//  NoticeBookViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBookViewController.h"
#import "NoticeBookDetail.h"
#import "FSCustomButton.h"
#import "UIView+Frame.h"
#import "NoticeVoiceListCell.h"
#import "NoticeSearchBookController.h"
@interface NoticeBookViewController ()<NoticeVoiceListClickDelegate,LCActionSheetDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSMutableArray *hotArr;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSString *glastId;

@property (nonatomic, strong) NoticeBookDetail *hotListView;
@property (nonatomic, strong) NoticeVoiceListModel *priModel;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, strong) NoticeNoDataView *noDataView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

@implementation NoticeBookViewController

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hotArr = [NSMutableArray new];
    self.dataArr = [NSMutableArray new];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopPlayer" object:nil];

    self.isDown = YES;

    self.tableView.backgroundColor = GetColorWithName(VBackColor);
    [self.tableView registerClass:[NoticeVoiceListCell class] forCellReuseIdentifier:@"cell1"];
    self.hotListView = [[NoticeBookDetail alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 302+DR_SCREEN_WIDTH*95/375-102)];

    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-45-102);
    [self createRefesh];
    self.canShowAssest = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"REFRESHUSERINFORNOTICATION" object:nil];
    
    [self refresh];
}

- (void)refresh{
    self.isDown = YES;
    [self request];
}

- (void)searchClick{
    NoticeSearchBookController *ctl = [[NoticeSearchBookController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
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
        if (self.isNew) {
            if (self.dataArr.count && self.oldModel) {
                NoticeVoiceListModel *oldM = self.oldModel;
                oldM.nowTime = oldM.voice_len;
                oldM.nowPro = 0;
                [self.tableView reloadData];
            }
        }else{
            if (self.hotArr.count && self.oldModel) {
                NoticeVoiceListModel *oldM = self.oldModel;
                oldM.nowTime = oldM.voice_len;
                oldM.nowPro = 0;
                [self.tableView reloadData];
            }
        }
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }
    if (self.isNew) {
        if (tag > self.dataArr.count-1) {
            return;
        }
    }else{
        if (tag > self.hotArr.count-1) {
            return;
        }
    }
    NoticeVoiceListModel *model = self.isNew ? self.dataArr[tag] : self.hotArr[tag];
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
        weakSelf.lastPlayerTag = tag;
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
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1)|| (model.voice_len.intValue == 120 && [[NSString stringWithFormat:@"%.f",currentTime]integerValue] >= 118)) {
            cell.playerView.timeLen = model.voice_len;
            cell.playerView.slieView.progress = 0;
            //cell.playerView.lineImageView.frame = CGRectMake(cell.playerView.slieView.progress*cell.playerView.frame.size.width, 0, 10, cell.playerView.frame.size.width);
            model.nowPro = 0;
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            if ((model.voice_len.integerValue-currentTime)<-3) {
                [weakSelf.audioPlayer stopPlaying];
            }
     
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            weakSelf.audioPlayer.playComplete = ^{
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
                model.nowPro = 0;
                cell.playerView.timeLen = model.voice_len;
                [weakSelf.tableView reloadData];
                if (weakSelf.isAutoPlayer && !self.isrefreshNewToPlayer) {
                    [weakSelf nextForAssest];
                }
                if (weakSelf.isrefreshNewToPlayer) {
                    weakSelf.isrefreshNewToPlayer = NO;
                }
            };
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        cell.playerView.slieView.progress = weakSelf.progross > 0? weakSelf.progross: currentTime/model.voice_len.floatValue;
        //cell.playerView.lineImageView.frame = CGRectMake(cell.playerView.slieView.progress*cell.playerView.frame.size.width, 0, 10, cell.playerView.frame.size.width);
        model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        model.nowPro = currentTime/model.voice_len.floatValue;
 
        if (model.moveSpeed > 0) {
            [cell.playerView refreshMoveFrame:model.moveSpeed*currentTime];
        }
    };
}

#pragma 信息流助手方法

- (void)stopOrPlayerForAssest{
    if (self.isNew) {
        if (!self.dataArr.count) {
            return;
        }
        if (self.oldSelectIndex > 200 || self.lastPlayerTag == 0) {
            self.oldSelectIndex = 0;
        }
        if (self.oldSelectIndex > self.dataArr.count-1) {
            return;
        }
        [self startPlayAndStop:self.oldSelectIndex];
    }else{
        if (!self.hotArr.count) {
            return;
        }
        if (self.oldSelectIndex > 200 || self.lastPlayerTag == 0) {
            self.oldSelectIndex = 0;
        }
        if (self.oldSelectIndex > self.hotArr.count-1) {
            return;
        }
        [self startPlayAndStop:self.oldSelectIndex];
    }

}
- (void)clickChangeVoiceType:(NSInteger)type{
    self.isDown = YES;
    [self request];
}
- (void)nextForAssest{
    if (self.isPlayFromFirst) {
        self.isPlayFromFirst = NO;
        if (self.isNew) {
            if (!self.dataArr.count) {
                return;
            }
            NoticeVoiceListModel *model = self.dataArr[0];
            if (model.content_type.intValue == 2) {
                return;
            }
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self startRePlayer:0];
        }else{
            if (!self.hotArr.count) {
                return;
            }
            NoticeVoiceListModel *model = self.hotArr[0];
            if (model.content_type.intValue == 2) {
                return;
            }
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self startRePlayer:0];
        }
        return;
    }
    if (self.stopAutoPlayerForDissapear) {
        return;
    }
    if (self.isNew) {
        if (!self.dataArr.count) {
            return;
        }
        if (self.dataArr.count-1 <= self.lastPlayerTag+1) {//不能越界
            self.isPushMoreToPlayer = YES;
            [self.tableView.mj_footer beginRefreshing];
            return;
        }
        NoticeVoiceListModel *model = self.dataArr[self.lastPlayerTag+1];
        if (model.content_type.intValue == 2) {
            self.lastPlayerTag++;
            [self nextForAssest];
            return;
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPlayerTag+1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self startRePlayer:self.lastPlayerTag+1];
    }else{
        if (!self.hotArr.count) {
            return;
        }
        if (self.hotArr.count-1 <= self.lastPlayerTag+1) {//不能越界
            self.isPushMoreToPlayer = YES;
            [self.tableView.mj_footer beginRefreshing];
            return;
        }
        NoticeVoiceListModel *model = self.hotArr[self.lastPlayerTag+1];
        if (model.content_type.intValue == 2) {
            self.lastPlayerTag++;
            [self nextForAssest];
            return;
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPlayerTag+1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self startRePlayer:self.lastPlayerTag+1];
    }
}

- (void)proForAssest{
    if (self.lastPlayerTag == 0) {
        return;
    }
    if (self.isNew) {
        if (!self.dataArr.count) {
             return;
         }
        if (!self.lastPlayerTag) {
            self.lastPlayerTag = 1;
        }
        NoticeVoiceListModel *model = self.dataArr[self.lastPlayerTag-1];
        if (model.content_type.intValue == 2) {
            self.lastPlayerTag--;
            [self proForAssest];
            return;
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPlayerTag-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self startRePlayer:self.lastPlayerTag-1];
    }else{
        if (!self.hotArr.count) {
             return;
         }
        if (!self.lastPlayerTag) {
            self.lastPlayerTag = 1 ;
        }
        NoticeVoiceListModel *model = self.hotArr[self.lastPlayerTag-1];
        if (model.content_type.intValue == 2) {
            self.lastPlayerTag--;
            [self proForAssest];
            return;
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPlayerTag-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self startRePlayer:self.lastPlayerTag-1];
    }
}
- (void)autoOrNoAutoForAssest{
    self.isAutoPlayer = [NoticeTools isAutoPlayer];
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
            model.played_num = [NSString stringWithFormat:@"%ld",(long)(model.played_num.integerValue+1)];
            [self.tableView reloadData];
            
        }
    } fail:^(NSError *error) {
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.isMovie = YES;
    cell.isNeedLikeBtn = self.isNew;
    cell.needFavietaer = YES;
    if (indexPath.row == (self.isNew? self.dataArr.count-1 : self.hotArr.count-1)) {
        cell.buttonView.line.hidden = YES;
    }else{
        cell.buttonView.line.hidden = NO;
    }
    if (!self.isNew && !self.hotArr.count) {
        return cell;
    }
    cell.index = indexPath.row;
    cell.worldM = self.isNew ? self.dataArr[indexPath.row] : self.hotArr[indexPath.row];
    NoticeVoiceListModel *model = self.isNew ? self.dataArr[indexPath.row] : self.hotArr[indexPath.row];
    cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
    cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
    [cell.playerView.playButton setImage:GETUIImageNamed(model.isPlaying ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
    cell.delegate = self;
    cell.playerView.timeLen = model.voice_len;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isNew && !self.hotArr.count) {
        return 0;
    }
    NoticeVoiceListModel *model = self.isNew ? self.dataArr[indexPath.row] : self.hotArr[indexPath.row];
    return [NoticeComTools voiceCellHeight:model needFavie:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isNew && !self.dataArr.count) {
        return 0;
    }
    if (!self.isNew && !self.hotArr.count) {
        return 0;
    }
    return self.isNew? self.dataArr.count : self.hotArr.count;
}

- (void)createRefesh{
    
    __weak NoticeBookViewController *ctl = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)reSetPlayerData{
    self.canReoadData = NO;
    self.lastPlayerTag = 0;
    self.isrefreshNewToPlayer = YES;
    if (self.isNew) {
        if (self.dataArr.count) {
            self.isReplay = YES;
            self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        }
    }else{
        if (self.hotArr.count) {
            self.isReplay = YES;
            self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        }
    }
    
    [self.tableView reloadData];
}
- (void)request{
    NSString *url = nil;
    
    if (self.isDown) {
        [self reSetPlayerData];
        if (self.isNew) {
            if ([NoticeTools voiceType]) {
                url = [NSString stringWithFormat:@"club/2/voices?contentType=%ld",[NoticeTools voiceType]];
            }else{
                url = @"club/2/voices";
            }
            
        }else{
            if ([NoticeTools voiceType]) {
                [NSString stringWithFormat:@"voices/subscription?resourceType=2?contentType=%ld",[NoticeTools voiceType]];
            }else{
                url = @"voices/subscription?resourceType=2";
            }
            
        }
        
    }else{
        if (self.isNew) {
            if (self.lastId) {
                if ([NoticeTools voiceType]) {
                    url = [NSString stringWithFormat:@"club/2/voices?lastId=%@&contentType=%ld",self.lastId,[NoticeTools voiceType]];
                }else{
                    url = [NSString stringWithFormat:@"club/2/voices?lastId=%@",self.lastId];
                }
                
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                return;
            }
        }else{
            if ([NoticeTools voiceType]) {
                url = [NSString stringWithFormat:@"voices/subscription?resourceType=2&lastId=%@&contentType=%ld",self.glastId,[NoticeTools voiceType]];
            }else{
                url = [NSString stringWithFormat:@"voices/subscription?resourceType=2&lastId=%@",self.glastId];
            }
            
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.isrefreshNewToPlayer = NO;
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                self.isPushMoreToPlayer = NO;
                if (self.isNew) {
                    [self.dataArr removeAllObjects];
                }else{
                    [self.hotArr removeAllObjects];
                }
                self.isDown = NO;
            }
            BOOL hasNewData = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                if (self.isNew) {
                    [self.dataArr addObject:model];
                    hasNewData = YES;
                }else{
                    [self.hotArr addObject:model];
                    hasNewData = YES;
                }
                
            }
            
            if (self.isNew) {
                if (self.dataArr.count) {
                    NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                    self.lastId = lastM.voice_id;
                }
            }else{
                if (self.hotArr.count) {
                    NoticeVoiceListModel *lastM = self.hotArr[self.hotArr.count-1];
                    self.glastId = lastM.voice_id;
                }
                self.tableView.tableFooterView = self.hotArr.count? nil : self.noDataView;
            }
            
            [self.tableView reloadData];
            if (hasNewData && self.isPushMoreToPlayer) {
                self.isPushMoreToPlayer = NO;
                [self nextForAssest];
            }else if (!hasNewData && self.isPushMoreToPlayer){
                self.isPlayFromFirst = YES;
                [self nextForAssest];
            }
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
        if (self.isNew) {
        if (self.choicemoreTag <= self.dataArr.count-1) {
            [self.dataArr removeObjectAtIndex:self.choicemoreTag];
        }
        
    }else{
        if (self.choicemoreTag <= self.hotArr.count-1) {
           [self.hotArr removeObjectAtIndex:self.choicemoreTag];
        }
    }
    [self.tableView reloadData];
}
//点击更多设置私密回调
- (void)moreClickSetPriSucess{
    [self.tableView reloadData];
}

//点击更多
- (void)hasClickMoreWith:(NSInteger)tag{
    if (self.isNew) {
        if (tag > self.dataArr.count-1) {
              return;
          }
    }else{
        if (tag > self.hotArr.count-1) {
              return;
          }
    }
  
    NoticeVoiceListModel *model = self.isNew? self.dataArr[tag] : self.hotArr[tag];
    self.choicemoreTag = tag;
    if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是别人
        return;
    }
    
    [self.clickMore voiceClickMoreWith:model];
    
}

//欣赏列表取消欣赏成功
- (void)noGuanzhuSuccess:(NSInteger)index{
    if (!self.isNew) {
        [self.hotArr removeObjectAtIndex:index];
        self.tableView.tableFooterView = self.hotArr.count? nil : self.noDataView;
        [self.tableView reloadData];
    }
}

- (NoticeNoDataView *)noDataView{
    if (!_noDataView) {//
        _noDataView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,self.tableView.frame.size.height-44)];
        
        _noDataView.titleImageV.frame = CGRectMake((DR_SCREEN_WIDTH-104)/2,31,104, 131);
        _noDataView.backgroundColor = GetColorWithName(VBackColor);
        _noDataView.titleImageV.contentMode = UIViewContentModeScaleAspectFit;
        _noDataView.titleL.textAlignment = NSTextAlignmentCenter;
        _noDataView.titleL.frame = CGRectMake(0, CGRectGetMaxY(_noDataView.titleImageV.frame)+32, DR_SCREEN_WIDTH, 15);
        _noDataView.titleL.font = THRETEENTEXTFONTSIZE;
        
        _noDataView.titleL.text = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.noxinshang"]:@"還沒有關註任何人";
        _noDataView.titleL.font = TWOTEXTFONTSIZE;
        _noDataView.actionButton.hidden = NO;
        _noDataView.actionButton.frame = CGRectMake(_noDataView.titleL.frame.origin.x,CGRectGetMaxY(_noDataView.titleL.frame) , _noDataView.titleL.frame.size.width, 30);
        _noDataView.actionButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [_noDataView.actionButton setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.smshixinshang"]:@"什麽是關註？" forState:UIControlStateNormal];
        [_noDataView.actionButton addTarget:self action:@selector(tapTost) forControlEvents:UIControlEventTouchUpInside];
        _noDataView.titleImageV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"gexingh_imgs":@"gexingh_imgys");
        _noDataView.titleL.textColor = GetColorWithName(VDarkTextColor);
        [_noDataView.actionButton setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        _noDataView.actionButton.titleLabel.font = TWOTEXTFONTSIZE;
    }
    return _noDataView;
}

- (void)tapTost{
    NoticePinBiView *tostV = [[NoticePinBiView alloc] initWithLeaderBook:2];
    [tostV showTostView];
}

@end
