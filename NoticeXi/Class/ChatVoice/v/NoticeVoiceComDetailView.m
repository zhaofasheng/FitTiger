//
//  NoticeVoiceComDetailView.m
//  NoticeXi
//
//  Created by li lei on 2022/2/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceComDetailView.h"
#import "NoticeVoiceComDetailCell.h"
#import "NoticeDanMuController.h"
@implementation NoticeVoiceComDetailView


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
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.font = XGTwentyBoldFontSize;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        self.titleL = label;
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 50)];
        [closeBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
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
        [self.tableView registerClass:[NoticeVoiceComDetailCell class] forCellReuseIdentifier:@"cell1"];
        self.dataArr = [NSMutableArray new];
   
        // 添加点击手势
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
        self.tapGesture.delegate = self;
        [self addGestureRecognizer:self.tapGesture];
               
        // 添加滑动手势
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, BOTTOM_HEIGHT)];
        bottomView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:bottomView];
    }
    return self;
}

- (void)setComModel:(NoticeVoiceComModel *)comModel{
    _comModel = comModel;
    if (comModel.is_allow_reply.boolValue && !self.noInputView) {
        self.inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        self.inputView.delegate = self;
        self.inputView.isRead = YES;
        self.inputView.limitNum = 100;
        self.inputView.plaStr = self.bokeModel?[NoticeTools chinese:@"回复留言" english:@"Reply" japan:@"返事"]: [NoticeTools getLocalStrWith:@"ly.openis"];
        self.inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        if(self.bokeModel){
            self.inputView.saveKey = [NSString stringWithFormat:@"bokereplyLy%@%@-%@",[NoticeTools getuserId],self.bokeModel.bokeId,self.comId];
        }else if (self.voiceM){
            self.inputView.saveKey = [NSString stringWithFormat:@"voicereplyLy%@%@-%@",[NoticeTools getuserId],self.voiceM.voice_id,self.comId];
        }
        
    }
}

- (void)setBokeModel:(NoticeDanMuModel *)bokeModel{
    _bokeModel = bokeModel;
    if (bokeModel) {
        self.inputView.plaStr = [NoticeTools chinese:@"回复留言" english:@"Reply" japan:@"返事"];
        self.inputView.saveKey = [NSString stringWithFormat:@"bokereplyLy%@%@-%@",[NoticeTools getuserId],bokeModel.bokeId,self.comId];
    }
}

- (void)sendCommentWithText:(NSString *)text voiceId:(NSString *)voiceid subId:(NSString *)subId{
    
    if (!text || !text.length || !voiceid || !subId || !subId.integerValue) {
        return;
    }
    if (self.dataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:text forKey:@"content"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.bokeModel? [NSString stringWithFormat:@"podcast/comment/%@/%@",voiceid,(subId.length && subId)?subId:@"0"] : [NSString stringWithFormat:@"voice/comment/%@/%@",voiceid,(subId.length && subId)?subId:@"0"] Accept:self.bokeModel?@"application/vnd.shengxi.v5.4.6+json": @"application/vnd.shengxi.v5.3.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.isDown = YES;
            [self requestData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.comModel.is_allow_reply.boolValue) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"ly.onetoone"] message:nil cancleBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"]];
        [alerView showXLAlertView];
    }
}

//发送留言
- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    [self sendCommentWithText:comment voiceId:self.bokeModel?self.bokeModel.bokeId: self.voiceId subId:self.comId];
}
    
- (void)requestData{
   
    NSString *url = nil;
    url = [NSString stringWithFormat:@"voice/commentDetail/%@",self.comId];
    if (self.bokeModel) {
        url = [NSString stringWithFormat:@"podcast/commentDetail/%@",self.comId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.bokeModel?@"application/vnd.shengxi.v5.4.6+json": @"application/vnd.shengxi.v5.3.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
       
            for (NSDictionary *dic in allM.replys) {
                NoticeVoiceComModel *model = [NoticeVoiceComModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)setVoiceId:(NSString *)voiceId{
    _voiceId = voiceId;
    if (!self.noRequest) {
        self.isDown = YES;
        [self requestData];
    }
    if (self.noRequest) {
        self.noRequest = NO;
    }
}

- (void)dissMissTap{
    [self removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NoticeVoiceCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.isDetail = YES;
        cell.jubaoContent = self.jubaoContent;
        cell.voiceM = self.voiceM;
        cell.bokeModel = self.bokeModel;
        cell.comModel = self.comModel;
        __weak typeof(self) weakSelf = self;
        cell.dissMissBlock = ^(BOOL diss) {
            [weakSelf closeClick];
            if (weakSelf.dissMissBlock) {
                weakSelf.dissMissBlock(YES);
            }
        };
        cell.deleteComBlock = ^(NSString * _Nonnull comId) {
            if (weakSelf.deleteComBlock) {
                weakSelf.deleteComBlock(comId);
            }
            [weakSelf closeClick];
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
        cell.likeBlock = ^(NoticeVoiceComModel * _Nonnull comM) {
            if (weakSelf.likeBlock) {
                weakSelf.likeBlock(comM);
            }
        };
        return cell;
    }
    NoticeVoiceComDetailCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell1.jubaoContent = self.jubaoContent;
    cell1.comModel = self.dataArr[indexPath.row];
    cell1.voiceM = self.voiceM;
    cell1.bokeModel = self.bokeModel;
    __weak typeof(self) weakSelf = self;
    cell1.dissMissBlock = ^(BOOL diss) {
        [weakSelf closeClick];
        if (weakSelf.dissMissBlock) {
            weakSelf.dissMissBlock(YES);
        }
    };
    cell1.deleteComBlock = ^(NSString * _Nonnull comId) {
        for (NoticeVoiceComModel *inM in weakSelf.dataArr) {
            if ([inM.subId isEqualToString:comId]) {
                [weakSelf.dataArr removeObject:inM];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    cell1.manageDeleteComBlock = ^(NSString * _Nonnull comId) {
        for (NoticeVoiceComModel *inM in weakSelf.dataArr) {
            if ([inM.subId isEqualToString:comId]) {
                inM.comment_status = @"3";
                inM.content = [NoticeTools getLocalStrWith:@"nesw.hasdel"];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    cell1.likeBlock = ^(NoticeVoiceComModel * _Nonnull comM) {
        if (weakSelf.likeBlock) {
            weakSelf.likeBlock(comM);
        }
    };
    cell1.topfgView.hidden = indexPath.row == 0?YES:NO;
    cell1.bottomfgView.hidden = (indexPath.row == (self.dataArr.count-1))?YES:NO;
    return cell1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NoticeVoiceComModel *model = self.comModel;
        return model.mainTextHeight+83;
    }
    NoticeVoiceComModel *model1 = self.dataArr[indexPath.row];
    return model1.subTextHeight+69;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0 && self.comModel) {
        return 1;
    }
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 && self.fromBokeMsg) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0 && self.fromBokeMsg) {
        UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
        footV.backgroundColor = self.contentView.backgroundColor;
        UILabel *tapL = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, DR_SCREEN_WIDTH-70, 40)];
        tapL.text = [NoticeTools chinese:@"查看播客详情 >" english:@"More >" japan:@"もっと >"];
        tapL.font = FIFTHTEENTEXTFONTSIZE;
        tapL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        [footV addSubview:tapL];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailT)];
        [tapL addGestureRecognizer:tap];
        tapL.userInteractionEnabled = YES;
        return footV;
    }
    return [UIView new];
}

- (void)detailT{
    [self dissMissTap];
    [self.inputView.contentView resignFirstResponder];
    [self.inputView clearView];
    NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];

    ctl.bokeModel = self.bokeModel;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)closeClick{
    
    [self.inputView.contentView resignFirstResponder];
    [self.inputView clearView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
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
    if (!self.noInputView) {
        [self.inputView showJustComment:nil];
    }
    
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
