//
//  NoticeFriendRquestViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeFriendRquestViewController.h"
#import "NoticeStayVoiceCell.h"
#import "NoticeBackVoiceViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeNoDataView.h"
#import "NoticeNowViewController.h"
#import "NoticeSendViewController.h"
#import "NoticeWebViewController.h"
#import "NoticeTcPageController.h"
#import "NoticeTopTenController.h"
#import "NoticeDrawDateViewController.h"
#import "NoticeDrawShowListController.h"
#import "NoticeTcController.h"

#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeImageViewController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeVoiceDetailController.h"
#import "AFHTTPSessionManager.h"
#import "NoticePyComController.h"
#import "NoticeHelpDetailController.h"
#import "NoticeVoiceComDetailView.h"
@interface NoticeFriendRquestViewController ()<NoticeAgreeFriendDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSArray *titArr;
@end

@implementation NoticeFriendRquestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text =self.isOther? [NoticeTools getLocalStrWith:@"message.eachMessage"] : [NoticeTools getTextWithSim:@"学友和欣赏通知" fantText:@"學友和欣賞通知"];
    self.tableView.rowHeight = 68;
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeStayVoiceCell class] forCellReuseIdentifier:@"cell1"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMessage *message = self.dataArr[indexPath.row];
    if ([message.type isEqualToString:@"5"]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = message.from_user_id;
        ctl.isOther = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if ([message.type isEqualToString:@"3"] || [message.type isEqualToString:@"14"]) {
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",message.voice_id] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                if (model.resource) {
                    if (model.content_type.intValue == 2) {
                        NoticeMbsDetailTextController *ctl = [[NoticeMbsDetailTextController alloc] init];
                        ctl.voiceM = model;
                        [self.navigationController pushViewController:ctl animated:NO];
                    }else{
                        NoticeMBSDetailVoiceController *ctl = [[NoticeMBSDetailVoiceController alloc] init];
                        ctl.voiceM = model;
                        [self.navigationController pushViewController:ctl animated:NO];
                    }
                    return;
                }
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
    }else if([message.type isEqualToString:@"8"]){
        NoticeMessage *meg = self.dataArr[indexPath.row];
        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        NoticeWeb *web = [[NoticeWeb alloc] init];
        web.html_id = meg.html_id;
        ctl.web = web;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if ([message.type isEqualToString:@"4"]) {
        if (message.open_at.integerValue > 7) {
            NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
            ctl.userId = message.from_user_id;
            ctl.isOther = YES;
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }else if([message.type isEqualToString:@"16"] || message.type.intValue == 501 || message.type.intValue == 21) {//跳转到台词详情
        if (!message.line_id.intValue) {
            [self showToastWithText:@"台词已被删除"];
            return;
        }
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"checkStatus/4/%@",message.line_id] Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                NoticeTcPageController *ctl = [[NoticeTcPageController alloc] init];
                ctl.tcId = message.line_id;
                ctl.isFromMessageVC = YES;
                [self.navigationController pushViewController:ctl animated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];

    }else if ([message.type isEqualToString:@"18"] || [message.type isEqualToString:@"25"] || [message.type isEqualToString:@"27"] || [message.type isEqualToString:@"26"]) {//被喜欢/收藏的画/送的画/今日推荐
        NoticeDrawShowListController *ctl = [[NoticeDrawShowListController alloc] init];
        ctl.artId = message.artwork_id;
        ctl.listType = 7;
        ctl.isPicker = message.type.intValue == 26 ? YES:NO;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if([message.type isEqualToString:@"19"]) {//涂鸦的作品
        NoticeDrawDateViewController *ctl = [[NoticeDrawDateViewController alloc] init];
        ctl.artId = message.artwork_id;
        ctl.isSelf = YES;
        ctl.isFromMessage = YES;
        ctl.graffiti_id = message.graffiti_id;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if([message.type isEqualToString:@"20"]) {//被喜欢的涂鸦
        NoticeDrawDateViewController *ctl = [[NoticeDrawDateViewController alloc] init];
        ctl.artId = message.artwork_id;
        ctl.isSelf = YES;
        ctl.isFromMessage = YES;
        ctl.isBackReplay = YES;
        ctl.graffiti_id = message.graffiti_id;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if ((message.type.intValue >= 48100 && message.type.intValue <= 48102) || message.type.intValue == 17 || message.type.intValue == 22 || message.type.intValue == 23 || message.type.intValue == 26){
        if (!message.dubbing_id.intValue) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"py.thepyhasdel"]];
            return;
        }
    
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"checkStatus/3/%@",message.dubbing_id] Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                NoticePyComController *ctl = [[NoticePyComController alloc] init];
                if (message.type.intValue == 23) {
                    ctl.isPicker = YES;
                }
                ctl.pyId = message.dubbing_id;
                [self.navigationController pushViewController:ctl animated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    
    }else if([message.type isEqualToString:@"48602"]){
        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        NoticeWeb *web = [[NoticeWeb alloc] init];
        web.html_id = @"83";
        ctl.web = web;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if ((message.type.intValue >= 19000 && message.type.intValue <= 19002)){
        [self requestDetail:message];
    }
    else if ((message.type.intValue == 35)){
        [self requestArt:message];
    }else if (message.type.intValue >= 19010 && message.type.intValue <= 19013){
        [self requestBokeId:message];
    }
    else{
        //        NSString *url = @"http://itunes.apple.com/cn/lookup?id=1358222995";
        //        [[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        //            NSArray *results = responseObject[@"results"];
        //            if (results && results.count > 0) {
        //                NSDictionary *response = results.firstObject;
        //                NSString *trackViewUrl = response[@"trackViewUrl"];// AppStore 上软件的地址
        //                if (trackViewUrl) {
        //                    NSURL *appStoreURL = [NSURL URLWithString:trackViewUrl];
        //                    if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
        //                        [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
        //                    }
        //                }
        //            }
        //        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //        }];
    }
}

- (void)requestArt:(NoticeMessage *)message{
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

- (void)requestBokeId:(NoticeMessage *)message{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@",message.podcast_id] Accept:@"application/vnd.shengxi.v4.9.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeDanMuModel *bokeM = [NoticeDanMuModel mj_objectWithKeyValues:dict[@"data"]];
            //__weak typeof(self) weakSelf = self;
            NoticeVoiceComDetailView *comView = [[NoticeVoiceComDetailView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            if (message.type.intValue >= 19012) {
                comView.noInputView = YES;
            }
            comView.comId = message.comBokeModel.subId;
            comView.titleL.text = [NoticeTools getLocalStrWith:@"cao.liiuyan"];
            comView.voiceId = @"0";
            comView.fromBokeMsg = YES;
            comView.bokeModel = bokeM;
            comView.comModel = message.comBokeModel;
            [comView show];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)requestDetail:(NoticeMessage *)message{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeStayVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (self.isOther) {
        cell.other = self.dataArr[indexPath.row];
    }else{
        cell.message = self.dataArr[indexPath.row];
    }
    cell.index = indexPath.row;
    cell.delegate = self;
    if (indexPath.row == self.dataArr.count-1) {
        cell.line.hidden = YES;
    }else{
        cell.line.hidden = NO;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticeFriendRquestViewController *ctl = self;
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
        url = [NSString stringWithFormat:@"messages/%@/%@",[[NoticeSaveModel getUserInfo]user_id],self.isOther? @"3" : @"2"];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"messages/%@/%@?lastId=%@",[[NoticeSaveModel getUserInfo] user_id],self.isOther? @"3" : @"2",self.lastId];
        }else{
            url = [NSString stringWithFormat:@"messages/%@/%@",[[NoticeSaveModel getUserInfo] user_id],self.isOther? @"3" : @"2"];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
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
                NoticeMessage *model = [NoticeMessage mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                
                if (self.isFromPushOfBoke) {
                    if ([model.message_id isEqualToString:self.msgId] && (model.type.intValue >= 19010 && model.type.intValue <= 19013)) {
                        self.isFromPushOfBoke = NO;
                        [self requestBokeId:model];
                    }
                }
                
                if (self.isFromPushOfArt) {
                    if ([model.html_id isEqualToString:self.msgId] && [model.type isEqualToString:@"8"]) {
                        NoticeMessage *meg = model;
                        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
                        NoticeWeb *web = [[NoticeWeb alloc] init];
                        web.html_id = meg.html_id;
                        ctl.web = web;
                        self.isFromPushOfArt = NO;
                        [self.navigationController pushViewController:ctl animated:YES];
                    }
                }
            }
            if (self.dataArr.count) {
                NoticeMessage *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.msgId;
                self.tableView.tableFooterView = nil;
            }else{
                self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy3");
                self.queshenView.titleStr = [NoticeTools getLocalType]?@"So quiet and peaceful":@"我听见呼唤，来自茫茫人海";
                self.tableView.tableFooterView = self.queshenView;
            }
            self.isFromPushOfArt = NO;
            self.isFromPushOfBoke = NO;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

- (void)agreaaFriendWith:(NSInteger)index {
    
}

- (void)refusFriendWith:(NSInteger)index {
    
}


@end
