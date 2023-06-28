//
//  NoticeOrderComDetailController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/17.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeOrderComDetailController.h"
#import "NoticeShopComUserView.h"
@interface NoticeOrderComDetailController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIView *userNoComView;
@property (nonatomic, strong) UIImageView *userIconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIButton *comButton;
@property (nonatomic, strong) UIView *shopComView;
@property (nonatomic, strong) UILabel *shopComTimeL;
@property (nonatomic, strong) UIImageView *shopScoreImgV;
@property (nonatomic, strong) UILabel *shopScoreL;
@end

@implementation NoticeOrderComDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-55);
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 120)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(15, 12, DR_SCREEN_WIDTH-30, 68)];
    titleView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFC"];
    titleView.layer.cornerRadius = 10;
    titleView.layer.masksToBounds = YES;
    [self.headerView addSubview:titleView];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 48, 48)];
    self.iconImageView.layer.cornerRadius = 2;
    self.iconImageView.layer.masksToBounds = YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.goodsUrl]];
    [titleView addSubview:self.iconImageView];
    
    self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(66, 14, DR_SCREEN_WIDTH-30-68, 21)];
    self.priceL.font = FIFTHTEENTEXTFONTSIZE;
    self.priceL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    self.priceL.text = self.isVoice?[NSString stringWithFormat:@"%@*%@",self.orderName,[self  getMMSSFromSS:self.second]] : [NSString stringWithFormat:@"文字聊天*%@",self.orderName];
    [titleView addSubview:self.priceL];
    
    self.markL = [[UILabel alloc] initWithFrame:CGRectMake(66, 39,DR_SCREEN_WIDTH-30-68, 16)];
    self.markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    self.markL.font = ELEVENTEXTFONTSIZE;
    self.markL.text = self.time;
    [titleView addSubview:self.markL];
    
    [self.tableView registerClass:[NoticeShopChatCommentCell class] forCellReuseIdentifier:@"cell"];
    self.dataArr = [[NSMutableArray alloc] init];
    [self request];
    
    
    [self.navBarView.backButton removeFromSuperview];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView addSubview:backBtn];
    self.navBarView.backButton = backBtn;
    [self.navBarView.backButton addTarget:self action:@selector(sureBackClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (UIButton *)comButton{
    if(!_comButton){
        _comButton = [[UIButton alloc] initWithFrame:CGRectMake(68, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-40-10, DR_SCREEN_WIDTH-68*2, 40)];
        _comButton.layer.cornerRadius = 20;
        _comButton.layer.masksToBounds = YES;
        [_comButton setTitle:@"添加对买家的印象" forState:UIControlStateNormal];
        _comButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [_comButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _comButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.view addSubview:_comButton];
        [_comButton addTarget:self action:@selector(comClick) forControlEvents:UIControlEventTouchUpInside];
        _comButton.hidden = YES;
    }
    return _comButton;
}

- (void)comClick{
    __weak typeof(self) weakSelf = self;
    NoticeShopComUserView *comView = [[NoticeShopComUserView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    comView.scoreBlock = ^(NSString * _Nonnull score) {
        [weakSelf comUser:score];
    };
    [comView show];
}

- (void)comUser:(NSString *)score{

    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/shopComment?orderId=%@&score=%@",self.orderId,score] Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.comButton.hidden = YES;
            [self request];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (UIView *)shopComView{
    if(!_shopComView){
        _shopComView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,90)];
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 80)];
        backview.layer.cornerRadius = 10;
        backview.layer.masksToBounds = YES;
        backview.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [_shopComView addSubview:backview];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,15,DR_SCREEN_WIDTH-30-15-15-50, 22)];
        titleL.font = XGSIXBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.text = @"你对买家的印象：";
        [backview addSubview:titleL];
        
        self.shopComTimeL = [[UILabel alloc] initWithFrame:CGRectMake(15, 47,DR_SCREEN_WIDTH-30-15-15-50, 17)];
        self.shopComTimeL.font = TWOTEXTFONTSIZE;
        self.shopComTimeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backview addSubview:self.shopComTimeL];
        
        self.shopScoreImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 19, 16,16)];
        [backview addSubview:self.shopScoreImgV];
        
        self.shopScoreL = [[UILabel alloc] initWithFrame:CGRectMake(15, 47,DR_SCREEN_WIDTH-30-15-15-50, 0)];
        self.shopScoreL.font = TWOTEXTFONTSIZE;
        self.shopScoreL.textAlignment = NSTextAlignmentRight;
        [backview addSubview:self.shopScoreL];
    }
    return _shopComView;
}

- (void)sureBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(self.isFromCom){
        appdel.noPop = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = NO;
}


- (UIView *)userNoComView{
    if(!_userNoComView){
        _userNoComView = [[UIView alloc] initWithFrame:CGRectMake(15, 120, DR_SCREEN_WIDTH-30, 54)];
        _userNoComView.layer.cornerRadius = 5;
        _userNoComView.layer.masksToBounds = YES;
        _userNoComView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.headerView addSubview:_userNoComView];
        
        self.userIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 24, 24)];
        self.userIconImageView.image = UIImageNamed(@"Image_nimingpeiy");
        [_userNoComView addSubview:self.userIconImageView];

        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(47,0, GET_STRWIDTH(@"太治愈了", 14, 22)+30, 54)];
        self.nickNameL.font = XGSIXBoldFontSize;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_userNoComView addSubview:self.nickNameL];
        self.nickNameL.text = self.needDelete?@"我的评价":@"买家评价";
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-30-GET_STRWIDTH(@"对方还未评价", 12, 54)-15, 0,GET_STRWIDTH(@"对方还未评价", 12, 54), 54)];
        self.timeL.font = TWOTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.text = self.needDelete?@"评价已删除":@"对方还未评价";
        [_userNoComView addSubview:self.timeL];
    }
    return _userNoComView;
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
 
    NSInteger seconds = [totalTime integerValue];
 
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    if(str_hour.intValue){
        return [NSString stringWithFormat:@"%@时%@分%@秒",str_hour.intValue?str_hour:@"0",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
    }else{
        if(str_minute.intValue){
            return [NSString stringWithFormat:@"%@分%@秒",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
        }else{
            return [NSString stringWithFormat:@"%@秒",str_second.intValue?str_second:@"0"];
        }
    }
 
}


- (void)request{
    NSString *url = @"";

    url = [NSString stringWithFormat:@"shopGoodsOrder/getOrderComment/%@?type=3",self.orderId];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.dataArr removeAllObjects];
            NoticeShopCommentModel *model = [NoticeShopCommentModel mj_objectWithKeyValues:dict[@"data"]];
            if(model.userCommentModel.score.intValue){
                if (!model.userCommentModel.marks || model.userCommentModel.marks.length <= 0) {
                    if(model.userCommentModel.score.intValue == 1){
                        model.userCommentModel.marks = @"Ta觉得太治愈了";
                    }else if (model.userCommentModel.score.intValue == 2){
                        model.userCommentModel.marks = @"Ta觉得还可以啦";
                    }else{
                        model.userCommentModel.marks = @"Ta觉得不太行噢";
                    }
                }
                [self.dataArr addObject:model.userCommentModel];
            }else{
                self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 186);
                self.userNoComView.hidden = NO;
            }
            
            if(!self.needDelete){
                if(!model.shopCommentModel.score.intValue){
                    self.comButton.hidden = NO;
                }else{
                    self.tableView.tableFooterView = self.shopComView;
                    self.shopComView.hidden = NO;
                    self.shopComTimeL.text = model.shopCommentModel.created_at;
                    NSString *imgName = [NSString stringWithFormat:@"shopgoodcomimg_%@",model.shopCommentModel.score];
                    self.shopScoreImgV.image = UIImageNamed(imgName);
                    if(model.shopCommentModel.score.intValue == 1){
                        self.shopScoreL.text = @"很好";
                        self.shopScoreL.textColor = [UIColor colorWithHexString:@"#FD330C"];
                    }else if (model.shopCommentModel.score.intValue == 1){
                        self.shopScoreL.text = @"有点受伤";
                        self.shopScoreL.textColor = [UIColor colorWithHexString:@"#FD330C"];
                    }else{
                        self.shopScoreL.text = @"受到重创";
                        self.shopScoreL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
                    }
                    self.shopScoreL.frame = CGRectMake(DR_SCREEN_WIDTH-30-15-GET_STRWIDTH(self.shopScoreL.text, 12, 17), 18, GET_STRWIDTH(self.shopScoreL.text, 12, 17), 17);
                    self.shopScoreImgV.frame = CGRectMake(self.shopScoreL.frame.origin.x-16, 19, 16, 16);
                    _comButton.hidden = YES;
                    
                }
            }
        
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeShopChatCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isComDetail = YES;
    cell.needDelete = self.needDelete;
    cell.commentModel = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.deleteSureBlock = ^(NoticeShopCommentModel * _Nonnull commentM) {
        
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"删除后不能再次评价" message:nil sureBtn:@"再想想" cancleBtn:@"删除" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf deleteCom:commentM];
            }
        };
        [alerView showXLAlertView];
    };
    return cell;
}

- (void)deleteCom:(NoticeShopCommentModel *)model{
    
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"shopGoodsOrder/delComment/%@",model.comId] Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if(success){
            self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 186);
            self.userNoComView.hidden = NO;
            [self.dataArr removeAllObjects];
            [self.tableView reloadData];
            if (self.hasDeleteComBlock) {
                self.hasDeleteComBlock(self.orderId);
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeShopCommentModel *model = self.dataArr[indexPath.row];

    return model.marksHeight+(model.labelHeight>0?(model.labelHeight+8):0)+15+57+8+30;
}

@end
