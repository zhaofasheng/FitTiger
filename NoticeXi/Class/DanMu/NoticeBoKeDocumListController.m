//
//  NoticeBoKeDocumListController.m
//  NoticeXi
//
//  Created by li lei on 2022/9/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBoKeDocumListController.h"
#import "NoticeBoKeDocumCell.h"
#import "NoticeSaveVoiceTools.h"
@interface NoticeBoKeDocumListController ()
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger page;
@end

@implementation NoticeBoKeDocumListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    [self.tableView registerClass:[NoticeBoKeDocumCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 182+15;
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-10);
    
    self.dataArr = [[NSMutableArray alloc] init];
    if (self.type == 3) {
        NSMutableArray *arr = [NoticeSaveVoiceTools getbokepArrary];
        for (NoticeVoiceSaveModel *model in arr) {
            NoticeDanMuModel *bokM = [[NoticeDanMuModel alloc] init];
            bokM.isSaveInDocum = YES;
            bokM.podcast_title = model.titleName;
            bokM.podcast_intro = model.textContent;
            bokM.cover_url = model.img1Path;
            bokM.audio_url = model.voiceFilePath;
            bokM.saveModel = model;
            [self.dataArr addObject:bokM];
        }
        if (self.dataArr.count) {
            self.tableView.tableFooterView = nil;
        }else{
            self.queshenView.frame = self.tableView.bounds;
            self.queshenView.titleStr = [NoticeTools chinese:@"这里什么都没有噢～" english:@"There is nothing yet." japan:@"まだ何もありません。"];
            self.tableView.tableFooterView = self.queshenView;
        }
        [self.tableView reloadData];
    }else{
        [self createRefesh];
        [self.tableView.mj_header beginRefreshing];
    }

}


- (void)createRefesh{

    __weak NoticeBoKeDocumListController *ctl = self;
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
    url = [NSString stringWithFormat:@"podcast/%@?pageNo=%ld",self.type==1?@"2":@"3",self.page];
    
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
                model.podcast_type = self.type==1?@"1":@"2";
                if (!model.background_url) {
                    model.background_url = model.cover_url;
                }
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.queshenView.frame = self.tableView.bounds;
                self.queshenView.titleStr = [NoticeTools chinese:@"这里什么都没有噢～" english:@"There is nothing yet." japan:@"まだ何もありません。"];
                self.tableView.tableFooterView = self.queshenView;
            }
            [self.tableView reloadData];
        }

    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeBoKeDocumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.index = indexPath.row;
    cell.model = self.dataArr[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^(NSInteger index) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"确定删除此稿件吗？" english:@"Delete this post?" japan:@"この投稿を削除しますか？"] message:[NoticeTools chinese:@"对应的播客源文件也会被删除" english:@"Podcast will be deleted" japan:@"ポッドキャストは削除されます"] sureBtn:[NoticeTools getLocalStrWith:@"py.dele"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index1) {
            NSMutableArray *arr = [NoticeSaveVoiceTools getbokepArrary];
            if (index1 == 1) {
                if (index <= weakSelf.dataArr.count-1  && index <= arr.count-1) {
                    [weakSelf.dataArr removeObjectAtIndex:index];
                    [arr removeObjectAtIndex:index];
                    [NoticeSaveVoiceTools savebokeArr:arr];
                    [weakSelf.tableView reloadData];
                }
            }
        };
        [alerView showXLAlertView];
    };
    
    cell.suredeleteBlock = ^(NSInteger index) {
        if (weakSelf.type == 2) {
            if (index <= weakSelf.dataArr.count-1) {
                [weakSelf.dataArr removeObjectAtIndex:index];
                [weakSelf.tableView reloadData];
            }
            return;
        }
        NSMutableArray *arr = [NoticeSaveVoiceTools getbokepArrary];
        if (index <= weakSelf.dataArr.count-1  && index <= arr.count-1) {
            [weakSelf.dataArr removeObjectAtIndex:index];
            [arr removeObjectAtIndex:index];
            [NoticeSaveVoiceTools savebokeArr:arr];
            [weakSelf.tableView reloadData];
        }
    };
    
    cell.deleteNetBlock = ^(NoticeDanMuModel * _Nonnull bokM) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:[NoticeTools chinese:@"确定删除此播客吗？" english:@"Delete this podcast?" japan:@"このポッドキャストを削除しますか?"] english:@"Delete this podcast?" japan:@"このポッドキャストを削除しますか?"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"py.dele"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index1) {
            if (index1 == 1) {
                [[NoticeTools getTopViewController] showHUD];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"podcast/%@",bokM.podcast_no] Accept:@"application/vnd.shengxi.v5.4.4+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [[NoticeTools getTopViewController] hideHUD];
                    if (success) {
                        [weakSelf.dataArr removeObject:bokM];
                        [weakSelf.tableView reloadData];
                    }
                } fail:^(NSError * _Nullable error) {
                    [[NoticeTools getTopViewController] hideHUD];
                }];
            }
        };
        [alerView showXLAlertView];
    };
    
    return cell;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;


}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    [appdel.audioPlayer stopPlaying];
}

@end
