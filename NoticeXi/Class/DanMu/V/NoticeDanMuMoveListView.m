//
//  NoticeDanMuMoveListView.m
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDanMuMoveListView.h"
#import "NoticeDanMuCell.h"
@implementation NoticeDanMuMoveListView
{
    UIView *_noDataView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, frame.size.height-BOTTOM_HEIGHT-50)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 30;
        [self.tableView registerClass:[NoticeDanMuCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        self.tableView.backgroundColor = self.backgroundColor;
        
        _noDataView = [[UIView alloc] initWithFrame:self.tableView.frame];
        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 176, 94)];
        imagV.center = _noDataView.center;
        imagV.image = UIImageNamed(@"Image_nodanmu");
        [_noDataView addSubview:imagV];
        self.tableView.tableFooterView = _noDataView;
        
        self.isDown = YES;
        self.dataArr  = [NSMutableArray new];
        [self createRefesh];
    }
    return self;
}

- (void)createRefesh{

    __weak NoticeDanMuMoveListView *ctl = self;

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestVoice];
    }];
}

- (void)setBokeM:(NoticeDanMuModel *)bokeM{
    _bokeM = bokeM;
    self.isDown = YES;
    [self requestVoice];
}

- (void)requestVoice{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"podcast/%@/barrage?pageSize=100&type=1",self.bokeM.bokeId];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"podcast/%@/barrage?pageSize=100&lastId=%@&type=1",self.bokeM.bokeId,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"podcast/%@/barrage?pageSize=100&type=1",self.bokeM.bokeId];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.9.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeDanMuListModel *model = [NoticeDanMuListModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
                self.lastId = [self.dataArr[self.dataArr.count-1] barrage_at];
            }else{
                self.tableView.tableFooterView = _noDataView;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDanMuListModel *model = self.dataArr[indexPath.row];
    return model.textHeight+16+15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDanMuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^(NoticeDanMuListModel * _Nonnull model) {
        for (NoticeDanMuListModel *deleteM in weakSelf.dataArr) {
            if ([deleteM.danmuId isEqualToString:model.danmuId]) {
                [weakSelf.dataArr removeObject:deleteM];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    return cell;
}

@end
