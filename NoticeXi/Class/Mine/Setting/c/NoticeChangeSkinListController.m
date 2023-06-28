//
//  NoticeChangeSkinListController.m
//  NoticeXi
//
//  Created by li lei on 2021/9/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeSkinListController.h"
#import "NoticeSkinCell.h"
#import "NoticeChangeSkinReusableView.h"
#import "NoticeChangeSkinController.h"
#import "NoticeCurentLeaveController.h"
@interface NoticeChangeSkinListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *localArr;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation NoticeChangeSkinListController

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;// 隐藏垂直方向滚动条
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        // 注册cell
        [_collectionView registerClass:[NoticeSkinCell class] forCellWithReuseIdentifier:@"Cell"];
        [_collectionView registerClass:[NoticeChangeSkinReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        self.dataArr = [[NSMutableArray alloc] init];
    }
    
    return _collectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        __weak typeof(self) weakSelf = self;
        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
        if (!userM.level.intValue && indexPath.row == 1) {
            NSString *str = nil;
            if ([NoticeTools getLocalType] == 2) {
                str = [NSString stringWithFormat:@"Lv%@へのアップグレードを使用できる〜",@"1"];
            }else if ([NoticeTools getLocalType] == 1){
                str = [NSString stringWithFormat:@"Limited to Lv%@ or higher",@"1"];
            }else{
                str = [NSString stringWithFormat:@"升级至Lv%@可使用哦~",@"1"];
            }
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.golv"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    NoticeCurentLeaveController *ctl = [[NoticeCurentLeaveController alloc] init];
                    [weakSelf.navigationController pushViewController:ctl animated:YES];
                }
            };
            [alerView showXLAlertView];
            return;
        }
        NoticeChangeSkinController *ctl = [[NoticeChangeSkinController alloc] init];
        ctl.type = indexPath.row;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeChangeSkinController *ctl = [[NoticeChangeSkinController alloc] init];
        ctl.type = 3;
        ctl.skinModel = self.dataArr[indexPath.row];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeSkinCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.section = indexPath.section;
    merchentCell.lockImageView.hidden = NO;
    if (indexPath.section == 0) {
        
        merchentCell.skinModel = self.localArr[indexPath.row];
        merchentCell.lockImageView.hidden = YES;
    }else{
        merchentCell.skinModel = self.dataArr[indexPath.row];
    }
    
    return merchentCell;
}


//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((DR_SCREEN_WIDTH-70)/3,(DR_SCREEN_WIDTH-70)/3/102*150+40);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 15, 20, 15);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}


// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

// 返回Header的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(DR_SCREEN_WIDTH, 57);
}

// 返回Header/Footer内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {          // Header视图
        // 从复用队列中获取HooterView
        NoticeChangeSkinReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.nameL.text = [NoticeTools getLocalStrWith:@"skin.gf"];
        }else{
            headerView.nameL.text = [NoticeTools getLocalStrWith:@"skin.sx"];
        }
        return headerView;
    }
    return nil;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.localArr.count;
    }
    return self.dataArr.count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView removeFromSuperview];
    
    self.dataArr = [[NSMutableArray alloc] init];
    [self.view addSubview:self.collectionView];
    
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"skin.gxchange"];;
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.needHideNavBar = YES;
    
    self.localArr = [[NSMutableArray alloc] init];
    
    NSArray *titleArr = @[[NoticeTools getLocalStrWith:@"skin.mr"],[NoticeTools getLocalStrWith:@"skin.zdy"]];
    NSArray *defaultArr = @[@"",@"Image_custumeimgde"];
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    for (int i = 0; i < 2; i++) {
        NoticeSkinModel *localM = [[NoticeSkinModel alloc] init];
        localM.title = titleArr[i];
        localM.defaultImg = defaultArr[i];
        if (i==0) {
            localM.image_url = userM.spec_bg_default_photo;
        }
        if (i == userM.spec_bg_type.intValue-1) {
            localM.isSelect = YES;
        }
        [self.localArr addObject:localM];
    }
    [self.collectionView reloadData];
    
    self.dataArr = [[NSMutableArray alloc] init];
    self.pageNo = 1;
    __weak typeof(self) weakSelf = self;
    self.isDown = YES;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isDown = YES;
        weakSelf.pageNo = 1;
        [weakSelf request];
    }];
    
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isDown = NO;
        weakSelf.pageNo++;
        [weakSelf request];
    }];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
}
  
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isDown = YES;
    self.pageNo = 1;
    [self request];
}

- (void)request{
    NSString *url = @"";
    if (self.isDown) {
        url = [NSString stringWithFormat:@"user/skin/list?pageNo=1"];
    }else{
        url = [NSString stringWithFormat:@"user/skin/list?pageNo=%ld",self.pageNo];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.2.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"][@"skin_list"]) {
                NoticeSkinModel *model = [NoticeSkinModel mj_objectWithKeyValues:dic];
                model.isSelect = model.is_set.boolValue;
                [self.dataArr addObject:model];
            }
            [self.collectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

@end
