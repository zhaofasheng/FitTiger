//
//  NoticeTcController.m
//  NoticeXi
//
//  Created by li lei on 2019/10/16.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeTcController.h"
#import "NoticeTCCell.h"
#import "NoticeSendTCController.h"
#import "NoticeCllockTagView.h"
#import "NoticeBdController.h"
#import "SPMultipleSwitch.h"
#import "NoticeWhiteTcCell.h"
@interface NoticeTcController ()<NoticeTcCellDelegate,NoticeWhiteTcCellDelegate>
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) NoticeCllockTagView *tagView;
@property (nonatomic, strong) UIView *footBtnView;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIView *footV;
@property (nonatomic, strong) UIView *sectionView;
@end

@implementation NoticeTcController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"CHANGETHEROOTSELECTARTTC" object:nil];
    
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeWhiteTcCell class] forCellReuseIdentifier:@"wpyCell"];
    [self.tableView registerClass:[NoticeTCCell class] forCellReuseIdentifier:@"pyCell"];
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:self.needBackGround?0:1];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.dataArr = [NSMutableArray new];
    
    self.type = 1;
    
    if (self.tcId) {
        self.isDown = YES;
        [self request];
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        self.navigationItem.title = [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"py.replytc"] fantText:@"被回應的臺詞"];
    }else if (self.topType == 1){
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        self.navigationItem.title = [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"py.tdbestTc"] fantText:@"今日最佳臺詞"];
    }
    else{
        [self createRefesh];
        [self.tableView.mj_header beginRefreshing];
    }
    if (self.isUserLine){
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
    }
    if (self.isCollection) {
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-44);
    }
    
    if (self.isSelf) {
        self.tableView.tableFooterView = self.footBtnView;
    }
    
    if (self.needTag) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 24+88)];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 24, DR_SCREEN_WIDTH-40, 88)];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        imageV.userInteractionEnabled = YES;
        imageV.image =  UIImageNamed([NoticeTools getLocalImageNameCN:@"Image_pytcheader"]);
        [headerView addSubview:imageV];
        self.tableView.tableHeaderView = headerView;
        headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bdTap)];
        [headerView addGestureRecognizer:tap];
        
        self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        self.sectionView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
        self.tagView = [[NoticeCllockTagView alloc] initWithFrame:CGRectMake(20,6, DR_SCREEN_WIDTH-40, 38)];
        __weak typeof(self) weakSelf = self;
        self.tagView.setTagBlock = ^(NSInteger clockTag) {
            weakSelf.type = clockTag;
        };
        [self.sectionView addSubview:self.tagView];
    }
    
    if ((self.isUserLine || self.isCollection) && !self.isUserCenter) {
        
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 44)];
        self.numL.font = FOURTHTEENTEXTFONTSIZE;
        self.numL.textColor = self.needBackGround? [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8] : [UIColor colorWithHexString:@"#5C5F66"];
        [headerV addSubview:self.numL];
        self.tableView.tableHeaderView = headerV;

        if (self.isUserLine) {
            SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[[NoticeTools getLocalStrWith:@"py.zuixin"],[NoticeTools getLocalStrWith:@"py.zuihot"]]];
            switch1.titleFont = TWOTEXTFONTSIZE;
            switch1.frame = CGRectMake(DR_SCREEN_WIDTH-20-64*2,10,64*2,24);
            [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
            if (self.needBackGround) {
                switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
                switch1.titleColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
                switch1.trackerColor = [UIColor colorWithHexString:@"#F7F8FC"];
                switch1.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.1];
            }else{
                switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
                switch1.titleColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
                switch1.trackerColor = [UIColor colorWithHexString:@"#FFFFFF"];
                switch1.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:1];
            }
          
            [headerV addSubview:switch1];
            
            if (self.isOther) {
                self.isOrderByHot = YES;
                [switch1 setSelectedSegmentIndex:1];
            }
        }
    }
    if (self.isCollection) {
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50);
    }
    if (self.isUserCenter) {
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-44);
    }
}

- (void)changeVale:(SPMultipleSwitch *)swithbtn{
    self.isOrderByHot = swithbtn.selectedSegmentIndex==1?YES:NO;
    [self.tableView.mj_header beginRefreshing];
}

- (void)bdTap{
    NoticeBdController *ctl = [[NoticeBdController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)setType:(NSInteger)type{
    _type = type;
    [self.tableView.mj_header beginRefreshing];
}

//获取用户台词
- (void)getUserLine{
    NSString *url = @"";
    if (self.isDown) {
        url = [NSString stringWithFormat:@"users/%@/lines?pageNo=1&type=%d",self.isOther?self.userId: [NoticeTools getuserId],self.isOrderByHot?2:1];
        if (self.isCollection) {
            url = @"linesCollection";
        }
    }else{
        url = [NSString stringWithFormat:@"users/%@/lines?pageNo=%ld&type=%d",self.isOther?self.userId: [NoticeTools getuserId],self.pageNo,self.isOrderByHot?2:1];
        if (self.isCollection) {
            url = [NSString stringWithFormat:@"linesCollection?lastId=%@",self.lastId];
        }
    }

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isUserLine?@"application/vnd.shengxi.v5.3.6+json": @"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeMJIDModel *model = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if (self.isDown == YES) {
                self.numL.text = [NSString stringWithFormat:@"%@%@",model.total,[NoticeTools getLocalStrWith:@"py.ofnum"]];
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            BOOL hasNewData = NO;
            
           
            for (NSDictionary *dic in model.list) {
                NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                
                hasNewData = YES;
            }
            if (self.dataArr.count) {
                self.lastId = [self.dataArr[self.dataArr.count-1] tcId];
                if (self.isCollection) {
                    self.lastId = [self.dataArr[self.dataArr.count-1] collection_id];
                }
                self.tableView.tableFooterView = nil;
            }else{
                if (self.isUserCenter) {
                    self.tableView.tableFooterView = self.footV;
                }else{
                    self.queshenView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height-40);
                    if (self.isCollection) {
                        self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy16");
                        self.queshenView.titleStr = [NoticeTools getLocalStrWith:@"py.youhavenoscoltc"];
                    }else{
                        self.queshenView.titleImageV.image = UIImageNamed(self.isOther?@"Image_quesy14" :@"Image_quesy15");
                        self.queshenView.titleStr = self.isOther?@"Ta还没有发过台词哦~":[NoticeTools getLocalStrWith:@"py.nosendtc"];
                    }
               
                    self.tableView.tableFooterView = self.queshenView;
                }
        
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)request{
    if (self.isUserLine || self.isCollection) {
        [self getUserLine];
        return;
    }
    NSString *url = @"";
    url = @"lines";
    if (self.isDown) {
        if (self.needTag) {
            if (self.type == 2 || self.type == 3) {
                url = [NSString stringWithFormat:@"lines?tagId=%@",self.type == 2?@"1":@"2"];
            }
        }
    }else{
        if (self.needTag) {
            if (self.type == 2 || self.type == 3) {
                url = [NSString stringWithFormat:@"lines?tagId=%@&lastId=%@",self.type == 2?@"1":@"2",self.lastId];
            }else{
                url = [NSString stringWithFormat:@"lines?lastId=%@",self.lastId];
            }
        }
    }

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown == YES) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.lastId = [self.dataArr[self.dataArr.count-1] tcId];
                self.tableView.tableFooterView = nil;
            }else{
                if (self.isUserCenter) {
                    self.tableView.tableFooterView = self.footV;
                }
                
            }
            [self.tableView reloadData];
        }

    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (UIView *)footV{
    if (!_footV) {
        _footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH-40)*180/335)];
        
        UIImageView *iamgeV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40)*180/335)];
        iamgeV.image = UIImageNamed(@"Image_noshare");
        [_footV addSubview:iamgeV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-40, iamgeV.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.7];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.text = [NoticeTools chinese:@"哦豁 什么都没有" english:@"Post something to create a stream" japan:@"何かを投稿してストリームを作成する"];
      
        [iamgeV addSubview:label];
    }
    return _footV;
}

- (void)createRefesh{
    __weak NoticeTcController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ctl.pageNo++;
        ctl.isDown = NO;
        if (ctl.isUserLine || ctl.isCollection) {
            [ctl getUserLine];
            return;
        }
        [ctl request];
        
    }];
}

- (void)refresh{
    self.isDown = YES;
    [self request];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 121+[self.dataArr[indexPath.row] contentHeight]+15+40-(self.isUserCenter?20:0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.needBackGround) {
        NoticeWhiteTcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wpyCell"];
        cell.index = indexPath.row;
        cell.isGoToUserCenter = self.isUserLine;
        cell.tcModel = self.dataArr[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    NoticeTCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pyCell"];
    cell.isUserCenter = self.isUserCenter;
    cell.index = indexPath.row;
    cell.isGoToUserCenter = self.isUserLine;
    cell.tcModel = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!self.needTag) {
        return 0;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.needTag) {
        return [UIView new];
    }
    return self.sectionView;
}

- (void)delegateSuccess:(NoticeClockPyModel *)tcModel{
    if (self.dataArr.count) {
        NSInteger num1 = 0;
        for (NoticeClockPyModel *tcM in self.dataArr) {
            if ([tcModel.tcId isEqualToString:tcM.tcId]) {
                if (self.dataArr.count >= num1+1) {
                    [self.dataArr removeObjectAtIndex:num1];
                }
                break;
            }
            num1++;
        }
    }

    [self.tableView reloadData];
}

- (void)recoderSuccess:(NoticeClockPyModel *)tcModel{
    for (NoticeClockPyModel *tcM in self.dataArr) {
        if ([tcModel.tcId isEqualToString:tcM.tcId]) {
            tcM.is_dubbed = tcModel.is_dubbed;
            tcM.dubbing_num = tcModel.dubbing_num;
            break;
        }
    }

}


- (void)sendClick{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/lines/statistics",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.6.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeIfCanSendLine *limetModel = [NoticeIfCanSendLine mj_objectWithKeyValues:dict[@"data"]];
            if (limetModel.can_create.intValue) {
                NoticeSendTCController *ctl = [[NoticeSendTCController alloc] init];
                ctl.titleMessage = limetModel.tips;
                [self.navigationController pushViewController:ctl animated:YES];
            }else{
                [self showToastWithText:limetModel.tips];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (UIView *)footBtnView{
    if (!_footBtnView) {
        _footBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 90)];
        _footBtnView.backgroundColor = GetColorWithName(VBackColor);
        UIButton *sendTCBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-345)/2,23, 345, 44)];
        [sendTCBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_shishimore_b":@"Image_shishimore_y") forState:UIControlStateNormal];
        [sendTCBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"py.mesendtc"]:@"我也來發布臺詞" forState:UIControlStateNormal];
        [sendTCBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        sendTCBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [sendTCBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [_footBtnView addSubview:sendTCBtn];
    }
    return _footBtnView;
}

@end
