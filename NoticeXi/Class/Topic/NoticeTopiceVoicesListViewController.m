//
//  NoticeTopiceVoicesListViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTopiceVoicesListViewController.h"
#import "NoticerTopicSearchResultNewController.h"
#import "NoticeSearchPersonViewController.h"
#import "NoticeTopicBaseController.h"
#import "NoticeCustumBackImageView.h"
@interface NoticeTopiceVoicesListViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NoticeTopicBaseController *topicVC;
@property (nonatomic, strong) NoticeSearchPersonViewController *personVC;
@property (nonatomic, strong) UITextField *topicField;
@property (nonatomic, strong) UIView *mbsView;
@property (nonatomic, strong) NoticeCustumBackImageView *backGroundImageView;
@end

@implementation NoticeTopiceVoicesListViewController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"search.topic"],[NoticeTools getLocalStrWith:@"search.user"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH([NoticeTools getLocalStrWith:@"search.topic"], 18, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 17;
        self.titleSizeSelected = 17;
        self.progressViewBottomSpace = 0;
        self.progressColor = [UIColor colorWithHexString:@"#0099E6"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.8];
        self.titleColorSelected = [UIColor colorWithHexString:@"#25262E"];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, (STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-36)/2), DR_SCREEN_WIDTH-67-20, 36)];
    backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    backView.layer.cornerRadius = 18;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    self.topicField = [[UITextField alloc] initWithFrame:CGRectMake(40,0,DR_SCREEN_WIDTH-67-20-40, 36)];
    self.topicField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.topicField.font = FIFTHTEENTEXTFONTSIZE;
    self.topicField.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.topicField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.topicField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalType]==1?@"Input key word":@"输入关键词" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1]}];
    self.topicField.delegate = self;
    self.topicField.returnKeyType = UIReturnKeySearch;
    self.topicField.text = self.topicName;
    [backView addSubview:self.topicField];
    
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(10,8,20, 20)];
    imageViewPwd.image= UIImageNamed(@"Image_newsearchss");
    [backView addSubview:imageViewPwd];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-67, STATUS_BAR_HEIGHT, 67, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [btn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0,0,-10);
    [btn setTitleColor:[[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1] forState:UIControlStateNormal];
    btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,47, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    [self.menuView addSubview:line];
    
}

- (void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!textField.text.length) {
        [self showToastWithText:@"请输入您要搜索的内容"];
        return NO;
    }
    [textField resignFirstResponder];
    [self.personVC.dataArr removeAllObjects];
    [self.personVC.tableView reloadData];
    [self.personVC sarchPerson:textField.text];
    self.topicVC.topicId = @"0";
    self.topicVC.topicName = textField.text;

    return YES;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT+48, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  80;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return (DR_SCREEN_WIDTH- 160)/3;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#25262E"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.8];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.topicVC;
    }else{
        return self.personVC;
    }
}

- (NoticeTopicBaseController *)topicVC{
    if (!_topicVC) {
        _topicVC = [[NoticeTopicBaseController alloc] init];
        _topicVC.topicName = self.topicName;
        _topicVC.topicId = self.topicId;
    }
    return _topicVC;
}

- (NoticeSearchPersonViewController *)personVC{
    if (!_personVC) {
        _personVC = [[NoticeSearchPersonViewController alloc] init];
        [_personVC sarchPerson:self.topicName];
        _personVC.fromSearch = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.alphaValue >0 && appdel.alphaValue < 0.9){
            _personVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _personVC.tableView.backgroundColor = _personVC.view.backgroundColor;
        }
    }
    return _personVC;
}
@end

