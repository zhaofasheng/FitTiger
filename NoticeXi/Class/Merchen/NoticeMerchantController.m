//
//  NoticeMerchantController.m
//  NoticeXi
//
//  Created by li lei on 2021/8/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeMerchantController.h"
#import "NoticeHasOrNoBuyTostView.h"
#import "NoticeOpenTbModel.h"
#import "NoticeExchangeController.h"
#import "STRIAPManager.h"
#import "NoticePayView.h"
#import "NoticeMerchHeaderView.h"
#import "NoticerMerchantListCell.h"
#import "NoticePayAndSendRecoderController.h"
@interface NoticeMerchantController ()
@property (nonatomic, assign) BOOL hasGoToBuy;//是否跳转了购买
@property (nonatomic, strong) NoticeOpenTbModel *opTaoBao;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) NoticePayView *payView;
@property (nonatomic, strong) NoticeMerchHeaderView *headerView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@end

@implementation NoticeMerchantController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"listen.nearby"];

    UIButton *dhBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-40-10,DR_SCREEN_WIDTH-40, 40)];
    dhBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    dhBtn.layer.cornerRadius = 8;
    dhBtn.layer.masksToBounds = YES;
    [dhBtn setTitle:[[NoticeTools getLocalStrWith:[NoticeTools getLocalStrWith:@"qu.zhoubianxz"]] substringToIndex:[[NoticeTools getLocalStrWith:@"qu.zhoubianxz"] length]-1] forState:UIControlStateNormal];
    [dhBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    dhBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [dhBtn addTarget:self action:@selector(tqClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dhBtn];
    
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50-10, STATUS_BAR_HEIGHT, 50, (NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT))];
    [changeBtn setImage:UIImageNamed(@"Image_zbcentert") forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(dhClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changeBtn];

    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-40-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-10);
    self.headerView = [[NoticeMerchHeaderView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 76+((DR_SCREEN_WIDTH-40)*3)/4)];
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView registerClass:[NoticerMerchantListCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 204+15;
    
    self.pageNo = 1;
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.headerView.player _pauseVideo];
    [self.headerView.player _deallocPlayer];
    [self.headerView.player removeFromSuperview];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.opTaoBao) {
        [self requestHeader];
    }else{
        self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 10+((DR_SCREEN_WIDTH-40)*3)/4+self.opTaoBao.height);
        self.headerView.model = self.opTaoBao;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}

- (void)createRefesh{
    
    __weak NoticeMerchantController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
    }];

    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl request];
    }];

}


- (void)requestHeader{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"product/peripherys" Accept:@"application/vnd.shengxi.v5.2.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
            NoticeOpenTbModel *model = [NoticeOpenTbModel mj_objectWithKeyValues:dict[@"data"]];
            self.opTaoBao = model;
            self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 10+((DR_SCREEN_WIDTH-40)*3)/4+model.height);
            self.headerView.model = model;
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)request{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"product/categorys?pageNo=%ld",self.pageNo] Accept:@"application/vnd.shengxi.v5.2.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
     
        if (success) {
            if (self.isDown) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMerchantModel *model = [NoticeMerchantModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticerMerchantListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tqClick{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgImageView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-538, DR_SCREEN_WIDTH,538+40);
    }];
}

- (void)popTap{
    [UIView animateWithDuration:0.2 animations:^{
        self.bgImageView.frame = self.bgImageView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,538+40);
    }];
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-538, DR_SCREEN_WIDTH,538+40)];
        [self.view addSubview:_bgImageView];
        _bgImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popTap)];
        [_bgImageView addGestureRecognizer:tap];
        
        _bgImageView.layer.cornerRadius = 20;
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, 12, 24, 24)];
        [cancelBtn setImage:UIImageNamed(@"Image_giveluyin") forState:UIControlStateNormal];
        [_bgImageView addSubview:cancelBtn];
        cancelBtn.userInteractionEnabled = NO;
        
        UILabel *labelL1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 58, 200, 24)];
        labelL1.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        labelL1.font = FOURTHTEENTEXTFONTSIZE;
        labelL1.text = [NoticeTools getLocalStrWith:@"qu.zhoubianxz"];
        [_bgImageView addSubview:labelL1];
        
        UIImageView *subImagev = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(labelL1.frame)+12, 335, 79)];
        subImagev.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"Image_zbxuzhi"]);
        [_bgImageView addSubview:subImagev];
        
        UILabel *labelL2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(subImagev.frame)+30, 200, 24)];
        labelL2.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        labelL2.font = FOURTHTEENTEXTFONTSIZE;
        labelL2.text = [NoticeTools getLocalStrWith:@"qu.dengquj"];
        [_bgImageView addSubview:labelL2];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(labelL2.frame)+12, 250, 53)];
        imageView.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"dhbgm_img"]);
        [_bgImageView addSubview:imageView];
        
        NSString *str = [NoticeTools getLocalStrWith:@"zb.mark"];
        NSAttributedString *attStr = [NoticeTools setLabelSpacewithValue:str withFont:THRETEENTEXTFONTSIZE];
        CGFloat height = [NoticeTools getSpaceLabelHeight:str withFont:THRETEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-70];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(imageView.frame), DR_SCREEN_WIDTH-40, height+40)];
        backV.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.1];
        backV.layer.cornerRadius = 5;
        backV.layer.masksToBounds = YES;
        [_bgImageView addSubview:backV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, backV.frame.size.width-30, backV.frame.size.height)];
        label.numberOfLines = 0;
        label.font = THRETEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.attributedText = attStr;
        [backV addSubview:label];
    }
    return _bgImageView;
}

- (void)dhClick{
    
    NoticeShareGroupView *sendView = [[NoticeShareGroupView alloc] initWithRecodeWith];
    __weak typeof(self) weakSelf = self;
    sendView.clickvoiceBtnBlock = ^(NSInteger voiceType) {
   
        if (voiceType == 0) {
            NoticePayAndSendRecoderController *ctl = [[NoticePayAndSendRecoderController alloc] init];
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }else{
            NoticeExchangeController *ctl = [[NoticeExchangeController alloc] init];
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }
    };
    [sendView showShareView];

}


@end
