
//
//  NoticeZjView.m
//  NoticeXi
//
//  Created by li lei on 2019/8/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeZjView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeAddZjController.h"
#import "NoticeZJDetailController.h"
#import "NoticeSeasonViewController.h"
#import "NoticeAbout.h"
#import "NoticeJoinTextAlbumController.h"
@implementation NoticeZjView

- (instancetype)initWithFrame:(CGRect)frame isOther:(BOOL)isOther{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        self.isOther = isOther;
        self.backgroundColor = [NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#181828"];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,15, DR_SCREEN_WIDTH-30-83, 15)];
        _titleL.font = FIFTHTEENTEXTFONTSIZE;
        _titleL.textColor = GetColorWithName(VMainTextColor);
        [self addSubview:_titleL];
        
        if (!isOther) {
            _addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-73-15, 10, 73, 25)];
            _addButton.backgroundColor = [NoticeTools getWhiteColor:@"#FAFAFA" NightColor:@"#222238"];
            _addButton.layer.cornerRadius = 25/2;
            _addButton.layer.masksToBounds = YES;
            [_addButton setTitle:[NoticeTools isSimpleLau]?@" 添加专辑":@" 添加專輯" forState:UIControlStateNormal];
            [_addButton setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            _addButton.titleLabel.font = ELEVENTEXTFONTSIZE;
            [_addButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"add_zjimg":@"add_zjimgy") forState:UIControlStateNormal];
            [self addSubview:_addButton];
            [_addButton addTarget:self action:@selector(addzjClick) forControlEvents:UIControlEventTouchUpInside];
        }

        
        //1.初始化layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置列的最小间距
        layout.minimumInteritemSpacing = 0;
        // 设置最小行间距
        layout.minimumLineSpacing = 0;
        self.layout = layout;
        
        //2.初始化collectionView
        _merchantCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15,49,DR_SCREEN_WIDTH-60, (DR_SCREEN_WIDTH-60-16)/3+32) collectionViewLayout:self.layout];
        _merchantCollectionView.dataSource = self;
        _merchantCollectionView.delegate = self;
        _merchantCollectionView.backgroundColor = self.backgroundColor;
        _merchantCollectionView.showsVerticalScrollIndicator = NO;
        _merchantCollectionView.showsHorizontalScrollIndicator = NO;
        [_merchantCollectionView registerClass:[NoticeZjCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_merchantCollectionView];
        
        if (!isOther) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAblum) name:@"CREATABLUMSUCCESS" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAblum) name:@"CREATABLUMSUCCESSTEXT" object:nil];
            [self refreshAblum];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame isText:(BOOL)isText isOther:(BOOL)isOther{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.isText = isText;
        
        self.isOther = isOther;
        
        self.backgroundColor = [NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#181828"];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,15, DR_SCREEN_WIDTH-30-83, 15)];
        _titleL.font = FIFTHTEENTEXTFONTSIZE;
        _titleL.textColor = GetColorWithName(VMainTextColor);
        [self addSubview:_titleL];
        
        if (!isOther) {
            _addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-73-15, 10, 73, 25)];
            _addButton.backgroundColor = [NoticeTools getWhiteColor:@"#FAFAFA" NightColor:@"#222238"];
            _addButton.layer.cornerRadius = 25/2;
            _addButton.layer.masksToBounds = YES;
            [_addButton setTitle:[NoticeTools isSimpleLau]?@" 添加专辑":@" 添加專輯" forState:UIControlStateNormal];
            [_addButton setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            _addButton.titleLabel.font = ELEVENTEXTFONTSIZE;
            [_addButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"add_zjimg":@"add_zjimgy") forState:UIControlStateNormal];
            [self addSubview:_addButton];
            [_addButton addTarget:self action:@selector(addzjClick) forControlEvents:UIControlEventTouchUpInside];
        }

        
        //1.初始化layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置列的最小间距
        layout.minimumInteritemSpacing = 0;
        // 设置最小行间距
        layout.minimumLineSpacing = 0;
        self.layout = layout;
        
        //2.初始化collectionView
        _merchantCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15,49,DR_SCREEN_WIDTH-60, (DR_SCREEN_WIDTH-60-16)/3+32) collectionViewLayout:self.layout];
        _merchantCollectionView.dataSource = self;
        _merchantCollectionView.delegate = self;
        _merchantCollectionView.backgroundColor = self.backgroundColor;
        _merchantCollectionView.showsVerticalScrollIndicator = NO;
        _merchantCollectionView.showsHorizontalScrollIndicator = NO;
        [_merchantCollectionView registerClass:[NoticeZjCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_merchantCollectionView];
        
        if (!isOther) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAblum) name:@"CREATABLUMSUCCESSTEXT" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAblum) name:@"CREATABLUMSUCCESS" object:nil];
            [self refreshAblum];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame isLimit:(BOOL)isLimit{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.isLimit = isLimit;
        self.backgroundColor = [NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#181828"];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,15, DR_SCREEN_WIDTH-30-83, 15)];
        _titleL.font = FIFTHTEENTEXTFONTSIZE;
        _titleL.textColor = GetColorWithName(VMainTextColor);
        [self addSubview:_titleL];
        
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-73-15, 10, 73, 25)];
        _addButton.backgroundColor = [NoticeTools getWhiteColor:@"#FAFAFA" NightColor:@"#222238"];
        _addButton.layer.cornerRadius = 25/2;
        _addButton.layer.masksToBounds = YES;
        [_addButton setTitle:[NoticeTools isSimpleLau]?@" 添加专辑":@" 添加專輯" forState:UIControlStateNormal];
        [_addButton setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        _addButton.titleLabel.font = ELEVENTEXTFONTSIZE;
        [_addButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"add_zjimg":@"add_zjimgy") forState:UIControlStateNormal];
        [self addSubview:_addButton];
        [_addButton addTarget:self action:@selector(addzjClick) forControlEvents:UIControlEventTouchUpInside];

        //1.初始化layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置列的最小间距
        layout.minimumInteritemSpacing = 0;
        // 设置最小行间距
        layout.minimumLineSpacing = 0;
        self.layout = layout;
        
        //2.初始化collectionView
        _merchantCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15,49,DR_SCREEN_WIDTH-60, (DR_SCREEN_WIDTH-60-16)/3+32) collectionViewLayout:self.layout];
        _merchantCollectionView.dataSource = self;
        _merchantCollectionView.delegate = self;
        _merchantCollectionView.backgroundColor = self.backgroundColor;
        _merchantCollectionView.showsVerticalScrollIndicator = NO;
        _merchantCollectionView.showsHorizontalScrollIndicator = NO;
        [_merchantCollectionView registerClass:[NoticeZjCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_merchantCollectionView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAblum) name:@"CREATABLUMSUCCESSLIMIT" object:nil];
        [self refreshAblum];
    }
    return self;
}

- (void)getZjAllNumbet{
    NSString *url = self.isLimit?@"dialogAlbums/statistics":[NSString stringWithFormat:@"user/%@/voiceAlbum/Statistics",_userId?_userId: [[NoticeSaveModel getUserInfo] user_id]];
    if (self.isText) {
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum/Statistics?voiceType=2",_userId?_userId: [[NoticeSaveModel getUserInfo] user_id]];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isLimit? @"application/vnd.shengxi.v4.3+json": @"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeZjModel *totalM = [NoticeZjModel mj_objectWithKeyValues:dict[@"data"]];
            self.allNumber = totalM.total;
            [self.merchantCollectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

//刷新专辑列表
- (void)refreshAblum{
    self.isDown = YES;
    [self getAlbum];
}

- (void)setUserId:(NSString *)userId{
    _userId = userId;
    if (self.isOther) {
        [self requestList];
    }
}

- (void)requestList{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"relations/%@",self.userId] Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
     
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                [self getAlbum];
                return ;
            }
            NoticeAbout *about = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            if ([about.friend_status isEqualToString:@"2"]) {
                self.isFriend = YES;
            }else{
                self.isFriend = NO;
            }
        }
        [self getAlbum];
    } fail:^(NSError * _Nullable error) {
        [self getAlbum];
    }];

}

- (void)getAlbum{
    [self getZjAllNumbet];
    if (self.isLimit) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"dialogAlbums" Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {

            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                if (self.isDown == YES) {
                    [self.dataArr removeAllObjects];
                    self.isDown = NO;
                }
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeZjModel *model = [NoticeZjModel mj_objectWithKeyValues:dic];
                    [self.dataArr addObject:model];
                }
                if (self.dataArr.count) {
                    NoticeZjModel *lastM = self.dataArr[self.dataArr.count-1];
                    self.lastId = lastM.album_sort;
                }
                if (self.isOther) {
                    self.noDataL.hidden = self.dataArr.count ? YES :NO;
                }
                [self.merchantCollectionView reloadData];
            }
            
        } fail:^(NSError *error) {
        }];
        return;
    }
    NSString *url = nil;
    url = [NSString stringWithFormat:@"user/%@/voiceAlbum",_userId?_userId: [[NoticeSaveModel getUserInfo] user_id]];
    if (self.isText) {
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?voiceType=2",_userId?_userId: [[NoticeSaveModel getUserInfo] user_id]];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {

        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isText) {
                DRLog(@">>>%@",dict);
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeZjModel *model = [NoticeZjModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeZjModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.album_sort;
            }
            if (self.isOther) {
                self.noDataL.hidden = self.dataArr.count ? YES :NO;
            }
            [self.merchantCollectionView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}
//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeZjCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    merchentCell.titleL.hidden = YES;
    merchentCell.isText = self.isText;
    merchentCell.isLimit = self.isLimit;
    merchentCell.timeL.hidden = NO;
    merchentCell.markImgV.hidden = YES;
    if (self.isOther) {
        if (indexPath.row < 2) {
            if (self.isFriend) {
                merchentCell.firModel = self.dataArr[indexPath.row];
            }else{
                merchentCell.nofirModel = self.dataArr[indexPath.row];
            }
            if (self.isLimit) {
                merchentCell.timeL.hidden = NO;
            }
        }else{
            merchentCell.titleL.hidden = NO;
            merchentCell.timeL.hidden = YES;
            merchentCell.titleL.text = [NSString stringWithFormat:@"查看更多\n(%@)",self.allNumber];
            merchentCell.zjImageView.image = nil;
            merchentCell.nameL.text = @"";
        }

    }else{
        if (self.dataArr.count) {
            if (indexPath.row < 2) {
                merchentCell.markImgV.hidden = NO;
                merchentCell.nameL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#666666":@"#72727f"];
                merchentCell.urlModel = self.dataArr[indexPath.row];
            }else{
                merchentCell.titleL.hidden = NO;
                merchentCell.timeL.hidden = YES;
                merchentCell.titleL.text = [NSString stringWithFormat:@"查看更多\n(%@)",self.allNumber];
                merchentCell.zjImageView.image = nil;
                merchentCell.nameL.text = @"";
            }
            if (self.isLimit) {
                merchentCell.timeL.hidden = NO;
            }
        }else{
            merchentCell.nameL.text = @"";
            merchentCell.zjImageView.image = nil;
            merchentCell.titleL.hidden = NO;
            merchentCell.timeL.hidden = YES;
            if (merchentCell.mbView) {
                merchentCell.mbView.hidden = YES;
            }
            merchentCell.titleL.text = [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"zj.creat"] fantText:@"創建專輯"];
        }
    }

    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (self.dataArr.count) {
        return self.dataArr.count <= 2 ? self.dataArr.count : 3;
    }
    if (self.isOther) {
        return 0;
    }
    return 1;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-60-16)/3,(DR_SCREEN_WIDTH-60-16)/3+32);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)addzjClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    NoticeAddZjController *ctl = [[NoticeAddZjController alloc] init];
    ctl.isText = self.isText;
    ctl.isDiaAblum = self.isLimit;
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    if (!self.dataArr.count) {
        NoticeAddZjController *ctl = [[NoticeAddZjController alloc] init];
        ctl.isText = self.isText;
        ctl.isDiaAblum = self.isLimit;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }else{
        if (indexPath.row < 2) {
            if (self.isFriend && [[self.dataArr[indexPath.row] album_type] isEqualToString:@"3"]) {//朋友私密不可点击
                return;
            }
            if (!self.isFriend && self.isOther) {
                if ([[self.dataArr[indexPath.row] album_type] isEqualToString:@"2"] || [[self.dataArr[indexPath.row] album_type] isEqualToString:@"3"]) {//非朋友不可点击
                    return;
                }
            }
            
            if (self.isText) {//进入文字专辑详情
                NoticeJoinTextAlbumController *ctl = [[NoticeJoinTextAlbumController alloc] init];
                ctl.isOther = self.isOther;
                ctl.userId = self.userId;
                ctl.zjModel = self.dataArr[indexPath.row];
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
                return;
            }
            NoticeZJDetailController *ctl = [[NoticeZJDetailController alloc] init];
            ctl.isOther = self.isOther;
            ctl.isLimit = self.isLimit;
            if (self.isOther) {
                if (![self.dataArr[indexPath.row]voice_total_len].intValue) {
                    [nav.topViewController showToastWithText:@"专辑为空"];
                    return;
                }
                ctl.userId = self.userId;
            }
            ctl.zjModel = self.dataArr[indexPath.row];
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            return;
        }
        NoticeSeasonViewController *ctl = [[NoticeSeasonViewController alloc] init];
        ctl.isFriend = self.isFriend;
        ctl.isLimt = self.isLimit;
        if (self.isOther) {
            ctl.userId = _userId;
        }
        ctl.isText = self.isText;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (UILabel  *)noDataL{
    if (!_noDataL) {
        _noDataL = [[UILabel alloc] initWithFrame:CGRectMake(self.merchantCollectionView.frame.origin.x,self.merchantCollectionView.frame.origin.y, self.merchantCollectionView.frame.size.width, self.merchantCollectionView.frame.size.height)];
        _noDataL.textAlignment = NSTextAlignmentCenter;
        _noDataL.font = FOURTHTEENTEXTFONTSIZE;
        _noDataL.textColor = [NoticeTools getWhiteColor:@"#b2b2b2" NightColor:@"#3e3e4a"];
        _noDataL.text = [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"zj.nozj"] fantText:@"ta還沒有專輯"];
        [self addSubview:_noDataL];
    }
    return _noDataL;
}
@end
