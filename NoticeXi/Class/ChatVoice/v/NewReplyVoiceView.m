//
//  NewReplyVoiceView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/20.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NewReplyVoiceView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeXi-Swift.h"
@implementation NewReplyVoiceView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 500)];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.contentView];
        self.contentView.layer.cornerRadius = 20;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.userInteractionEnabled = YES;
        self.contentView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentView.clipsToBounds = YES;
        

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-100, 50)];
        label.text = [NoticeTools getLocalStrWith:@"yl.allhs"];
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.font = XGTwentyBoldFontSize;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 50)];
        [closeBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [self.contentView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.backgroundColor = [self.contentView.backgroundColor colorWithAlphaComponent:0];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-50-BOTTOM_HEIGHT-10);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[NoticeReplyVoiceCell class] forCellReuseIdentifier:@"chatCell"];
        [self.contentView addSubview:self.tableView];
        
        self.dataArr = [NSMutableArray new];
        
        [self createRefesh];
 
        
//        UIView *dissmissView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.contentView.frame.size.height)];
//        dissmissView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *distap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
//        [dissmissView addGestureRecognizer:distap];
//        dissmissView.backgroundColor = [UIColor clearColor];
//        [self addSubview:dissmissView];
        
        self.oldtag = 768;
        
        // 添加点击手势
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
        self.tapGesture.delegate = self;
        [self addGestureRecognizer:self.tapGesture];
               
        // 添加滑动手势
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];
    }
    return self;
}



#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.panGesture) {
        UIView *touchView = touch.view;
        while (touchView != nil) {
            if ([touchView isKindOfClass:[UIScrollView class]]) {
                self.scrollView = (UIScrollView *)touchView;
                self.isDragScrollView = YES;
                break;
            }else if (touchView == self.contentView) {
                self.isDragScrollView = NO;
                break;
            }
            touchView = (UIView *)[touchView nextResponder];
        }
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.tapGesture) {
        CGPoint point = [gestureRecognizer locationInView:self.contentView];
        if ([self.contentView.layer containsPoint:point] && gestureRecognizer.view == self) {
            return NO;
        }
    }else if (gestureRecognizer == self.panGesture) {
        return YES;
    }
    return YES;
}

// 是否与其他手势共存
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self.contentView];
    if (self.isDragScrollView) {
        // 当UIScrollView在最顶部时，处理视图的滑动
        if (self.scrollView.contentOffset.y <= 0) {
            if (translation.y > 0) { // 向下拖拽
                self.scrollView.contentOffset = CGPointZero;
                self.scrollView.panGestureRecognizer.enabled = NO;
                self.isDragScrollView = NO;
                
                CGRect contentFrame = self.contentView.frame;
                contentFrame.origin.y += translation.y;
                self.contentView.frame = contentFrame;
            }
        }
    }else {
        
        CGFloat contentM = (self.frame.size.height - self.contentView.frame.size.height);
        if (translation.y > 0) { // 向下拖拽
            CGRect contentFrame = self.contentView.frame;
            contentFrame.origin.y += translation.y;
            self.contentView.frame = contentFrame;
        }else if (translation.y < 0 && self.contentView.frame.origin.y > contentM) { // 向上拖拽
            CGRect contentFrame = self.contentView.frame;
            contentFrame.origin.y = MAX((self.contentView.frame.origin.y + translation.y), contentM);
            self.contentView.frame = contentFrame;
        }
    }
    
    [panGesture setTranslation:CGPointZero inView:self.contentView];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [panGesture velocityInView:self.contentView];
        
        self.scrollView.panGestureRecognizer.enabled = YES;
        
        // 结束时的速度>0 滑动距离> 5 且UIScrollView滑动到最顶部
        if (velocity.y > 0 && self.lastTransitionY > 5 && !self.isDragScrollView) {
            [self closeClick];
        }else {
            [self show];
        }
    }
    
    self.lastTransitionY = translation.y;
}

- (void)requestData{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"voices/%@/chats",self.voiceM.voice_id];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"voices/%@/chats?lastId=%@",self.voiceM.voice_id,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"voices/%@/chats",self.voiceM.voice_id];
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
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceChat *model = [NoticeVoiceChat mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeVoiceChat *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.chat_id;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    self.isDown = YES;
    [self requestData];
}

- (void)createRefesh{
    
    __weak NewReplyVoiceView *ctl = self;

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestData];
    }];
}

- (void)dissMissTap{
    [self removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeReplyVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    cell.section = indexPath.section;
    cell.chat = self.dataArr[indexPath.row];
    cell.voiceM = self.voiceM;
    cell.delegate = self;
    cell.index = indexPath.row;
    __weak typeof(self) weakSelf = self;
    cell.dissMissTapBlock = ^(BOOL diss) {
        [weakSelf dissMissTap];
    };
    [cell.playerView.playButton setImage:UIImageNamed(!cell.chat.isPlaying ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceChat *chat = self.dataArr[indexPath.row];
    if (chat.content_type.intValue == 2) {
        return 174-50;
    }
    return (chat.content_type.intValue == 1?113:174);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

- (void)longTapWithIndex:(NSInteger)index{
    NoticeVoiceChat *model = self.dataArr[index];
    self.choiceChat = model;
    __weak typeof(self) weakSelf = self;
    if ([[[NoticeSaveModel getUserInfo] user_id] isEqualToString:self.voiceM.subUserModel.userId]) {//声昔是自己的
        LCActionSheet *sheet2 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex2) {
           if (buttonIndex2 == 2){
                [weakSelf deleteModel:model tag:index];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.jubao"],[NoticeTools getLocalStrWith:@"groupManager.del"]]];
        sheet2.delegate = self;
        [sheet2 show];
    }else{
        [self deleteModel:model tag:index];
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [self jubao:self.choiceChat];
    }
}

- (void)deleteModel:(NoticeVoiceChat *)chat tag:(NSInteger)tag{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    __weak typeof(self) weakSelf = self;
    LCActionSheet *sheet2 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex2) {
        if (buttonIndex2 ==2 ) {
            [nav.topViewController showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"chats/%@",chat.chat_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [nav.topViewController hideHUD];
                if (success) {
                    [weakSelf.dataArr removeObjectAtIndex:tag];
                    [weakSelf.tableView reloadData];
                    [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
                    //对话或者悄悄话数量
                    if ([self.voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
                    
                        self.voiceM.chat_num = [NSString stringWithFormat:@"%ld",self.voiceM.chat_num.integerValue-1];
                    }else{
                    
                        self.voiceM.dialog_num = [NSString stringWithFormat:@"%ld",self.voiceM.dialog_num.integerValue-1];
                    }
                    [self.tableView reloadData];
                }
            } fail:^(NSError *error) {
                [nav.topViewController hideHUD];
            }];
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"hh.surescdh"],[NoticeTools getLocalStrWith:@"main.sure"]]];
    [sheet2 show];
}

- (void)jubao:(NoticeVoiceChat *)chat{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = chat.dialog_id;
    juBaoView.reouceType = @"3";
    [juBaoView showView];
}

- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section{

    if (tag != self.oldtag) {
        if (self.dataArr.count && self.oldChat) {
            NoticeVoiceChat *oldM = self.oldChat;
            oldM.isPlaying = NO;
            oldM.nowPro = 0;
            oldM.nowTime = oldM.resource_len;
            [self.tableView reloadData];
        }
        self.oldtag = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }

    NoticeVoiceChat *model = self.dataArr[tag];
    self.oldChat = model;
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
        NoticeReplyVoiceCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.resource_len.integerValue) {
            currentTime = model.resource_len.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.resource_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.resource_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            if ((model.resource_len.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
            }
            weakSelf.audioPlayer.playComplete = ^{
                [weakSelf.audioPlayer stopPlaying];
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
                model.nowPro = 0;
                cell.playerView.timeLen = model.resource_len;
                //weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                [weakSelf.tableView reloadData];
            };
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        cell.playerView.slieView.progress = currentTime/model.resource_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        model.nowPro = currentTime/model.resource_len.floatValue;
    };
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

- (void)closeClick{
    
    [self.audioPlayer stopPlaying];

    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 500);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-480, DR_SCREEN_WIDTH, 500);
    } completion:^(BOOL finished) {
    }];
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.floatView.isPlaying) {
            appdel.floatView.noRePlay = YES;
            [appdel.floatView.audioPlayer stopPlaying];
        }
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

@end
