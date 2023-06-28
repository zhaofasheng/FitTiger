//
//  NoticeYuLanZjController.m
//  NoticeXi
//
//  Created by li lei on 2019/8/14.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeYuLanZjController.h"
#import "NoticeBigZjView.h"
#import "NoticeZJCollectionCell.h"
@interface NoticeYuLanZjController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) UILabel *headerL;
@property (nonatomic, strong) UICollectionView *merchantCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeYuLanZjController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;//关闭右滑返回
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#12121F"];
    
    UILabel *headerL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 116)];
    headerL.backgroundColor = [NoticeTools isWhiteTheme]?[UIColor colorWithHexString:@"#323232"]:GetColorWithName(VBackColor);
    headerL.font = EIGHTEENTEXTFONTSIZE;
    headerL.textColor = [NoticeTools isWhiteTheme]?[UIColor colorWithHexString:@"#F6F6F6"]:[UIColor colorWithHexString:@"#B2B2B2"];
    headerL.textAlignment = NSTextAlignmentCenter;
    headerL.text = self.isFriendView ? [NoticeTools getTextWithSim:@"学友看我的专辑" fantText:@"学友看我的專輯"]:[NoticeTools getTextWithSim:@"非学友看我的专辑" fantText:@"非学友看我的專輯"];
    _headerL = headerL;
    [self.view addSubview:headerL];
    
    self.dataArr = [NSMutableArray new];
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.naviHeight = NAVIGATION_BAR_HEIGHT;
    // 设置列的最小间距
    layout.minimumInteritemSpacing = 0;
    // 设置最小行间距
    layout.minimumLineSpacing = 0;
    self.layout = layout;
    
    //2.初始化collectionView
    _merchantCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 116, DR_SCREEN_WIDTH-40, DR_SCREEN_HEIGHT - 116-74-BOTTOM_HEIGHT-10) collectionViewLayout:self.layout];
    _merchantCollectionView.dataSource = self;
    _merchantCollectionView.delegate = self;
    _merchantCollectionView.backgroundColor = self.view.backgroundColor;
    _merchantCollectionView.showsVerticalScrollIndicator = NO;
    _merchantCollectionView.showsHorizontalScrollIndicator = NO;
    [_merchantCollectionView registerClass:[NoticeZJCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
    [self.view addSubview:_merchantCollectionView];
    

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-74, DR_SCREEN_WIDTH, 74+BOTTOM_HEIGHT)];
    footView.backgroundColor = headerL.backgroundColor;
    [self.view addSubview:footView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 44)];
    button.layer.cornerRadius = 22;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1;
    button.layer.borderColor = headerL.textColor.CGColor;
    button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [button setTitleColor:_headerL.textColor forState:UIControlStateNormal];
    [button setTitle:[NoticeTools isSimpleLau]?@"退出预览":@"退出預覽" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    
    self.isDown = YES;
    [self requestList];
}

- (void)requestList{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=albumSort&voiceType=2",[[NoticeSaveModel getUserInfo] user_id]];
    }else{
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByValue=%@&orderByField=albumSort&voiceType=2",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
    }
    if (!self.isText) {
        if (self.isDown) {
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=albumSort",[[NoticeSaveModel getUserInfo] user_id]];
        }else{
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByValue=%@&orderByField=albumSort",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.merchantCollectionView.mj_header endRefreshing];
        [self.merchantCollectionView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeZjModel *model = [NoticeZjModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeZjModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.album_sort;
                hasData = YES;
            }
            if (hasData) {
                [self getMore];
            }
            [self.merchantCollectionView reloadData];
        }
        
    } fail:^(NSError *error) {
        [self.merchantCollectionView.mj_header endRefreshing];
        [self.merchantCollectionView.mj_footer endRefreshing];
    }];
}

- (void)getMore{
    NSString *url = nil;
    url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByValue=%@&orderByField=albumSort&voiceType=2",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
    if (!self.isText) {
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByValue=%@&orderByField=albumSort",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.merchantCollectionView.mj_header endRefreshing];
        [self.merchantCollectionView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NSMutableArray *arr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeZjModel *model = [NoticeZjModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                [arr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeZjModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.album_sort;
            }
            if (arr.count) {
                [self getMore];
            }
            [self.merchantCollectionView reloadData];
        }
        
    } fail:^(NSError *error) {
        [self.merchantCollectionView.mj_header endRefreshing];
        [self.merchantCollectionView.mj_footer endRefreshing];
    }];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeZJCollectionCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    merchentCell.isText = self.isText;
    if (self.isFriendView) {
       merchentCell.firModel = self.dataArr[indexPath.row];
    }else{
       merchentCell.nofirModel = self.dataArr[indexPath.row];
    }
    
    return merchentCell;
}


//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-40-30)/3,(DR_SCREEN_WIDTH-40-30)/3+22+15);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nodateDelegate{
    _footView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_headerL.frame), DR_SCREEN_WIDTH,126+88+30)];
    _footView.titleImageV.image = UIImageNamed(@"Image_jyot");
    _footView.titleImageV.frame = CGRectMake((DR_SCREEN_WIDTH-126)/2, 70,126, 126);
    _footView.actionButton.hidden = YES;
    _footView.titleL.frame = CGRectMake(0, CGRectGetMaxY(_footView.titleImageV.frame)+50, DR_SCREEN_WIDTH, 20);
    _footView.titleL.text = [NoticeTools isSimpleLau]?@"ta还没有心情专辑":@"ta還沒有心情專輯";
    _footView.backgroundColor = self.view.backgroundColor;
  
}

@end
