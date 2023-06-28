//
//  NoticeMyBokeController.m
//  NoticeXi
//
//  Created by li lei on 2022/9/20.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyBokeController.h"
#import "NoticeBoKeCell.h"
#import "NoticeDanMuController.h"
#import "NoticeSendBoKeController.h"
#import "NoticeBoKeDocumController.h"
@interface NoticeMyBokeController ()
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger page;
@end

@implementation NoticeMyBokeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    self.dataArr = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;

    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.navBarView.backgroundColor = self.view.backgroundColor;
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"b.myboke"];
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arr = @[[NoticeTools getLocalImageNameCN:@"bktg_Image"],[NoticeTools getLocalImageNameCN:@"bokgjzx_Image"]];
    
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30+175*i, NAVIGATION_BAR_HEIGHT+20, 140, 56)];
        btn.tag = i;
        [btn setBackgroundImage:UIImageNamed(arr[i]) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(funClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+20+56+25, 150, 25)];
    titleL.font = XGEightBoldFontSize;
    titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    titleL.text = [NoticeTools chinese:@"播客动态" english:@"Podcasts" japan:@"内容"];
    [self.view addSubview:titleL];
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(titleL.frame)+10, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-10-CGRectGetMaxY(titleL.frame));
    
    [self.tableView registerClass:[NoticeBoKeCell class] forCellReuseIdentifier:@"cell"];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBoKeBeDelete:) name:@"DeleteBoKeNotification" object:nil];
}

- (void)getBoKeBeDelete:(NSNotification*)notification{
    if (self.dataArr.count) {
        for (NoticeDanMuModel *bokeM in self.dataArr) {
            NSDictionary *nameDictionary = [notification userInfo];
            NSString *num = nameDictionary[@"danmuNumber"];
            if ([bokeM.podcast_no isEqualToString:num]) {
                [self.dataArr removeObject:bokeM];
                [self.tableView reloadData];
                break;
            }
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDanMuModel *model = self.dataArr[indexPath.row];
    return 50 + model.titleHeight + (((DR_SCREEN_WIDTH-70)*203)/305)+12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];

    ctl.bokeModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBoKeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isMine = YES;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{

    __weak NoticeMyBokeController *ctl = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.page = 1;
        [ctl requestVoice];
    }];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.page++;
        ctl.isDown = NO;
        [ctl requestVoice];
    }];
}

- (void)requestVoice{
    NSString *url = nil;
    if (self.isDown) {
        url = @"podcast/1";
    }else{
        url = [NSString stringWithFormat:@"podcast/1?pageNo=%ld",self.page];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.4+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dic];
                if (!model.background_url) {
                    model.background_url = model.cover_url;
                }
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.queshenView.frame = self.tableView.bounds;
                self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy21");
                self.queshenView.titleStr = [NoticeTools chinese:@"空空如也，去投稿试试吧～" english:@"Try posting your first podcast." japan:@"最初のポッドキャストを投稿しよ。"];
                self.tableView.tableFooterView = self.queshenView;
            }
            
            [self.tableView reloadData];
        }

    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)funClick:(UIButton *)button{
    if (button.tag == 0) {
        __weak typeof(self) weakSelf = self;
        NoticeSendBoKeController *ctl = [[NoticeSendBoKeController alloc] init];
        ctl.refreshDataBlock = ^(BOOL refresh) {
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeBoKeDocumController *ctl = [[NoticeBoKeDocumController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
