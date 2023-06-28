//
//  NoticeJieYouGoodsController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeJieYouGoodsController.h"
#import "NoticeAddSellMerchantController.h"
#import "NoticeChoiceJieyouChatCell.h"
@interface NoticeJieYouGoodsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UILabel *defaultL;
@end

@implementation NoticeJieYouGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor =  [UIColor whiteColor];
    self.tableView = [[UITableView alloc] init];

    self.tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NoticeChoiceJieyouChatCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 116;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-BOTTOM_HEIGHT-50);
    if(self.isUserLookShop){
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-BOTTOM_HEIGHT);
    }
}

- (UIView *)footView{
    if(!_footView){
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 112)];
        _footView.backgroundColor = [UIColor whiteColor];
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 112)];
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        backV.layer.cornerRadius = 10;
        backV.layer.masksToBounds = YES;
        [_footView addSubview:backV];
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, DR_SCREEN_WIDTH-30, 20)];
        numL.font = FOURTHTEENTEXTFONTSIZE;
        numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        numL.textAlignment = NSTextAlignmentCenter;
        numL.text = @"还没上架商品噢～";
        [backV addSubview:numL];
        
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((backV.frame.size.width-93)/2, 56, 93, 32)];
        addBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        addBtn.layer.cornerRadius = 16;
        addBtn.layer.masksToBounds = YES;
        [addBtn setTitle:@"添加商品" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [backV addSubview:addBtn];
    }
    return _footView;
}

- (void)setGoodssellArr:(NSMutableArray *)goodssellArr{
    _goodssellArr = goodssellArr;
    if (!self.isUserLookShop) {
        self.tableView.tableFooterView = goodssellArr.count?nil:self.footView;
        [self.tableView reloadData];
    }
}

- (void)setShopDetailModel:(NoticeMyShopModel *)shopDetailModel{
    _shopDetailModel = shopDetailModel;
    if(_shopDetailModel.goods_listArr.count){
        self.tableView.tableHeaderView = nil;
    }else{
        self.tableView.tableHeaderView = self.defaultL;
        self.defaultL.text = @"店铺还没有营业哦~";
    }
    [self.tableView reloadData];
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

- (void)addClick{
    NoticeAddSellMerchantController *ctl = [[NoticeAddSellMerchantController alloc] init];
    ctl.goodsModel = self.goodsModel;
    ctl.sellGoodsArr = self.goodssellArr;
    __weak typeof(self) weakSelf = self;
    ctl.refreshGoodsBlock = ^(NSMutableArray * _Nonnull goodsArr) {
        weakSelf.goodssellArr = goodsArr;
        [weakSelf.tableView reloadData];
        if(weakSelf.refreshGoodsBlock){
            weakSelf.refreshGoodsBlock(weakSelf.goodssellArr);
        }
    };
    ctl.changePriceBlock = ^(NSString * _Nonnull price) {
        for (NoticeGoodsModel *model in self.goodssellArr) {
            if(model.type.intValue == 2){
                model.price = price;
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isUserLookShop){
        return;
    }
    if(self.goodsModel.myShopM.operate_status.integerValue == 2){
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"店铺营业中，不能更换售卖的商品哦" message:nil cancleBtn:@"知道了"];
        [alerView showXLAlertView];
        return;
    }
    [self addClick];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isUserLookShop){
        return self.shopDetailModel.goods_listArr.count;
    }
    return self.goodssellArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeChoiceJieyouChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isUserLookShop = self.isUserLookShop;
    if (self.isUserLookShop) {
        __weak typeof(self) weakSelf = self;
        cell.buyGoodsBlock = ^(NoticeGoodsModel * _Nonnull buyGood) {
            if(weakSelf.buyGoodsBlock){
                weakSelf.buyGoodsBlock(buyGood);
            }
        };
        cell.goodModel = self.shopDetailModel.goods_listArr[indexPath.row];
    }else{
        cell.goodModel = self.goodssellArr[indexPath.row];
    }
    
    return cell;
}
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}



@end
