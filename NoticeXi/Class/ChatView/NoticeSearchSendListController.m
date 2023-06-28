//
//  NoticeSearchSendListController.m
//  NoticeXi
//
//  Created by li lei on 2022/5/26.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeSearchSendListController.h"
#import "NoticeSearchChatCell.h"
#import "NoticeShareSureView.h"
@interface NoticeSearchSendListController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) NoticeShareSureView *sureView;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *topicField;
@end

@implementation NoticeSearchSendListController
- (NoticeShareSureView *)sureView{
    if (!_sureView) {
        _sureView = [[NoticeShareSureView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _sureView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.frame = CGRectMake(0, 80+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT- 80-NAVIGATION_BAR_HEIGHT);
    
    [self.tableView registerClass:[NoticeSearchChatCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 65;
    
    self.navBarView.hidden = NO;
    self.needHideNavBar = YES;
    self.navBarView.backButton.hidden = YES;
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-100, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    self.titleL.font = XGEightBoldFontSize;
    self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.view addSubview:self.titleL];
    self.titleL.text = [NoticeTools getLocalStrWith:@"shanre.to"];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT, 70, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    backLabel.userInteractionEnabled = YES;
    backLabel.font = SIXTEENTEXTFONTSIZE;
    backLabel.textColor = [UIColor colorWithHexString:@"#0099E6"];
    backLabel.text = [NoticeTools getLocalStrWith:@"main.cancel"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap)];
    [backLabel addGestureRecognizer:tap];
    [self.view addSubview:backLabel];
    
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+8, DR_SCREEN_WIDTH-40, 36)];
    self.searchBtn.backgroundColor = [UIColor whiteColor];
    [self.searchBtn setTitle:[NoticeTools getLocalStrWith:@"yl.searchs"] forState:UIControlStateNormal];
    [self.searchBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
    self.searchBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.view addSubview:self.searchBtn];
    self.searchBtn.layer.cornerRadius = 18;
    self.searchBtn.layer.masksToBounds = YES;
    [self.searchBtn setImage:UIImageNamed(@"Image_searchchat") forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(inputClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.typeL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.searchBtn.frame)+16, 200, 20)];
    self.typeL.font = FOURTHTEENTEXTFONTSIZE;
    self.typeL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.typeL.text = self.isLike?[NoticeTools getLocalStrWith:@"yl.likeeach"]:[NoticeTools getLocalStrWith:@"chat.zuijinchant"];
    
    
    [self.view addSubview:self.typeL];
    
    self.dataArr = [[NSMutableArray alloc] init];
    self.isDown = YES;
    self.pageNo = 1;
    [self createRefesh];
    [self request];
    
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+8, DR_SCREEN_WIDTH-20, 36)];
    self.searchView.hidden = YES;
    [self.view addSubview:self.searchView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH-20-60, 36)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    backView.layer.cornerRadius = 18;
    backView.layer.masksToBounds = YES;
    [self.searchView addSubview:backView];
    
    UIImageView *searchImageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 20, 20)];
    searchImageV.image = UIImageNamed(@"Image_searchchat");
    [backView addSubview:searchImageV];
    
    self.topicField = [[UITextField alloc] initWithFrame:CGRectMake(42, 0,DR_SCREEN_WIDTH-20-60-42, 36)];
    self.topicField.tintColor = GetColorWithName(VMainThumeColor);
    self.topicField.font = SIXTEENTEXTFONTSIZE;
    self.topicField.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.topicField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.topicField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"yl.searchs"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
    [self.topicField setupToolbarToDismissRightButton];
    self.topicField.delegate = self;
    self.topicField.returnKeyType = UIReturnKeySearch;
    [backView addSubview:self.topicField];
    
    UILabel *backL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backView.frame), 0,60, 36)];
    backL.backgroundColor = self.view.backgroundColor;
    backL.font = SIXTEENTEXTFONTSIZE;
    backL.textColor = [UIColor colorWithHexString:@"#25262E"];
    backL.text = [NoticeTools getLocalStrWith:@"main.cancel"];
    backL.textAlignment = NSTextAlignmentCenter;
    [self.searchView addSubview:backL];
    backL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    [backL addGestureRecognizer:tap1];
}

- (void)cancelClick{
    self.isSearch = NO;
    [self.topicField resignFirstResponder];
    self.searchView.hidden = YES;
    self.searchBtn.hidden = NO;
    self.pageNo = 1;
    self.isDown = YES;
    self.typeL.hidden = NO;
    [self request];
}

- (void)inputClick{
    self.isSearch = YES;
    [self.topicField resignFirstResponder];
    self.searchView.hidden = NO;
    self.searchBtn.hidden = YES;
    self.typeL.hidden = YES;
}

- (void)createRefesh{
 
    __weak NoticeSearchSendListController *ctl = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        self.pageNo++;
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSearchChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.friendM = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.sendBlcok = ^(NoticeFriendAcdModel * _Nonnull userM) {
    
        if (weakSelf.voiceM) {
            weakSelf.sureView.voiceM = weakSelf.voiceM;
        }
        if (weakSelf.pyModel) {
            weakSelf.sureView.pyModel = weakSelf.pyModel;
        }
        if (weakSelf.tcModel) {
            weakSelf.sureView.tcModel = weakSelf.tcModel;
        }
        weakSelf.sureView.userM = userM;
        [weakSelf.sureView showTost];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)request{
    if (self.isSearch) {
        NSString *url = nil;
        if (!self.isDown) {
            url = [NSString stringWithFormat:@"users/search?searchValue=%@&lastId=%@",[self.topicField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"users/search?searchValue=%@",[self.topicField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]]];
        }
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [self.tableView.mj_footer endRefreshing];
            if (success) {
                
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                
                if (self.isDown) {
                  [self.dataArr removeAllObjects];
                    self.isDown = NO;
                }
                
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                    [self.dataArr addObject:model];
                }
                if (self.dataArr.count) {
                    self.lastId = [self.dataArr[self.dataArr.count-1] user_id];
               
                }
                [self.tableView reloadData];
            }
        } fail:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
        }];
        return;
    }
    if (self.isLike) {
        NSString *type = @"3";
        NSString *url = @"";

        url = [NSString stringWithFormat:@"users/%@/newAdmires?type=%@&pageNo=%ld",[NoticeTools getuserId],type,self.pageNo];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                if (self.isDown) {
                    [self.dataArr removeAllObjects];
                    self.isDown = NO;
                }
                
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                    model.userId = model.user_id;
                    [self.dataArr addObject:model];
                }
       
                [self.tableView reloadData];
            }
        } fail:^(NSError * _Nullable error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/recently?pageNo=%ld",self.pageNo] Accept:@"application/vnd.shengxi.v5.3.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                if (self.isDown) {
                    [self.dataArr removeAllObjects];
                    self.isDown = NO;
                }
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                    [self.dataArr addObject:model];
                }
             
                [self.tableView reloadData];
            }
        } fail:^(NSError * _Nullable error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

- (void)searchClick{
    [self request];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.isDown = YES;
    self.pageNo = 1;
    [self searchClick];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

- (void)backTap{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    [self.topicField resignFirstResponder];
}

@end
