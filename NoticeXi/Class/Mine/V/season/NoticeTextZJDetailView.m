//
//  NoticeTextZJDetailView.m
//  NoticeXi
//
//  Created by li lei on 2021/1/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextZJDetailView.h"
#import "NoticeTextZJDetailCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeTextZJDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = GetColorWithName(VBackColor);
        
        self.musicBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 9, 22, 22)];
        [self.musicBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_textzjbtnm_b":@"Image_textzjbtnm_y") forState:UIControlStateNormal];
        [self addSubview:self.musicBtn];
        
        self.contentBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-22-22-15, 9, 22, 22)];
        [self.contentBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_textzjcont_b":@"Image_textzjcont_y") forState:UIControlStateNormal];
        [self addSubview:self.contentBtn];
        
        self.listBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-22, 9, 22, 22)];
        [self.listBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_textzjchoicelist_b":@"Image_textzjchoicelist_y") forState:UIControlStateNormal];
        [self addSubview:self.listBtn];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, DR_SCREEN_WIDTH-15-15-100, 26)];
        self.numL.textColor = GetColorWithName(VMainTextColor);
        self.numL.font = XGFourthBoldFontSize;
        [self addSubview:self.numL];
        
        UIButton *howBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-10-100, 40, 100, 26)];
        [howBtn setTitle:[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"zj.howadd"] fantText:@"如何加入專輯?"] forState:UIControlStateNormal];
        [howBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        howBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self addSubview:howBtn];
        [howBtn addTarget:self action:@selector(howClick) forControlEvents:UIControlEventTouchUpInside];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(howBtn.frame)+15, DR_SCREEN_WIDTH, frame.size.height-howBtn.frame.size.height-40-15)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 35;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = GetColorWithName(VBackColor);
        [_tableView registerClass:[NoticeTextZJDetailCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTextZJDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.vocieM = self.dataArr[indexPath.row];
    return cell;
}

- (void)howClick{
    NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithLeaderView1];
    [pinV showTostView];
}

- (void)setZjModel:(NoticeZjModel *)zjModel{
    _zjModel = zjModel;
    self.dataArr = [NSMutableArray new];
    
    [self requestInfo];
    
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestInfo{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/voiceAlbum/%@?voiceType=2",self.userId,self.zjModel.albumId] Accept:@"application/vnd.shengxi.v3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            NoticeZjModel *model = [NoticeZjModel mj_objectWithKeyValues:dict[@"data"]];
            self.numL.text = [NSString stringWithFormat:@"%@%d%@",[NoticeTools getLocalStrWith:@"groupImg.g"],model.voice_num.intValue,[NoticeTools getLocalStrWith:@"zj.texnum"]];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)createRefesh{
    
    __weak NoticeTextZJDetailView *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestList];
        [ctl requestInfo];
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestList];
    }];
}

- (void)requestList{
    NSString *url = nil;
    if (!self.isDown) {
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum/%@/voice?lastId=%@&voiceType=2",self.userId,self.zjModel.albumId,self.lastId];
    }else{
        url= [NSString stringWithFormat:@"user/%@/voiceAlbum/%@/voice?voiceType=2",self.userId,self.zjModel.albumId];
    }

    NSMutableArray *arr = [NSMutableArray new];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.6.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                if (model.content_type.intValue == 2 && model.title) {
                    model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
                }
                BOOL alerady = NO;
                for (NoticeVoiceListModel *olM in self.dataArr) {
                    if ([olM.voice_id isEqualToString:model.voice_id]) {
                        alerady = YES;
                        break;
                    }
                }
                if (!alerady) {
                    [arr addObject:model];
                    [self.dataArr addObject:model];
                }
            }
            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.voice_id;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.noDataView;
            }
            if (self.getDataBlock) {
                self.getDataBlock(self.dataArr);
            }
            if (self.dataArr.count) {
                if (!self.isFirstRequest) {
                    self.isFirstRequest = YES;
                    if (self.choiceDataBlock) {
                        NSInteger index = arc4random() % self.dataArr.count;
                        DRLog(@"%ld",index);
                        self.choiceDataBlock(self.dataArr[index]);
                    }
                }
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.choiceDataBlock) {
        self.choiceDataBlock(self.dataArr[indexPath.row]);
    }
}

- (UIView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        _noDataView.backgroundColor = GetColorWithName(VBackColor);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        imageView.layer.cornerRadius = 3;
        imageView.layer.masksToBounds = YES;
        imageView.image = [NoticeTools isWhiteTheme]?  UIImageNamed(@"zj_nodimg") : UIImageNamed(@"zj_nodimgy");
        [_noDataView addSubview:imageView];
        imageView.center = _noDataView.center;
    }
    return _noDataView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return YES;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    // 添加一个删除按钮
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"加入到" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //在这里添加点击事件
        NoticeZjListView * listView = [[NoticeZjListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        listView.isText = YES;
        listView.choiceM = model;
        [listView show];
    }];
    deleteRowAction.backgroundColor = [NoticeTools getWhiteColor:@"#FFB165" NightColor:@"#B37D47"];
    UITableViewRowAction *jubaoRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"移除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NoticeVoiceListModel *reM = model;
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:reM.voice_id forKey:@"voiceId"];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController showHUD];
        NSString *url = nil;
        url = [NSString stringWithFormat:@"user/%@/albumVoice/%@/%@",self.userId,self.zjModel.albumId,reM.voice_id];
        [[DRNetWorking shareInstance]requestWithDeletePath:url Accept: @"application/vnd.shengxi.v5.0.0+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                
                [weakSelf.dataArr removeObjectAtIndex:indexPath.row];
                if (weakSelf.getDataBlock) {
                    weakSelf.getDataBlock(weakSelf.dataArr);
                }
                [weakSelf.tableView reloadData];
            }
        } fail:^(NSError *error) {
            [nav.topViewController hideHUD];
        }];
    }];
    jubaoRowAction.backgroundColor = [NoticeTools getWhiteColor:@"#FE736C" NightColor:@"#B3524D"];
    // 将设置好的按钮放到数组中返回
    return @[jubaoRowAction,deleteRowAction];
}
@end
