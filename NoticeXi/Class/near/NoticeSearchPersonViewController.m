//
//  NoticeSearchPersonViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSearchPersonViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMineViewController.h"
#import "NoticeNearSearchPersonCell.h"
#import "DDHAttributedMode.h"
#import "NoticeNearViewController.h"
#import "NoticeCarePeopleCell.h"
#import "NoticeLocalTopicCell.h"
@interface NoticeSearchPersonViewController ()<UITextFieldDelegate,NoticeTopiceCancelDelegate>
@property (nonatomic, strong) UIView *backViews;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UILabel *scanL;
@property (nonatomic, assign) BOOL hasCreate;  //YES  下拉
@property (nonatomic, assign) BOOL hasSearch;  //已经搜索过人
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) UITextField *topicField;
@property (nonatomic, strong) NSMutableArray *careArr;
@property (nonatomic, strong) NSMutableArray *localArr;
@property (nonatomic, strong) UIView *headerSectionView;
@property (nonatomic, strong) UIButton *moreButton;
@end

@implementation NoticeSearchPersonViewController
{
    UIButton *_beizhuBtn;
    BOOL _isMore;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    if (self.fromSearch) {
        self.useSystemeNav = YES;
        self.navBarView.hidden = YES;
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
    }
    [self.tableView registerClass:[NoticeNearSearchPersonCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[NoticeCarePeopleCell class] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerClass:[NoticeLocalTopicCell class] forCellReuseIdentifier:@"cell3"];
    if (self.olnySearsh) {
        self.navBarView.hidden = YES;
        self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+40, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40);

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-36)/2, DR_SCREEN_WIDTH-20-20-GET_STRWIDTH([NoticeTools getLocalStrWith:@"main.cancel"], 16, 30)-5, 36)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        backView.layer.cornerRadius = 18;
        backView.layer.masksToBounds = YES;
        [self.view addSubview:backView];
        
        UIImageView *searchImageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 20, 20)];
        searchImageV.image = UIImageNamed(@"Image_newsearchss");
        [backView addSubview:searchImageV];
        
        self.topicField = [[UITextField alloc] initWithFrame:CGRectMake(42, 0,DR_SCREEN_WIDTH-20-67-42, 36)];
        self.topicField.tintColor = GetColorWithName(VMainThumeColor);
        self.topicField.font = SIXTEENTEXTFONTSIZE;
        self.topicField.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.topicField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.topicField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"yl.searchs"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
        [self.topicField setupToolbarToDismissRightButton];
        self.topicField.delegate = self;
        self.topicField.returnKeyType = UIReturnKeySearch;
        [backView addSubview:self.topicField];
        
        UILabel *backL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-GET_STRWIDTH([NoticeTools getLocalStrWith:@"main.cancel"], 16, 30), STATUS_BAR_HEIGHT, GET_STRWIDTH([NoticeTools getLocalStrWith:@"main.cancel"], 16, 30), NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        backL.backgroundColor = self.view.backgroundColor;
        backL.font = SIXTEENTEXTFONTSIZE;
        backL.textColor = [UIColor colorWithHexString:@"#41434D"];
        backL.text = [NoticeTools getLocalStrWith:@"main.cancel"];
        backL.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:backL];
        backL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)];
        [backL addGestureRecognizer:tap];
        
      
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-20,40)];
        label.font = ELEVENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        label.text = [NoticeTools getLocalStrWith:@"yl.marks"];
        [self.view addSubview:label];

        
        self.careArr = [[NSMutableArray alloc] init];
        self.localArr = [NoticeTools getSearchArr];
      
        self.headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
        
        self.headerSectionView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];

        UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(15, 4,100, 40)];
        titL.text = [NoticeTools getLocalStrWith:@"search.recent"];
        titL.font = FOURTHTEENTEXTFONTSIZE;
        titL.textColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
        [self.headerSectionView addSubview:titL];
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-10-40, 4, 40, 40)];
        [deleteBtn addTarget:self action:@selector(deleteLocalClick) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setImage:UIImageNamed( @"img_deletetopictm") forState:UIControlStateNormal];
        [self.headerSectionView addSubview:deleteBtn];
        
        self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
        self.moreButton.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        self.moreButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.moreButton setTitleColor:[[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1] forState:UIControlStateNormal];
        [self.moreButton setTitle:[NoticeTools getLocalStrWith:@"topic.history"] forState:UIControlStateNormal];
        [self.moreButton addTarget:self action:@selector(lookMore) forControlEvents:UIControlEventTouchUpInside];
        _isMore = YES;
        if (self.sendWhite) {
            self.pageNo = 1;
            [self requestlike];
        }
    }

}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchClick{
    if (!self.topicField.text.length) {
        return;
    }
    self.tableView.tableHeaderView = nil;
    [self sarchPerson:self.topicField.text];
}

- (void)createRefesh{
    self.hasCreate = YES;
    __weak NoticeSearchPersonViewController *ctl = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        if (self.hasSearch) {
            [ctl request];
        }else{
            ctl.pageNo++;
            [ctl requestlike];
        }
        
    }];
}

- (void)requestlike{
    NSString *url = @"";
    url = [NSString stringWithFormat:@"users/%@/newAdmires?type=%@&pageNo=%ld",[NoticeTools getuserId],@"3",self.pageNo];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
        
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [self.careArr addObject:model];
            }

            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.hasSearch) {
        if (indexPath.section == 0) {
            NSString *str = self.localArr[indexPath.row];
            [self sarchPerson:str];
        }
        return;
    }
    NoticeNearPerson *person = self.dataArr[indexPath.row];
    if ([person.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = person.user_id;
        ctl.isOther = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.hasSearch) {
        if (indexPath.section == 0) {
            return 44;
        }
        return 68;
    }
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.hasSearch) {
        return 0;
    }
    if (section == 1 && self.careArr.count) {
        return 40;
    }
    return self.localArr.count?44:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.hasSearch) {
        return [UIView new];
    }
    if (section == 1 && self.careArr.count) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
        view.backgroundColor = self.view.backgroundColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,DR_SCREEN_WIDTH-25,40)];
        label.textColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.text =self.careArr.count? [NoticeTools getLocalStrWith:@"yl.likeeach"]:@"";
        [view addSubview:label];
        return view;
    }
    return self.localArr.count?self.headerSectionView: [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (self.localArr.count > 3 && _isMore && !self.hasSearch) {
            return self.moreButton;
        }
    }
 
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.localArr.count > 3 && _isMore && !self.hasSearch) {
        return 44;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.hasSearch) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.hasSearch) {
        if (section == 0) {
            if (!self.localArr.count) {
                return 0;
            }
            if (!_isMore) {
                return self.localArr.count;
            }
            if (self.localArr.count > 3) {
                return 3;
            }
            return self.localArr.count;
        }
        return self.careArr.count;
    }
    return self.dataArr.count;
}

- (void)lookMore{
    self.localArr = [NoticeTools getSearchArr];
    _isMore = NO;
   [self.tableView reloadData];
}

- (void)deleteLocalClick{
    [NoticeTools saveSearchArr:[NSArray new]];
     self.localArr = [NoticeTools getSearchArr];
     _isMore = YES;
    [self.tableView reloadData];
}

- (void)deleteCareM:(NoticeFriendAcdModel *)careM{
    for (NoticeFriendAcdModel *oldM in self.careArr) {
        if ([oldM.userId isEqualToString:careM.userId]) {
            [self.careArr removeObject:oldM];
            break;
        }
    }
    [self.tableView reloadData];
}

- (void)cancelHistoryTipicIn:(NSInteger)index{
    if (!self.localArr.count) {
        return;
    }
    if (self.localArr.count -1 >= index) {
        [self.localArr removeObjectAtIndex:index];
        [self.tableView reloadData];
        [NoticeTools saveSearchArr:self.localArr];
    }
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.hasSearch) {
        if (indexPath.section == 0) {
            NoticeLocalTopicCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            cell3.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:1];
            if (self.localArr.count) {
                if (indexPath.row <= self.localArr.count-1) {
                    cell3.mainL.text = self.localArr[indexPath.row];
                }
            }
      
            
            cell3.index = indexPath.row;
            cell3.delegate = self;
            return cell3;
        }else{
            NoticeCarePeopleCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            cell2.isSendWhite = YES;
            cell2.careModel = self.careArr[indexPath.row];
            
            __weak typeof(self) weakSelf = self;
            
            cell2.cancelCareBlock = ^(NoticeFriendAcdModel * _Nonnull careM) {
                [weakSelf deleteCareM:careM];
            };
            
            cell2.sendBlock = ^(NoticeFriendAcdModel * _Nonnull person) {
                if (!person.user_id) {
                    [weakSelf showToastWithText:@"用户不存在"];
                    return;
                }
                if (!weakSelf.cardNo) {
                    [weakSelf showToastWithText:@"卡片不存在"];
                    return;
                }
                NSString *str = [NoticeTools getLocalType]?[NSString stringWithFormat:@" Sure to send it to%@?",person.nick_name]:[NSString stringWithFormat:@"确定送给%@吗?",person.nick_name];
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"main.sure"] right:YES];
            
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 2) {
                        [weakSelf sendToPeople:person.user_id];
                    }
                };
                [alerView showXLAlertView];
            };
       
            
            return cell2;
        }
    }
    NoticeNearSearchPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.sendWhite = self.sendWhite;
    cell.person = self.dataArr[indexPath.row];

    __weak typeof(self) weakSelf = self;
    cell.sendBlock = ^(NoticeNearPerson * _Nonnull person) {
        if ([person.user_id isEqualToString:[NoticeTools getuserId]]) {
            [weakSelf showToastWithText:@"不可以送给自己哦"];
            return ;
        }
        if (!person.user_id) {
            [weakSelf showToastWithText:@"用户不存在"];
            return;
        }
        if (!weakSelf.cardNo) {
            [weakSelf showToastWithText:@"卡片不存在"];
            return;
        }
        NSString *str = [NoticeTools getLocalType]?[NSString stringWithFormat:@" Sure to send it to%@?",person.nick_name]:[NSString stringWithFormat:@"确定送给%@吗?",person.nick_name];
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"main.sure"] right:YES];
    
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf sendToPeople:person.user_id];
            }
        };
        [alerView showXLAlertView];
    };
    
    return cell;
}

- (void)sendToPeople:(NSString *)toUserId{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:toUserId forKey:@"toUserId"];
    [parm setObject:self.cardNo forKey:@"cardNo"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"famousQuotesCardLogs" Accept:@"application/vnd.shengxi.v4.8.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshlistNotice" object:nil];
            [UIView animateWithDuration:2 animations:^{
                [self showToastWithText:[NoticeTools getLocalType]?@"Sent":@"已送出,对方已收到"];
            } completion:^(BOOL finished) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    if (!_field.text.length) {
        return;
    }
    self.isDown = YES;
    [self request];
}

- (void)sarchPerson:(NSString *)name{
    self.name = name;

    self.isDown = YES;
    [self request];
}

- (void)request{
    NSString *url = nil;
    if (!self.isDown) {
        url = [NSString stringWithFormat:@"users/search?searchValue=%@&lastId=%@",[self.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]],self.lastId];
    }else{
        url = [NSString stringWithFormat:@"users/search?searchValue=%@",[self.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]]];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown) {
              self.dataArr = [NSMutableArray new];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeNearPerson *person = [NoticeNearPerson mj_objectWithKeyValues:dic];
                [self.dataArr addObject:person];
            }
            self.hasSearch = YES;
            if (self.dataArr.count) {
                self.lastId = [self.dataArr[self.dataArr.count-1] user_id];
                if (!self.hasCreate) {
                    [self createRefesh];
                }
                self.tableView.tableFooterView = nil;
            }else{
                self.queshenView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height);
                self.queshenView.backgroundColor = self.view.backgroundColor;
                self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy4");
                self.queshenView.titleStr = [NoticeTools getLocalStrWith:@"search.noUser"];
                self.tableView.tableFooterView = self.queshenView;
            }
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.olnySearsh) {
        if (self.topicField.text.length > 0) {
            DRLog(@"添加");
            [self.localArr insertObject:self.topicField.text atIndex:0];//保存乎执行回调
            if (self.localArr.count == 11) {
                [self.localArr removeObjectAtIndex:10];
            }
            NSArray *arr = [NSArray arrayWithArray:self.localArr];
            [NoticeTools saveSearchArr:arr];
        }

        [self searchClick];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

@end
