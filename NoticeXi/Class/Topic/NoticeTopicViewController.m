//
//  NoticeTopicViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/30.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTopicViewController.h"
#import "NoticeTopicCell.h"
#import "NoticeLocalTopicCell.h"
#import "KMTagListView.h"
#import "NoticeTopiceVoicesListViewController.h"
@interface NoticeTopicViewController ()<UITextFieldDelegate,NoticeTopiceCancelDelegate,KMTagListViewDelegate>
@property (nonatomic, strong) NSMutableArray *localArr;
@property (nonatomic, strong) NSMutableArray *serachArr;
@property (nonatomic, strong) UITextField *topicField;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *headerSectionView;
@end

@implementation NoticeTopicViewController
{
    BOOL _isMore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLocal = YES;
    _isMore = YES;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(3, STATUS_BAR_HEIGHT,60, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [self.navBarView addSubview:btn1];
    self.navBarView.backButton.hidden = YES;
    
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
    self.moreButton.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    self.moreButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.moreButton setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    [self.moreButton setTitle:[NoticeTools getLocalStrWith:@"topic.history"] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(lookMore) forControlEvents:UIControlEventTouchUpInside];


    self.topicField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0,DR_SCREEN_WIDTH-67-20-10, 32)];
    self.topicField.tintColor = [UIColor colorWithHexString:@"#0099E6"];
    self.topicField.font = FOURTHTEENTEXTFONTSIZE;
    self.topicField.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
    self.topicField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.topicField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.isJustTopic?[NoticeTools getLocalStrWith:@"yl.sht"]: [NoticeTools getLocalStrWith:@"search.pla"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1]}];
    [self.topicField setupToolbarToDismissRightButton];
    [self.topicField becomeFirstResponder];
    [self.topicField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.topicField.delegate = self;
    if (self.isSearch) {
        self.topicField.returnKeyType = UIReturnKeySearch;
        if (self.topicName) {
            self.topicField.text = self.topicName;
        }
    }

    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, (NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2+STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-87, 32)];
    backV.layer.cornerRadius = 16;
    backV.layer.masksToBounds = YES;
    backV.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    [backV addSubview:self.topicField];
    [self.view addSubview:backV];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);

    self.hotArr = [NSMutableArray new];
    self.serachArr = [NSMutableArray new];
    self.localArr = [NoticeTools getTopicArr];
    
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 0)];
    UIImageView *iamgeV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 24, 24)];
    iamgeV.image = UIImageNamed(@"img_topic");
    [self.footView addSubview:iamgeV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iamgeV.frame)+10, 16, 100, 16)];
    label.font = XGSIXBoldFontSize;
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    label.text = [NoticeTools getLocalStrWith:@"search.hotTopic"];
    [self.footView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-67,STATUS_BAR_HEIGHT, 57, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [btn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    btn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self request];
    
    [self.tableView registerClass:[NoticeLocalTopicCell class] forCellReuseIdentifier:@"locallCell"];
    [self.tableView registerClass:[NoticeTopicCell class] forCellReuseIdentifier:@"topicCell"];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    self.headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 48)];
    self.headerSectionView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];

    UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(15, 8,100, 40)];
    titL.text = [NoticeTools getLocalStrWith:@"search.recent"];
    titL.font = FOURTHTEENTEXTFONTSIZE;
    titL.textColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
    [self.headerSectionView addSubview:titL];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-10-40, 8, 40, 40)];
    [deleteBtn addTarget:self action:@selector(deleteLocalClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:UIImageNamed(@"img_deletetopictm") forState:UIControlStateNormal];
    [self.headerSectionView addSubview:deleteBtn];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.localArr = [NoticeTools getTopicArr];
    [self.tableView reloadData];
}

- (void)lookMore{
    self.localArr = [NoticeTools getTopicArr];
    _isMore = NO;
   [self.tableView reloadData];
}
- (void)deleteLocalClick{
    [NoticeTools saveTopicArr:[NSArray new]];
     self.localArr = [NoticeTools getTopicArr];
     _isMore = YES;
    [self.tableView reloadData];
}


#pragma mark - KMTagListViewDelegate
-(void)ptl_TagListView:(KMTagListView *)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content {
    if (self.isSearch) {
        NoticeTopicModel *model = self.hotArr[index];
        NoticeTopiceVoicesListViewController *ctl = [[NoticeTopiceVoicesListViewController alloc] init];
        ctl.topicId = model.topic_id;
        ctl.topicName = model.topic_name;
         [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    if (self.topicBlock) {
        self.topicBlock(self.hotArr[index]);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (!self.isLocal) {
        if (self.localArr.count) {//判断是否存在
            for (NoticeTopicModel *model in self.localArr) {
                if ([model.topic_name isEqualToString:[self.serachArr[indexPath.row] topic_name]]) {//如果存在一样的，不保存，直接回调
                    if (self.isSearch) {
                        NoticeTopiceVoicesListViewController *ctl = [[NoticeTopiceVoicesListViewController alloc] init];
                        ctl.topicName = model.topic_name;
                        [self.navigationController pushViewController:ctl animated:YES];
                        return;
                    }
                    if (self.topicBlock) {
                        self.topicBlock(model);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
            }
        }
        if ((self.serachArr.count < indexPath.row+1)) {
            return;
        }
        [self.localArr insertObject:self.serachArr[indexPath.row] atIndex:0];//保存乎执行回调
        if (self.localArr.count == 11) {
            [self.localArr removeObjectAtIndex:10];
        }
        NSArray *arr = [NSArray arrayWithArray:self.localArr];
        [NoticeTools saveTopicArr:arr];
        
        if (self.isSearch) {//是否是搜索话题
            NoticeTopiceVoicesListViewController *ctl = [[NoticeTopiceVoicesListViewController alloc] init];
            ctl.topicName = [self.serachArr[indexPath.row] topic_name];
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
        
        if (self.topicBlock) {
            self.topicBlock(self.serachArr[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (!self.localArr.count) {
            return;
        }
        if (self.isSearch) {//是否是搜索话题
            NoticeTopiceVoicesListViewController *ctl = [[NoticeTopiceVoicesListViewController alloc] init];
            ctl.topicName = [self.localArr[indexPath.row] topic_name];
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
        if (self.topicBlock) {
            self.topicBlock(self.localArr[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    if (self.isSearch) {
        return;
    }
    
    if (_field.text.length) {
        self.isLocal = NO;
    }else{
        self.isLocal = YES;
        [self.tableView reloadData];
        return;
    }
    
    NSString *str = _field.text.length > 15 ? [_field.text substringToIndex:15] : _field.text;
    
    NoticeTopicModel *model = [[NoticeTopicModel alloc] init];
    model.topic_name = str;
    model.keyTitle = str;
    [self showHUD];
    NSString *urlName = [NSString stringWithFormat:@"topics?topicName=%@&topicType=%@",[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]],self.isDraw?@"1":@"0"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:urlName Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            [self hideHUD];
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                [self.serachArr removeAllObjects];
                [self.serachArr addObject:model];
                [self.tableView reloadData];
                return ;
            }
            if (![dict[@"data"] count]) {
                [self.serachArr removeAllObjects];
                [self.serachArr addObject:model];
                [self.tableView reloadData];
                return;
            }
            
            [self.serachArr removeAllObjects];
            [self.serachArr addObject:model];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeTopicModel *topicM = [NoticeTopicModel mj_objectWithKeyValues:dic];
                topicM.keyTitle = _field.text;
                [self.serachArr addObject:topicM];
            }
            [self.tableView reloadData];
        }else{
            [self.serachArr removeAllObjects];
            [self.serachArr addObject:model];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)request{
    if (self.hotArr.count) {
        NSMutableArray *arrary = [NSMutableArray new];
        for (NoticeTopicModel *topicM in self.hotArr) {
            [arrary addObject:topicM.name];
            [self.hotArr addObject:topicM];
        }
        self.tableView.tableFooterView = self.footView;
        KMTagListView *tagV = [[KMTagListView alloc]initWithFrame:CGRectMake(0,16+16+14, self.view.frame.size.width, 0)];
        tagV.delegate_ = self;
        [tagV setupSubViewsWithTitles:arrary];
        
        CGRect rect = tagV.frame;
        rect.size.height = tagV.contentSize.height;
        tagV.frame = rect;
        self.footView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, rect.size.height+46);
        [self.footView addSubview:tagV];
        [self.tableView reloadData];
        return;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topics/hot/1" Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.hotArr removeAllObjects];
            NSMutableArray *arrary = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeTopicModel *topicM = [NoticeTopicModel mj_objectWithKeyValues:dic];
                [arrary addObject:topicM.name];
                [self.hotArr addObject:topicM];
            }
            if (self.hotArr.count) {
                self.tableView.tableFooterView = self.footView;
                KMTagListView *tagV = [[KMTagListView alloc]initWithFrame:CGRectMake(0,16+16+14, self.view.frame.size.width, 0)];
                tagV.delegate_ = self;
                [tagV setupSubViewsWithTitles:arrary];
                
                CGRect rect = tagV.frame;
                rect.size.height = tagV.contentSize.height;
                tagV.frame = rect;
                self.footView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, rect.size.height+46);
                [self.footView addSubview:tagV];
                [self.tableView reloadData];
            }
        }
    } fail:^(NSError *error) {
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isLocal) {
        NoticeLocalTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locallCell"];
        cell.topicM = self.localArr[indexPath.row];
        cell.index = indexPath.row;
        cell.delegate = self;
        if (indexPath.row == self.localArr.count-1) {
            cell.line.hidden = YES;
        }else{
            cell.line.hidden = NO;
        }
        return cell;
    }else{
        NoticeTopicCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"topicCell"];
        cell1.isDraw = self.isDraw;
        cell1.topicM = self.serachArr[indexPath.row];
        
        if (indexPath.row == self.serachArr.count-1) {
            cell1.line.hidden = YES;
        }else{
            cell1.line.hidden = NO;
        }
        return cell1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isLocal) {
        return 56;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.isLocal) {
        return self.serachArr.count;
    }
    if (!_isMore) {
        return self.localArr.count;
    }
    if (self.localArr.count > 3) {
        return 3;
    }
    return self.localArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.localArr.count && self.isLocal) {
        return 48;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!self.isLocal) {
        return [UIView new];
    }
    if (self.localArr.count > 3 && _isMore) {
        return self.moreButton;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (!self.isLocal) {
        return 0;
    }
    if (self.localArr.count > 3) {
        return 44;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isLocal && self.localArr.count) {
        return self.headerSectionView;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 8)];
    return view;
}

- (void)cancelHistoryTipicIn:(NSInteger)index{
    [self.localArr removeObjectAtIndex:index];
    [self.tableView reloadData];
    [NoticeTools saveTopicArr:self.localArr];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int kMaxLength = 115;
    NSInteger strLength = textField.text.length - range.length + string.length;
    //输入内容的长度 - textfield区域字符长度（一般=输入字符长度）+替换的字符长度（一般为0）
    return (strLength <= kMaxLength);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.isSearch) {
        if (!self.topicName && !textField.text.length) {
            return YES;
        }
        NoticeTopiceVoicesListViewController *ctl = [[NoticeTopiceVoicesListViewController alloc] init];
        ctl.topicName = textField.text.length > 15 ? [textField.text substringToIndex:15] : textField.text;
        NoticeTopicModel *model = [[NoticeTopicModel alloc] init];
        if (!textField.text.length) {
            model.topic_name = self.topicName;
        }else{
            model.topic_name =  textField.text.length > 15 ? [textField.text substringToIndex:15] : textField.text;
        }
        ctl.topicName = model.topic_name;
        [self.localArr insertObject:model atIndex:0];//保存乎执行回调
        if (self.localArr.count == 11) {
            [self.localArr removeObjectAtIndex:10];
        }
        NSArray *arr = [NSArray arrayWithArray:self.localArr];
        [NoticeTools saveTopicArr:arr];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

- (void)cancelClick{
    [self.topicField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
