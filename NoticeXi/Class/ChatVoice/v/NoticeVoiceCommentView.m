//
//  NoticeVoiceCommentView.m
//  NoticeXi
//
//  Created by li lei on 2022/2/22.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceCommentView.h"
#import "NoticeVoiceCommentCell.h"

@implementation NoticeVoiceCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.contentView];
        self.contentView.layer.cornerRadius = 20;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.userInteractionEnabled = YES;
        self.contentView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-100, 50)];
        
        if ([NoticeTools getLocalType] == 1) {
            label.text = @"0 comments";
        }else if ([NoticeTools getLocalType] == 2){
            label.text = @"0 コメント";
        }else{
            label.text = @"0条留言";
        }
        
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.font = XGTwentyBoldFontSize;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        self.titleL = label;
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 50)];
        self.closeBtn = closeBtn;
        [self.closeBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [self.contentView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.backgroundColor = [self.contentView.backgroundColor colorWithAlphaComponent:0];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-20-50-BOTTOM_HEIGHT-10-50);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.tableView];
        [self.tableView registerClass:[NoticeVoiceCommentCell class] forCellReuseIdentifier:@"cell"];
        
        self.dataArr = [NSMutableArray new];
        
        [self createRefesh];
 
   
        // 添加点击手势
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
        self.tapGesture.delegate = self;
        [self addGestureRecognizer:self.tapGesture];
               
        // 添加滑动手势
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];
        
        self.inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        self.inputView.delegate = self;
        self.inputView.isRead = YES;
        self.inputView.limitNum = 100;
        self.inputView.plaStr = [NoticeTools chinese:@"就是你了，留下言嘛…" english:@"Leave a comment" japan:@"コメント"];
        self.inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, BOTTOM_HEIGHT)];
        bottomView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:bottomView];
    }
    return self;
}

- (void)setIsVoiceDetail:(BOOL)isVoiceDetail{
    _isVoiceDetail = isVoiceDetail;
    if (_isVoiceDetail) {
        [self.closeBtn setImage:UIImageNamed(@"Image_lyup") forState:UIControlStateNormal];
    }
}

- (void)sendCommentWithText:(NSString *)text voiceId:(NSString *)voiceid subId:(NSString *)subId{
    
    if (!text || !text.length || !voiceid) {
        return;
    }
    if (self.dataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
  
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:text forKey:@"content"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.bokeModel? [NSString stringWithFormat:@"podcast/comment/%@/%@",voiceid,(subId.length && subId)?subId:@"0"] : [NSString stringWithFormat:@"voice/comment/%@/%@",voiceid,(subId.length && subId)?subId:@"0"] Accept:self.bokeModel?@"application/vnd.shengxi.v5.4.6+json": @"application/vnd.shengxi.v5.3.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeVoiceComModel *model = [NoticeVoiceComModel mj_objectWithKeyValues:dict[@"data"]];
            if (model.content) {
                [self.dataArr insertObject:model atIndex:0];
                [self.tableView reloadData];
                if (!self.dataArr.count) {
                    self.tableView.tableFooterView = self.footView;
                }else{
                    self.tableView.tableFooterView = nil;
                }
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

//发送留言
- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    [self sendCommentWithText:comment voiceId:self.bokeModel?self.bokeModel.bokeId: self.voiceM.voice_id subId:commentId];
}


- (void)requestData{
   
    NSString *url = nil;
    if (self.isDown) {
        self.pageNo = 1;
        url = [NSString stringWithFormat:@"voice/comment/%@?pageNo=1",self.voiceM.voice_id];
        if (self.bokeModel) {
            url = [NSString stringWithFormat:@"podcast/comment/%@?pageNo=1",self.bokeModel.bokeId];
        }
    }else{
        url = [NSString stringWithFormat:@"voice/comment/%@?pageNo=%ld",self.voiceM.voice_id,self.pageNo];
        if (self.bokeModel) {
            url = [NSString stringWithFormat:@"podcast/comment/%@?pageNo=%ld",self.bokeModel.bokeId,self.pageNo];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.bokeModel?@"application/vnd.shengxi.v5.4.6+json": @"application/vnd.shengxi.v5.3.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if ([NoticeTools getLocalType] == 1) {
                self.titleL.text = [NSString stringWithFormat:@"%@ comments",allM.total];
            }else if ([NoticeTools getLocalType] == 2){
                self.titleL.text = [NSString stringWithFormat:@"%@ コメント",allM.total];
            }else{
                self.titleL.text = [NSString stringWithFormat:@"%@条留言",allM.total];
            }
            if (self.numBlock) {
                self.numBlock(allM.total);
            }
            for (NSDictionary *dic in allM.list) {
                NoticeVoiceComModel *model = [NoticeVoiceComModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
            
            if (!self.dataArr.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = nil;
            }
        }
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError * _Nullable error) {
    }];
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.width)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2, (_footView.frame.size.height-70)/2, 335, 70)];
        image.image = UIImageNamed(@"bo_qiangsf");
        [_footView addSubview:image];
    }
    return _footView;
}

- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    if (voiceM) {
        self.inputView.saveKey = [NSString stringWithFormat:@"voicecom%@%@",[NoticeTools getuserId],voiceM.voice_id];
        self.inputView.plaStr = [NoticeTools getLocalStrWith:@"ly.openis"];
    }
    if (self.isVoiceDetail) {
        return;
    }
    if (!self.noRequest) {
        self.isDown = YES;
        [self requestData];
    }
    if (self.noRequest) {
        self.noRequest = NO;
    }
   
}

- (void)setBokeModel:(NoticeDanMuModel *)bokeModel{
    _bokeModel = bokeModel;
    if (bokeModel) {
        self.inputView.plaStr = [NoticeTools chinese:@"就是你了，留下言嘛…" english:@"Leave a comment" japan:@"コメント"];
        self.inputView.saveKey = [NSString stringWithFormat:@"bokeLy%@%@",[NoticeTools getuserId],bokeModel.bokeId];
    }
    if (!self.noRequest) {
        self.isDown = YES;
        [self requestData];
    }
    if (self.noRequest) {
        self.noRequest = NO;
    }
}

- (void)createRefesh{
    
    __weak NoticeVoiceCommentView *ctl = self;

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo ++;
        ctl.isDown = NO;
        [ctl requestData];
    }];
}

- (void)dissMissTap{
    [self removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.voiceM = self.voiceM;
    cell.bokeModel = self.bokeModel;
    cell.comModel = self.dataArr[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    if (!self.isVoiceDetail) {
        cell.dissMissBlock = ^(BOOL diss) {
            [weakSelf closeClick];
        };
    }

    cell.deleteComBlock = ^(NSString * _Nonnull comId) {
        for (NoticeVoiceComModel *inM in weakSelf.dataArr) {
            if ([inM.subId isEqualToString:comId]) {
                [weakSelf.dataArr removeObject:inM];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    cell.manageDeleteComBlock = ^(NSString * _Nonnull comId) {
        for (NoticeVoiceComModel *inM in weakSelf.dataArr) {
            if ([inM.subId isEqualToString:comId]) {
                inM.comment_status = @"3";
                inM.content = [NoticeTools getLocalStrWith:@"nesw.hasdel"];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceComModel *model = self.dataArr[indexPath.row];
    if (model.replys.count) {//有回复
        NoticeVoiceComModel *subModel = model.replysArr[0];
        if (model.reply_num.integerValue > 1) {//超过一条回复
            return model.mainTextHeight+subModel.subTextHeight+83+10+69+40;
        }
        return model.mainTextHeight+subModel.subTextHeight+83+10+69;
    }
    return model.mainTextHeight+83;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

- (void)closeClick{

    [self.inputView.contentView resignFirstResponder];
    [self.inputView clearView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
    }];
    
    [self.inputView showJustComment:nil];
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

@end
