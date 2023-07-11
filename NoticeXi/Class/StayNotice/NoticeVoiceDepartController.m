//
//  NoticeVoiceDepartController.m
//  NoticeXi
//
//  Created by li lei on 2023/3/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceDepartController.h"
#import "NoticeDepartureCell.h"
#import "NoticeVoiceComDetailView.h"
@interface NoticeVoiceDepartController ()
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;
@end

@implementation NoticeVoiceDepartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-40);
    [self.tableView registerClass:[NoticeDepartureCell class] forCellReuseIdentifier:@"cell"];

    
    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDataLikeModel *model = self.dataArr[indexPath.row];
    if (model.voiceM) {
        [self upComView:model];
    }else{
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",model.voice_id] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                NoticeVoiceListModel *voicemodel = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                model.voiceM = voicemodel;
                [self upComView:model];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.clearUnreadBlock) {
        self.clearUnreadBlock(YES);
    }
}

- (void)upComView:(NoticeDataLikeModel *)model{
    NoticeVoiceComDetailView *comView = [[NoticeVoiceComDetailView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];

    NoticeVoiceComModel *comM = model.message_type.intValue == 17100? model.currentComM:model.parrentComM;
    if (model.message_type.intValue == 17100 || model.message_type.intValue == 17101) {
        comM.is_allow_reply = @"1";
       
        if ([NoticeTools getLocalType] == 1) {
            comView.titleL.text = [NSString stringWithFormat:@"Comment with%@",model.fromUser.nick_name];
        }else if ([NoticeTools getLocalType] == 2){
            comView.titleL.text = [NSString stringWithFormat:@"%@とのメッセージ",model.fromUser.nick_name];
        }else{
            comView.titleL.text = [NSString stringWithFormat:@"和%@的留言",model.fromUser.nick_name];
        }
    }else{
        model.currentComM.is_allow_reply = @"0";
        comView.titleL.text = [NoticeTools getLocalStrWith:@"ly.lydetail"];
    }
    
    comView.comId = model.message_type.intValue == 17100? model.currentComM.subId:model.parrentComM.subId;
    comView.voiceId = model.voice_id;
    comView.voiceM = model.voiceM;
    comView.comModel = comM;
    [comView show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDataLikeModel *model = self.dataArr[indexPath.row];
    return 98+model.voiceComHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDepartureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.voiceComModel = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticeVoiceDepartController *ctl = self;
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
        url = [NSString stringWithFormat:@"messages/%@/3",[[NoticeSaveModel getUserInfo]user_id]];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"messages/%@/3?lastId=%@",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"messages/%@/3",[[NoticeSaveModel getUserInfo]user_id]];
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
                self.defaultL.text = [NoticeTools chinese:@"啊呀 下次给Ta心情留个言好了" english:@"No interactions yet" japan:@"まだ返信がありません"];
                self.tableView.tableFooterView = self.defaultL;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}


@end
