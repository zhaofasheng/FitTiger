//
//  BaseTableViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeClockPyModel.h"
@interface BaseTableViewController ()<NoticeReceveMessageSendMessageDelegate>
@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isReplay = YES;
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.effect = appdel.effect>0?appdel.effect: 0.1;
    
    self.view.backgroundColor =  [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView = [[UITableView alloc] init];

    self.tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0,0,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 65;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.tableView];
   
    //进入后台停止播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVoiceTopSet:) name:@"SETTOPNOTICENTERION" object:nil];//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getcancelCollection:) name:@"cancelCollectionNotification" object:nil];//NOLIKEVOICENotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCollection:) name:@"collectionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"RefreshTableForVoiceContent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin) name:@"NOTICECHANGESKINNOTICIONHS" object:nil];
    //编辑心情回传
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editVoiceNotice:) name:@"NOTICEREEDITVOICENotification" object:nil];
    [self changeSkin];
    
    self.lastPlayerTag = 0;
    self.isAutoPlayer = [NoticeTools isAutoPlayer];
    
    self.floatView = appdel.floatView;
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow bringSubviewToFront:appdel.floatView];
    
    
    appdel.socketManager.delegate = self;
}

- (void)didReceiveComment:(NSDictionary *)commentVoiceDic{
    if (self.noNeedReceComment) {
        return;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEREEDITVOICECOMMENT" object:self userInfo:@{@"data":commentVoiceDic}];

}

- (void)didReceiveMemoryWarning{
    DRLog(@"内存泄漏");
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [self.view addSubview:_navBarView];
        _navBarView.hidden = YES;
        _navBarView.titleL.text = self.navigationItem.title;
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}

- (NoticeNoNetWorkView *)noNetWorkView{
    if (!_noNetWorkView) {
        _noNetWorkView = [[NoticeNoNetWorkView alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+20, DR_SCREEN_WIDTH-40, 60)];
    }
    return _noNetWorkView;
}

- (void)backClick{
 
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNeedBackGroundView:(BOOL)needBackGroundView{
    _needBackGroundView = needBackGroundView;
    [self changeSkin];
}

- (void)changeSkin{
    if (!self.needBackGroundView) {
        self.tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
        //self.backGroundImageView.hidden = YES;
        return;
    }

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.backImg) {
        self.tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    }else{
        self.tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
    }

    [self.tableView reloadData];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.tableView.backgroundColor = self.view.backgroundColor;
}

- (void)refreshTableView{
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.stopAutoPlayerForDissapear = NO;
    if (self.needHideNavBar) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    if (self.needBackGroundView || self.needHideNavBar) {

        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
            //添加背景色
            appperance.backgroundEffect = nil;
            appperance.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];//设置导航条颜色
            appperance.shadowImage = [[UIImage alloc]init];
            appperance.shadowColor = [[UIColor greenColor] colorWithAlphaComponent:0];
            [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"],NSFontAttributeName:XGTwentyBoldFontSize}];
            UINavigationBar *navgationBar = self.navigationController.navigationBar;
            navgationBar.standardAppearance = appperance;
            navgationBar.scrollEdgeAppearance = appperance;
            //透明
            self.navigationController.navigationBar.translucent = YES;
        }else{
        
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];//设置阴影图片
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            //透明
            self.navigationController.navigationBar.translucent = YES;
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.stopAutoPlayerForDissapear = YES;
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if (userM.spec_bg_type.intValue == 1) {
        [self.backGroundImageView.svagPlayer pauseAnimation];
    }
    
    [_noNetWorkView dissMiss];
    
    if (self.dataArr.count && self.floatView.isPlaying) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            self.canReoadData = NO;
            self.isReplay = YES;
            self.oldSelectIndex = 678;
            self.floatView.currentModel.isPlaying = NO;
            self.floatView.currentModel.nowPro = 0;
            self.floatView.currentModel.nowTime = self.floatView.currentModel.voice_len;
        }
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if (userM.spec_bg_type.intValue == 1) {
        [self.backGroundImageView.svagPlayer startAnimation];
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([NoticeSaveModel getUserInfo]){
        appdel.floatView.assestDelegate = self;
       
    }else{
        appdel.floatView.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.noNav) {
        return;
    }
    if (self.needHideNavBar) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    if (self.needBackGroundView || self.needHideNavBar) {

        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
            //添加背景色
            appperance.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];//设置导航条颜色
            appperance.shadowImage = [[UIImage alloc]init];
            appperance.shadowColor = nil;
            [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#41434D"],NSFontAttributeName:XGTwentyBoldFontSize}];
            UINavigationBar *navgationBar = self.navigationController.navigationBar;;
            navgationBar.standardAppearance = appperance;
            navgationBar.scrollEdgeAppearance = appperance;
            //不透明
            self.navigationController.navigationBar.translucent = NO;
            
        }else{
            self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F7F8FC"];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];//设置阴影图片
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.translucent = NO;
        }
    }
}

- (void)getCollection:(NSNotification*)notification{

    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.is_collected = @"1";
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }
}

- (void)editVoiceNotice:(NSNotification*)notification{
    NSDictionary *Dictionary = [notification userInfo];
    NSDictionary *voiceDic = Dictionary[@"data"];
    NoticeVoiceListModel *voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:voiceDic];
    if (voiceM.voice_id && self.dataArr.count) {
    
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (int i = 0; i < self.dataArr.count; i++) {
                NoticeVoiceListModel *oldM = self.dataArr[i];
                if ([oldM.voice_id isEqualToString:voiceM.voice_id]) {
                    [self.dataArr removeObjectAtIndex:i];
                    [self.dataArr insertObject:voiceM atIndex:i];
                    [self.tableView reloadData];
                    break;
                }
            }
        }
    }
}

- (void)getcancelCollection:(NSNotification*)notification{
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.is_collected = @"0";
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }
}

- (void)getVoiceTopSet:(NSNotification*)notification{
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.is_top = nameDictionary[@"isTop"];
                        voiceM.voiceIdentity = nameDictionary[@"voiceIdentity"];
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }
}

- (void)stopPlayingNotice{
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    [self.tableView reloadData];
}

- (void)setNeedPasue:(BOOL)needPasue{
    if (needPasue) {
        [self.audioPlayer stopPlaying];
    }
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

- (NoticeClickVoiceMore *)clickMore{
    if (!_clickMore) {
        _clickMore = [[NoticeClickVoiceMore alloc] init];
        _clickMore.delegate = self;
    }
    return _clickMore;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastContentOffset = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y < self.lastContentOffset)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewScrollViewContentSet: isUp:)]) {
            [self.delegate tableViewScrollViewContentSet:scrollView.contentOffset.y isUp:NO];
        }
    } else if (scrollView.contentOffset.y > self.lastContentOffset)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewScrollViewContentSet: isUp:)]) {
            [self.delegate tableViewScrollViewContentSet:scrollView.contentOffset.y isUp:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < self.lastContentOffset)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewScrollViewContentSet: isUp:)]) {
            [self.delegate tableViewScrollViewContentSet:scrollView.contentOffset.y isUp:NO];
        }
    } else if (scrollView.contentOffset.y > self.lastContentOffset)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewScrollViewContentSet: isUp:)]) {
            [self.delegate tableViewScrollViewContentSet:scrollView.contentOffset.y isUp:YES];
        }
    }
}

- (void)backToTopForAssest{
    if (self.dataArr.count) {
        BOOL isPalying = NO;
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (int i = 0; i < self.dataArr.count; i++) {
                NoticeVoiceListModel *voiceM = self.dataArr[i];
                if (voiceM.isPlaying) {
                    if (self.isSection) {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }
                    isPalying = YES;
                    break;
                }
            }
            if (!isPalying) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }else if([self.dataArr[0] isKindOfClass:[NoticeClockPyModel class]]){
            for (int i = 0; i < self.dataArr.count; i++) {
                NoticeClockPyModel *voiceM = self.dataArr[i];
                if (voiceM.isPlaying) {
                    if (self.isSection) {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }
                    isPalying = YES;
                    break;
                }
            }
            if (!isPalying) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }
}


- (void)iconTapAssest{
    
}

- (void)clickStopOrPlayAssest:(BOOL)pause playing:(BOOL)playing{
    
}

- (void)reSetPlayerData{
    
    self.lastPlayerTag = 0;
    self.isrefreshNewToPlayer = YES;
    self.canReoadData = NO;
    if (self.dataArr.count) {
        self.isReplay = YES;
       // [self.audioPlayer stopPlaying];
        self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    }
    [self.tableView reloadData];
}

- (void)reStopPlay{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
}

- (void)addPlayNum:(NoticeVoiceListModel *)model{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:model.voice_id forKey:@"voiceId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices/addReading" Accept:@"application/vnd.shengxi.v5.3.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            model.reading_num = [NSString stringWithFormat:@"%d",model.reading_num.intValue+1];
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (NoticeNoDataView *)queshenView{
    if (!_queshenView) {
        _queshenView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height)];
        _queshenView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    }
    return _queshenView;
}

- (UILabel *)defaultL{
    if (!_defaultL) {
        _defaultL = [[UILabel alloc] initWithFrame:self.tableView.bounds];
        _defaultL.textAlignment = NSTextAlignmentCenter;
        _defaultL.font = FOURTHTEENTEXTFONTSIZE;
        _defaultL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
    return _defaultL;
}
@end
