//
//  NoticeBingGanListView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBingGanListView.h"
#import "NoticeBingGanCollCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeBingGanListView

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,100,self.frame.size.width,self.keyView.frame.size.height-120);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;          // 隐藏垂直方向滚动条
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        // 注册cell
        [_collectionView registerClass:[NoticeBingGanCollCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        
        
        
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 400+BOTTOM_HEIGHT+20)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 20;
        self.keyView.layer.masksToBounds = YES;
        
        UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.keyView.frame.size.height)];
        tapV.userInteractionEnabled = YES;
        tapV.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        [self addSubview:tapV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [tapV addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.text = [NoticeTools getLocalStrWith:@"xs.xbg"];
        label.textAlignment = NSTextAlignmentCenter;
        [self.keyView addSubview:label];
        self.titleL = label;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50,0,50, 50)];
        [cancelBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [self.keyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 65, 24, 24)];
        bgImageView.image = UIImageNamed(@"Image_songbg");
        [self.keyView addSubview:bgImageView];
        self.titleImageV = bgImageView;
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bgImageView.frame)+10, 65, DR_SCREEN_WIDTH-24-20-10-10, 24)];
        numL.font = FOURTHTEENTEXTFONTSIZE;
        numL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        numL.text = [NoticeTools getLocalStrWith:@"xs.getxgb"];
        [self.keyView addSubview:numL];
        self.bgL = numL;
        
        [self.keyView addSubview:self.collectionView];
        
        self.dataArr = [NSMutableArray new];
        
    }
    return self;
}

- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/1/%@/cracker",voiceM.voice_id] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if (allM.total.intValue) {
                self.bgL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"xs.getxgb"],allM.total] setColor:[UIColor colorWithHexString:@"#E6C14D"] setLengthString:allM.total beginSize:[[NoticeTools getLocalStrWith:@"xs.getxgb"] length]+1];
            }
            for (NSDictionary *dic in allM.list) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count >= 48) {
                NoticeFriendAcdModel *locaM = [[NoticeFriendAcdModel alloc] init];
                locaM.localData = YES;
                [self.dataArr addObject:locaM];
            }
            [self.collectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)setPyModel:(NoticeClockPyModel *)pyModel{
    _pyModel = pyModel;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/2/%@/cracker",pyModel.pyId] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if (allM.total.intValue) {
                self.bgL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"xs.getxgb"],allM.total] setColor:[UIColor colorWithHexString:@"#E6C14D"] setLengthString:allM.total beginSize:[[NoticeTools getLocalStrWith:@"xs.getxgb"] length]+1];
            }
            for (NSDictionary *dic in allM.list) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count >= 48) {
                NoticeFriendAcdModel *locaM = [[NoticeFriendAcdModel alloc] init];
                locaM.localData = YES;
                [self.dataArr addObject:locaM];
            }
            [self.collectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)setScModel:(NoticeClockPyModel *)scModel{
    _scModel = scModel;
    self.bgL.text = [NoticeTools getLocalStrWith:@"xs.hasscs"];
    self.titleL.text = [NoticeTools getLocalStrWith:@"emtion.sc"];
    self.titleImageV.image = UIImageNamed(@"Image_pyshoucangy");
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/1/%@/collection",scModel.pyId] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if (allM.total.intValue) {
                self.bgL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"xs.hasscs"],allM.total] setColor:[UIColor colorWithHexString:@"#E6C14D"] setLengthString:allM.total beginSize:[[NoticeTools getLocalStrWith:@"xs.hasscs"] length]+1];
            }
            for (NSDictionary *dic in allM.list) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count >= 48) {
                NoticeFriendAcdModel *locaM = [[NoticeFriendAcdModel alloc] init];
                locaM.localData = YES;
                [self.dataArr addObject:locaM];
            }
            [self.collectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)setScTCModel:(NoticeClockPyModel *)scTCModel{
    _scTCModel = scTCModel;
    self.titleImageV.image = UIImageNamed(@"Image_pyshoucangy");
    self.titleL.text = [NoticeTools getLocalStrWith:@"emtion.sc"];
    self.bgL.text = [NoticeTools getLocalStrWith:@"xs.hasscs"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/2/%@/collection",scTCModel.tcId] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if (allM.total.intValue) {
                self.bgL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"已获得收藏数 %@",allM.total] setColor:[UIColor colorWithHexString:@"#E6C14D"] setLengthString:allM.total beginSize:7];
            }
            for (NSDictionary *dic in allM.list) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count >= 48) {
                NoticeFriendAcdModel *locaM = [[NoticeFriendAcdModel alloc] init];
                locaM.localData = YES;
                [self.dataArr addObject:locaM];
            }
            [self.collectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)setDrawM:(NoticeDrawList *)drawM{
    _drawM = drawM;
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/3/%@/cracker",_drawM.drawId] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if (allM.total.intValue) {
                self.bgL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"已收到贴贴 %@",allM.total] setColor:[UIColor colorWithHexString:@"#E6C14D"] setLengthString:allM.total beginSize:7];
            }
            for (NSDictionary *dic in allM.list) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count >= 48) {
                NoticeFriendAcdModel *locaM = [[NoticeFriendAcdModel alloc] init];
                locaM.localData = YES;
                [self.dataArr addObject:locaM];
            }
            [self.collectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)setScDrawM:(NoticeDrawList *)scDrawM{
    _scDrawM = scDrawM;
    self.titleImageV.image = UIImageNamed(@"Image_pyshoucangy");
    self.titleL.text = [NoticeTools getLocalStrWith:@"emtion.sc"];
    self.bgL.text = [NoticeTools getLocalStrWith:@"xs.hasscs"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/3/%@/collection",_scDrawM.drawId] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if (allM.total.intValue) {
                self.bgL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"已获得收藏数 %@",allM.total] setColor:[UIColor colorWithHexString:@"#E6C14D"] setLengthString:allM.total beginSize:7];
            }
            for (NSDictionary *dic in allM.list) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count >= 48) {
                NoticeFriendAcdModel *locaM = [[NoticeFriendAcdModel alloc] init];
                locaM.localData = YES;
                [self.dataArr addObject:locaM];
            }
            [self.collectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeBingGanCollCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.peopleM = self.dataArr[indexPath.row];
    return merchentCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    
    NoticeFriendAcdModel *model = self.dataArr[indexPath.row];
    if (model.localData) {
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"xs.noshow"]];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
        [self removeFromSuperview];
        return;
    }
    ctl.isOther = YES;
    ctl.userId = model.user_id;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
    [self cancelClick];
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-100)/7,(DR_SCREEN_WIDTH-100)/7);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10,20,10,20);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (void)showTost{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.keyView.frame.size.height+20, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    }];
}

- (void)cancelClick{
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
