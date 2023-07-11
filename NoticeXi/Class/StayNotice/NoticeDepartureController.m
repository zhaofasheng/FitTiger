//
//  NoticeDepartureController.m
//  NoticeXi
//
//  Created by li lei on 2023/3/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeDepartureController.h"
#import "NoticeDepartureCell.h"
#import "NoticePyComController.h"
#import "NoticeHelpDetailController.h"
#import "NoticeVoiceComDetailView.h"
#import "NoticeWebViewController.h"
#import "NoticeImageViewController.h"

@interface NoticeDepartureController ()

@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;

@end

@implementation NoticeDepartureController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = [NoticeTools chinese:@"社区内容留言" english:@"Community" japan:@"コミュニティ"];
    [self.tableView registerClass:[NoticeDepartureCell class] forCellReuseIdentifier:@"cell"];
    self.navBarView.backgroundColor = [UIColor whiteColor];
    
    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDataLikeModel *model = self.dataArr[indexPath.row];
    if (model.message_type.intValue == 48100 || model.message_type.intValue == 48101) {
        if (!model.dubbing_id.intValue) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"py.thepyhasdel"]];
            return;
        }
    
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"checkStatus/3/%@",model.dubbing_id] Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                NoticePyComController *ctl = [[NoticePyComController alloc] init];
                if (model.message_type.intValue == 23) {
                    ctl.isPicker = YES;
                }
                ctl.pyId = model.dubbing_id;
                [self.navigationController pushViewController:ctl animated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }else if (model.message_type.intValue == 19000 || model.message_type.intValue == 19001){
        [self requestDetail:model needDetail:NO];
    }else if (model.message_type.intValue == 19010 || model.message_type.intValue == 19011){
        [self requestBokeId:model];
    }else if (model.message_type.intValue == 8){
        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        NoticeWeb *web = [[NoticeWeb alloc] init];
        web.html_id = model.html_id;
        ctl.web = web;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (model.message_type.intValue == 35){
        [self requestArt:model];
    }
}

- (void)requestArt:(NoticeDataLikeModel *)message{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"details/%@",message.article_id] Accept:@"application/vnd.shengxi.v5.4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeBannerModel *bannerM = [NoticeBannerModel mj_objectWithKeyValues:dict[@"data"]];
            NoticeImageViewController *ctl = [[NoticeImageViewController alloc] init];
            ctl.url = bannerM.http_attr_pc;
            ctl.ismessage = YES;
            ctl.bannerM = bannerM;
            [self.navigationController pushViewController:ctl animated:YES];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)requestBokeId:(NoticeDataLikeModel *)message{
    if (message.bokeModel) {
     
        NoticeVoiceComDetailView *comView = [[NoticeVoiceComDetailView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        
        comView.comId = message.message_type.intValue==19011?message.podcast_parent_comment_id: message.comBokeModel.subId;
        comView.bokeModel = message.bokeModel;
        comView.titleL.text = [NoticeTools getLocalStrWith:@"cao.liiuyan"];
        comView.comModel = message.comBokeModel;

        comView.voiceId = @"0";
        comView.fromBokeMsg = YES;
        [comView show];
        return;
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@",message.podcast_id] Accept:@"application/vnd.shengxi.v4.9.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeDanMuModel *bokeM = [NoticeDanMuModel mj_objectWithKeyValues:dict[@"data"]];
            //__weak typeof(self) weakSelf = self;
            NoticeVoiceComDetailView *comView = [[NoticeVoiceComDetailView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            comView.comId = message.message_type.intValue==19011?message.podcast_parent_comment_id: message.comBokeModel.subId;
            message.bokeModel = bokeM;
            comView.bokeModel = bokeM;
            comView.comModel = message.comBokeModel;
            
            if ([NoticeTools getLocalType] == 1) {
                comView.titleL.text = [NSString stringWithFormat:@"Comment with%@",message.fromUser.nick_name];
            }else if ([NoticeTools getLocalType] == 2){
                comView.titleL.text = [NSString stringWithFormat:@"%@とのメッセージ",message.fromUser.nick_name];
            }else{
                comView.titleL.text = [NSString stringWithFormat:@"和%@的留言",message.fromUser.nick_name];
            }
            comView.voiceId = @"0";
            comView.fromBokeMsg = YES;
            [comView show];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)requestDetail:(NoticeDataLikeModel *)message needDetail:(BOOL)needDetail{
    NSString *url = @"";

    url = [NSString stringWithFormat:@"invitation/%@",message.invitation_id];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeHelpListModel *model = [NoticeHelpListModel mj_objectWithKeyValues:dict[@"data"]];
            if (model) {
                NoticeHelpDetailController *ctl = [[NoticeHelpDetailController alloc] init];
                ctl.helpModel = model;
                ctl.comModel = message.comModel;
                ctl.needDetail = needDetail;
                [self.navigationController pushViewController:ctl animated:YES];
            }else{
                [self showToastWithText:@"帖子已不存在"];
            }
        }else{
            [self showToastWithText:@"帖子已不存在"];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDataLikeModel *model = self.dataArr[indexPath.row];
    if (model.message_type.intValue == 48100 || model.message_type.intValue == 48101) {
        return 148+model.dubbingHeight;
    }else if (model.message_type.intValue == 19000){
        return 148+model.comHeight;
    }else if (model.message_type.intValue == 19001){
        return 148+model.subComHeight;
    }else if (model.message_type.intValue == 19010 || model.message_type.intValue == 19011) {
        return 148+model.podcastHeight;
    }else if (model.message_type.intValue == 8) {
        return 148+model.htmlHeight;
    }else if (model.message_type.intValue == 35) {
        return 148+model.articleHeight;
    }
    return 148;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDepartureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.lyModel = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.clickHelpTitleBlock = ^(NoticeDataLikeModel * _Nonnull model) {
        [weakSelf requestDetail:model needDetail:YES];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticeDepartureController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)request{
    NSString *url = nil;
    
    if (self.isDown) {
        url = [NSString stringWithFormat:@"messages/%@/2",[[NoticeSaveModel getUserInfo]user_id]];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"messages/%@/2?lastId=%@",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"messages/%@/2",[[NoticeSaveModel getUserInfo]user_id]];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeDataLikeModel *model = [NoticeDataLikeModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeDataLikeModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.msgId;
                self.tableView.tableFooterView = nil;
            }else{
                self.defaultL.text = [NoticeTools chinese:@"啊呀 下次和Ta互动一下好了" english:@"You haven't received any comment yet" japan:@"まだコメントを受け取っていません"];
                self.tableView.tableFooterView = self.defaultL;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}


@end
