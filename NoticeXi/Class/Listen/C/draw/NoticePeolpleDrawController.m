//
//  NoticePeolpleDrawController.m
//  NoticeXi
//
//  Created by li lei on 2019/9/26.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticePeolpleDrawController.h"
#import "NoticeDrawCell.h"
#import "NoticeDrawViewController.h"
@interface NoticePeolpleDrawController ()<NoticeDrawEditDelegate>
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UIButton *myTuBtn;
@property (nonatomic, assign) NSInteger selfIndex;
@end

@implementation NoticePeolpleDrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.peoplety"]:@"大家的塗鴉";
    self.dataArr = [NSMutableArray new];
    BOOL isSelf = NO;
    if ([self.drawM.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        isSelf = YES;
    }
    
    self.tableView.frame = CGRectMake(0, 1, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-1-(isSelf ? 0 : 58));
    [self.tableView.mj_header beginRefreshing];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.backgroundColor = GetColorWithName(VBackColor);
    [self.tableView registerClass:[NoticeDrawCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 65+DR_SCREEN_WIDTH+50+8;
    [self.tableView reloadData];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor = GetColorWithName(VlineColor);
    [self.view addSubview:line];
    
    if (!isSelf) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-359)/2, DR_SCREEN_HEIGHT-58-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT, 359, 58)];
        if (self.drawM.being_graffiti.integerValue) {//自己已经涂鸦过
            [button setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.movetome"]:@"跳轉到我的塗鴉" forState:UIControlStateNormal];
        }else{
            [button setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.wanttuy"]:@"我也要塗鴉" forState:UIControlStateNormal];
        }
        _myTuBtn = button;
        button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button setTitleColor:[NoticeTools isWhiteTheme]?[UIColor whiteColor]:[UIColor colorWithHexString:@"#B2B2B2"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tuyaClick) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"tuya_Imagebig":@"tuya_Imagebigy") forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    
    [self createRefesh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPost:) name:@"postTuYaNotification" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"postTuYaNotification" object:nil];
}

- (void)getPost:(NSNotification*)notification{

    NSDictionary *nameDictionary = [notification userInfo];
    NSString *drawId = nameDictionary[@"drawId"];
    if ([drawId isEqualToString:self.drawM.drawId]) {
        self.drawM.being_graffiti = @"1";
        [_myTuBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.movetome"]:@"跳轉到我的塗鴉" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    if (self.drawM.being_graffiti.integerValue) {//自己已经涂鸦过
        [_myTuBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.movetome"]:@"跳轉到我的塗鴉" forState:UIControlStateNormal];
    }else{
        [_myTuBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.wanttuy"]:@"我也要塗鴉" forState:UIControlStateNormal];
    }
}

- (void)createRefesh{
    __weak NoticePeolpleDrawController *ctl = self;
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
        url = [NSString stringWithFormat:@"artworks/%@/graffitis",self.drawM.drawId];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"artworks/%@/graffitis?lastId=%@",self.drawM.drawId,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"artworks/%@/graffitis",self.drawM.drawId];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
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
                    NoticeDrawTuM *model = [NoticeDrawTuM mj_objectWithKeyValues:dic];
                
                    [self.dataArr addObject:model];
                }
                if (self.dataArr.count) {
                    NoticeDrawTuM *lastM = self.dataArr[self.dataArr.count-1];
                    self.lastId = lastM.graffitiId;
                }
                [self.tableView reloadData];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tuyaClick{
    if (self.drawM.being_graffiti.integerValue) {
        BOOL hasTuya = NO;
        for (int i = 0; i < self.dataArr.count; i++) {
            NoticeDrawTuM *model = self.dataArr[i];
            if ([model.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
                self.selfIndex = i;
                hasTuya = YES;
                break;
            }
        }
        if (!hasTuya) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"hh.mark2"]];
            return;
        }
        if ((self.dataArr.count-1) >= self.selfIndex) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selfIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
         }
        return;
    }
    if ([NoticeComTools canDraw:[[NoticeSaveModel getUserInfo] created_at]]) {
        NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithWarnTostViewContent:[NSString stringWithFormat:@"涂鸦功能仅对来到声昔超过24小时的用户开放，当前帐号再过%@就可以使用了",[NoticeComTools canDraw:[[NoticeSaveModel getUserInfo] created_at]]]];
        [pinV showTostView];
        return;
    }
    NoticeDrawViewController *ctl = [[NoticeDrawViewController alloc] init];
    ctl.tuyeImage = self.tuYaImage;
    ctl.drawId = self.drawM.drawId;
    ctl.isTuYa = YES;
    ctl.isFromDrawList = YES;
    if (self.drawM.topic_id.length && ![self.drawM.topic_id isEqualToString:@"0"]) {
        NoticeTopicModel *topM = [[NoticeTopicModel alloc] init];
        topM.topic_id = self.drawM.topic_id;
        topM.topic_name = self.drawM.topic_name;
        ctl.topicM = topM;
    }

    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isPeopleTuYa = YES;
    cell.noNeedTuYa = YES;
    cell.index = indexPath.row;
    cell.tuModel = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)deleteSucessWith:(NSInteger)index{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"postTuYaDeleteNotification" object:self userInfo:@{@"drawId":self.drawM.drawId?self.drawM.drawId:@""}];
    if (self.dataArr.count) {
        NoticeDrawTuM *model = self.dataArr[index];
        if ([model.user_id isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {//如果删除的是自己的涂鸦，则改变底部按钮状态
            self.drawM.being_graffiti = @"0";
            if (self.drawM.being_graffiti.integerValue) {//自己已经涂鸦过
                [_myTuBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.movetome"]:@"跳轉到我的塗鴉" forState:UIControlStateNormal];
            }else{
                [_myTuBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.wanttuy"]:@"我也要塗鴉" forState:UIControlStateNormal];
            }
        }
        [self.dataArr removeObjectAtIndex:index];
        [self.tableView reloadData];
    }
    if (self.dataArr.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
