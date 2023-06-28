//
//  NoticeManagerBBSController.m
//  NoticeXi
//
//  Created by li lei on 2020/11/12.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerBBSController.h"
#import "NoticeManagerTzCell.h"
#import "NoticeBBSDetailController.h"
@interface NoticeManagerBBSController ()
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *changeNum;
@property (nonatomic, strong) NoticeBBSModel *changeModel;
@end

@implementation NoticeManagerBBSController

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 60)];
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
        [self.cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
        [self.cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:self.cancelBtn];
        self.cancelBtn.hidden = YES;
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-100, 60)];
        self.markL.textColor = GetColorWithName(VDarkTextColor);
        self.markL.font = ELEVENTEXTFONTSIZE;
        self.markL.numberOfLines = 2;
        self.markL.textAlignment = NSTextAlignmentCenter;
        self.markL.text = @"0XXX为主页帖子，1XXX为往期帖子\n数字越小位置越上(一次只能编辑一个)";
        [_headerView addSubview:self.markL];
        self.markL.hidden = YES;
        
        self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 60)];
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editButton setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        self.editButton.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
        [self.editButton addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:self.editButton];
  
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = GetColorWithName(VlineColor);
        [_headerView addSubview:line];
    }
    return _headerView;
}

- (void)cancelClick{
    self.cancelBtn.hidden = YES;
    self.markL.hidden = YES;
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
    self.isEdit = NO;
    [self.tableView reloadData];
}

- (void)editClick{
    
    if (self.isEdit) {
        
        if (!self.changeNum) {
            return;
        }
        [self showHUD];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
        [parm setObject:self.changeNum forKey:@"postSort"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/posts/%@/postSort",self.changeModel.post_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                self.changeNum = nil;
                [self cancelClick];
                [self.tableView.mj_header beginRefreshing];
                [self showToastWithText:@"编辑成功"];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        return;
    }
    
    self.cancelBtn.hidden = NO;
    self.markL.hidden = NO;
    [self.editButton setTitle:[NoticeTools getLocalStrWith:@"groupfm.finish"] forState:UIControlStateNormal];
    [self.editButton setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
    self.isEdit = YES;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.backgroundColor = GetColorWithName(VBackColor);



    self.tableView.tableHeaderView = self.headerView;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-60);

    [self.tableView registerClass:[NoticeManagerTzCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 40;
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)createRefesh{
    
    __weak NoticeManagerBBSController *ctl = self;

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBBSModel *bbsModel = self.dataArr[indexPath.row];
    NoticeBBSDetailController *ctl = [[NoticeBBSDetailController alloc] init];
    ctl.manageCode = self.mangagerCode;
    ctl.bbsModel = bbsModel;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)requestList{
    NSString *url = @"";
    if (self.isDown) {
        url = [NSString stringWithFormat:@"admin/posts?confirmPasswd=%@",self.mangagerCode];
    }else{
        url = [NSString stringWithFormat:@"admin/posts?confirmPasswd=%@&lastSort=%@&pageNo=%ld",self.mangagerCode,self.lastId,self.pageNo];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
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
                model.post_id = model.cagaoId;
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeBBSModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.post_sort;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeManagerTzCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isEdit = self.isEdit;
    cell.bbsM = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.finishBlock = ^(NSString * _Nonnull newNum, NoticeBBSModel * _Nonnull bbsModel) {
        weakSelf.changeNum = newNum;
        weakSelf.changeModel = bbsModel;
    };
    return cell;
}

@end
