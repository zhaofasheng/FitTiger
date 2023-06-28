//
//  NoticeMoveBookSonPrivayController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/3.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMoveBookSonPrivayController.h"
#import "NoticeLabelAndSwitchCell.h"
#import "NoticeNoticenterModel.h"
@interface NoticeMoveBookSonPrivayController ()<SwitchChoiceDelegate>
@property (nonatomic, strong) NSArray *boolArr;
@property (nonatomic, strong) NoticeNoticenterModel *noticeM;
@property (nonatomic, strong) NoticeNoticenterModel *oldNoticeM;
@property (nonatomic, strong) UIView *footView;
@end

@implementation NoticeMoveBookSonPrivayController
{
    NSArray *_titleArr;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;//关闭右滑返回
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.type == 0 ? [NoticeTools getTextWithSim:@"电影社隐私设置" fantText:@"電影社隱私設置"]:[NoticeTools getTextWithSim:@"读书社隐私设置" fantText:@"讀書社隱私設置"];
    if (self.type == 2) {
        self.navigationItem.title = [NoticeTools getTextWithSim:@"音乐社隐私设置" fantText:@"音乐社隱私設置"];
    }
    _titleArr =self.type == 2?@[GETTEXTWITE(@"ys.song1"),GETTEXTWITE(@"ys.song2"),GETTEXTWITE(@"ys.song3"),GETTEXTWITE(@"ys.song4"),[NoticeTools isSimpleLau]?@"隐藏我的音乐心情-歌曲词条下":@"隱藏我的音乐心情-歌曲詞條下",[NoticeTools isSimpleLau]?@"隐藏我-歌曲找同好":@"隱藏我-歌曲找同好"] : (self.type == 1?@[GETTEXTWITE(@"ys.book1"),GETTEXTWITE(@"ys.book2"),GETTEXTWITE(@"ys.book3"),GETTEXTWITE(@"ys.book4"),[NoticeTools isSimpleLau]?@"隐藏我的书籍心情-书籍词条下":@"隱藏我的書籍心情-書籍詞條下",[NoticeTools isSimpleLau]?@"隐藏我-书籍找同好":@"隱藏我-書籍找同好"]: @[GETTEXTWITE(@"ys.mv1"),GETTEXTWITE(@"ys.mv2"),GETTEXTWITE(@"ys.mv3"),GETTEXTWITE(@"ys.mv4"),[NoticeTools isSimpleLau]?@"隐藏我的电影心情-电影词条下":@"隱藏我的電影心情-電影詞條下",[NoticeTools isSimpleLau]?@"隐藏我-电影找同好":@"隱藏我-電影找同好"]);
    
    [self.tableView registerClass:[NoticeLabelAndSwitchCell class] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell1"];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 260)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, DR_SCREEN_WIDTH-90, 185+30)];
    label.numberOfLines = 0;
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    
    NSString *str = self.type == 2? ([NoticeTools isSimpleLau]?@"想唱很多歌曲但又担心刷屏？开启之后就会在对应页面过滤你的唱歌心情啦,连自己也看不到哦~":@"想唱很多歌曲但又擔心刷屏？開啟之後就會在對應頁面過濾妳的唱歌心情啦,連自己也看不到哦~"): (self.type == 1? ([NoticeTools isSimpleLau]?@"想发布书籍心情但又担心刷屏？开启之后就会在对应页面过滤你的书籍心情啦,连自己也看不到哦~":@"想發布書籍心情但又擔心刷屏？開啟之後就會在對應頁面過濾妳的書籍心情啦,連自己也看不到哦~"): ([NoticeTools isSimpleLau]?@"想发布电影心情但又担心刷屏？开启之后就会在对应页面过滤你的电影心情啦,连自己也看不到哦~":@"想發布電影心情但又擔心刷屏？開啟之後就會在對應頁面過濾妳的電影心情啦,連自己也看不到哦~"));
    label.frame = CGRectMake(45, 15, DR_SCREEN_WIDTH-90,GET_STRHEIGHT(str, 14, DR_SCREEN_WIDTH-90)+20);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
    label.attributedText = attributedString;
    
    [footView addSubview:label];
    
    self.footView = footView;
    label.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30,69);
    self.footView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH,69);
    
    UIView *footView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,35)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-15, 15)];
    label1.font = FOURTHTEENTEXTFONTSIZE;
    label1.textColor = GetColorWithName(VDarkTextColor);
    label1.text = self.type == 1 ? ([NoticeTools isSimpleLau]?@"开启后即使别人欣赏了你的书籍心情也看不到":@"開啟後即使別人關註了妳的書籍心情也看不到") : (self.type == 2 ? ([NoticeTools isSimpleLau]?@"开启后即使别人欣赏了你的音乐心情也看不到":@"開啟後即使別人關註了妳的音乐心情也看不到"): ([NoticeTools isSimpleLau]?@"开启后即使别人欣赏了你的电影心情也看不到":@"開啟後即使別人關註了妳的电影心情也看不到") );
    [footView1 addSubview:label1];
    self.tableView.tableFooterView = footView1;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 42, 44);
    [backButton setTitle:@"    " forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    if ([NoticeTools isWhiteTheme]) {
        [backButton setImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateNormal];
    }else{
        [backButton setImage:[UIImage imageNamed:@"btn_nav_white"] forState:UIControlStateNormal];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    [self requestData];
}

- (void)backToPageAction{

    if ([self.oldNoticeM.homepage isEqualToString:self.noticeM.homepage] && [self.oldNoticeM.memory isEqualToString:self.noticeM.memory] && [self.oldNoticeM.machine isEqualToString:self.noticeM.machine] && [self.oldNoticeM.square isEqualToString:self.noticeM.square] && [self.oldNoticeM.review isEqualToString:self.noticeM.review] && [self.oldNoticeM.entry isEqualToString:self.noticeM.entry] && [self.oldNoticeM.hobby isEqualToString:self.noticeM.hobby] && [self.oldNoticeM.subscribe isEqualToString:self.noticeM.subscribe]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:self.noticeM.review?self.noticeM.review:@"" forKey:@"review"];
        [dic setObject:self.noticeM.homepage?self.noticeM.homepage:@"" forKey:@"homepage"];
        [dic setObject:self.noticeM.memory?self.noticeM.memory:@"" forKey:@"memory"];
        [dic setObject:self.noticeM.machine?self.noticeM.machine:@"" forKey:@"machine"];
        [dic setObject:self.noticeM.square?self.noticeM.square:@"" forKey:@"square"];
        [dic setObject:self.noticeM.entry?self.noticeM.entry:@"" forKey:@"entry"];
        [dic setObject:self.noticeM.hobby?self.noticeM.hobby:@"" forKey:@"hobby"];
        [dic setObject:self.noticeM.subscribe?self.noticeM.subscribe:@"" forKey:@"subscribe"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/visibility/%ld",[[NoticeSaveModel getUserInfo] user_id],(long)(self.type+1)]  Accept:@"application/vnd.shengxi.v3.6+json" isPost:YES parmaer:dic page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESelecTsETVOICENOTICE" object:nil userInfo:nil];
                }else{
                    [self showToastWithText:dict[@"msg"]];
                }
            } fail:^(NSError *error) {
                
            }];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)requestData{
    [self showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/visibility/%ld",[[NoticeSaveModel getUserInfo] user_id],(long)(self.type+1)] Accept:@"application/vnd.shengxi.v3.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            self.oldNoticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            self.boolArr = @[self.noticeM.homepage?self.noticeM.homepage:@"1",self.noticeM.memory?self.noticeM.memory:@"1",self.noticeM.machine?self.noticeM.machine:@"1",self.noticeM.square?self.noticeM.square:@"1",self.noticeM.entry?self.noticeM.entry:@"1",self.noticeM.hobby?self.noticeM.hobby:@"1"];
            [self.tableView reloadData];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section == 0){
        NoticeLabelAndSwitchCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell2.mainL.text = _titleArr[indexPath.row];
        cell2.line.hidden = indexPath.row == 5?YES:NO;
        cell2.choiceTag = indexPath.row;
        cell2.choiceSection = indexPath.section;
        cell2.delegate = self;
        cell2.switchButton.on = ![self.boolArr[indexPath.row] boolValue];
        return cell2;
    }else{
        NoticeLabelAndSwitchCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        NSString *titles = self.type == 2 ? @"音乐心情" : (self.type == 1 ? ([NoticeTools isSimpleLau]?@"书籍心情":@"書籍心情") :@"电影心情");
        cell2.mainL.text = [NoticeTools isSimpleLau]? [NSString stringWithFormat:@"隐藏我的%@-「欣赏」Tab",titles]:[NSString stringWithFormat:@"隱藏我的%@-「關註」Tab",titles];
        cell2.line.hidden = YES;
        cell2.choiceTag = indexPath.row;
        cell2.choiceSection = indexPath.section;
        cell2.delegate = self;
        cell2.switchButton.on = !self.noticeM.subscribe.integerValue;
        return cell2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return section == 1 ? 1:_titleArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.footView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 69;
    }
    return 0;
}

- (void)choiceTag:(NSInteger)tag withIsOn:(BOOL)isOn section:(NSInteger)section{
    isOn = !isOn;
    if (section == 1) {
        self.noticeM.subscribe = [NSString stringWithFormat:@"%d",isOn];
        return;
    }
    if (tag == 0) {
        self.noticeM.homepage = [NSString stringWithFormat:@"%d",isOn];
    }else if (tag == 1){
        self.noticeM.memory = [NSString stringWithFormat:@"%d",isOn];
    }else if (tag == 2){
        self.noticeM.machine = [NSString stringWithFormat:@"%d",isOn];
    }else if (tag == 3){
        self.noticeM.square = [NSString stringWithFormat:@"%d",isOn];
    }else if (tag == 4){
        self.noticeM.entry = [NSString stringWithFormat:@"%d",isOn];
    }else if (tag == 5){
        self.noticeM.hobby = [NSString stringWithFormat:@"%d",isOn];
    }
}

@end
