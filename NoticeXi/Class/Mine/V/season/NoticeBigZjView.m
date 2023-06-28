//
//  NoticeBigZjView.m
//  NoticeXi
//
//  Created by li lei on 2019/8/19.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBigZjView.h"
#import "NoticeBigZjCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeZJDetailController.h"
@implementation NoticeBigZjView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = GetColorWithName(VlistColor);
        self.isDown = YES;
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-30-83, 16)];
        _titleL.font = SIXTEENTEXTFONTSIZE;
        _titleL.textColor = GetColorWithName(VMainTextColor);
        [self addSubview:_titleL];
        //1.初始化layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 设置列的最小间距
        layout.minimumInteritemSpacing = 0;
        // 设置最小行间距
        layout.minimumLineSpacing = 0;
        self.layout = layout;
        
        //2.初始化collectionView
        _merchantCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15,49, DR_SCREEN_WIDTH-15,DR_SCREEN_WIDTH-32+25) collectionViewLayout:self.layout];
        _merchantCollectionView.dataSource = self;
        _merchantCollectionView.delegate = self;
        _merchantCollectionView.backgroundColor = GetColorWithName(VBigLineColor);
        _merchantCollectionView.showsVerticalScrollIndicator = NO;
        _merchantCollectionView.showsHorizontalScrollIndicator = NO;
        [_merchantCollectionView registerClass:[NoticeBigZjCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_merchantCollectionView];
    }
    return self;
}

- (void)setIsYulan:(BOOL)isYulan{
    _isYulan = isYulan;
    self.backgroundColor =[NoticeTools isWhiteTheme]? GetColorWithName(VBackColor):GetColorWithName(VlistColor);
    self.merchantCollectionView.backgroundColor = self.backgroundColor;
    
}

- (void)setUserId:(NSString *)userId{
    _userId = userId;
    if (self.isFriend) {
        [self requestListfriend];
    }else{
        [self requestListNofriend];
    }
}

- (void)requestListNofriend{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=albumSort&albumType=1",_userId];
    }else{
        if (self.allLastId) {
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=albumSort&albumType=1&orderByValue=%@",_userId,self.allLastId];
        }else{
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=albumSort&albumType=1",_userId];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            BOOL needContuine = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                BOOL isAlready = NO;
                NoticeZjModel *model = [NoticeZjModel mj_objectWithKeyValues:dic];
                for (NoticeZjModel *lodm in self.showDataArr) {
                    if ([lodm.albumId isEqualToString:model.albumId]) {
                        isAlready = YES;
                    }
                }
                if (self->_isYulan) {
                    if (model.voice_total_len_o.integerValue) {
                        if (!isAlready) {
                            [self.showDataArr addObject:model];
                        }
                        
                    }
                }else{
                    if (model.voice_num.integerValue) {
                        if (!isAlready) {
                            [self.showDataArr addObject:model];
                        }
                    }
                }
                
                [self.dataArr addObject:model];
                needContuine = YES;
            }
            
            if (self.dataArr.count) {
                NoticeZjModel *lastM = self.dataArr[self.dataArr.count-1];
                self.allLastId = lastM.album_sort;
            }
            [self.merchantCollectionView reloadData];
            if (needContuine) {
                [self requestListNofriend];
            }else{
                self.titleL.text = [NSString stringWithFormat:@"%ld%@",self.showDataArr.count,[NoticeTools isSimpleLau]?@"张心情专辑":@"張心情專輯"];
            }
            if (!self.showDataArr.count) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(nodateDelegate)]) {
                    [self.delegate nodateDelegate];
                }
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)requestListfriend{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=albumSort&albumType=2",_userId];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=albumSort&albumType=2&orderByValue=%@",_userId,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=albumSort&albumType=2",_userId];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            BOOL needContuine = NO;
            
            for (NSDictionary *dic in dict[@"data"]) {
                BOOL isAlready = NO;
                NoticeZjModel *model = [NoticeZjModel mj_objectWithKeyValues:dic];
                for (NoticeZjModel *lodm in self.showDataArr) {
                    if ([lodm.albumId isEqualToString:model.albumId]) {
                        isAlready = YES;
                    }
                }
                if (self->_isYulan) {
                    if (model.voice_total_len_o.integerValue) {
                        if (!isAlready) {
                           [self.showDataArr addObject:model];
                        }
                        
                    }
                }else{
                    if (model.voice_num.integerValue) {
                        if (!isAlready) {
                            [self.showDataArr addObject:model];
                        }
                    }
                }
                
                [self.dataArr addObject:model];
                needContuine = YES;
            }
            
            if (self.dataArr.count) {
                NoticeZjModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.album_sort;
            }
            [self.merchantCollectionView reloadData];
            if (needContuine) {
                [self requestListfriend];
            }else{
                [self requestListNofriend];
            }
//            if (!self.showDataArr.count) {
//                if (self.delegate && [self.delegate respondsToSelector:@selector(nodateDelegate)]) {
//                    [self.delegate nodateDelegate];
//                }
//            }
        }
    } fail:^(NSError *error) {
    }];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeBigZjCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    merchentCell.contentView.backgroundColor = self.backgroundColor;
    merchentCell.zjModel = self.showDataArr[indexPath.row];
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.showDataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(DR_SCREEN_WIDTH-32,DR_SCREEN_WIDTH-32+25);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 7;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isYulan) {
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticeZJDetailController *ctl = [[NoticeZJDetailController alloc] init];
    ctl.zjModel = self.showDataArr[indexPath.row];
    ctl.userId = _userId;
    ctl.isOther = YES;
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (NSMutableArray *)showDataArr{
    if (!_showDataArr  ) {
        _showDataArr = [[NSMutableArray alloc] init];
    }
    return _showDataArr;
}
@end
