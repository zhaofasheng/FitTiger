//
//  NoticeBgmView.m
//  NoticeXi
//
//  Created by li lei on 2021/3/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBgmView.h"

@implementation NoticeBgmView
{
    BOOL _isMoreView;
    UIButton *oldBtn;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#B8BECC"] colorWithAlphaComponent:0.0];
     
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, frame.size.height-50)];
        [self addSubview:headerView];
        self.headerV = headerView;
        // 绘制圆角 需设置的圆角 使用"|"来组合
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft |
        UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        // 设置大小
        maskLayer.frame = self.bounds;
        // 设置图形样子
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        CGFloat width = GET_STRWIDTH(@"推荐的", 14, 40);
        CGFloat bwidth = GET_STRWIDTH([NoticeTools getLocalStrWith:@"recoder.custume"], 14, 40);
        NSArray *titleArr = @[@"BGM",[NoticeTools getLocalStrWith:@"recoder.custume"]];
        for (int i = 0; i < 1; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+(width+20)*i, 0,i==1?bwidth: width, 40)];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            if (i == 0) {
                oldBtn = btn;
                [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            }
            btn.tag = i;
            [self addSubview:btn];
        }
        [self addSubview:self.collectionView];
        self.dataArr = [NSMutableArray new];
    }
    return self;
}

- (NoticeAddCustumeMusicView *)custumeMusicView{
    if (!_custumeMusicView) {
        _custumeMusicView = [[NoticeAddCustumeMusicView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-305-95-15+50)];
        _custumeMusicView.backGroundImageView.hidden = YES;
        _custumeMusicView.isFromRecodering = YES;
        _custumeMusicView.navView.hidden = YES;
        _custumeMusicView.mbsView.hidden = YES;
        _custumeMusicView.tableView.backgroundColor = _custumeMusicView.backgroundColor;
        _custumeMusicView.tableView.frame = CGRectMake(0,CGRectGetMaxY(_custumeMusicView.erroL.frame)+10,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-CGRectGetMaxY(_custumeMusicView.erroL.frame)-10-BOTTOM_HEIGHT-305-95-15+50);
        __weak typeof(self) weakSelf = self;
        _custumeMusicView.useMusicBlock = ^(NoticeCustumMusiceModel * _Nonnull model) {
          
            if (weakSelf.stopMusicTapBlock) {
                weakSelf.stopMusicTapBlock(YES);
            }
            weakSelf.collectionView.hidden = YES;
            weakSelf.playCustumeView.musicModel = model;
            weakSelf.playCustumeView.hidden = NO;
        };
        _custumeMusicView.requestMusicBlock = ^(BOOL add) {
            if (weakSelf.playCustumeView.musicModel && weakSelf.custumeMusicView.dataArr.count) {
                for (NoticeCustumMusiceModel *model in weakSelf.custumeMusicView.dataArr) {
                    if ([model.song_id isEqualToString:weakSelf.playCustumeView.musicModel.song_id]) {
                        model.status = weakSelf.playCustumeView.musicModel.status;
                        [weakSelf.custumeMusicView.tableView reloadData];
                        break;
                    }
                }
            }
        };
    }
    return _custumeMusicView;
}

- (void)playClick{
    [self.custumeMusicView clickWith:self.playCustumeView.musicModel];
}

- (NoticePlayCustumePlay *)playCustumeView{
    if (!_playCustumeView) {
        _playCustumeView = [[NoticePlayCustumePlay alloc] initWithFrame:CGRectMake(0, 40, DR_SCREEN_WIDTH, self.frame.size.height-40)];
        [self addSubview:_playCustumeView];
        _playCustumeView.hidden = YES;
        [_playCustumeView.playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
        [_playCustumeView.musicBtn addTarget:self action:@selector(addMusicClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playCustumeView;
}

- (void)addMusicClick{
    __weak typeof(self) weakSelf = self;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.closcontent"] cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf surecloseclick];
            if (weakSelf.stopRecoderIngBlock) {
                weakSelf.stopRecoderIngBlock(YES);
            }
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"recoder.sureclose"]]];
    [sheet show];
}

- (void)surecloseclick{
    if (_playCustumeView.hidden == NO) {
        self.custumeMusicView.hidden = YES;
        [self.custumeMusicView refresh];
        _playCustumeView.hidden = YES;
        self.collectionView.hidden = NO;
        self.playCustumeView.hidden = YES;
    }
}

- (void)setNeedAutoRecoder:(BOOL)needAutoRecoder{
    
    _needAutoRecoder = needAutoRecoder;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"bgms" Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeTextZJMusicModel *model = [NoticeTextZJMusicModel mj_objectWithKeyValues:dic];
                model.hasListen =  [NoticeComTools getHasbmgMp4:model.bgmM.bgmId];
                [self.dataArr addObject:model];
            }
        }
        if (self.dataArr.count > 3) {
            [self.dataArr removeObjectAtIndex:self.dataArr.count-2];
            
            NoticeTextZJMusicModel *lastM = self.dataArr[self.dataArr.count-1];
         
            lastM.imgName = [NoticeTools getLocalImageNameCN:@"Image_bgmw"];
            NoticeTextZJMusicModel *cuM = [[NoticeTextZJMusicModel alloc] init];
            cuM.imgName = @"Image_bgmzdy";
            cuM.choiceCustume = YES;
            [self.dataArr addObject:cuM];
        }
        [self.collectionView reloadData];
        
        if (self.needAutoRecoder) {//是否需要自动播放bgm
            if (self.dataArr.count) {
                //随机播放一个
                NSInteger tag = arc4random()%(self.dataArr.count-2);
                NoticeTextZJMusicModel *choiceM = self.dataArr[tag];
                
                choiceM.isSelect = YES;
                if (!choiceM.hasListen) {
                    [NoticeComTools setbgmMp4:choiceM.bgmM.bgmId];
                    choiceM.hasListen = YES;
                }
                
                [self.collectionView reloadData];
                if (self.musicTapBlock) {
                    self.musicTapBlock(choiceM.bgmM.audio_url);
                }
                if (self.musicCurrentIDBlock) {
                    self.musicCurrentIDBlock(choiceM);
                }
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeRecoderMusicCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.model = self.dataArr[indexPath.row];
    return merchentCell;
}

- (void)noBgmChoice{
    for (NoticeTextZJMusicModel *model in self.dataArr) {
        model.isSelect = NO;
    }
    [self.collectionView reloadData];
}

- (void)refresStop:(NoticeTextZJMusicModel *)currentM{
    for (NoticeTextZJMusicModel *model in self.dataArr) {
        model.isSelect = NO;
    }
    [self.collectionView reloadData];
    if (self.stopMusicTapBlock) {
        self.stopMusicTapBlock(YES);
    }
    if (self.musicCurrentIDBlock) {
        self.musicCurrentIDBlock(currentM);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    NoticeTextZJMusicModel *currentM = self.dataArr[indexPath.row];
    if (currentM.bgmM.audio_url.length < 10) {//没有bgm的
        if (indexPath.row == 5) {
            if (self.choiceZdyBlock && currentM.choiceCustume) {
                self.choiceZdyBlock(currentM);
            }
        }else{
        
            [self refresStop:currentM];
        }
        return;
    }
    if (currentM.isSelect) {//如果点击的是已选择的，则停止播放
        for (NoticeTextZJMusicModel *model in self.dataArr) {
            model.isSelect = NO;
        }
        [self.collectionView reloadData];
        if (self.stopMusicTapBlock) {
            self.stopMusicTapBlock(YES);
        }
        return;
    }
    for (NoticeTextZJMusicModel *model in self.dataArr) {
        model.isSelect = NO;
    }
    NoticeTextZJMusicModel *choiceM = self.dataArr[indexPath.row];
    choiceM.noNeedRic = NO;
    choiceM.isSelect = YES;
    if (!choiceM.hasListen) {
        choiceM.hasListen = YES;
        [NoticeComTools setbgmMp4:choiceM.bgmM.bgmId];
    }
    
    [self.collectionView reloadData];
    if (self.musicTapBlock) {
        self.musicTapBlock(choiceM.bgmM.audio_url);
    }
    if (self.musicCurrentIDBlock) {
        self.musicCurrentIDBlock(choiceM);
    }
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(45,45);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5,(DR_SCREEN_WIDTH-45*6)/7, 10,(DR_SCREEN_WIDTH-45*6)/7);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (DR_SCREEN_WIDTH-45*6)/7;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,50, DR_SCREEN_WIDTH,self.frame.size.height-50);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;          // 隐藏垂直方向滚动条
        _collectionView.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:0];
        // 注册cell
        [_collectionView registerClass:[NoticeRecoderMusicCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}

@end
