//
//  NoticeVoiceAlbumController.m
//  NoticeXi
//
//  Created by li lei on 2023/3/1.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceAlbumController.h"
#import "NoticeVoiceAlbumCell.h"
#import "NoticeNewAddZjView.h"
#import "NoticeDiaDetailController.h"
#import "NoticeZJDetailController.h"
@interface NoticeVoiceAlbumController ()
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeVoiceAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-40-34);
    [self.tableView registerClass:[NoticeVoiceAlbumCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 100;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH-30, 40)];
    addButton.layer.cornerRadius = 20;
    addButton.layer.masksToBounds = YES;
    addButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [addButton setTitle:self.isVoiceAlbum? [NoticeTools chinese:@"新建心情专辑" english:@"Add an album" japan:@"アルバムを追加"]:[NoticeTools chinese:@"新建对话专辑" english:@"Add a chat album" japan:@"チャットアルバムの追加"] forState:UIControlStateNormal];
    addButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addzjClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isVoiceAlbum) {
        NoticeDiaDetailController *ctl = [[NoticeDiaDetailController alloc] init];
        ctl.zjModel = self.dataArr[indexPath.row];
        __weak typeof(self) weakSelf = self;
        ctl.deleteSuccessBlock = ^(NSString * _Nonnull albumId) {
            for (NoticeZjModel *oldM in weakSelf.dataArr) {
                if ([oldM.albumId isEqualToString:albumId]) {
                    [weakSelf.dataArr removeObject:oldM];
                    break;
                }
            }
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
            [weakSelf.tableView reloadData];
        };
        
        ctl.editSuccessBlock = ^(NoticeZjModel * _Nonnull zjmodel) {
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
   
    NoticeZJDetailController *ctl = [[NoticeZJDetailController alloc] init];
    ctl.zjModel = self.dataArr[indexPath.row];
    ctl.userId = [NoticeTools getuserId];
    __weak typeof(self) weakSelf = self;
    ctl.deleteSuccessBlock = ^(NSString * _Nonnull albumId) {
        for (NoticeZjModel *oldM in weakSelf.dataArr) {
            if ([oldM.albumId isEqualToString:albumId]) {
                [weakSelf.dataArr removeObject:oldM];
                break;
            }
        }
        [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
        [weakSelf.tableView reloadData];
    };
    
    ctl.editSuccessBlock = ^(NoticeZjModel * _Nonnull zjmodel) {
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isdialog = !self.isVoiceAlbum;
    cell.zjModel = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)createRefesh{
    
    __weak NoticeVoiceAlbumController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestList];
    }];
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestList];
    }];
}

- (void)requestList{
    NSString *url = nil;
    
    if (self.isDown) {
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=updatedAt",[[NoticeSaveModel getUserInfo] user_id]];
    }else{
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByValue=%@&orderByField=updatedAt",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
     
    }
    
    
    if (!self.isVoiceAlbum) {
        if (self.isDown) {
            url = @"dialogAlbums?orderByField=updatedAt";
        }else{
            url = [NSString stringWithFormat:@"dialogAlbums?orderByValue=%@&orderByField=updatedAt",self.lastId];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:!self.isVoiceAlbum ? @"application/vnd.shengxi.v4.3+json" : @"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
                NoticeZjModel *model = [NoticeZjModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeZjModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.updated_at;
                self.tableView.tableHeaderView = nil;
            }else{
                self.tableView.tableHeaderView = self.defaultL;
                self.defaultL.text = [NoticeTools chinese:@"欸 这里空空的" english:@"Nothing yet" japan:@"まだ何もありません"];
            }
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)addzjClick{

    __weak typeof(self) weakSelf = self;
    NoticeNewAddZjView *inputView = [[NoticeNewAddZjView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.isDiaZJ = !self.isVoiceAlbum;
    inputView.addBlock = ^(NSString * _Nonnull name, BOOL isOpen) {
        if (name.length > 20) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.nozishulimit"]];
            return;
        }
        
        
        NSMutableDictionary *parm = [NSMutableDictionary new];
        if (!weakSelf.isVoiceAlbum) {
            [parm setObject:@"0" forKey:@"bucketId"];
            [parm setObject:@"0000000000" forKey:@"albumCoverUri"];
            [parm setObject:name forKey:@"albumName"];
        }else{
            [parm setObject:name forKey:@"albumName"];
            [parm setObject:isOpen?@"1":@"3" forKey:@"albumType"];

        }

        [weakSelf showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:!weakSelf.isVoiceAlbum?@"dialogAlbums":[NSString stringWithFormat:@"user/%@/voiceAlbum",[NoticeTools getuserId]] Accept:!weakSelf.isVoiceAlbum?@"application/vnd.shengxi.v4.7.6+json":@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                [weakSelf.tableView.mj_header beginRefreshing];
            }
            [weakSelf hideHUD];
        } fail:^(NSError * _Nullable error) {
            [weakSelf hideHUD];
        }];
    };
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.nameField becomeFirstResponder];

}

@end
