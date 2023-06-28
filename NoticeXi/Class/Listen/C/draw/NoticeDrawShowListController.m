
//
//  NoticeDrawShowListController.m
//  NoticeXi
//
//  Created by li lei on 2020/6/1.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeDrawShowListController.h"
#import "NoticeTodayBestCell.h"
#import "NoticeNewStyleDrawCell.h"
#import "NoticeCollectionDrawModel.h"
#import "NoticeDrawViewController.h"
#import "NoticeZjModel.h"
#import "NoticeClockPyModel.h"
#import "NoticeMySelfDrawController.h"
#import "NoticeUserInfoCenterController.h"
@interface NoticeDrawShowListController ()<NoticeNewDrawEditDelegate>
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) BOOL isDown1;//YES  下拉
@property (nonatomic, assign) BOOL isDown2;//YES  下拉
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *pickerL;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *headeV;
@end

@implementation NoticeDrawShowListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    if (self.isSelf || self.listType == 4 || self.listType == 3) {
      
        self.tableView.frame = CGRectMake(0,44, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-44-48);
    }
    self.pageNo = 1;
    self.isDown1 = YES;
    self.isDown2 = YES;

    self.navigationItem.title = [NoticeTools getLocalStrWith:@"main.draw"];
    
    [self.tableView registerClass:[NoticeTodayBestCell class] forCellReuseIdentifier:@"tuijianCell"];
    [self.tableView registerClass:[NoticeNewStyleDrawCell class] forCellReuseIdentifier:@"drawCell"];
    self.tableView.rowHeight = 124+DR_SCREEN_WIDTH-70+15;
    self.tableView.backgroundColor = self.view.backgroundColor;
    if (self.listType == 5) {
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"hh.hishua"];
        self.tableView.frame = CGRectMake(0,31+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-31);
        [self.view addSubview:self.numL];
        [self requestOtherDrawNum];
        self.tableView.tableFooterView = nil;
        
        self.navBarView.rightButton.frame = CGRectMake(DR_SCREEN_WIDTH-15-72, STATUS_BAR_HEIGHT, 72, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        self.navBarView.rightButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.navBarView.rightButton setTitle:[NoticeTools getLocalStrWith:@"py.mainofhe"] forState:UIControlStateNormal];
        [self.navBarView.rightButton setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        
        [self.navBarView.rightButton addTarget:self action:@selector(centerIntClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.listType == 6 || self.listType == 7) {//作品单页
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"hh.h"];
        self.tableView.tableFooterView = nil;
        self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-1);
    }
    
    if (self.isPicker) {
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"py.todaypicker"];
        [self isPickerLabel];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddOrDelete:) name:@"CHANGETHEROOTSELECTARTTY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"CHANGETHEROOTSELECTART" object:nil];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    if (self.isShowSend) {
        UIButton *sendTcBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-68, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-40-68, 68, 68)];
        [sendTcBtn setBackgroundImage:UIImageNamed(@"Image_sendtcnew") forState:UIControlStateNormal];
        [self.view addSubview:sendTcBtn];
        [sendTcBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.navBarView.rightButton.frame.size.width-32)/2,(self.navBarView.rightButton.frame.size.height-32)/2, 32, 32)];
       
        iconImageView.layer.cornerRadius = 16;
        iconImageView.layer.masksToBounds = YES;
        [self.navBarView.rightButton addSubview:iconImageView];
        [self.navBarView.rightButton addTarget:self action:@selector(iconTap) forControlEvents:UIControlEventTouchUpInside];

        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
        
    }
    
    if (!self.isFromMyDraw) {
        
        self.needBackGroundView = YES;
        self.needHideNavBar = YES;
        self.navBarView.hidden = NO;
    }else{
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-44);
    }

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 4)];

    [self requestTotalNum];
}

- (void)requestTotalNum{
    if (self.listType == 3) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/artworksStatistics",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeZjModel *totalM = [NoticeZjModel mj_objectWithKeyValues:dict[@"data"]];
                self.tableView.tableHeaderView = self.headeV;
                self.numL.text = totalM.total.intValue?[NSString stringWithFormat:@"%@%@",totalM.total,[NoticeTools getLocalStrWith:@"py.ofnum"]]:[NoticeTools getLocalStrWith:@"hh.nozupp"];
                
            }
        } fail:^(NSError * _Nullable error) {

        }];
    }
    if (self.listType == 4) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/artworksCollectionStatistics",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeZjModel *totalM = [NoticeZjModel mj_objectWithKeyValues:dict[@"data"]];
                self.tableView.tableHeaderView = self.headeV;
                self.numL.text = totalM.total.intValue?[NSString stringWithFormat:@"%@%@",[NoticeTools getLocalStrWith:@"groupImg.g"],totalM.total]:[NoticeTools getLocalStrWith:@"hh.noshouc"];
            
            }
        } fail:^(NSError * _Nullable error) {

        }];
    }
}

- (void)getAddOrDelete:(NSNotification*)notification{
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeDrawList class]]) {//判断是否是心情模型
            for (NoticeDrawList *drawM in self.dataArr) {
                if (drawM.drawId) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *drawId = nameDictionary[@"drawId"];
                    NSString *isAdd = nameDictionary[@"add"];
                    if ([drawM.drawId isEqualToString:drawId]) {
                        if (isAdd.intValue) {
                            drawM.dialog_num = [NSString stringWithFormat:@"%d",drawM.dialog_num.intValue+1];
                        }else{
                            drawM.dialog_num = [NSString stringWithFormat:@"%d",drawM.dialog_num.intValue-1];
                        }
                        if (drawM.dialog_num.intValue < 0) {
                            drawM.dialog_num = @"0";
                        }
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }
}


- (void)centerIntClick{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.userId = self.userId;
    ctl.isOther = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)iconTap{
    NoticeMySelfDrawController *ctl = [[NoticeMySelfDrawController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)sendClick{
    NoticeDrawViewController *ctl = [[NoticeDrawViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)requestOtherDrawNum{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/artworksStatistics",self.userId] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeZjModel *totalM = [NoticeZjModel mj_objectWithKeyValues:dict[@"data"]];
            self.numL.text = totalM.total.intValue?[NSString stringWithFormat:@"%@%@",totalM.total,[NoticeTools getLocalStrWith:@"py.ofnum"]]:[NoticeTools getLocalStrWith:@"hh.nozupp"];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)refresh{
    self.isRefresh = YES;
    self.isDown = YES;
    [self request];
}

- (void)request{
    if (self.listType == 2) {
        if (self.isDown) {
            [self requestTop];
        }else{
            [self requestfirst];
        }
        
        return;
    }
    NSString *url = nil;
    NSString *accept = nil;
    if (self.listType == 1) {
        if (self.isDown) {
           url = @"artworks/hot";
        }else{
            url = [NSString stringWithFormat:@"artworks/hot?pageNo=%ld",self.pageNo];
        }
        accept = @"application/vnd.shengxi.v4.3+json";
    }else if (self.listType == 0){
        accept = @"application/vnd.shengxi.v4.3+json";
        if (self.isDown) {
            url = @"artworks/top";
        }else{
            url = [NSString stringWithFormat:@"artworks/top?lastId=%@",self.lastId];
        }
    }
    else if (self.listType == 7 || self.listType == 6){
        url = [NSString stringWithFormat:@"artworks/%@",self.artId];
        accept = @"application/vnd.shengxi.v4.2+json";
    }else if (self.listType == 3 || self.listType == 5){//自己或者别人的画
        accept = @"application/vnd.shengxi.v5.0.0+json";
        if (self.isDown) {
            url = [NSString stringWithFormat:@"users/%@/artworks?pageNo=1",self.listType == 5 ? self.userId: [NoticeTools getuserId]];
        }else{
            url = [NSString stringWithFormat:@"users/%@/artworks?pageNo=%ld",self.listType == 5 ? self.userId: [NoticeTools getuserId],self.pageNo];
        }
    }else if (self.listType == 4){
        accept = @"application/vnd.shengxi.v4.3+json";
        if (self.isDown) {
            url = [NSString stringWithFormat:@"users/%@/artworkCollection",[NoticeTools getuserId]];
        }else{
            url = [NSString stringWithFormat:@"users/%@/artworkCollection?lastId=%@",[NoticeTools getuserId],self.lastId];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:accept isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            if (self.listType == 7 || self.listType == 6) {//单个画
                NoticeDrawList *model = [NoticeDrawList mj_objectWithKeyValues:dict[@"data"]];
                if ([model.user_id isEqualToString:[NoticeTools getuserId]]) {
                    NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
                    model.avatar_url = userInfo.avatar_url;
                    model.nick_name = userInfo.nick_name;
                    model.identity_type = userInfo.identity_type;
                }else{
                    if (model.user_info) {
                        NoticeUserInfoModel *userM = [NoticeUserInfoModel mj_objectWithKeyValues:model.user_info];
                        model.avatar_url = userM.avatar_url;
                        model.nick_name = userM.nick_name;
                        model.identity_type = userM.identity_type;
                    }
                }
                [self.dataArr addObject:model];
            }else if (self.listType == 4 || self.listType == 0){//收藏列表
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeCollectionDrawModel *model = [NoticeCollectionDrawModel mj_objectWithKeyValues:dic];
                    if (self.listType == 4) {
                        model.drawModel.collectionId = model.collectionId;
                        model.drawModel.collection_id = model.collectionId;
                    }else{
                        model.drawModel.topId = model.collectionId;
                    }
                    
                    if (model.drawModel.user) {
                        NoticeUserInfoModel *userM = [NoticeUserInfoModel mj_objectWithKeyValues:model.drawModel.user];
                        model.drawModel.avatar_url = userM.avatar_url;
                        model.drawModel.nick_name = userM.nick_name;
                        model.drawModel.identity_type = userM.identity_type;
                    }
                    if (model.drawModel.isSelf) {
                        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
                        model.drawModel.avatar_url = userM.avatar_url;
                        model.drawModel.nick_name = userM.nick_name;
                        model.drawModel.identity_type = userM.identity_type;
                    }
                    [self.dataArr addObject:model.drawModel];
                }
            }
            else{//列表
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeDrawList *model = [NoticeDrawList mj_objectWithKeyValues:dic];
                    if (model.user) {
                        NoticeUserInfoModel *userM = [NoticeUserInfoModel mj_objectWithKeyValues:model.user];
                        model.avatar_url = userM.avatar_url;
                        model.nick_name = userM.nick_name;
                        model.identity_type = userM.identity_type;
                        model.levelName = userM.levelName;
                        model.levelImgName = userM.levelImgName;
                        model.levelImgIconName = userM.levelImgIconName;
                    }
                    if (model.isSelf) {
                        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
                        model.avatar_url = userM.avatar_url;
                        model.nick_name = userM.nick_name;
                        model.identity_type = userM.identity_type;
                        model.levelName = userM.levelName;
                        model.levelImgName = userM.levelImgName;
                        model.levelImgIconName = userM.levelImgIconName;
                    }
                    [self.dataArr addObject:model];
                }
            }

            if (self.dataArr.count) {
                NoticeDrawList *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = self.listType == 4? lastM.collectionId : lastM.drawId;
                if (self.listType == 0) {
                    self.lastId = lastM.topId;
                }
                if (self.listType == 0) {//今日推荐获取用户关系要
                    [self getUserReal];
                }
                self.tableView.tableFooterView = nil;
            }else{
                if (self.listType >=3 && self.listType <=5) {
                    self.queshenView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height-40);
                    if (self.listType == 3) {
                        self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy11");
                        self.queshenView.titleStr = @"历史功能不能使用";
                    }else if(self.listType == 4){
                        self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy12");
                        self.queshenView.titleStr = @"历史功能不能使用";
                    }else if(self.listType == 5){
                        self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy11");
                        self.queshenView.titleStr = @"历史功能不能使用";
                    }
                    self.tableView.tableFooterView = self.queshenView;
                }
            }
            [self.tableView reloadData];
            if (self.isRefresh) {
                self.isRefresh = NO;
                if (self.dataArr.count) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}

- (void)requestTop{
    NSString *url = @"";
 
    url = @"artworks/top";
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                [self.tableView.mj_header endRefreshing];//获取到时间才结束加载
                [self.tableView.mj_footer endRefreshing];
                return ;
            }
            [self.dataArr removeAllObjects];
  
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeCollectionDrawModel *model = [NoticeCollectionDrawModel mj_objectWithKeyValues:dic];
                model.drawModel.isPick = YES;
                
                if (model.drawModel.user) {
                    NoticeUserInfoModel *userM = [NoticeUserInfoModel mj_objectWithKeyValues:model.drawModel.user];
                    model.drawModel.avatar_url = userM.avatar_url;
                    model.drawModel.nick_name = userM.nick_name;
                    model.drawModel.identity_type = userM.identity_type;
                }
                if (model.drawModel.isSelf) {
                    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
                    model.drawModel.avatar_url = userM.avatar_url;
                    model.drawModel.nick_name = userM.nick_name;
                    model.drawModel.identity_type = userM.identity_type;
                }
                [self.dataArr addObject:model.drawModel];
            }
        }
        [self requestfirst];
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];//获取到时间才结束加载
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)requestfirst{
    
    NSString *url = @"";
 
    if (self.isDown) {
        url = @"users/0/artwork";
    }else{
        url = [NSString stringWithFormat:@"users/%@/artwork?lastId=%@",@"0",self.lastId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                [self.tableView.mj_header endRefreshing];//获取到时间才结束加载
                [self.tableView.mj_footer endRefreshing];
                return ;
            }
            if (self.isDown == YES) {
                self.isDown = NO;
            }
  
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeDrawList *model = [NoticeDrawList mj_objectWithKeyValues:dic];
                if (model.user) {
                    NoticeUserInfoModel *userM = [NoticeUserInfoModel mj_objectWithKeyValues:model.user];
                    model.avatar_url = userM.avatar_url;
                    model.nick_name = userM.nick_name;
                    model.identity_type = userM.identity_type;
                    model.levelName = userM.levelName;
                    model.levelImgName = userM.levelImgName;
                    model.levelImgIconName = userM.levelImgIconName;
                }
                if (model.isSelf) {
                    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
                    model.avatar_url = userM.avatar_url;
                    model.nick_name = userM.nick_name;
                    model.identity_type = userM.identity_type;
                    model.levelName = userM.levelName;
                    model.levelImgName = userM.levelImgName;
                    model.levelImgIconName = userM.levelImgIconName;
                }
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeDrawList *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId =  lastM.drawId;
            }
            [self.tableView reloadData];
            if (self.isRefresh && self.dataArr.count) {
                self.isRefresh = NO;
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
        [self.tableView.mj_header endRefreshing];//获取到时间才结束加载
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];//获取到时间才结束加载
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
    __weak NoticeDrawShowListController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
        ctl.isDown = YES;
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    if (self.listType != 6 && self.listType != 7) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //上拉
            ctl.pageNo++;
            ctl.isDown = NO;
            [ctl request];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NoticeNewStyleDrawCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"drawCell"];
    cell1.delegate = self;
    cell1.type = self.listType;
    if (self.listType == 5 || self.isSelf) {
        cell1.goCenter = YES;
    }
    if (self.listType == 3) {
        cell1.goCenter = YES;
    }
    cell1.index = indexPath.row;
    if (self.dataArr.count) {
        if (self.dataArr.count -1 >= indexPath.row) {
            cell1.drawM = self.dataArr[indexPath.row];
        }
    }
  
    return cell1;
}

- (void)deleteNewDrawSucessWith:(NSInteger)index{
    if (self.dataArr.count-1 < index) {
        return;
    }
    [self.dataArr removeObjectAtIndex:index];
    [self.tableView reloadData];
}

- (void)findMoreClick{
    if (self.listType == 0) {
        if (self.setHotBlock) {
             self.setHotBlock(YES);
        }
    }else if (self.listType == 1){
        if (self.setNowBlock) {
            self.setNowBlock(YES);
        }
    }else if (self.listType == 3){
        NoticeDrawViewController *ctl = [[NoticeDrawViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (self.listType == 4){
        if (self.setHotBlock) {
            self.setHotBlock(YES);
        }
    }
}

- (UIView *)headeV{
    if (!_headeV) {
        
        _headeV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 30)];
        
        _numL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 90, 30)];
        _numL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _numL.font = FOURTHTEENTEXTFONTSIZE;
        [_headeV addSubview:_numL];
       
    }
    return _headeV;
}

- (void)isPickerLabel{
    self.tableView.frame = CGRectMake(0, 44+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-44);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
    label.textColor = GetColorWithName(VDarkTextColor);
    label.font = ELEVENTEXTFONTSIZE;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    self.pickerL = label;
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-150, 0, 150, 44)];
    [self.cancelBtn addTarget:self action:@selector(cancelTop) forControlEvents:UIControlEventTouchUpInside];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"artworks/%@/pick",self.artId] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
      
        if (success) {
            [self.cancelBtn removeFromSuperview];
            NoticeClockPyModel *pickM = [NoticeClockPyModel mj_objectWithKeyValues:dict[@"data"]];
            if (pickM.top_status.intValue == 0) {
                label.userInteractionEnabled = NO;
            }else if (pickM.top_status.intValue == 1){
                label.userInteractionEnabled = YES;
                [label addSubview:self.cancelBtn];
                NSString *str = [NoticeTools getLocalStrWith:@"hh.piing"];
                label.attributedText = [DDHAttributedMode setColorString:[NoticeTools getLocalStrWith:@"hh.quxao"] setColor:GetColorWithName(VMainThumeColor) setLengthString:@"点此取消" beginSize:str.length];
            }else if (pickM.top_status.intValue == 2 || pickM.top_status.intValue == 3){
                label.userInteractionEnabled = NO;
                label.text = pickM.top_status.intValue == 2? [NoticeTools getLocalStrWith:@"hh.toyouquxiao"]:[NSString stringWithFormat:@"你的作品曾在%@展示",pickM.pickTime];
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)getUserReal{
    for (NoticeDrawList *drawM in self.dataArr) {
        if (!drawM.hasGetBlack && !drawM.isSelf) {
              [[DRNetWorking shareInstance] requestNoTosat:[NSString stringWithFormat:@"relations/%@",drawM.user_id] Accept:@"application/vnd.shengxi.v2.2+json" parmaer:nil success:^(NSDictionary *dict1, BOOL success) {
                  drawM.hasGetBlack = YES;
                  if (success) {
                      if ([dict1[@"data"] isEqual:[NSNull null]]) {
                          return ;
                      }
                      if ([dict1[@"data"][@"friend_status"] isEqual:[NSNull null]]) {
                          return ;
                      }
                      NSString *friend_status = [NSString stringWithFormat:@"%@",dict1[@"data"][@"friend_status"]];

                      if ([friend_status isEqualToString:@"3"] || [friend_status isEqualToString:@"4"]) {
                          drawM.isBlack = YES;
                      }
                  }
                  [self.tableView reloadData];
              }];
        }
    }
}

- (void)cancelTop{
    if (!(self.dataArr.count == 1)) {
        return;
    }
    NoticeDrawList *drawm = self.dataArr[0];
    if (!drawm.top_id.intValue) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"hh.quxiaozhanma"] message:[NoticeTools getLocalStrWith:@"hh.xiaoshi"] sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf cancelTopSure];
        }
    };
    [alerView showXLAlertView];
}

- (void)cancelTopSure{
    NoticeDrawList *drawm = self.dataArr[0];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"artworkTop/%@",drawm.top_id] Accept:@"application/vnd.shengxi.v4.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self.cancelBtn removeFromSuperview];
            self.pickerL.text = [NoticeTools getLocalStrWith:@"hh.toyouquxiao"];
            self.pickerL.userInteractionEnabled = NO;
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.dataArr.count && !(self.listType == 0)) {
        return;
    }
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 5;
    
    if(y > h + reload_distance) {
        if (self.canLoad) {
            self.canLoad = NO;
            [self.tableView.mj_footer beginRefreshing];
        }
    }
}
@end
