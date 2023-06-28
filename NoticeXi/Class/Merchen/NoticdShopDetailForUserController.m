//
//  NoticdShopDetailForUserController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/11.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticdShopDetailForUserController.h"
#import "NoticeByOfOrderModel.h"
#import "NoticerUserShopDetailHeaderView.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"
#import "NoticeXi-Swift.h"
#import "NoticeJieYouGoodsComController.h"
#import "NoticeJieYouGoodsController.h"
@interface NoticdShopDetailForUserController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NoticeMyShopModel *timeModel;
@property (nonatomic, strong) NoticeMyShopModel *shopDetailM;
@property (nonatomic, strong) NoticeGoodsModel *choiceGoods;
@property (nonatomic, strong) NoticeByOfOrderModel *orderM;

@property (nonatomic, strong) NoticerUserShopDetailHeaderView *shopHeaderView;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
@property (nonatomic, strong) NoticeJieYouGoodsController *goodsVC;
@property (nonatomic, strong) NoticeJieYouGoodsComController *comVC;
@property (nonatomic, assign) BOOL isBuying;
@property (nonatomic, strong) NSString *roomId;
@end

@implementation NoticdShopDetailForUserController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titles = @[@"商品",@"评价"];
    self.shopHeaderView = [[NoticerUserShopDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 220)];

    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,GET_STRWIDTH(@"商品的", 18, 50)*2+40,50)];
    self.categoryView.titles = self.titles;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"#25262E"];
    self.categoryView.titleColor = [UIColor colorWithHexString:@"#8A8F99"];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleFont = SIXTEENTEXTFONTSIZE;
    self.categoryView.titleSelectedFont = XGEightBoldFontSize;
    
    self.categoryView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.mainTableView.gestureDelegate = self;
    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
        _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:self.pagerView];
    
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
    [self.sectionView addSubview:_categoryView];
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.lineStyle = JXCategoryIndicatorLineStyle_LengthenOffset;
    lineView.lineScrollOffsetX = 2;
    lineView.indicatorHeight = 2;
    lineView.indicatorColor = [UIColor colorWithHexString:@"#25262E"];
    lineView.indicatorWidth = GET_STRWIDTH(@"商品", 18, 50);
    lineView.componentPosition = JXCategoryComponentPosition_Bottom;
    self.categoryView.indicators = @[lineView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasKillApp) name:@"APPWASKILLED" object:nil];
    [self getShopRequest];
    self.tableView.hidden = YES;
    [self getTime];
    //收到语音通话请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noAccepectOrder) name:@"SHOPNOACCEPECT" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overFinish) name:@"SHOPFINISHEDHOUTAI" object:nil];//后台告知结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overFinish) name:@"SHOPHASJUBAOED" object:nil];//举报结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overFinish) name:@"SHOPFINISHED" object:nil];//买家结束
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopRequest) name:@"REFRESHMYWALLECT" object:nil];
}

- (void)getTime{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"adminConfig/1" Accept:@"application/vnd.shengxi.v5.4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
       
        if (success) {
            self.timeModel = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
        }
    } fail:^(NSError * _Nullable error) {
     
    }];
}

- (void)hasKillApp{
    [self cancelOrder];
}

//取消订单
- (void)cancelOrder{
    if(self.choiceGoods.type.intValue == 1){
        if(self.isBuying && self.orderM.orderId){
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"2" forKey:@"orderType"];
            [parm setObject:self.orderM.orderId forKey:@"orderId"];
            [[DRNetWorking shareInstance] requestWithPatchPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    self.isBuying = NO;
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
        }
    }else if (self.choiceGoods.type.intValue == 2){
        if(self.isBuying && self.orderM.room_id){
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"2" forKey:@"orderType"];
            [parm setObject:self.orderM.room_id forKey:@"roomId"];
            [[DRNetWorking shareInstance] requestWithPatchPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    self.isBuying = NO;
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
        }
    }
}

- (void)getShopRequest{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopInfo/%@?type=2",self.shopModel.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.shopDetailM = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
            self.shopHeaderView.shopModel = self.shopDetailM.myShopM;
            self.goodsVC.shopDetailModel = self.shopDetailM;
            self.shopHeaderView.labelArr = self.shopDetailM.labelArr;
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [self showToastWithText:error.debugDescription];
    }];
}

- (void)overFinish{
    DRLog(@"刷新店铺鲸币数据");
    [self getShopRequest];
}

- (void)chongzhiView{
    NoticeChongZhiTosatView *payV = [[NoticeChongZhiTosatView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    [payV showView];
}

- (void)buyTextChat:(NoticeGoodsModel *)goodM{
    __weak typeof(self) weakSelf = self;
    [self.shopHeaderView stopPlay];
    self.choiceGoods = goodM;
    
    NoticeShopXiaDanTostaView *sureView = [[NoticeShopXiaDanTostaView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    sureView.titleL.text = @"确定下单【文字聊天】？";
    sureView.titleL.frame = CGRectMake(0, 20, 280, 25);
    sureView.contentL.frame = CGRectMake(48, 55, 280-48, 108);
    sureView.contentL.text = [NSString stringWithFormat:@"·聊天每次限时%@分钟\n·聊天双方都是匿名的\n·聊天记录不会保留\n·此类型不支持语音通话",goodM.duration];
    
    sureView.sureXdBlock = ^(NSInteger index) {
        [self showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:weakSelf.choiceGoods.goodId forKey:@"goodsId"];
        [parm setObject:weakSelf.shopModel.shopId forKey:@"shopId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if(success){
                weakSelf.orderM = [NoticeByOfOrderModel mj_objectWithKeyValues:dict[@"data"]];
                weakSelf.isBuying = YES;
                [NoticeQiaojjieTools showWithJieDanTitle:weakSelf.orderM.user_nick_name orderId:weakSelf.orderM.orderId time:weakSelf.timeModel.get_order_time creatTime:weakSelf.orderM.created_at clickBlcok:^(NSInteger tag) {
                    [weakSelf cancelOrder];
                }];
            }else{
                NoticeOneToOne *allM = [NoticeOneToOne mj_objectWithKeyValues:dict];
                if(allM.code.intValue == 288){//用户余额不足
                    [NoticeQiaojjieTools showWithTitle:@"你的鲸币余额不足，需要充值才能继续下单噢" msg:@"" button1:@"再想想" button2:@"充值" clickBlcok:^(NSInteger tag) {
                        [weakSelf chongzhiView];
                    }];
                }else{
                    [NoticeQiaojjieTools showWithTitle:allM.msg];
                }
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
            [self showToastWithText:error.description];
        }];
    };
    [sureView showView];
}

//通话无响应
- (void)noAccepectOrder{
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"订单已超时失效，请尝试其它店铺" message:nil cancleBtn:@"知道了"];
    [alerView showXLAlertView];
    if(!self.orderM.room_id){
        return;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.orderM.room_id forKey:@"roomId"];
    [parm setObject:@"4" forKey:@"orderType"];
    [[DRNetWorking shareInstance] requestWithPatchPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            DRLog(@"商家无响应");
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)stopPlay{
    [self.shopHeaderView stopPlay];
}

- (void)hasMicBuyVoice:(NoticeGoodsModel *)goodM{
    self.choiceGoods = goodM;
    [self.shopHeaderView stopPlay];
    __weak typeof(self) weakSelf = self;
    if(self.shopDetailM.jingbi.intValue < goodM.price.intValue){
        [NoticeQiaojjieTools showWithTitle:@"你的鲸币余额不足，无法使用此功能~" msg:@"" button1:@"再想想" button2:@"充值" clickBlcok:^(NSInteger tag) {
            [weakSelf chongzhiView];
        }];
        return;
    }
    NoticeShopXiaDanTostaView *sureView = [[NoticeShopXiaDanTostaView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    sureView.titleL.frame = CGRectMake(0, 15, 280, 25);
    sureView.contentL.frame = CGRectMake(48, 80, 280-48, 108);
    sureView.titleL.text = [NSString stringWithFormat:@"你的鲸币余额可通话%d分钟\n超时自动结束，确定下单？",(int)(self.shopDetailM.jingbi.floatValue/goodM.price.intValue)];
    sureView.contentL.text = [NSString stringWithFormat:@"·聊天时长最多%d分钟\n·聊天双方都是匿名的\n·聊天记录不会保留\n·此类型仅可语音通话",(int)(self.shopDetailM.jingbi.floatValue/goodM.price.intValue)];
    sureView.sureXdBlock = ^(NSInteger index) {
        [self showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:weakSelf.choiceGoods.goodId forKey:@"goodsId"];
        [parm setObject:weakSelf.shopModel.shopId forKey:@"shopId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if(success){
                weakSelf.orderM = [NoticeByOfOrderModel mj_objectWithKeyValues:dict[@"data"]];
                weakSelf.isBuying = YES;
                
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                if(!weakSelf.shopDetailM.myShopM.user_id){
                    [weakSelf showToastWithText:@"找不到店主Id"];
                    return;
                }
                [appdel.audioChatTools callToUserId:weakSelf.shopDetailM.myShopM.user_id roomId:weakSelf.orderM.room_id.intValue getOrderTime:weakSelf.orderM.get_order_time nickName:weakSelf.orderM.user_nick_name];
                appdel.audioChatTools.cancelBlcok = ^(BOOL cancel) {
                    [weakSelf cancelOrder];
                };
                
                appdel.audioChatTools.repjectBlcok = ^(BOOL cancel) {
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"对方暂无法接单\n请尝试其他店铺" message:nil cancleBtn:@"知道了"];
                    [alerView showXLAlertView];
                };
            }else{
                NoticeOneToOne *allM = [NoticeOneToOne mj_objectWithKeyValues:dict];
                if(allM.code.intValue == 288){//用户余额不足
                    [NoticeQiaojjieTools showWithTitle:@"你的鲸币余额不足，需要充值才能继续下单噢" msg:@"" button1:@"再想想" button2:@"充值" clickBlcok:^(NSInteger tag) {
                        [weakSelf chongzhiView];
                    }];
                }else{
                    [NoticeQiaojjieTools showWithTitle:allM.msg];
                }
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
            [self showToastWithText:error.description];
        }];
    };
    [sureView showView];
}

- (void)buyVoiceChat:(NoticeGoodsModel *)goodM{
    
    __weak typeof(self) weakSelf = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) { // 有使用麦克风的权限
                [weakSelf hasMicBuyVoice:goodM];
            }else { // 没有麦克风权限
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.kaiqire"] message:@"有麦克风权限才可以语音通话功能哦~" sureBtn:[NoticeTools getLocalStrWith:@"recoder.kaiqi"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 1) {
                        UIApplication *application = [UIApplication sharedApplication];
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([application canOpenURL:url]) {
                            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                if (@available(iOS 10.0, *)) {
                                    [application openURL:url options:@{} completionHandler:nil];
                                }
                            } else {
                                [application openURL:url options:@{} completionHandler:nil];
                            }
                        }
                    }
                };
                [alerView showXLAlertView];
            }
        });
    }];
}

- (NoticeJieYouGoodsController *)goodsVC{
    if(!_goodsVC){
        _goodsVC = [[NoticeJieYouGoodsController alloc] init];
        __weak typeof(self) weakSelf = self;
        _goodsVC.buyGoodsBlock = ^(NoticeGoodsModel * _Nonnull buyGood) {
            
            if(buyGood.type.intValue == 1){
                [weakSelf buyTextChat:buyGood];
            }else if (buyGood.type.intValue == 2){
                [weakSelf buyVoiceChat:buyGood];
            }
        };
        _goodsVC.isUserLookShop = YES;
    }
    return _goodsVC;
}

- (NoticeJieYouGoodsComController *)comVC{
    if(!_comVC){
        _comVC = [[NoticeJieYouGoodsComController alloc] init];
        _comVC.isUserLookShop = YES;
        _comVC.shopId = self.shopModel.shopId;
        [_comVC refresh];
    }
    return _comVC;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
      _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
    self.pagerView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.pagerView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.shopHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.shopHeaderView.frame.size.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView.frame.size.height;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
    
    
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        return self.goodsVC;
    }else {
        return self.comVC;
    }
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end
