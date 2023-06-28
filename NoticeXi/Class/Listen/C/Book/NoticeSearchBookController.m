//
//  NoticeSearchBookController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSearchBookController.h"
#import "NoticeSearchBookResultController.h"
#import "NoticeLocalTopicCell.h"
#import "LeftViewTextField.h"
@interface NoticeSearchBookController ()<UITextFieldDelegate,NoticeTopiceCancelDelegate>
@property (nonatomic, strong) UITextField *topicField;
@property (nonatomic, strong) NSMutableArray *locaArr;
@property (nonatomic, strong) UIButton *moreButton;
@end

@implementation NoticeSearchBookController
{
    BOOL _isMore;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.topicField resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.topicField becomeFirstResponder];
     self.locaArr = [NoticeTools getBookArr];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _isMore = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
    self.moreButton.backgroundColor = GetColorWithName(VBackColor);
    self.moreButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.moreButton setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
    [self.moreButton setTitle:GETTEXTWITE(@"topic.history") forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(lookMore) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, (STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-36)/2), DR_SCREEN_WIDTH-67-20, 36)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    backView.layer.cornerRadius = 18;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    self.topicField = [[UITextField alloc] initWithFrame:CGRectMake(40,0,DR_SCREEN_WIDTH-67-20-40, 36)];
    self.topicField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.topicField.font = SIXTEENTEXTFONTSIZE;
    self.topicField.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.topicField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.topicField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"book.searchbook"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ACB3BF"]}];
    self.topicField.delegate = self;
    self.topicField.returnKeyType = UIReturnKeySearch;
    [self.topicField becomeFirstResponder];
    self.topicField.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    [backView addSubview:self.topicField];
    
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(10,8,20, 20)];
    imageViewPwd.image= UIImageNamed(@"Imagesbt");
    [backView addSubview:imageViewPwd];
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 30)];
    self.tableView.tableHeaderView = headerV;

    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.tableView.rowHeight = 44;
    [self.tableView registerClass:[NoticeLocalTopicCell class] forCellReuseIdentifier:@"locallCell"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-67, STATUS_BAR_HEIGHT, 67, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [btn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0,0,-20);
    [btn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
    btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)lookMore{
    [self.moreButton setTitle:GETTEXTWITE(@"topic.clear") forState:UIControlStateNormal];
    
    if (!_isMore) {
        [self.locaArr removeAllObjects];
        [NoticeTools saveBookArr:self.locaArr];
        [self.moreButton setTitle:GETTEXTWITE(@"topic.history") forState:UIControlStateNormal];
        _isMore = YES;
    }
    _isMore = NO;
    [self.tableView reloadData];
    
    
}


- (void)cancelHistoryTipicIn:(NSInteger)index{
    [self.locaArr removeObjectAtIndex:index];
    [self.tableView reloadData];
    if (self.locaArr.count) {
        [NoticeTools saveBookArr:self.locaArr];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSearchBookResultController *ctl = [[NoticeSearchBookResultController alloc] init];
    ctl.name = [[self.locaArr[indexPath.row]name] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]];
    ctl.nameT = [self.locaArr[indexPath.row]name];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeLocalTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locallCell"];
    
    cell.mainL.text = [self.locaArr[indexPath.row] name];
    cell.index = indexPath.row;
    cell.delegate = self;
    if (indexPath.row == self.locaArr.count-1) {
        if (_isMore) {
            cell.line.hidden = YES;
        }
        
    }else{
        cell.line.hidden = NO;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.locaArr.count > 3 && _isMore) {
        return 3;
    }
    return self.locaArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.locaArr.count > 3) {
        return 44;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.locaArr.count > 3) {
        return self.moreButton;
    }
    return [UIView new];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (!textField.text.length) {
        return YES;
    }
    
    if (self.locaArr.count == 10) {
        [self.locaArr removeObjectAtIndex:9];
    }
    NoticeTopicModel *model = [[NoticeTopicModel alloc] init];
    model.name = textField.text;
    [self.locaArr insertObject:model atIndex:0];//保存乎执行回调
    NSArray *arr = [NSArray arrayWithArray:self.locaArr];
    [NoticeTools saveBookArr:arr];
    
    NoticeSearchBookResultController *ctl = [[NoticeSearchBookResultController alloc] init];
    ctl.name = [textField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]];
    ctl.nameT = textField.text;
    [self.navigationController pushViewController:ctl animated:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

- (void)cancelClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
