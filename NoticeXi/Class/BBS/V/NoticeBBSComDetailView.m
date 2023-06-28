//
//  NoticeBBSComDetailView.m
//  NoticeXi
//
//  Created by li lei on 2020/11/12.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSComDetailView.h"
#import "NoticeBBSComentCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "BaseNavigationController.h"

@implementation NoticeBBSComDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        
        UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
        [rootWindow addSubview:self];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT+15)];
        self.backView.backgroundColor = GetColorWithName(VBackColor);
        self.backView.layer.cornerRadius = 15;
        self.backView.layer.masksToBounds = YES;
        [self addSubview:self.backView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,9, 22, 22)];
        imageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_bbsdetailx_b":@"Image_bbsdetailx_y");
        [self.backView addSubview:imageView];
        
        UILabel *markl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 0, 100, 40)];
        markl.textColor = GetColorWithName(VMainTextColor);
        markl.font = SIXTEENTEXTFONTSIZE;
        markl.text = [NoticeTools getLocalStrWith:@"ly.lydetail"];
        [self.backView addSubview:markl];
        
        UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
        tapV.userInteractionEnabled = YES;
        [self.backView addSubview:tapV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelTap)];
        [tapV addGestureRecognizer:tap];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,40, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = GetColorWithName(VlineColor);
        [self.backView addSubview:line];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor =  GetColorWithName(VBackColor);
        self.tableView.frame = CGRectMake(0,41,DR_SCREEN_WIDTH,self.backView.frame.size.height-BOTTOM_HEIGHT-50-15-40);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[NoticeBBSComentCell class] forCellReuseIdentifier:@"comentCell"];
        [self.backView addSubview:self.tableView];
        
        NoticeBBSComentInputView *replyView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        replyView.delegate = self;
        replyView.plaStr = @"给留言留言";
        [replyView showJustComment:nil];
        self.inputView = replyView;
        
        self.dataArr = [NSMutableArray new];
        [self createRefesh];
        [self.tableView.mj_header beginRefreshing];
    }
    return self;
}


- (void)createRefesh{
    
    __weak NoticeBBSComDetailView *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl requestList];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        ctl.pageNo++;
        [ctl requestList];
    }];
}

- (void)requestList{
    if (self.isFromJuBao || self.isLoading) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    NSString *url = @"";
    if (self.isDown) {
        url = [NSString stringWithFormat:@"posts/%@/comments?sortType=3&commentId=%@",self.postId,self.comModel.commentId];
    }else{
        url = [NSString stringWithFormat:@"posts/%@/comments?sortType=%@&pageNo=%ld&lastId=%@&commentId=%@",self.postId,@"3",self.pageNo,self.lastId,self.comModel.commentId];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
                self.pageNo = 1;
            }
            
            BOOL hasPointComId = false;
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeSubComentModel *model = [NoticeSubComentModel mj_objectWithKeyValues:dic];
                if ([model.commentId isEqualToString:self.pointComId]) {
                    hasPointComId = YES;
                }
                if (model.to_user_id.intValue && model.toUserInfo) {
                    [model sethHasToUserContent];
                }
                if (model.comment_status.intValue != 1) {
                    [model hasDelete];
                }
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeSubComentModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.commentId;
            }
            
            [self.tableView reloadData];
            
            if (self.dataArr.count == 10 && self.roadAll && !hasPointComId) {//有十条数据就自动加载更多以便跳转到指定留言，仅限于消息列表进入时候以及前十个不存在指定留言
                self.roadAll = NO;//手动加载后不再自动加载
                self.isLoading = YES;
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }
                [nav.topViewController showHUD];
                [self getMoreAuto];
            }else{
                if (hasPointComId) {//如果找到了
                    for (int i = 0; i < self.dataArr.count; i++) {
                        NoticeSubComentModel *pointM = self.dataArr[i];
                        if ([pointM.commentId isEqualToString:self.pointComId]) {
                            self.scroRow = i;
                            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.scroRow inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                            break;
                        }
                    }
                }
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)getMoreAuto{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NSString *url = @"";
    url = [NSString stringWithFormat:@"posts/%@/comments?sortType=%@&pageNo=%ld&lastId=%@&commentId=%@",self.postId,@"3",self.pageNo,self.lastId,self.comModel.commentId];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {

            BOOL hasPointComId = false;
            NSMutableArray *arr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeSubComentModel *model = [NoticeSubComentModel mj_objectWithKeyValues:dic];
                if ([model.commentId isEqualToString:self.pointComId]) {
                    hasPointComId = YES;
                }
                if (model.to_user_id.intValue && model.toUserInfo) {
                    [model sethHasToUserContent];
                }
                if (model.comment_status.intValue != 1) {
                    [model hasDelete];
                }
                [arr addObject:model];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                NoticeSubComentModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.commentId;
            }
            
            [self.tableView reloadData];
            if (arr.count == 10  && !hasPointComId && self.dataArr.count < 100) {//有十条数据就自动加载更多以便跳转到指定留言，仅限于消息列表进入时候以及前十个不存在指定留言
                [self getMoreAuto];
            }else{
                self.isLoading = NO;
                if (hasPointComId) {//如果找到了
                    for (int i = 0; i < self.dataArr.count; i++) {
                        NoticeSubComentModel *pointM = self.dataArr[i];
                        if ([pointM.commentId isEqualToString:self.pointComId]) {
                            self.scroRow = i;
                            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.scroRow inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                            break;
                        }
                    }
                }
                [nav.topViewController hideHUD];
            }

        }else{
            self.isLoading = NO;
        }
    } fail:^(NSError * _Nullable error) {
        self.isLoading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)sendWithComment:(NSString *)comment toUserId:(nonnull NSString *)userId subCommentId:(nonnull NSString *)subcommentId{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSString *url = [NSString stringWithFormat:@"posts/%@/comments",self.postId];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"1" forKey:@"commentType"];
    [parm setObject:comment forKey:@"commentContent"];
    if (subcommentId) {
        [parm setObject:subcommentId forKey:@"commentId"];
    }else{
        [parm setObject:self.comModel.commentId forKey:@"commentId"];
    }
    
    if ([userId isEqualToString:[NoticeTools getuserId]]) {//不允许艾特自己
        userId = @"0";
    }
    [parm setObject:userId?userId: @"0" forKey:@"toUserId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.8.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [self.tableView.mj_header beginRefreshing];
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"yl.lychengg"]];
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       return 65+self.comModel.textHeight+10;
    }
    NoticeSubComentModel *model = self.dataArr[indexPath.row];
    return 65+model.textHeight+10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBBSComentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comentCell"];
    __weak typeof(self) weakSelf = self;
    cell.hideBlock = ^(BOOL hide) {
        [weakSelf cancelTap];
    };
    if (indexPath.section == 0) {
        cell.replyBtn.hidden = YES;
        cell.commentM = self.comModel;
    }else{
        cell.replyBtn.hidden = NO;
        cell.subComModel = self.dataArr[indexPath.row];
        cell.replysubBlock = ^(NoticeSubComentModel * _Nonnull commentM) {
            NoticeBBSComentInputView *replyView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
            replyView.subCommentM = commentM;
            replyView.subcommentId = commentM.commentId;
            replyView.delegate = self;
            replyView.plaStr = @"给留言回复";
            replyView.toUserId = commentM.from_user_id;
            [replyView showJustComment:commentM.commentId];
            [replyView.contentView becomeFirstResponder];
            replyView.replyToView.replyLabel.text = [NSString stringWithFormat:@"回复 %@:%@",commentM.userInfo.nick_name,commentM.comment_content];
        };
        
        cell.deletesubBlock = ^(NoticeSubComentModel * _Nonnull commentM) {
            [weakSelf.tableView reloadData];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    NoticeSubComentModel *commentM = self.dataArr[indexPath.row];
    NoticeBBSComentInputView *replyView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
    replyView.subCommentM = commentM;
    replyView.subcommentId = commentM.commentId;
    replyView.delegate = self;
    replyView.plaStr = @"给留言回复";
    replyView.toUserId = commentM.from_user_id;
    [replyView showJustComment:commentM.commentId];
    [replyView.contentView becomeFirstResponder];
    replyView.replyToView.replyLabel.text = [NSString stringWithFormat:@"回复 %@:%@",commentM.userInfo.nick_name,commentM.comment_content];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 8)];
        line1.backgroundColor = GetColorWithName(VBigLineColor);
        return line1;
    }
    return [UIView new];
}

- (void)cancelTap{
    [self.inputView clearView];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.frame = CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backView removeFromSuperview];
        [self.inputView removeFromSuperview];
    }];
}

- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}
@end
