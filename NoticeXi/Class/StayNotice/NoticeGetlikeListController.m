//
//  NoticeGetlikeListController.m
//  NoticeXi
//
//  Created by li lei on 2023/3/2.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeGetlikeListController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeVoiceDetailController.h"
#import "NoticePyComController.h"
#import "NoticeDanMuController.h"
#import "NoticeTcPageController.h"
#import "NoticeHelpDetailController.h"
#import "NoticeDrawShowListController.h"
#import "NoticeDataLikeCell.h"
@interface NoticeGetlikeListController ()
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;
@end

@implementation NoticeGetlikeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-40);
    [self.tableView registerClass:[NoticeDataLikeCell class] forCellReuseIdentifier:@"cell"];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDataLikeModel *model = self.dataArr[indexPath.row];
    if (model.message_type.intValue == 3 || model.message_type.intValue == 17102 || model.message_type.intValue == 17103) {
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",model.voice_id] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];

                if (model.content_type.intValue == 2) {
                    NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
                    ctl.voiceM = model;
                    [self.navigationController pushViewController:ctl animated:NO];
                }else{
                    NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
                    ctl.voiceM = model;
                    [self.navigationController pushViewController:ctl animated:NO];
                }
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }else if (model.message_type.intValue == 22 || model.message_type.intValue == 17 || model.message_type.intValue == 48102 || model.message_type.intValue == 23){
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
    }else if (model.message_type.intValue == 16 || model.message_type.intValue == 501){
        if (!model.line_id.intValue) {
            [self showToastWithText:@"台词已被删除"];
            return;
        }
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"checkStatus/4/%@",model.line_id] Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                NoticeTcPageController *ctl = [[NoticeTcPageController alloc] init];
                ctl.tcId = model.line_id;
                ctl.isFromMessageVC = YES;
                [self.navigationController pushViewController:ctl animated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }else if (model.message_type.intValue == 19002){
        [self requestDetail:model];
    }else if (model.message_type.intValue == 19012 || model.message_type.intValue == 19013){
        [self requestBokeId:model];
    }else if (model.message_type.intValue == 25 || model.message_type.intValue == 27 || model.message_type.intValue == 18 || model.message_type.intValue == 26){
        NoticeDrawShowListController *ctl = [[NoticeDrawShowListController alloc] init];
        ctl.artId = model.artwork_id;
        ctl.listType = 7;
        ctl.isPicker = model.message_type.intValue == 26 ? YES:NO;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)requestBokeId:(NoticeDataLikeModel *)message{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@",message.podcast_id] Accept:@"application/vnd.shengxi.v4.9.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dict[@"data"]];
            NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];
            ctl.bokeModel = model;
            [self.navigationController pushViewController:ctl animated:YES];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)requestDetail:(NoticeDataLikeModel *)message{
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDataLikeModel *model = self.dataArr[indexPath.row];
   if (model.message_type.intValue == 19002){//求助帖留言点赞
        if (model.comModel.content_type.intValue > 1) {
            return 174;
        }
        return 106;
    }else if (model.message_type.intValue == 17102 || model.message_type.intValue == 17103){//心情留言/回复点赞
        return 106;
    }else if (model.message_type.intValue == 19012 || model.message_type.intValue == 19013 || model.message_type.intValue == 48102){//赞了配音/播客下的评论,
        return 106;
    }
    return 82;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDataLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.likeModel = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticeGetlikeListController *ctl = self;
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
        url = [NSString stringWithFormat:@"messages/%@/1",[[NoticeSaveModel getUserInfo]user_id]];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"messages/%@/1?lastId=%@",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"messages/%@/1",[[NoticeSaveModel getUserInfo]user_id]];
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
                self.defaultL.text = [NoticeTools chinese:@"哎也 贴贴也太稀有了吧" english:@"Post more to receive more" japan:@"もっと投稿してもっと受け取りましょう"];
                self.tableView.tableFooterView = self.defaultL;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

@end
