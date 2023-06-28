//
//  NoticeSendBBSRecoderController.m
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendBBSRecoderController.h"
#import "NoticeSendBBSHistoryCell.h"
#import "NoticeNavItemButton.h"
#import "NoticeSendBBSController.h"
#import "NoticeBBSDetailController.h"
@interface NoticeSendBBSRecoderController ()
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UILabel *noDanteL;
@end

@implementation NoticeSendBBSRecoderController

- (UILabel *)noDanteL{
    if (!_noDanteL) {
        _noDanteL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height)];
        _noDanteL.font = FOURTHTEENTEXTFONTSIZE;
        _noDanteL.textAlignment = NSTextAlignmentCenter;
        _noDanteL.textColor = GetColorWithName(VDarkTextColor);
        _noDanteL.text = @"你还没有投过稿哦";
    }
    return _noDanteL;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [NoticeTools getTextWithSim:@"投稿记录" fantText:@"投稿記錄"];
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    NoticeNavItemButton *btn = [NoticeNavItemButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,0,60, 25);
    [btn setTitle:@"投稿" forState:UIControlStateNormal];
    [btn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
    btn.backgroundColor = GetColorWithName(VMainThumeColor);
    btn.layer.cornerRadius = 25/2;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.dataArr = [NSMutableArray new];
    [self.tableView registerClass:[NoticeSendBBSHistoryCell class] forCellReuseIdentifier:@"hisCell"];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)createRefesh{
    
    __weak NoticeSendBBSRecoderController *ctl = self;

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
        url = [NSString stringWithFormat:@"users/%@/drafts",[NoticeTools getuserId]];
    }else{
        url = [NSString stringWithFormat:@"users/%@/drafts?lastId=%@&pageNo=%ld",[NoticeTools getuserId],self.lastId,self.pageNo];
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
                NoticeBBSModel *model = [NoticeBBSModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeBBSModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.cagaoId;
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

- (void)sendClick{
    NoticeSendBBSController *ctl = [[NoticeSendBBSController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSendBBSHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hisCell"];
    cell.bbsModel = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^(NoticeBBSModel * _Nonnull bbsModel) {
        [weakSelf deleteWith:bbsModel];
    };
    
    return cell;
}

- (void)deleteWith:(NoticeBBSModel *)bbsModel{
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"drafts/%@",bbsModel.cagaoId] Accept:@"application/vnd.shengxi.v4.8.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            for (NoticeBBSModel *model in self.dataArr) {
                if ([model.cagaoId isEqualToString:bbsModel.cagaoId]) {
                    [self.dataArr removeObject:model];
                    break;
                }
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBBSModel *model = self.dataArr[indexPath.row];
    if (model.twoLineHeight>=13) {
        return 72+model.twoLineHeight-13 + model.imgHeight;
    }else{
       return  72+model.imgHeight;
    }
}

@end
