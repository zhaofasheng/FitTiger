//
//  NoticeBBSDetailController.m
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSDetailController.h"
#import "NoticeBBSDetailHeaderView.h"
#import "NoticeBBSDetailSectionView.h"
#import "NoticeBBSComentCell.h"
#import "NoticeBBSComentInputView.h"
#import "NoticeBBSComDetailView.h"
#import "NoticeManager.h"
#import "NoticeSendBBSController.h"
@interface NoticeBBSDetailController ()<NoticeBBSComentInputDelegate,NoticeManagerUserDelegate>
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSString *type;//排序类型，1:最新，2:最热，3:最早，4:最冷，默认1
@property (nonatomic, strong) NoticeBBSDetailHeaderView *headerView;
@property (nonatomic, strong) NoticeBBSComentInputView *inputView;
@property (nonatomic, strong) UILabel *noDanteL;
@property (nonatomic, strong) NoticeManager *magager;
@end

@implementation NoticeBBSDetailController
- (UILabel *)noDanteL{
    if (!_noDanteL) {
        _noDanteL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,60)];
        _noDanteL.font = FOURTHTEENTEXTFONTSIZE;
        _noDanteL.textAlignment = NSTextAlignmentCenter;
        _noDanteL.textColor = GetColorWithName(VDarkTextColor);
        _noDanteL.text = @"还没人留言，声昔君哭了";
    }
    return _noDanteL;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView. backgroundColor = GetColorWithName(VBackColor);
    
    if ([NoticeTools isManager]) {
        FSCustomButton *btn1 = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50-10-44,STATUS_BAR_HEIGHT,44,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [btn1 setImage:UIImageNamed(@"Image_managerc") forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(managerClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    }
    
    self.line.hidden = YES;
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT-50);
    
    self.inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
    self.inputView.delegate = self;
    self.inputView.plaStr = @"给帖子留言";

    self.headerView = [[NoticeBBSDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 0)];
    self.headerView.bbsModel = self.bbsModel;
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView registerClass:[NoticeBBSComentCell class] forCellReuseIdentifier:@"comentCell"];
    [self.tableView registerClass:[NoticeBBSDetailSectionView class] forHeaderFooterViewReuseIdentifier:@"headerSection"];
    
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    
    
    self.type = @"2";
    self.isDown = YES;
    if (!self.needRequestDetail) {
        [self requestList];
    }else{
        [self requestDetail];
    }
}

- (void)managerClick{
    
    self.magager.type = @"管理员登陆";
    [self.magager show];
}

- (void)sureManagerClick:(NSString *)code{
    [self.magager removeFromSuperview];
    if (self.manageCode) {
        [self pushToSend];
        return;
    }
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/users/login" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            self.manageCode = code;
            [self pushToSend];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)pushToSend{
    NoticeSendBBSController *ctl = [[NoticeSendBBSController alloc] init];
    ctl.bbsM = self.bbsModel;
    ctl.manageCode = self.manageCode;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)requestDetail{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"posts/%@",self.posiId] Accept:@"application/vnd.shengxi.v4.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.bbsModel = [NoticeBBSModel mj_objectWithKeyValues:dict[@"data"]];
            self.bbsModel.post_id = self.bbsModel.cagaoId;
            self.headerView.bbsModel = self.bbsModel;
            [self.tableView reloadData];
            [self requestList];
            if (self.commentM) {//来自于举报
                [self hideHUD];
                NoticeBBSComDetailView *comDetailView = [[NoticeBBSComDetailView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
                comDetailView.postId = self.bbsModel.post_id;
                comDetailView.isFromJuBao = YES;
                comDetailView.comModel = self.commentM;
                [comDetailView show];
            }else{
               [self requestComDetail];
            }
            
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)requestComDetail{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"posts/%@/comments/%@",self.posiId,self.commentId] Accept:@"application/vnd.shengxi.v4.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeBBSComent *model= [NoticeBBSComent mj_objectWithKeyValues:dict[@"data"]];

            if (model.comment_status.intValue != 1) {
                model.comment_content = @"「该留言已被删除」";
                [model hasDelete];
            }
            NoticeBBSComDetailView *comDetailView = [[NoticeBBSComDetailView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            comDetailView.postId = self.bbsModel.post_id;
            comDetailView.roadAll = self.roadAll;
            comDetailView.pointComId = self.pointComId;
            comDetailView.comModel = model;
            [comDetailView show];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)createRefesh{
    
    __weak NoticeBBSDetailController *ctl = self;

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
    NSString *url = @"";
    if (self.isDown) {
        url = [NSString stringWithFormat:@"posts/%@/comments?sortType=%@",self.bbsModel.post_id,self.type];
    }else{
        url = [NSString stringWithFormat:@"posts/%@/comments?sortType=%@&pageNo=%ld&lastId=%@",self.bbsModel.post_id,self.type,self.pageNo,self.lastId];
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
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeBBSComent *model = [NoticeBBSComent mj_objectWithKeyValues:dic];
                if (model.comment_status.intValue != 1) {
                    model.comment_content = @"「该留言已被删除」";
                    [model hasDelete];
                }
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeBBSComent *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.commentId;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.noDanteL;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.inputView.contentView resignFirstResponder];
    [self.inputView clearView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.inputView showJustComment:nil];
}

//点击发送
- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    if (!commentId) {//给帖子留言
        [self commentBBS:comment];
    }else{//给留言留言
        [self showHUD];
        NSString *url = [NSString stringWithFormat:@"posts/%@/comments",self.bbsModel.post_id];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:@"1" forKey:@"commentType"];
        [parm setObject:comment forKey:@"commentContent"];
        [parm setObject:commentId forKey:@"commentId"];
        [parm setObject:@"0" forKey:@"toUserId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.8.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                for (NoticeBBSComent *superCom in self.dataArr) {
                    if ([superCom.commentId isEqualToString:commentId]) {
                        superCom.reply_num = [NSString stringWithFormat:@"%d",superCom.reply_num.intValue+1];
                        NoticeSubComentModel *subComM = [NoticeSubComentModel new];
             
                        subComM.userInfo = [NoticeAbout new];
                        subComM.userInfo.nick_name = [[NoticeSaveModel getUserInfo] nick_name];
                        subComM.comment_content = comment;
                        [subComM reSetText];
                        NSMutableArray *arr = [NSMutableArray new];
              
                        if (superCom.subCommentArr.count) {
                            for (NoticeSubComentModel *model in superCom.subCommentArr) {
                                [arr addObject:model];
                            }
                            [arr addObject:subComM];
                        }else{
                         
                            [arr addObject:subComM];
                        }
                        superCom.subCommentArr = arr;
                        break;
                    }
                }
                [self.tableView reloadData];
                [self showToastWithText:[NoticeTools getLocalStrWith:@"yl.lychengg"]];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }
}

- (void)commentBBS:(NSString *)content{
    [self showHUD];
    NSString *url = [NSString stringWithFormat:@"posts/%@/comments",self.bbsModel.post_id];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"1" forKey:@"commentType"];
    [parm setObject:content forKey:@"commentContent"];
    [parm setObject:@"0" forKey:@"commentId"];
    [parm setObject:@"0" forKey:@"toUserId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.8.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"yl.lychengg"]];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBBSComent *model = self.dataArr[indexPath.row];
    return 65+model.textHeight+10 + (model.subCommentArr.count? (model.subCommentHeight+10):0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBBSComentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comentCell"];
    cell.showReply = YES;
    cell.commentM = self.dataArr[indexPath.row];
   __weak typeof(self) weakSelf = self;
    cell.replyBlock = ^(NoticeBBSComent * _Nonnull commentM) {
        NoticeBBSComentInputView *replyView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        replyView.commentM = commentM;
        replyView.delegate = self;
        replyView.plaStr = @"给留言留言";
        [replyView showJustComment:commentM.commentId];
        [replyView.contentView becomeFirstResponder];
        replyView.replyToView.replyLabel.text = [NSString stringWithFormat:@"回复 %@:%@",commentM.userInfo.nick_name,commentM.comment_content];
    };
    
    cell.deleteBlock = ^(NoticeBBSComent * _Nonnull commentM) {
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBBSComent *model = self.dataArr[indexPath.row];
    if (!model.subCommentArr.count) {
        return;
    }
    NoticeBBSComDetailView *comDetailView = [[NoticeBBSComDetailView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    comDetailView.postId = self.bbsModel.post_id;
    comDetailView.roadAll = self.roadAll;
    comDetailView.comModel = model;
    [comDetailView show];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NoticeBBSDetailSectionView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerSection"];
    __weak typeof(self) weakSelf = self;
    header.showTypeBlock = ^(NSInteger type) {
        if (type == 0) {
            weakSelf.type = @"2";
        }else if (type == 1){
            weakSelf.type = @"3";
        }else{
            weakSelf.type = @"1";
        }
        weakSelf.isDown = YES;
        weakSelf.isDown = YES;
        [weakSelf requestList];
    };
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y > 30) {
        self.navigationItem.title = self.bbsModel.title;
        self.headerView.titleL.hidden = YES;
    }else{
        self.headerView.titleL.hidden = NO;
        self.navigationItem.title = @"";
    }
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}
@end
