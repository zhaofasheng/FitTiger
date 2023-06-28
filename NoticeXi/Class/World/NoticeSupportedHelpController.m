//
//  NoticeSupportedHelpController.m
//  NoticeXi
//
//  Created by li lei on 2023/5/9.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeSupportedHelpController.h"
#import "NoticeHasSupportHelpCell.h"
#import "NoticeHasSupportSectionView.h"
#import "NoticeSupportFootView.h"
#import "NoticeHelpDetailController.h"
@interface NoticeSupportedHelpController ()
@property (nonatomic, assign) BOOL isDown;// YES下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@end

@implementation NoticeSupportedHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.tableView registerClass:[NoticeHasSupportHelpCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[NoticeHasSupportSectionView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[NoticeSupportFootView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.rowHeight = 40;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.userM = [NoticeSaveModel getUserInfo];
    

    self.navBarView.hidden = NO;
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.navBarView.titleL.text = [NoticeTools chinese:@"建议过" english:@"Commented" japan:@"提案をした"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeHasSupportHelpModel *model = self.dataArr[indexPath.section];
    [self requestHelpDetail:model.tieId];
}

- (void)requestHelpDetail:(NSString *)invitationId{
    NSString *url = @"";

    url = [NSString stringWithFormat:@"invitation/%@",invitationId];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeHelpListModel *model = [NoticeHelpListModel mj_objectWithKeyValues:dict[@"data"]];
            if (model) {
                NoticeHelpDetailController *ctl = [[NoticeHelpDetailController alloc] init];
                ctl.helpModel = model;
                __weak typeof(self) weakSelf = self;
                ctl.deleteSuccess = ^(NSString * _Nonnull tieId) {
                    for (NoticeHasSupportHelpModel *model in weakSelf.dataArr) {
                        if ([model.tieId isEqualToString:tieId]) {
                            [weakSelf.dataArr removeObject:model];
                            [weakSelf.tableView reloadData];
                            break;
                        }
                    }
                };
                ctl.noLikeBlock = ^(NoticeHelpListModel * _Nonnull helpM) {
                    [weakSelf noLikeTiezi:helpM];
                };
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

- (void)noLikeTiezi:(NoticeHelpListModel *)helpModel{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"invitationDislike/%@/%@",helpModel.tieId,helpModel.is_dislike.boolValue?@"2":@"1"] Accept:@"application/vnd.shengxi.v5.5.1+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            [self hideHUD];
            [self showToastWithText:[NoticeTools chinese:@"谢谢你的反馈" english:@"Thanks for helping" japan:@"助けてくれてありがとう"]];
    
            for (NoticeHasSupportHelpModel *model in self.dataArr) {
                if ([model.tieId isEqualToString:helpModel.tieId]) {
                    [self.dataArr removeObject:model];
                    [self.tableView reloadData];
                    break;
                }
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NoticeHasSupportHelpModel *model = self.dataArr[section];
    return model.replyModelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NoticeSupportFootView *footV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    
    return footV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NoticeHasSupportSectionView *sectionV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    NoticeHasSupportHelpModel *model = self.dataArr[section];
    sectionV.tieId = model.tieId;
    __weak typeof(self) weakSelf = self;
    sectionV.tieBlock = ^(NSString * _Nonnull tieiD) {
        [weakSelf requestHelpDetail:tieiD];
    };
    sectionV.contentL.text = model.title;
    return sectionV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeHasSupportHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NoticeHasSupportHelpModel *model = self.dataArr[indexPath.section];
    cell.tieFromUserId = model.user_id;
    cell.avaturl = self.userM.avatar_url;
    cell.supportModel = model.replyModelArr[indexPath.row];
    return cell;
}

- (void)request{
    
    NSString *url = @"";

    url = [NSString stringWithFormat:@"commentedInvitations?pageNo=%ld",self.pageNo];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.5.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeHasSupportHelpModel *model = [NoticeHasSupportHelpModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.defaultL;
                self.defaultL.text = [NoticeTools chinese:@"欸 这里空空的" english:@"Nothing yet" japan:@"まだ何もありません"];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
 
    __weak NoticeSupportedHelpController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo  = 1;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl request];
    }];
}

@end
