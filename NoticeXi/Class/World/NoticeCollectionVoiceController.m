//
//  NoticeCollectionVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2023/2/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeCollectionVoiceController.h"
#import "NoticeCollcetionVoiceCell.h"
#import "CYWWaterFallLayout.h"
#import "NoticeVoiceDetailController.h"
#import "UINavigationController+DoitAnimation.h"
#import "NoticeTextVoiceDetailController.h"
@interface NoticeCollectionVoiceController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NoticeCollectionVoiceListClickDelegate,NoticeVoiceClickMoreSuccess,NoticeAssestDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger choicemoreTag;
@property (nonatomic, assign) BOOL noData;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) CYWWaterFallLayout *layout;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UILabel *defaultL;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, assign) NSInteger oldSelectIndex;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) NoticeClickVoiceMore *clickMore;//心情点击更多工具
@property (nonatomic, assign) BOOL canReoadData;//可以刷新音频播放数据
@property (nonatomic, assign) NSInteger lastPlayerTag;
@end

@implementation NoticeCollectionVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    [self.view addSubview:self.collectionView];
    
    self.dataArr = [[NSMutableArray alloc] init];
    self.pageNo = 1;
    self.isDown = YES;
    self.isReplay = YES;
    self.oldSelectIndex = 6789;
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isDown = YES;
        weakSelf.pageNo = 1;
        if (!weakSelf.isSame) {
            [weakSelf getTopDate];
        }else{
            [weakSelf request];
        }
    }];
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isDown = NO;
        weakSelf.pageNo++;
        [weakSelf request];
        
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editVoiceNotice:) name:@"NOTICEREEDITVOICENotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVoiceTopSet:) name:@"SETTOPNOTICENTERION" object:nil];//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNolikeVoice:) name:@"NOLIKEVOICENotification" object:nil];//
    [self.collectionView.mj_header beginRefreshing];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow bringSubviewToFront:appdel.floatView];
}

- (void)getNolikeVoice:(NSNotification*)notification{

    if (self.dataArr.count) {
        for (NoticeVoiceListModel *voiceM in self.dataArr) {
            NSDictionary *nameDictionary = [notification userInfo];
            NSString *voiceId = nameDictionary[@"voiceId"];
            if ([voiceM.voice_id isEqualToString:voiceId]) {
                [self.dataArr removeObject:voiceM];
                [self.collectionView reloadData];
                break;
            }
        }
    }
}


- (void)getVoiceTopSet:(NSNotification*)notification{
    if (self.dataArr.count) {
        for (NoticeVoiceListModel *voiceM in self.dataArr) {
            if (voiceM.voice_id) {
                NSDictionary *nameDictionary = [notification userInfo];
                NSString *voiceId = nameDictionary[@"voiceId"];
                if ([voiceM.voice_id isEqualToString:voiceId]) {
                    voiceM.is_top = nameDictionary[@"isTop"];
                    voiceM.voiceIdentity = nameDictionary[@"voiceIdentity"];
                    [self.collectionView reloadData];
                    break;
                }
            }
        }
    }
}

- (void)editVoiceNotice:(NSNotification*)notification{
    NSDictionary *Dictionary = [notification userInfo];
    NSDictionary *voiceDic = Dictionary[@"data"];
    NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:voiceDic];
    if (model.voice_id && self.dataArr.count) {
    
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (int i = 0; i < self.dataArr.count; i++) {
                NoticeVoiceListModel *oldM = self.dataArr[i];
                if ([oldM.voice_id isEqualToString:model.voice_id]) {
                    
                    if (model.content_type.intValue == 2 && model.title) {
                        model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
                    }
                    
                    if (model.content_type.intValue == 1) {
                        if(model.topicName && model.topicName.length){//存在话题
                            model.textPbheight = GET_STRHEIGHT(model.topicName, 15, self.layout.itemWidth-16);
                        }else{
                            model.textPbheight = 0;
                        }
                   
                    }else{
                        NSString *str = model.voice_content;
                        if(model.topicName && model.topicName.length){//存在话题
                            str = [NSString stringWithFormat:@"%@%@",model.topicName,model.voice_content];
                        }
                        
                        if(str.length > 30){
                            model.textPbheight = GET_STRHEIGHT([str substringToIndex:30], 15, self.layout.itemWidth-16);
                        }else{
                            model.textPbheight = GET_STRHEIGHT(str, 15, self.layout.itemWidth-16);
                        }
                    }
                    
                    if(model.textPbheight > 0){
                        model.textPbheight+=8;
                    }
                    
                    if (model.img_list.count) {
                        if (!model.scale.floatValue) {
                            model.scale = @"1";
                        }
                        if (model.scale.floatValue > 2) {//高度是宽度俩倍，那么最高就是俩倍数值
                            model.scale = @"2";
                        }
                        
                        if (model.scale.floatValue < 0.5) {//如果高度是宽度的一半，那么最小去一半数值
                            model.scale = @"0.5";
                        }
                        model.height = self.layout.itemWidth*model.scale.floatValue+32+model.textPbheight;
                    }else{
                        model.height = self.layout.itemWidth+model.textPbheight+32;
                    }
                    if (oldM.isTop) {
                        model.topAt = @"4567890";
                        model.isTop = YES;
                    }
                    [self.dataArr replaceObjectAtIndex:i withObject:model];
                    [self.collectionView reloadData];
                    break;
                }
            }
        }
    }
}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        CYWWaterFallLayout *flowLayout = [[CYWWaterFallLayout alloc] init];
        flowLayout.columnCount = 2;
        flowLayout.itemWidth = (DR_SCREEN_WIDTH-40)/2;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout = flowLayout;
        // 创建collectionView
        CGRect frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-50-15-28);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.layout];
        _collectionView.backgroundColor = self.view.backgroundColor;
    
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;          // 隐藏垂直方向滚动条
        // 注册cell
        [_collectionView registerClass:[NoticeCollcetionVoiceCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.dataArr.count) {
        return;
    }
    if (indexPath.row > self.dataArr.count-1) {
        return;
    }

    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    if (model.content_type.intValue == 2) {
        NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
        ctl.voiceM = model;
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    
    NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
    ctl.voiceM = model;
    [self.navigationController pushViewController:ctl animated:YES];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeCollcetionVoiceCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.isGround =  self.isSame?NO:YES;
    merchentCell.index = indexPath.row;
    merchentCell.delegate = self;
    if (self.dataArr.count-1 >= indexPath.row) {
        merchentCell.voiceM = self.dataArr.count? self.dataArr[indexPath.row] : nil;
        merchentCell.playImageV.image =UIImageNamed(!merchentCell.voiceM.isPlaying ? @"img_voicebowen" : @"img_voicebowenplay");
    }
    return merchentCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count >= 10) {
        if (indexPath.row == self.dataArr.count-6 && self.canAutoLoad && !self.noData) {
            self.pageNo++;
            self.isDown = NO;
            [self request];
        }
    }
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)getTopDate{
    if(self.isRequesting){
        return;
    }
    if (self.isSame) {
        [self request];
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.isRequesting = YES;
    self.canAutoLoad = NO;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices/top" Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (self.isDown == YES) {
            [self.dataArr removeAllObjects];
            self.isDown = NO;
        }
        if (success) {
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                model.topAt = @"4567890";
                model.isTop = YES;
                
                if (model.content_type.intValue == 2 && model.title) {
                    model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
                }
                
                if (model.content_type.intValue == 1) {
                    if(model.topicName && model.topicName.length){//存在话题
                        model.textPbheight = GET_STRHEIGHT(model.topicName, 15, weakSelf.layout.itemWidth-16);
                    }else{
                        model.textPbheight = 0;
                    }
               
                }else{
                    NSString *str = model.voice_content;
                    if(model.topicName && model.topicName.length){//存在话题
                        str = [NSString stringWithFormat:@"%@%@",model.topicName,model.voice_content];
                    }
                    
                    if(str.length > 30){
                        model.textPbheight = GET_STRHEIGHT([str substringToIndex:30], 15, weakSelf.layout.itemWidth-16);
                    }else{
                        model.textPbheight = GET_STRHEIGHT(str, 15, weakSelf.layout.itemWidth-16);
                    }
                }
                
                if(model.textPbheight > 0){
                    model.textPbheight+=8;
                }
                
                if (model.img_list.count) {
                    if (!model.scale.floatValue) {
                        model.scale = @"1";
                    }
                    if (model.scale.floatValue > 2) {//高度是宽度俩倍，那么最高就是俩倍数值
                        model.scale = @"2";
                    }
                    
                    if (model.scale.floatValue < 0.5) {//如果高度是宽度的一半，那么最小去一半数值
                        model.scale = @"0.5";
                    }
                    model.height = weakSelf.layout.itemWidth*model.scale.floatValue+32+model.textPbheight;
                }else{
                    model.height = weakSelf.layout.itemWidth+model.textPbheight+32;
                }
                
                [self.dataArr addObject:model];
            }
        }
        if (!self.dataArr.count) {
            self.isDown = YES;
        }
        
        [self request];
    } fail:^(NSError * _Nullable error) {
        if (self.isDown == YES) {
            [self.dataArr removeAllObjects];
            self.isDown = NO;
        }
        if (!self.dataArr.count) {
            self.isDown = YES;
        }
        [self request];
    }];
}


- (void)request{
   
    NSString *url = nil;
    if (self.isDown) {
        url =self.isSame?@"voice/getMutual?pageNo=1": @"voices/list?pageNo=1";
    }else{
        if (!self.canAutoLoad && self.pageNo != 1) {//接口正在加载中，无需重复请求
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            return;
        }
        
        url = self.isSame? [NSString stringWithFormat:@"voice/getMutual?pageNo=%ld",self.pageNo] : [NSString stringWithFormat:@"voices/list?pageNo=%ld",self.pageNo];
    }
    __weak typeof(self) weakSelf = self;
    self.canAutoLoad = NO;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.isRequesting = NO;
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                if (model.content_type.intValue == 2 && model.title) {
                    model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
                }
                
                if (model.content_type.intValue == 1) {
                    if(model.topicName && model.topicName.length){//存在话题
                        model.textPbheight = GET_STRHEIGHT(model.topicName, 15, weakSelf.layout.itemWidth-16);
                    }else{
                        model.textPbheight = 0;
                    }
               
                }else{
                    NSString *str = model.voice_content;
                    if(model.topicName && model.topicName.length){//存在话题
                        str = [NSString stringWithFormat:@"%@%@",model.topicName,model.voice_content];
                    }
                    
                    if(str.length > 30){
                        model.textPbheight = GET_STRHEIGHT([str substringToIndex:30], 15, weakSelf.layout.itemWidth-16);
                    }else{
                        model.textPbheight = GET_STRHEIGHT(str, 15, weakSelf.layout.itemWidth-16);
                    }
                }
                
                if(model.textPbheight > 0){
                    model.textPbheight+=8;
                }
                
                if (model.img_list.count) {
                    if (!model.scale.floatValue) {
                        model.scale = @"1";
                    }
                    if (model.scale.floatValue > 2) {//高度是宽度俩倍，那么最高就是俩倍数值
                        model.scale = @"2";
                    }
                    
                    if (model.scale.floatValue < 0.5) {//如果高度是宽度的一半，那么最小去一半数值
                        model.scale = @"0.5";
                    }
                    model.height = weakSelf.layout.itemWidth*model.scale.floatValue+32+model.textPbheight;
                }else{
                    model.height = weakSelf.layout.itemWidth+model.textPbheight+32;
                }
                
                BOOL isHasSame = NO;
                for (NoticeVoiceModel *hasM in weakSelf.dataArr) {
                    if ([model.voice_id isEqualToString:hasM.voice_id]) {
                        isHasSame = YES;
                        break;
                    }
                }
                if (!isHasSame) {
                    [weakSelf.dataArr addObject:model];
                }
                hasData = YES;
            }
            if (!weakSelf.dataArr.count && weakSelf.isSame) {
                [weakSelf.collectionView addSubview:weakSelf.defaultL];
            }else{
                [_defaultL removeFromSuperview];
            }
            weakSelf.noData = !hasData;
            weakSelf.layout.dataList = weakSelf.dataArr;
            //[self.collectionView reloadData];
            [UIView performWithoutAnimation:^{
               //刷新界面
                [weakSelf.collectionView reloadData];
            }];
        }
        weakSelf.isRequesting = NO;
        weakSelf.canAutoLoad = YES;
    } fail:^(NSError *error) {
        self.canAutoLoad = YES;
        self.isRequesting = NO;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}


- (void)clickStopOrPlayAssest:(BOOL)pause playing:(BOOL)playing{

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.dataArr.count && (appdel.floatView.currentTag <= self.dataArr.count-1) && appdel.floatView.currentTag == self.oldSelectIndex) {
        NoticeVoiceListModel *model = self.dataArr[appdel.floatView.currentTag];
        if (model.content_type.intValue != 1) {
            return;
        }
        if (playing) {
            self.isPasue = !pause;
            model.isPlaying = !pause;
            [self.collectionView reloadData];
        }
    }
}

//播放暂停
- (void)startPlayAndStop:(NSInteger)tag{
   
    if (tag > self.dataArr.count-1) {
        return;
    }
    
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
        NoticeVoiceListModel *oldM = self.oldModel;
        oldM.nowTime = oldM.voice_len;
        oldM.nowPro = 0;
        oldM.isPlaying = NO;
        [self.collectionView reloadData];
    }else{
        DRLog(@"点击的是当前视图");
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
        self.canReoadData = YES;
        appdel.floatView.voiceArr = self.dataArr.mutableCopy;
        appdel.floatView.currentTag = tag;
        appdel.floatView.currentModel = model;
        self.isReplay = NO;
        self.isPasue = NO;
        appdel.floatView.isPasue = self.isPasue;
        appdel.floatView.isReplay = YES;
        appdel.floatView.isNoRefresh = YES;
        [appdel.floatView playClick];
   
        [self addPlayNum:model];
    }else{
        [appdel.floatView playClick];
    }
    
    __weak typeof(self) weakSelf = self;
    appdel.floatView.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        weakSelf.lastPlayerTag = tag;
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            if (self.canReoadData) {
                model.isPlaying = YES;
                [weakSelf.collectionView reloadData];
            }
        }
    };
    
    appdel.floatView.playComplete = ^{
        weakSelf.canReoadData = NO;
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowTime = model.voice_len;
        [weakSelf.collectionView reloadData];
    };
    
    appdel.floatView.playNext = ^{
        weakSelf.canReoadData = NO;
    };
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    appdel.floatView.playingBlock = ^(CGFloat currentTime) {
        NoticeCollcetionVoiceCell *cell = (NoticeCollcetionVoiceCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
        if (weakSelf.canReoadData) {
            model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
            cell.voiceLenL.text = [NSString stringWithFormat:@"%@s    ",model.nowTime.integerValue?model.nowTime:model.voice_len];
        }else{
            cell.voiceLenL.text = [NSString stringWithFormat:@"%@s    ",model.voice_len];
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        }
    };
}

- (void)reStopPlay{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
}
//屏蔽成功回调
- (void)otherPinbSuccess{
  
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self reStopPlay];
    if (self.dataArr.count-1 >= self.choicemoreTag) {
        [self.dataArr removeObjectAtIndex:self.choicemoreTag];
        [self.collectionView reloadData];
    }
    [self.collectionView reloadData];
}

//点击更多删除成功回调
- (void)moreClickDeleteSucess{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self reStopPlay];
    if (!self.dataArr.count) {
        return;
    }
    if (self.dataArr.count-1 >= self.choicemoreTag) {
        [self.dataArr removeObjectAtIndex:self.choicemoreTag];
        [self.collectionView reloadData];
    }
}

//点击更多
- (void)hasClickMoreWith:(NSInteger)tag{
    if (tag > self.dataArr.count-1) {
        return;
    }
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.choicemoreTag = tag;
    if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是别人
        return;
    }
    [self.clickMore voiceClickMoreWith:model];
}

- (NoticeClickVoiceMore *)clickMore{
    if (!_clickMore) {
        _clickMore = [[NoticeClickVoiceMore alloc] init];
        _clickMore.delegate = self;
    }
    return _clickMore;
}

- (UILabel *)defaultL{
    if (!_defaultL) {
        _defaultL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DR_SCREEN_WIDTH, self.collectionView.frame.size.height-225)];
        _defaultL.textAlignment = NSTextAlignmentCenter;
        _defaultL.font = FOURTHTEENTEXTFONTSIZE;
        _defaultL.text = [NoticeTools chinese:@"啊咧 想欣赏的人怎么还没出现" english:@"No following yet" japan:@"まだフォローしていません"];
        _defaultL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
    return _defaultL;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([NoticeSaveModel getUserInfo]){
        appdel.floatView.assestDelegate = self;
    }else{
        appdel.floatView.hidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.dataArr.count && appdel.floatView.isPlaying && appdel.floatView.currentModel) {
        self.canReoadData = NO;
        self.isReplay = YES;
        self.oldSelectIndex = 678;
        appdel.floatView.currentModel.isPlaying = NO;
        appdel.floatView.currentModel.nowPro = 0;
        appdel.floatView.currentModel.nowTime = @"0";
        [self.collectionView reloadData];
    }
}


- (void)addPlayNum:(NoticeVoiceListModel *)model{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:model.voice_id forKey:@"voiceId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices/addReading" Accept:@"application/vnd.shengxi.v5.3.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}
@end
