//
//  NoticeHelpListController.m
//  NoticeXi
//
//  Created by li lei on 2022/8/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeHelpListController.h"
#import "NoticeHelpListCell.h"
#import "NoticreSendHelpController.h"
#import "NoticeHelpDetailController.h"
#import "NoticeMyHelpListController.h"
#import "NoticeSupportedHelpController.h"
@interface NoticeHelpListController ()
@property (nonatomic, assign) BOOL isDown;// YES下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) UIView *headerView;
@end

@implementation NoticeHelpListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeHelpListCell class] forCellReuseIdentifier:@"cell"];
    
    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 90)];
   
    NSArray *imgArr = @[@"myhelpimg",@"mysupportimg"];
    NSArray *titleArr = @[[NoticeTools getLocalStrWith:@"tabbar.mine"],[NoticeTools chinese:@"建议过" english:@"Commented" japan:@"提案をした"]];
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-315)/2+175*i, 20, 140, 56)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        imageView.image = UIImageNamed(imgArr[i]);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
        label.font = FIFTHTEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.text = titleArr[i];
        [imageView addSubview:label];
        [self.headerView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listTap:)];
        [imageView addGestureRecognizer:tap];
    }
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)listTap:(UITapGestureRecognizer *)tap{
    UIImageView *tapV = (UIImageView *)tap.view;
    if(tapV.tag == 0){
        NoticeMyHelpListController *ctl = [[NoticeMyHelpListController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeSupportedHelpController *ctl = [[NoticeSupportedHelpController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)requestTop{
    if (self.isMine) {
        if (self.isDown) {
            self.isDown = NO;
            [self.dataArr removeAllObjects];
        }
        [self request];
        return;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"invitation/top" Accept:@"application/vnd.shengxi.v5.4.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            NoticeHelpListModel *model = [NoticeHelpListModel mj_objectWithKeyValues:dict[@"data"]];
            NoticeHelpListModel *hotmodel = [NoticeHelpListModel mj_objectWithKeyValues:model.hot_invitation];
            if (hotmodel.title.length) {
                hotmodel.isHot = YES;
                [self.dataArr addObject:hotmodel];
            }
            [self request];
        }else{
            [self request];
        }
    } fail:^(NSError * _Nullable error) {
        [self request];
    }];
}

- (void)request{
    
    NSString *url = @"";

    url =self.isMine?[NSString stringWithFormat:@"myInvitation?pageNo=%ld",self.pageNo]: [NSString stringWithFormat:@"invitation?pageNo=%ld",self.pageNo];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
           
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeHelpListModel *model = [NoticeHelpListModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.defaultL;
                self.defaultL.text = self.isMine?[NoticeTools chinese:@"欸 还没尝试过匿名求助吧" english:@"No posts made by you yet" japan:@"あなたからの投稿はまだありません"]: [NoticeTools chinese:@"欸 这里空空的" english:@"Nothing yet" japan:@"まだ何もありません"];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
 
    __weak NoticeHelpListController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo  = 1;
        [ctl requestTop];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count-1 >= indexPath.row) {
        NoticeHelpListModel *model = self.dataArr[indexPath.row];
        return (model.isMoreFiveLines?model.fiveTextHeight: model.textHeight)+15+48+40 + (model.isHot?30:0) + (self.isMine?32:0);
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeHelpListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isMine = self.isMine;
    if (self.dataArr.count > indexPath.row) {
        cell.helpModel = self.dataArr[indexPath.row];
    }
    __weak typeof(self) weakSelf = self;
    cell.noLikeBlock = ^(NoticeHelpListModel * _Nonnull helpM) {
        [weakSelf noLikeTiezi:helpM];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row > self.dataArr.count-1){
        return;
    }
    NoticeHelpListModel *model = self.dataArr[indexPath.row];
    if(model.is_dislike.boolValue){
        [self showToastWithText:[NoticeTools chinese:@"你已将此帖子设为不喜欢的内容" english:@"You have unliked this post" japan:@"この投稿を非表示にしました"]];
        return;
    }
    NoticeHelpDetailController *ctl = [[NoticeHelpDetailController alloc] init];
    ctl.helpModel = model;
    __weak typeof(self) weakSelf = self;
    ctl.deleteSuccess = ^(NSString * _Nonnull tieId) {
        for (NoticeHelpListModel *model in weakSelf.dataArr) {
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
}

- (void)noLikeTiezi:(NoticeHelpListModel *)helpModel{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"invitationDislike/%@/%@",helpModel.tieId,helpModel.is_dislike.intValue==1?@"2":@"1"] Accept:@"application/vnd.shengxi.v5.5.1+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            [self hideHUD];
            [self showToastWithText:helpModel.is_dislike.boolValue? @"已恢复":[NoticeTools chinese:@"谢谢你的反馈" english:@"Thanks for helping" japan:@"助けてくれてありがとう"]];
            helpModel.is_dislike = helpModel.is_dislike.intValue==1?@"0":@"1";
            if(helpModel.isHot){
                return;
            }
            for (NoticeHelpListModel *model in self.dataArr) {
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

@end
