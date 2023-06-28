//
//  NoticeImageViewController.m
//  NoticeXi
//
//  Created by li lei on 2021/1/15.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeImageViewController.h"
#import "NoticeBBSComentInputView.h"
#import "NoticeReadLyCell.h"
#import "NoticeXi-Swift.h"
#import "NoticeManager.h"
#import "NoticeReadRecodController.h"
#import "NoticeWriteRecodModel.h"
@interface NoticeImageViewController ()<NoticeBBSComentInputDelegate,NoticeManagerUserDelegate>
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) NoticeBBSComentInputView *inputView;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSString *deleteId;
@property (nonatomic, strong) UIImageView *senImagelead;

@property (nonatomic, strong) UILabel *likeNumL;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIView *tabHeadView;
@end

@implementation NoticeImageViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.inputView showJustComment:nil];
    if (self.isLead) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdel.floatView.hidden = YES;
    }else{
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-50-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.tableView.tableHeaderView = view;
    self.tabHeadView = view;
    
    self.needHideNavBar = YES;
    self.needBackGroundView = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    
    view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    [self.tableView registerClass:[NoticeReadLyCell class] forCellReuseIdentifier:@"cell"];
    
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"read.title"];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        
    [self createRefesh];
    self.dataArr = [[NSMutableArray alloc] init];
   
    if (self.isReadEveryDay) {
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"article" Accept:@"application/vnd.shengxi.v5.4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                NoticeBannerModel *bannerM = [NoticeBannerModel mj_objectWithKeyValues:dict[@"data"]];
                self.bannerM = bannerM;
                self.url = self.bannerM.http_attr_pc;
                [self refreshUrl];
            }
            [self hideHUD];
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }else{
        [self refreshUrl];
    }
    
    self.inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
    self.inputView.delegate = self;
    self.inputView.isLead = YES;
    self.inputView.isRead = YES;
    self.inputView.limitNum = 1000;
    self.inputView.plaStr = [NoticeTools getLocalStrWith:@"read.pla"];
    self.inputView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
  
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.isLead) {
        appdel.noPop = YES;
        self.navBarView.backButton.hidden = YES;
        UIButton *closBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 52, 28)];
        [closBtn setBackgroundImage:UIImageNamed(@"Image_leaclose") forState:UIControlStateNormal];
        [closBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.navBarView addSubview:closBtn];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-207)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-129-50, 207, 127)];
        [self.view addSubview:imageV];
        imageV.image = UIImageNamed(@"Image_lyzhiying3");
        imageV.userInteractionEnabled = YES;
        
  
        NSString *path = [[NSBundle mainBundle] pathForResource:@"46" ofType:@"m4a"];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
    
        __weak typeof(self) weakSelf = self;
        self.inputView.orignYBlock = ^(CGFloat y) {
            weakSelf.senImagelead.frame = CGRectMake(DR_SCREEN_WIDTH-207, self.inputView.frame.origin.y-119, 207, 119);
        };
        
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration:3.2 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            imageV.frame = CGRectMake((DR_SCREEN_WIDTH-207)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-129, 207, 127);
        } completion:^(BOOL finished) {
            imageV.hidden = YES;
            self.senImagelead = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-207, self.inputView.frame.origin.y-119-50, 207, 119)];
            self.senImagelead.image = UIImageNamed(@"Image_lyzhiying4");
            [self.view addSubview:self.senImagelead];
            [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
                NSString *path = [[NSBundle mainBundle] pathForResource:@"47" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
                self.senImagelead.frame = CGRectMake(DR_SCREEN_WIDTH-207, self.inputView.frame.origin.y-119, 207, 119);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        appdel.noPop = NO;
    }
    
    if (self.ismessage) {
        self.navBarView.titleL.text = @"";
    }
}

- (void)refreshUrl{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.cornerRadius = 5;
    imageView.backgroundColor = self.view.backgroundColor;
    imageView.layer.masksToBounds = YES;
    [self.tabHeadView addSubview:imageView];
    self.contentImageView = imageView;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image.size.width*image.size.height >0) {
            CGFloat height = (DR_SCREEN_WIDTH-30) /image.size.width*image.size.height;
            
            self.tabHeadView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, height+67);
            imageView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, height);
            [self.tableView reloadData];
            
            FSCustomButton *btn = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-32-32-32,CGRectGetMaxY(imageView.frame)+15,32,32)];
            [btn setBackgroundImage:[UIImage imageNamed:@"Image_down"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tostClick) forControlEvents:UIControlEventTouchUpInside];
            [self.tabHeadView addSubview:btn];
            
            self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-32, btn.frame.origin.y, 32, 32)];
            [self.likeButton addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
            [self.tabHeadView addSubview:self.likeButton];
            
            
            self.likeNumL = [[UILabel alloc] initWithFrame:CGRectMake(self.likeButton.frame.origin.x+18, self.likeButton.frame.origin.y-7, 70, 17)];
            self.likeNumL.font = [UIFont systemFontOfSize:10];
            self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
            [self.tabHeadView addSubview:self.likeNumL];
            
            if (self.bannerM.like_num.integerValue) {
                [self.likeButton setBackgroundImage:UIImageNamed(self.bannerM.is_like.boolValue?@"Image_readlikess": @"Image_readlikes") forState:UIControlStateNormal];
                self.likeNumL.text = self.bannerM.like_num;
                self.likeNumL.textColor = [UIColor colorWithHexString:self.bannerM.is_like.boolValue? @"#F47070":@"#25262E"];
                self.likeNumL.hidden = NO;
            }else{
                self.likeNumL.hidden = YES;
                [self.likeButton setBackgroundImage:UIImageNamed(@"Image_readlike") forState:UIControlStateNormal];
            }
            
            if (!self.ismessage) {
                FSCustomButton *btn1 = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-30, STATUS_BAR_HEIGHT,30, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
                [btn1 setImage:[UIImage imageNamed:@"Image_rili"] forState:UIControlStateNormal];
                [btn1 setTitle:@"  " forState:UIControlStateNormal];
                [btn1 setButtonImagePosition:FSCustomButtonImagePositionRight];
                [btn1 addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
                [self.navBarView addSubview:btn1];
            }
   
            [self.tableView.mj_header beginRefreshing];
        }
        
    }];
}

- (void)setBannerM:(NoticeBannerModel *)bannerM{
    _bannerM = bannerM;
    
    if (self.bannerM.like_num.integerValue) {
        [self.likeButton setBackgroundImage:UIImageNamed(self.bannerM.is_like.boolValue?@"Image_readlikess": @"Image_readlikes") forState:UIControlStateNormal];
        self.likeNumL.text = self.bannerM.like_num;
        self.likeNumL.textColor = [UIColor colorWithHexString:self.bannerM.is_like.boolValue? @"#F47070":@"#25262E"];
        self.likeNumL.hidden = NO;
    }else{
        self.likeNumL.hidden = YES;
        [self.likeButton setBackgroundImage:UIImageNamed(@"Image_readlike") forState:UIControlStateNormal];
    }
}

- (void)likeClick{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"article/like/%@/%@",self.bannerM.bannerId,self.bannerM.is_like.boolValue?@"0":@"1"] Accept:@"application/vnd.shengxi.v5.4.3+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.bannerM.is_like = self.bannerM.is_like.boolValue?@"0":@"1";
            if (self.bannerM.is_like.boolValue) {
                self.bannerM.like_num = [NSString stringWithFormat:@"%ld",self.bannerM.like_num.integerValue+1];
            }else{
                self.bannerM.like_num = [NSString stringWithFormat:@"%ld",self.bannerM.like_num.integerValue-1];
            }
            if (self.bannerM.like_num.integerValue) {
                [self.likeButton setBackgroundImage:UIImageNamed(self.bannerM.is_like.boolValue?@"Image_readlikess": @"Image_readlikes") forState:UIControlStateNormal];
                self.likeNumL.text = self.bannerM.like_num;
                self.likeNumL.textColor = [UIColor colorWithHexString:self.bannerM.is_like.boolValue? @"#F47070":@"#25262E"];
                self.likeNumL.hidden = NO;
            }else{
                self.likeNumL.hidden = YES;
                [self.likeButton setBackgroundImage:UIImageNamed(@"Image_readlike") forState:UIControlStateNormal];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)closeClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定放弃任务吗？" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
           
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":@"100"}];
        }
    };
    [alerView showXLAlertView];
}

- (void)recordClick{
    [self showHUD];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"article/getCommentHistory" Accept:@"application/vnd.shengxi.v5.3.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeWriteRecodModel *model = [NoticeWriteRecodModel mj_objectWithKeyValues:dic];
                [arr addObject:model];
            }
            if (arr.count) {
                NoticeReadRecodController *ctl = [[NoticeReadRecodController alloc] init];
                [self.navigationController pushViewController:ctl animated:YES];
            }else{
                [self showToastWithText:[NoticeTools getLocalStrWith:@"no.noliuyan"]];
            }
            
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
 
}

- (void)createRefesh{
    
    __weak NoticeImageViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = GetColorWithName(VMainTextColor);

    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"comment/%@",self.bannerM.bannerId];
    }else{
        url = [NSString stringWithFormat:@"comment/%@?pageNo=%ld",self.bannerM.bannerId,self.pageNo];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.9.20+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeLy *banM = [NoticeLy mj_objectWithKeyValues:dic];
                [self.dataArr addObject:banM];
            }
            [self.tableView reloadData];
            self.tableView.tableFooterView = self.dataArr.count?nil:self.footView;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeReadLyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.liuyan = self.dataArr[indexPath.row];
    cell.line.hidden = (indexPath.row == self.dataArr.count-1)?YES:NO;
    cell.cirView.hidden = indexPath.row == 0?NO:YES;
    __weak typeof(self) weakSelf = self;
    cell.longTapBlock = ^(NoticeLy * _Nonnull lyM) {
        if ([NoticeTools isManager]) {
            weakSelf.deleteId = lyM.liuyanId;
            weakSelf.magager.type = @"管理员删除";
            [weakSelf.magager show];
            return;
        }
        if ([lyM.from_user_id isEqualToString:[NoticeTools getuserId]]) {//自己的配音，是删除操作
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"py.issueredel"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"comment/%@",lyM.liuyanId] Accept:@"application/vnd.shengxi.v4.9.20+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                        if (success) {
                            for (NoticeLy * oldM in self.dataArr) {
                                if ([oldM.liuyanId isEqualToString:lyM.liuyanId]) {
                                    [weakSelf.dataArr removeObject:oldM];
                                    [weakSelf.tableView reloadData];
                                    break;
                                }
                            }
                        }
                    } fail:^(NSError * _Nullable error) {
                    }];
                }
            };
            [alerView showXLAlertView];
            return;
        }
        NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
        juBaoView.reouceId = lyM.liuyanId;
        juBaoView.reouceType = @"111";
        [juBaoView showView];
    };
    return cell;
}

- (void)sureManagerClick:(NSString *)code{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
 
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/comment/%@",self.deleteId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        [self.magager removeFromSuperview];
        if (success) {
            for (NoticeLy * oldM in self.dataArr) {
                if ([oldM.liuyanId isEqualToString:self.deleteId]) {
                    [self.dataArr removeObject:oldM];
                    [self.tableView reloadData];
                    break;
                }
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeLy *lyM = self.dataArr[indexPath.row];
    if (lyM.height1 < 40) {
        return 56 + (lyM.replyted_at.integerValue?(lyM.height2+10):0);
    }
    return lyM.height1+16+15 + (lyM.replyted_at.integerValue?(lyM.height2+10):0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 60)];
    view.backgroundColor = self.view.backgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-15, 50)];
    label.text = [NoticeTools getLocalStrWith:@"read.ly"];
    label.font = XGEightBoldFontSize;
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    [view addSubview:label];
    return view;
}

//点击发送
- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    if (self.isLead) {
        [self.inputView.contentView resignFirstResponder];
        [self.inputView clearView];
        [self.inputView removeFromSuperview];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":@"101"}];
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:comment forKey:@"content"];
    if (!self.bannerM.bannerId) {
        return;
    }
    [parm setObject:self.bannerM.bannerId forKey:@"article_id"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"comment" Accept:@"application/vnd.shengxi.v4.9.20+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"yl.lychengg"]];
            self.isDown = YES;
            [self request];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)tostClick{
    [self.contentImageView.image saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
        [self showToastWithText:[NoticeTools getLocalType]?@"Saved to album":@"已存至手机相册"];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.inputView.contentView resignFirstResponder];
    [self.inputView clearView];
    [self.inputView removeFromSuperview];
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, DR_SCREEN_WIDTH, 90)];
        _footView.backgroundColor = self.view.backgroundColor;
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, 20, DR_SCREEN_WIDTH-40, 70)];
        backV.layer.cornerRadius = 10;
        backV.layer.masksToBounds = YES;
        backV.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((backV.frame.size.width-280)/2, 13, 280, 43)];
        imageV.image = UIImageNamed(@"Image_meiyzj");
        [backV addSubview:imageV];
        [_footView addSubview:backV];
    }
    return _footView;
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}
@end
