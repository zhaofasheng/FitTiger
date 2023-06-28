//
//  NoticeReadRecodController.m
//  NoticeXi
//
//  Created by li lei on 2021/12/7.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeReadRecodController.h"
#import "NoticeWriteRecodCell.h"
#import "NoticeLyView.h"

@interface NoticeReadRecodController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NoticeLyView *lyView;
@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation NoticeReadRecodController

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      
        // 创建collectionView
        CGRect frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-150);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;//隐藏垂直方向滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        // 注册cell
        [_collectionView registerClass:[NoticeWriteRecodCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}

- (void)request{
   
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"article/getCommentHistory?pageNo=%ld",self.pageNo] Accept:@"application/vnd.shengxi.v5.3.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NSInteger hasData = 0;
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeWriteRecodModel *model = [NoticeWriteRecodModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                hasData ++;
                DRLog(@"还有数据");
            }
            if (self.dataArr.count) {
                self.lyView.dataArr = [self.dataArr[0] lyArr];
            }
            if (hasData > 0) {
                self.pageNo++;
                [self request];
            }else{
                [self.collectionView reloadData];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needHideNavBar = YES;
    self.needBackGroundView = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"ly.jl"];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    
    self.collectionView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    self.tableView.hidden = YES;
    [self.view addSubview:self.collectionView];
    self.pageNo = 1;
    self.dataArr = [[NSMutableArray alloc] init];

    
    self.lyView = [[NoticeLyView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-150-NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT/3*2)];
    [self.view addSubview:self.lyView];
    
    if (self.banneerModel) {
        [self.dataArr addObject:self.banneerModel];
        [self.collectionView reloadData];
        self.navBarView.titleL.text = @"";
    }else{
        [self request];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = DR_SCREEN_WIDTH;
    
    int currentPage = floor((self.collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
   
    if (self.dataArr.count-1 >= currentPage) {
        self.lyView.dataArr = [self.dataArr[currentPage] lyArr];
    }
}



//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeWriteRecodCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if ((indexPath.row <= self.dataArr.count-1) && self.dataArr.count) {
        merchentCell.model = self.dataArr[indexPath.row];
    }
    merchentCell.bottomLine.hidden = (indexPath.row == self.dataArr.count-1)?YES:NO;
    merchentCell.topLine.hidden = indexPath.row==0?YES:NO;
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-150);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0, 0, 0);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end
