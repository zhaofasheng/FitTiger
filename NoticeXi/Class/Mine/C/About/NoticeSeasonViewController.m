//
//  NoticeSeasonViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/8/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSeasonViewController.h"
#import "NoticeYuLanZjController.h"
#import "NoticeZJCollectionCell.h"
#import "NoticeZJDetailController.h"
#import "NoticeAddZjController.h"
#import "NoticeAbout.h"
#import "NoticeNewAddZjView.h"
#import "NoticeDiaDetailController.h"
@interface NoticeSeasonViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *footV;
@property (nonatomic, strong) UIView *titleHeadView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

@implementation NoticeSeasonViewController

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);

}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        if (self.isUserCenter) {
            frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-(self.isOther?TAB_BAR_HEIGHT:0));
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;          // 隐藏垂直方向滚动条
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        // 注册cell
        [_collectionView registerClass:[NoticeZJCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
    }
    
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    if (!self.isUserCenter) {
        self.navigationItem.title = self.isLimt?[NoticeTools getLocalStrWith:@"zj.mysimi"]: [NoticeTools getLocalStrWith:@"zj.myzj"];
        if (self.isOther) {
            self.navigationItem.title = [NoticeTools getLocalStrWith:@"zj.tasimizj"];
        }
    }

    self.dataArr = [NSMutableArray new];

    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isDown = YES;
        [weakSelf requestList];
    }];
    self.collectionView.mj_header = header;
        
    [self.collectionView.mj_header beginRefreshing];
    
    if ([NoticeTools isFirstknowdhZJOnThisDeveice] && self.isLimt) {
        self.collectionView.frame = CGRectMake(0,76+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-76);
        [self.view addSubview:self.titleHeadView];
    }


    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.alphaValue > 0 && appdel.alphaValue < 0.9){
        self.view.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        _collectionView.backgroundColor = self.view.backgroundColor;
    }
    

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isOther) {
        NoticeZjModel *zjModel = self.dataArr[indexPath.row];
        if (zjModel.album_type.intValue != 1) {
            return;
        }
        NoticeZJDetailController *ctl = [[NoticeZJDetailController alloc] init];
        ctl.zjModel = self.dataArr[indexPath.row];
        ctl.userId = self.isOther?self.userId: [NoticeTools getuserId];
        ctl.isOther = self.isOther;

        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    
    
    if (indexPath.row == 0 && !self.isNoShowSimi) {
        [self addZJTap];
    }else{
        if (self.isLimt) {
            NoticeDiaDetailController *ctl = [[NoticeDiaDetailController alloc] init];
            ctl.zjModel = self.dataArr[indexPath.row];
            __weak typeof(self) weakSelf = self;
            ctl.deleteSuccessBlock = ^(NSString * _Nonnull albumId) {
                for (NoticeZjModel *oldM in weakSelf.dataArr) {
                    if ([oldM.albumId isEqualToString:albumId]) {
                        [weakSelf.dataArr removeObject:oldM];
                        break;
                    }
                }
                [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
                [weakSelf.collectionView reloadData];
            };
            
            ctl.editSuccessBlock = ^(NoticeZjModel * _Nonnull zjmodel) {
                [weakSelf.collectionView.mj_header beginRefreshing];
            };
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
       
        NoticeZJDetailController *ctl = [[NoticeZJDetailController alloc] init];
        ctl.zjModel = self.dataArr[indexPath.row];
        ctl.userId = [NoticeTools getuserId];
        __weak typeof(self) weakSelf = self;
        ctl.deleteSuccessBlock = ^(NSString * _Nonnull albumId) {
            for (NoticeZjModel *oldM in weakSelf.dataArr) {
                if ([oldM.albumId isEqualToString:albumId]) {
                    [weakSelf.dataArr removeObject:oldM];
                    break;
                }
            }
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
            [weakSelf.collectionView reloadData];
        };
        
        ctl.editSuccessBlock = ^(NoticeZjModel * _Nonnull zjmodel) {
            [weakSelf.collectionView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)refreshAblum{
    self.isDown = YES;
    [self requestList];
}

- (void)requestList{
    
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=updatedAt",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id]];
        if (self.isNoShowSimi || self.isOther) {//不展示私密专辑
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=updatedAt&albumType=1",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id]];
        }
    }else{
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByValue=%@&orderByField=updatedAt",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        if (self.isNoShowSimi || self.isOther) {
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByValue=%@&orderByField=updatedAt&albumType=1",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }
    }
    
    if (self.isLimt) {
        if (self.isDown) {
            url = @"dialogAlbums?orderByField=updatedAt";
        }else{
            url = [NSString stringWithFormat:@"dialogAlbums?orderByValue=%@&orderByField=updatedAt",self.lastId];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isLimt? @"application/vnd.shengxi.v4.3+json" : @"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                if (!self.isOther && !self.isNoShowSimi) {
                    NoticeZjModel *model = [NoticeZjModel new];
                    [self.dataArr addObject:model];
                }
                self.isDown = NO;
            }
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeZjModel *model = [NoticeZjModel mj_objectWithKeyValues:dic];
                if (self.isOther) {
                    if (model.album_type.intValue != 1) {
                        model.album_name = [NoticeTools getLocalStrWith:@"zj.simi"];
                    }
                }
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeZjModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.updated_at;
                hasData = YES;
            }
            if (hasData) {
                [self getMore];
                [_footV removeFromSuperview];
            }else{
                [self.collectionView addSubview:self.footV];;
            }
            [self.collectionView reloadData];
        }
    } fail:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
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

- (void)getMore{
    NSString *url = nil;
    if (self.isLimt) {
        url = [NSString stringWithFormat:@"dialogAlbums?orderByValue=%@&orderByField=updatedAt",self.lastId];
    }else{
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByValue=%@&orderByField=updatedAt",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        if (self.isNoShowSimi || self.isOther) {
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByValue=%@&orderByField=updatedAt&albumType=1",self.userId?self.userId:[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isLimt? @"application/vnd.shengxi.v4.3+json" : @"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
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
                self.lastId = lastM.updated_at;
            }
            if (arr.count) {
                [self getMore];
            }
            [self.collectionView reloadData];
        }
        
    } fail:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

- (void)addZJTap{
    NoticeNewAddZjView *inputView = [[NoticeNewAddZjView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.isDiaZJ = self.isLimt;
    inputView.addBlock = ^(NSString * _Nonnull name, BOOL isOpen) {
        [self showHUD];
        
        NSMutableDictionary *parm = [NSMutableDictionary new];
        
        if (self.isLimt) {
            [parm setObject:@"0" forKey:@"bucketId"];
            [parm setObject:@"0000000000" forKey:@"albumCoverUri"];
            [parm setObject:name forKey:@"albumName"];
        }else{
            [parm setObject:name forKey:@"albumName"];
            [parm setObject:isOpen?@"1":@"3" forKey:@"albumType"];
        }
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.isLimt?@"dialogAlbums": [NSString stringWithFormat:@"user/%@/voiceAlbum",[NoticeTools getuserId]] Accept:self.isLimt?@"application/vnd.shengxi.v4.7.6+json": @"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                [self.collectionView.mj_header beginRefreshing];
            }
            
            [self hideHUD];
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    };
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.nameField becomeFirstResponder];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NoticeZJCollectionCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    merchentCell.isOther = self.isOther;
    merchentCell.isLimit = self.isLimt;
    merchentCell.isNoshowSimi = self.isNoShowSimi;
    merchentCell.index = indexPath.row;
    merchentCell.urlModel = self.dataArr[indexPath.row];
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-55)/2,(DR_SCREEN_WIDTH-55)/2+67);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (UIView *)titleHeadView{
    if (!_titleHeadView) {
        _titleHeadView = [[UIView alloc] initWithFrame:CGRectMake(20,20+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, 41)];
        _titleHeadView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
        _titleHeadView.layer.cornerRadius = 5;
        _titleHeadView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,DR_SCREEN_WIDTH-50, 40)];
        label.font = TWOTEXTFONTSIZE;
        label.text = [NoticeTools getLocalStrWith:@"zj.limit1"];
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.numberOfLines = 0;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg) {
            _titleHeadView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.08];
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_titleHeadView.frame.size.width-5-40, 0, 43, 40)];
        [button setImage:UIImageNamed(appdel.backImg?@"Image_sendXXtm": @"Image_sendXX") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickXX) forControlEvents:UIControlEventTouchUpInside];
        [_titleHeadView addSubview:button];
        [_titleHeadView addSubview:label];
    }
    return _titleHeadView;
}

- (void)clickXX{
    [NoticeTools setMarkForknowdhZJ];
    [self.titleHeadView removeFromSuperview];
    self.collectionView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
}
@end


