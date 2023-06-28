//
//  NoticeDrawDateViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/7/8.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeDrawDateViewController.h"
#import "NoticeDrawCell.h"
@interface NoticeDrawDateViewController ()<NoticeDrawEditDelegate>
@property (nonatomic, strong) NSMutableArray *tydataArr;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) UIImageView *footView;
@end

@implementation NoticeDrawDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.tydataArr = [NSMutableArray new];
    self.tableView.frame = CGRectMake(0, 1, DR_SCREEN_WIDTH,self.isFromMessage?(DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT): (DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-(DR_SCREEN_WIDTH*95/375+42)-1));
    if (!self.isFromMessage) {
        [self createRefesh];
        [self.tableView.mj_header beginRefreshing];
    }else{
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"hh.h"];
        if (self.graffiti_id) {
            self.navigationItem.title = [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"hh.toyouty"] fantText:@"給妳的塗鴉"];
        }
        if (self.isBackReplay) {
            self.navigationItem.title = [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"hh.erplyty"] fantText:@"被回應的塗鴉"];
        }
        self.isDown = YES;
        [self request];
    }
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.backgroundColor = GetColorWithName(VBackColor);
    [self.tableView registerClass:[NoticeDrawCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[NoticeDrawCell class] forCellReuseIdentifier:@"cellspec"];
    self.tableView.rowHeight = 65+DR_SCREEN_WIDTH+50+8;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"CHANGETHEROOTSELECTART" object:nil];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor = GetColorWithName(VlineColor);
    [self.view addSubview:line];
    
    if (!self.isSelf) {
        //postTuYaNotification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPost:) name:@"postTuYaNotification" object:nil];
        //postTuYaDeleteNotification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeletePost:) name:@"postTuYaDeleteNotification" object:nil];
    }
}

- (void)getPost:(NSNotification*)notification{
    if (self.isTuYa) {
        return;
    }
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *drawId = nameDictionary[@"drawId"];
    for (NoticeDrawList *model in self.dataArr) {
        if ([model.drawId isEqualToString:drawId]) {
            model.graffiti_num = [NSString stringWithFormat:@"%ld",(long)(model.graffiti_num.integerValue+1)];
            model.being_graffiti = @"1";
            [self.tableView reloadData];
            break;
        }
    }
}

- (void)getDeletePost:(NSNotification*)notification{
    if (self.isTuYa) {
        [self.tableView.mj_header beginRefreshing];
        return;
    }
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *drawId = nameDictionary[@"drawId"];
    for (NoticeDrawList *model in self.dataArr) {
        if ([model.drawId isEqualToString:drawId]) {
            if (model.graffiti_num.integerValue > 1) {
                model.graffiti_num = [NSString stringWithFormat:@"%ld",(long)(model.graffiti_num.integerValue-1)];
            }else{
                model.graffiti_num = @"0";
            }
            
            [self.tableView reloadData];
            break;
        }
    }
}

- (void)refresh{
    self.isDown = YES;
    [self request];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGETHEROOTSELECTART" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"postTuYaNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"postTuYaDeleteNotification" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.graffiti_id) {
        if (section == 0) {
            return self.tydataArr.count;
        }else{
            return self.dataArr.count;
        }
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.graffiti_id) {
        if (indexPath.section == 1) {
            NoticeDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.isMyDraw = self.isSelf;
            cell.drawModel = self.dataArr[indexPath.row];
            cell.index = indexPath.row;
            cell.delegate = self;
            return cell;
        }else{
            NoticeDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellspec"];
            cell.isPeopleTuYa = YES;
            cell.noNeedTuYa = YES;
            cell.index = indexPath.row;
            cell.tuModel = self.tydataArr[indexPath.row];
            cell.delegate = self;
            return cell;
        }
    }else{
        NoticeDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.isMyDraw = self.isSelf;
        cell.drawModel = self.dataArr[indexPath.row];
        cell.index = indexPath.row;
        cell.delegate = self;
        if (indexPath.row == self.dataArr.count-1) {
            cell.line.frame = CGRectMake(0,CGRectGetMaxY(cell.buttonView.frame), DR_SCREEN_WIDTH, 1);
        }else{
            cell.line.frame = CGRectMake(0,CGRectGetMaxY(cell.buttonView.frame), DR_SCREEN_WIDTH, 8);
        }
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.graffiti_id) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 32;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 32)];
        view.backgroundColor = GetColorWithName(VBackColor);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-15, 32)];
        label.font = SIXTEENTEXTFONTSIZE;
        label.text = @"原作:";
        label.textColor = GetColorWithName(VMainTextColor);
        [view addSubview:label];
        
        return view;
    }
    return [UIView new];
}

- (void)deleteSucessWith:(NSInteger)index{
    if (self.dataArr.count-1 < index) {
        return;
    }
    [self.dataArr removeObjectAtIndex:index];
    [self.tableView reloadData];
}

- (void)request{
    NSString *url = nil;
    if (self.isTuYa) {
        if (self.isDown) {
            url = @"graffitis/footprint";
        }else{
            url = [NSString stringWithFormat:@"graffitis/footprint?lastId=%@",self.lastId];
            
        }
    }else{
        if (self.isDown) {
            url = [NSString stringWithFormat:@"users/%@/artwork",self.isSelf?[[NoticeSaveModel getUserInfo] user_id]:@"0"];
        }else{
            if (self.lastId) {
                url = [NSString stringWithFormat:@"users/%@/artwork?lastId=%@",self.isSelf?[[NoticeSaveModel getUserInfo] user_id]:@"0",self.lastId];
            }else{
                url = [NSString stringWithFormat:@"users/%@/artwork",self.isSelf?[[NoticeSaveModel getUserInfo] user_id]:@"0"];
            }
            
        }
    }

    if (self.isFromMessage) {
        url = [NSString stringWithFormat:@"artworks/%@",self.artId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isFromMessage?@"application/vnd.shengxi.v4.2+json" : (self.isTuYa?@"application/vnd.shengxi.v4.1+json" : @"application/vnd.shengxi.v3.6+json") isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
            if (self.isFromMessage) {
                NoticeDrawList *model = [NoticeDrawList mj_objectWithKeyValues:dict[@"data"]];
                if ([model.user_id isEqualToString:[NoticeTools getuserId]]) {
                    NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
                    model.avatar_url = userInfo.avatar_url;
                    model.nick_name = userInfo.nick_name;
                    model.identity_type = userInfo.identity_type;
                    model.levelName = userInfo.levelName;
                    model.levelImgName = userInfo.levelImgName;
                    model.levelImgIconName = userInfo.levelImgIconName;
                }else{
                    if (model.user_info) {
                        NoticeUserInfoModel *userM = [NoticeUserInfoModel mj_objectWithKeyValues:model.user_info];
                        model.avatar_url = userM.avatar_url;
                        model.nick_name = userM.nick_name;
                        model.identity_type = userM.identity_type;
                        model.levelName = userM.levelName;
                        model.levelImgName = userM.levelImgName;
                        model.levelImgIconName = userM.levelImgIconName;
                    }
                }
                
                [self.dataArr addObject:model];
            }else{
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeDrawList *model = [NoticeDrawList mj_objectWithKeyValues:dic];
                    [self.dataArr addObject:model];
                }
            }
            
            if (self.dataArr.count) {
                NoticeDrawList *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.drawId;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    if (self.graffiti_id) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"graffitis/%@",self.graffiti_id] Accept:@"application/vnd.shengxi.v4.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                NoticeDrawTuM *model = [NoticeDrawTuM mj_objectWithKeyValues:dict[@"data"]];
                [self.tydataArr addObject:model];
                [self.tableView reloadData];
            }
        } fail:^(NSError *error) {
        }];
    }
}

- (void)createRefesh{
    __weak NoticeDrawDateViewController *ctl = self;
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

- (UIImageView *)footView{
    if (!_footView) {
        _footView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
        _footView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Imamzp":@"Imamzpy");
    }
    return _footView;
}

@end
