//
//  NoticeListenViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeListenViewController.h"
#import "NoticeStaySys.h"
#import "NoticeBannerModel.h"
#import "NoticeSCListViewController.h"
#import "HQCollectionViewFlowLayout.h"
#import "NoticeBokeMainCell.h"
#import "NoticeDanMuController.h"
#import "NoticeNewLeadController.h"
#import "UINavigationController+DoitAnimation.h"
static NSString *const DRMerchantCollectionViewCellID = @"DRTILICollectionViewCell";

@interface NoticeListenViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *allNumL;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastPodcastNo;
@property (nonatomic, strong) UIView *leadV;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIImageView *threeImage;
@end

@implementation NoticeListenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needHideNavBar = YES;
    self.pageNo = 1;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];

    [self.tableView removeFromSuperview];
    
    UIButton *msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
    [msgBtn setBackgroundImage:UIImageNamed(@"msgClick_imgw") forState:UIControlStateNormal];
    [self.view addSubview:msgBtn];
    [msgBtn addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.allNumL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24+17,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2-2, 14, 14)];
    self.allNumL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
    self.allNumL.layer.cornerRadius = 7;
    self.allNumL.layer.masksToBounds = YES;
    self.allNumL.textColor = [UIColor whiteColor];
    self.allNumL.font = [UIFont systemFontOfSize:9];
    self.allNumL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.allNumL];
    self.allNumL.hidden = YES;
    

        
    [self initCollectionView];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isDown = YES;
        weakSelf.pageNo = 1;
        [weakSelf requestVoice];
    }];
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isDown = NO;
        weakSelf.pageNo++;
        [weakSelf requestVoice];
        
    }];
    self.dataArr = [[NSMutableArray alloc] init];
    self.isDown = YES;
    [self requestVoice];
    
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    UIView *leaderView = [[UIView alloc] initWithFrame:CGRectMake(8, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2, 46+GET_STRWIDTH(userM.nick_name, 15, 32), 32)];
    [self.view addSubview:leaderView];
    leaderView.layer.cornerRadius = 16;
    leaderView.layer.masksToBounds = YES;
    leaderView.backgroundColor = [UIColor whiteColor];
    leaderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leadTap)];
    [leaderView addGestureRecognizer:tap];
    self.leadV = leaderView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 20, 20)];
    imageView.image = UIImageNamed(@"Image_sublogo");
    [self.leadV addSubview:imageView];
    
    self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, GET_STRWIDTH(userM.nick_name, 15, 32), 32)];
    self.nickNameL.font = XGFourthBoldFontSize;
    self.nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.leadV addSubview:self.nickNameL];
    
    self.threeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.leadV.frame.size.width-16, 12, 8, 8)];
    self.threeImage.image = UIImageNamed(@"Image_threeinto");
    [self.leadV addSubview:self.threeImage];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"RECLICKREFRESHBOKEDATA" object:nil];

}


- (void)refreshData{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)leadTap{
    NoticeNewLeadController *ctl = [[NoticeNewLeadController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)requestVoice{
    NSString *url = nil;
    if (self.isDown) {
        url = @"podcast";
    }else{
        url = [NSString stringWithFormat:@"podcast?pageNo=%ld",self.pageNo];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
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
                [self.dataArr addObject:model];
            }
            
            [self.collectionView reloadData];
        }

    } fail:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];

    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];
    ctl.bokeModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeBokeMainCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:DRMerchantCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.section == 1) {
        merchentCell.model = self.dataArr[indexPath.row];
    }
    
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return section==0? 0: self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-15)/2,81+(DR_SCREEN_WIDTH-15)/2*111/180);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5,5);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (void)initCollectionView {
    //1.初始化layout
    HQCollectionViewFlowLayout *layout = [[HQCollectionViewFlowLayout alloc] init];
    //layout.naviHeight = NAVIGATION_BAR_HEIGHT;
    //2.初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT -  NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[NoticeBokeMainCell class] forCellWithReuseIdentifier:DRMerchantCollectionViewCellID];
    [self.view addSubview:_collectionView];
}


- (void)msgClick{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeSCListViewController *ctl = [[NoticeSCListViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:NO];
}

- (void)redCirRequest{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v5.4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeStaySys *stay = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];
            self.allNumL.hidden = stay.chatpriM.num.intValue?NO:YES;
            CGFloat strWidth = GET_STRWIDTH(stay.chatpriM.num, 9, 14);
            if (stay.chatpriM.num.intValue < 10) {
                strWidth = 14;
            }else{
                strWidth = strWidth+6;
            }
            self.allNumL.text = stay.chatpriM.num;
            self.allNumL.frame = CGRectMake(DR_SCREEN_WIDTH-20-24+17, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2-4, strWidth, 14);
        }
    } fail:^(NSError *error) {
    }];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    [self redCirRequest];
    self.navigationController.navigationBar.hidden = YES;
    
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    self.leadV.frame = CGRectMake(8, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2, 46+GET_STRWIDTH(userM.nick_name, 15, 32), 32);

    
    self.nickNameL.frame = CGRectMake(30, 0, GET_STRWIDTH(userM.nick_name, 15, 32), 32);
    self.nickNameL.text = userM.nick_name;
    
    self.threeImage.frame = CGRectMake(self.leadV.frame.size.width-16, 12, 8, 8);
}

@end
