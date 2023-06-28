//
//  NoticeMyJieYouShopController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyJieYouShopController.h"
#import "NoticeXi-Swift.h"
#import "NoticeJieYouGoodsComController.h"
#import "NoticeJieYouGoodsController.h"
#import "NoticeJieYouShopHeaderView.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"
@interface NoticeMyJieYouShopController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NoticeJieYouGoodsController *goodsVC;
@property (nonatomic, strong) NoticeJieYouGoodsComController *comVC;
@property (nonatomic, strong) NoticeSupplyShopView *supplyView;
@property (nonatomic, strong) NoticeCureentShopStatusModel *applyModel;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) UIButton *workButton;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) NoticeJieYouShopHeaderView *shopHeaderView;
@property (nonatomic, strong) NSMutableArray *sellGoodsArr;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
@end

@implementation NoticeMyJieYouShopController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.shopHeaderView stopPlay];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titles = @[@"商品",@"评价"];
    self.shopHeaderView = [[NoticeJieYouShopHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 236)];
    __weak typeof(self) weakSelf = self;
    self.shopHeaderView.refreshShopModel = ^(BOOL refresh) {
        [weakSelf getShopRequest];
    };
    
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

    
    FSCustomButton *phoneBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-40-10, 112, 40)];
    phoneBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    phoneBtn.layer.cornerRadius = 20;
    phoneBtn.layer.masksToBounds = YES;
    [phoneBtn setTitle:@"电话亭规则" forState:UIControlStateNormal];
    phoneBtn.buttonImagePosition = FSCustomButtonImagePositionLeft;
    phoneBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [phoneBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    [phoneBtn setImage:UIImageNamed(@"call_rule") forState:UIControlStateNormal];
    [self.view addSubview:phoneBtn];
    [phoneBtn addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.workButton = [[UIButton alloc] initWithFrame:CGRectMake(147, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-40-10, DR_SCREEN_WIDTH-20-147, 40)];
    self.workButton.layer.cornerRadius = 20;
    self.workButton.layer.masksToBounds = YES;
    self.workButton.backgroundColor = [UIColor colorWithHexString:@"开始营业"];
    [self.workButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.workButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.view addSubview:self.workButton];
    [self.workButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if(userM.comeHereDays.integerValue < 100 && userM.mobile.integerValue < 10000){
        self.supplyView.getL.text = @"未满足申请条件“来声昔100天、绑定手机“";
        [self.supplyView.startBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.supplyView.startBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.supplyView.hidden = NO;
    }else if (userM.comeHereDays.integerValue < 100 && userM.mobile.integerValue > 10000){
        self.supplyView.getL.text = @"未满足申请条件“来声昔100天“";
        [self.supplyView.startBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.supplyView.startBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.supplyView.hidden = NO;
    }else if (userM.comeHereDays.integerValue >= 100 && userM.mobile.integerValue < 10000){
        self.supplyView.getL.text = @"未满足申请条件“绑定手机“";
        [self.supplyView.startBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.supplyView.startBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.supplyView.hidden = NO;
    }else{
        self.supplyView.getL.text = @"已满足申请条件“来声昔100天、绑定手机“";
        [self.supplyView.startBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.supplyView.startBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self getStatusRequest];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopRequest) name:@"REFRESHMYWALLECT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasSypply) name:@"HASSUPPLYSHOPNOTICE" object:nil];
    //
    self.tableView.hidden = YES;
    
    
}

- (void)getStatusRequest{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/getApplyStage" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.applyModel = [NoticeCureentShopStatusModel mj_objectWithKeyValues:dict[@"data"]];
            if(self.applyModel.status < 4 || self.applyModel.status == 5){
                self.supplyView.hidden = NO;
                self.supplyView.getL.text = @"已满足申请条件“来声昔100天、绑定手机“";
                [self.supplyView.startBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
                self.supplyView.startBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            }else if (self.applyModel.status == 4) {
                self.supplyView.getL.hidden = YES;
                self.supplyView.hidden = NO;
                [self.supplyView.startBtn setTitle:@"已申请，等待审核" forState:UIControlStateNormal];
                [self.supplyView.startBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
                self.supplyView.startBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
            }else if (self.applyModel.status == 6) {
                self.supplyView.hidden = YES;
                [self getShopRequest];
            }
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [self showToastWithText:error.debugDescription];
    }];
}

- (NoticeSupplyShopView *)supplyView{
    if(!_supplyView){
        _supplyView = [[NoticeSupplyShopView alloc] initWithFrame:CGRectMake(0, 10+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-20)];
        [self.view addSubview:_supplyView];
        [_supplyView.startBtn addTarget:self action:@selector(supplyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _supplyView;
}

- (void)hasSypply{
    self.applyModel.apply_stage = @"4";
    [self showToastWithText:@"已申请，等待审核"];
    self.supplyView.getL.hidden = YES;
    [self.supplyView.startBtn setTitle:@"已申请，等待审核" forState:UIControlStateNormal];
    [self.supplyView.startBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    self.supplyView.startBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
}

- (void)supplyClick{
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];

    if (userM.comeHereDays.integerValue < 100 || userM.mobile.integerValue < 10000) {
        return;
    }
    if(self.applyModel.status == 5){
        NoticeSupplyProController *ctl = [[NoticeSupplyProController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (self.applyModel.status < 4 && self.applyModel.status > 0){
        NoticeSupplyProController *ctl = [[NoticeSupplyProController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }

}

- (void)getShopRequest{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/ByUser" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.shopModel = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
            self.shopHeaderView.myShopModel = self.shopModel;
            [self refresButton];
            self.goodsArr = self.shopModel.goods_listArr;
            self.goodsVC.goodsModel = self.shopModel;
            if(!self.sellGoodsArr.count){
                for (NoticeGoodsModel *goods in self.goodsArr) {
                    if(goods.is_selling.intValue){
                        [self.sellGoodsArr addObject:goods];
                    }
                }
                self.goodsVC.goodssellArr = self.sellGoodsArr;
            }
            self.comVC.shopId = self.shopModel.myShopM.shopId;
            [self.comVC refresh];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [self showToastWithText:error.debugDescription];
    }];
}

- (NSMutableArray *)sellGoodsArr{
    if(!_sellGoodsArr){
        _sellGoodsArr = [[NSMutableArray alloc] init];
    }
    return _sellGoodsArr;
}


- (void)ruleClick{
    NoticeProtocolView *ruleView = [[NoticeProtocolView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    [ruleView showTitleWithTitle:@"声昔电话亭" content:@"·声昔电话亭\n只要你想见我，我随时都在。我会一直在你身边你慢慢说，我慢慢听。通过自己的暖心技能来治愈小伙伴\n\n·鲸币\\n鲸币是声昔APP的虚拟货币，可用于购买声昔电话亭中店铺里的虚拟服务商品。\n\n·店铺规则\n1.店铺需要手动「开始营业」「结束营业」。\n2.店主和顾客的身份都是匿名的。\n3.聊天记录不会保存\n4.店铺营业中，但连续3次以上不接单，将会自动结束营业。\n5.举报核实后，如属实或恶意举报，店主或顾客会有相应的违规惩罚，具体以管理员通知为准。\n6.每个订单的声昔会抽取20%的服务费。"];
}

- (void)startClick{
    
    
    if(self.shopModel.myShopM.is_stop.integerValue){
        return;
    }

    if(self.shopModel.myShopM.operate_status.integerValue == 2){
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/operateStatus/%@/1",self.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if(success){
                [self getShopRequest];
            }
            [self hideHUD];
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        return;
    }
    
    if(!self.shopModel.myShopM.role.intValue){
        [self showToastWithText:@"请选择您的角色"];
        return;
    }
   
    if(!self.sellGoodsArr.count){
        [self showToastWithText:@"请添加您要营业的商品"];
        return;
    }
   
    if(self.shopModel.myShopM.operate_status.integerValue == 1 && self.shopModel.myShopM.role.intValue && self.sellGoodsArr.count){
        
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"营业中，店铺有新订单时，声昔会通过手机短信提示你" message:nil sureBtn:@"再想想" cancleBtn:@"开始营业" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf start];
            }
        };
        [alerView showXLAlertView];
    }
}

- (void)start{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if(self.sellGoodsArr.count==1){
        NoticeGoodsModel *good1 = self.sellGoodsArr[0];
        [parm setObject:good1.goodId forKey:@"goods_id"];
    }else if (self.sellGoodsArr.count == 2){
        NoticeGoodsModel *good1 = self.sellGoodsArr[0];
        NoticeGoodsModel *good2 = self.sellGoodsArr[1];
        [parm setObject:[NSString stringWithFormat:@"%@,%@",good1.goodId,good2.goodId] forKey:@"goods_id"];
    }else{
        [YZC_AlertView showViewWithTitleMessage:@"没有选择营业的商品"];
        return;
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/operateStatus/%@/2",self.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            [self getShopRequest];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)refresButton{
    if(self.shopModel.myShopM.is_stop.integerValue > 0){
        if(self.shopModel.myShopM.is_stop.integerValue == 1){//店铺被永久关停
            [self.workButton setTitle:@"店铺已被永久关闭" forState:UIControlStateNormal];
            self.workButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
            [self.workButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        }else{
            [self.workButton setTitle:[NSString stringWithFormat:@"暂停营业中%@",[NoticeTools getDaoishi:self.shopModel.myShopM.is_stop]] forState:UIControlStateNormal];
            self.workButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
            self.workButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.workButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        }
    }else{
        if(self.shopModel.myShopM.operate_status.integerValue == 2){
            [self.workButton setTitle:@"营业中，结束营业" forState:UIControlStateNormal];
            self.workButton.backgroundColor = [UIColor colorWithHexString:@"#DB6E6E"];
            [self.workButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }else if (self.shopModel.myShopM.role <=0 || !self.sellGoodsArr.count){
            [self.workButton setTitle:@"开始营业" forState:UIControlStateNormal];
            self.workButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
            [self.workButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        }else if (self.shopModel.myShopM.operate_status.integerValue == 1){
            [self.workButton setTitle:@"开始营业" forState:UIControlStateNormal];
            self.workButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.workButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }
    }
    
}

- (NoticeJieYouGoodsController *)goodsVC{
    if(!_goodsVC){
        _goodsVC = [[NoticeJieYouGoodsController alloc] init];
        __weak typeof(self) weakSelf = self;
        _goodsVC.refreshGoodsBlock = ^(NSMutableArray * _Nonnull goodsArr) {
            weakSelf.sellGoodsArr = goodsArr;
            [weakSelf refresButton];
        };
    }
    return _goodsVC;
}

- (NoticeJieYouGoodsComController *)comVC{
    if(!_comVC){
        _comVC = [[NoticeJieYouGoodsComController alloc] init];
    }
    return _comVC;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
      _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
    self.pagerView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT-50);
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
