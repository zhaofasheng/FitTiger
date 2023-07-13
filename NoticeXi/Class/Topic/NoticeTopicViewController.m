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
#import "NoticeMorelikeTopicController.h"

#import "NoticeTopiceVoicesListViewController.h"
@interface NoticeTopicViewController ()<UITextFieldDelegate,NoticeTopiceCancelDelegate>
@property (nonatomic, strong) NSMutableArray *localArr;
@property (nonatomic, strong) NSMutableArray *serachArr;
@property (nonatomic, strong) NSMutableArray *likeArr;
@property (nonatomic, strong) UITextField *topicField;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *headerSectionView;
@property (nonatomic, strong) UIView *headerHotSectionView;
@property (nonatomic, strong) UIView *headerLikeSectionView;
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
    self.moreButton.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
    self.moreButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.moreButton setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    [self.moreButton setTitle:[NoticeTools getLocalStrWith:@"topic.history"] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(lookMore) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 43, DR_SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
    [self.moreButton addSubview:line];

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

    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, (NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2+STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-15-62, 32)];
    backV.layer.cornerRadius = 16;
    backV.layer.masksToBounds = YES;
    backV.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    [backV addSubview:self.topicField];
    [self.view addSubview:backV];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);

    self.likeArr = [[NSMutableArray alloc] init];
    self.hotArr = [NSMutableArray new];
    self.serachArr = [NSMutableArray new];
    self.localArr = [NoticeTools getTopicArr];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-62,STATUS_BAR_HEIGHT, 62, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [btn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    btn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    [self.tableView registerClass:[NoticeLocalTopicCell class] forCellReuseIdentifier:@"locallCell"];
    [self.tableView registerClass:[NoticeTopicCell class] forCellReuseIdentifier:@"topicCell"];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestLike) name:@"NOTICEREFRESHTOPICNOTICE" object:nil];
    [self request];
    [self requestLike];
}

- (UIView *)headerSectionView{
    if(!_headerSectionView){
        _headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 48)];
        _headerSectionView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        _headerSectionView.backgroundColor = self.view.backgroundColor;
        UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(15, 8,100, 40)];
        titL.text = [NoticeTools getLocalStrWith:@"search.recent"];
        titL.font = XGFifthBoldFontSize;
        titL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        [_headerSectionView addSubview:titL];
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-10-40, 8, 40, 40)];
        [deleteBtn addTarget:self action:@selector(deleteLocalClick) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setImage:UIImageNamed(@"img_deletetopictm") forState:UIControlStateNormal];
        [_headerSectionView addSubview:deleteBtn];
    }
    return _headerSectionView;
}

- (UIView *)headerLikeSectionView{
    if(!_headerLikeSectionView){
        _headerLikeSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 48)];
        _headerLikeSectionView.backgroundColor = self.view.backgroundColor;
        UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(15, 8,100, 40)];
        titL.text = @"我收藏的";
        titL.font = XGFifthBoldFontSize;
        titL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        [_headerLikeSectionView addSubview:titL];
  
        UIImageView *moreimg = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-20,14, 20, 20)];
        moreimg.image = UIImageNamed(@"img_sctoipcall");
        [_headerLikeSectionView addSubview:moreimg ];
        
        _headerLikeSectionView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreLike)];
        [_headerLikeSectionView addGestureRecognizer:tap];
    }
    return _headerLikeSectionView;
}

- (void)moreLike{
    NoticeMorelikeTopicController *ctl = [[NoticeMorelikeTopicController alloc] init];
    __weak typeof(self) weakSelf = self;
    ctl.topicBlock = ^(NoticeTopicModel * _Nonnull topic) {
        if(weakSelf.topicBlock){
            weakSelf.topicBlock(topic);
        }
        [weakSelf.navigationController popViewControllerAnimated:NO];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UIView *)headerHotSectionView{
    if(!_headerHotSectionView){
        _headerHotSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 48)];
        _headerHotSectionView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        _headerHotSectionView.backgroundColor = self.view.backgroundColor;
        UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(15, 8,100, 40)];
        titL.text = @"热门话题";
        titL.font = XGFifthBoldFontSize;
        titL.textColor = [[UIColor colorWithHexString:@"#FF9E3C"] colorWithAlphaComponent:1];
        [_headerHotSectionView addSubview:titL];
  
    }
    return _headerHotSectionView;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
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
    }else if (indexPath.section == 2){
        if (self.isSearch) {
            NoticeTopicModel *model = self.hotArr[indexPath.row];
            NoticeTopiceVoicesListViewController *ctl = [[NoticeTopiceVoicesListViewController alloc] init];
            ctl.topicId = model.topic_id;
            ctl.topicName = model.topic_name;
             [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
        if (self.topicBlock) {
            self.topicBlock(self.hotArr[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if (indexPath.section == 1){
        if (self.isSearch) {
            NoticeTopicModel *model = self.likeArr[indexPath.row];
            NoticeTopiceVoicesListViewController *ctl = [[NoticeTopiceVoicesListViewController alloc] init];
            ctl.topicId = model.topic_id;
            ctl.topicName = model.topic_name;
             [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
        if (self.topicBlock) {
            self.topicBlock(self.likeArr[indexPath.row]);
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

- (void)requestLike{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topicCollection?type=0" Accept:@"application/vnd.shengxi.v5.5.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.likeArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeTopicModel *topicM = [NoticeTopicModel mj_objectWithKeyValues:dic];
                topicM.isCollection = YES;
                [self.likeArr addObject:topicM];
            }
            if (self.likeArr.count) {

                [self.tableView reloadData];
            }
        }
    } fail:^(NSError *error) {
    }];
}

- (void)request{
    if (self.hotArr.count) {
        NSMutableArray *arrary = [NSMutableArray new];
        for (NoticeTopicModel *topicM in self.hotArr) {
            [arrary addObject:topicM.name];
            [self.hotArr addObject:topicM];
        }

        [self.tableView reloadData];
        return;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topics/hot/1" Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.hotArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeTopicModel *topicM = [NoticeTopicModel mj_objectWithKeyValues:dic];
                [self.hotArr addObject:topicM];
            }
            if (self.hotArr.count) {
                [self.tableView reloadData];
            }
        }
    } fail:^(NSError *error) {
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (self.isLocal) {
            NoticeLocalTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locallCell"];
            cell.type = 1;
            cell.topicM = self.localArr[indexPath.row];
            cell.index = indexPath.row;
            cell.delegate = self;

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
    }else {
        NoticeLocalTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locallCell"];
        cell.type = indexPath.section==1?2:3;
        cell.topicM = indexPath.section == 1? self.likeArr[indexPath.row]:self.hotArr[indexPath.row];
        cell.index = indexPath.row;
        cell.delegate = self;
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (!self.isLocal) {
            return 56;
        }
    }
  
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
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
    }else if (section == 1){
        return self.likeArr.count > 3?3:self.likeArr.count;
    }
    return self.hotArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if (self.localArr.count && self.isLocal) {
            return 48;
        }
        return 0;
    }else if (section == 1){
        return self.likeArr.count?48:0;
    }
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if (self.isLocal && self.localArr.count) {
            return self.headerSectionView;
        }
    }else if (section == 1){
        return self.likeArr.count? self.headerLikeSectionView:[UIView new];
    }
  
    return self.headerHotSectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        if (!self.isLocal) {
            return [UIView new];
        }
        if (self.localArr.count > 3 && _isMore) {
            return self.moreButton;
        }
    }

    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        if (!self.isLocal) {
            return 0;
        }
        if (self.localArr.count > 3) {
            return 44;
        }
    }

    return 0;
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
