//
//  NoticeMyCareListController.m
//  NoticeXi
//
//  Created by li lei on 2019/12/26.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyCareListController.h"
#import "NoticeMyFriendCell.h"
#import "DDHAttributedMode.h"
#import "NoticeNoDataView.h"
#import "NoticeWebViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMineViewController.h"
@interface NoticeMyCareListController ()
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeNoDataView *footView;
@end

@implementation NoticeMyCareListController
{
    UIView *_headv;
    UILabel *_label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [NoticeTools getWhiteColor:@"#F7F7F7" NightColor:@"#12121F"];
    self.dataArr = [NSMutableArray new];
    _headv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    _headv.backgroundColor = GetColorWithName(VBackColor);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,(DR_SCREEN_WIDTH-30)/2, 40)];
    label.font = ELEVENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VMainTextColor);
    _label = label;
    _label.text = [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"movie.noxinshang"] fantText:@"還沒有關註任何人"];
    [_headv addSubview:_label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2+15, 0, (DR_SCREEN_WIDTH-30)/2, 40)];
    label1.font = ELEVENTEXTFONTSIZE;
    label1.textColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    label1.text = [NoticeTools isSimpleLau]? @"为什么30天自动解除欣赏":@"為什麽30天自動解除關註";
    label1.textAlignment = NSTextAlignmentRight;
    label1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webClick)];
    [label1 addGestureRecognizer:tap];
    [_headv addSubview:label1];
    self.tableView.tableHeaderView = _headv;
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-35);
    [self.tableView registerClass:[NoticeMyFriendCell class] forCellReuseIdentifier:@"cell1"];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMyCareModel *person = self.dataArr[indexPath.row];
    if ([person.userInfo.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = person.userInfo.userId;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMyFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.careModel = self.dataArr[indexPath.row];
    cell.isPipei = NO;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticeMyCareListController *ctl = self;

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
        url = [NSString stringWithFormat:@"userSubscription?resourceType=%ld",(long)self.type];
    }else{
        url = [NSString stringWithFormat:@"userSubscription?resourceType=%ld$lastId=%@",(long)self.type,self.lastId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                NoticeMovie *movieTotalM = [NoticeMovie mj_objectWithKeyValues:dict[@"data"]];
                if (movieTotalM.total.intValue) {
                    self->_label.text = [NoticeTools getTextWithSim:[NSString stringWithFormat:@"当前欣赏了%d位小伙伴",movieTotalM.total.intValue] fantText:[NSString stringWithFormat:@"當前關註了%d位小夥伴",movieTotalM.total.intValue]];
                }
                
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"][@"list"]) {
                NoticeMyCareModel *model = [NoticeMyCareModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeMyCareModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.log_id;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return YES;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak NoticeMyCareListController *ctl = self;
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"xs.calxs"] fantText:@"取消關註"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSString *str = nil;
        if (self.type == 1) {
            str = [NoticeTools isSimpleLau]?@"确定取消欣赏Ta的电影心情吗?":@"確定取消關註Ta的电影心情嗎?";
        }else if (self.type == 2){
            str = [NoticeTools isSimpleLau]?@"确定取消欣赏Ta的书籍心情吗?":@"確定取消關註Ta的書籍心情嗎?";
        }else if (self.type == 3){
            str = [NoticeTools isSimpleLau]?@"确定取消欣赏Ta的音乐心情吗?":@"確定取消關註Ta的音乐心情嗎?";
        }
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"main.sure"]:@"確定" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"]];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [ctl showHUD];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"userSubscription/%@",[self.dataArr[indexPath.row] subId]] Accept:@"application/vnd.shengxi.v4.1+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [ctl hideHUD];
                    if (success) {
                        [ctl.dataArr removeObjectAtIndex:indexPath.row];
                        if (!ctl.dataArr.count) {
                            ctl.tableView.tableFooterView = ctl.footView;
                        }
                        [ctl.tableView reloadData];
                    }
                } fail:^(NSError * _Nullable error) {
                    [ctl hideHUD];
                }];
            }
        };
        
        [alerView showXLAlertView];

        
    }];
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction];
}

- (void)webClick{
    NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
    ctl.specic = @"3";
    [self.navigationController pushViewController:ctl animated:YES];
}
@end
