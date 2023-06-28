//
//  NoticeMyFriendViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/2.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyFriendViewController.h"
#import "NoticeMyFriendCell.h"
#import "DDHAttributedMode.h"
#import "NoticeNoDataView.h"
#import "NoticeOtherUserInfoViewController.h"
#import "NoticeMineViewController.h"
#import "NoticeNearViewController.h"
#import "NoticeWebViewController.h"


@interface NoticeMyFriendViewController ()<NoticePiPeiChoiceDelegate>
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) XLAlertView *alterView;
@property (nonatomic, strong) NSTimer *waitTimer;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) NSString *callUserId;
@property (nonatomic, assign) UInt64 callId;
@property (nonatomic, strong) UILabel *titL;
@property (nonatomic, strong) NoticeWebViewController *webVC;
@end

@implementation NoticeMyFriendViewController
{
    UIView *_headv;
    UILabel *_label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =GetColorWithName(VBackColor);
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.time = 60;
    
    self.navigationItem.title = @"我的学友";
    if (self.isSend) {
        self.navigationItem.title = [NoticeTools getTextWithSim:@"选择1位学友发送作品" fantText:@"選擇1位学友發送作品"];
    }
    [self.tableView registerClass:[NoticeMyFriendCell class] forCellReuseIdentifier:@"cell1"];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
 
    self.dataArr = [NSMutableArray new];
    [self createRefesh];

    _headv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    _headv.backgroundColor = GetColorWithName(VBackColor);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,(DR_SCREEN_WIDTH-30)/2, 40)];
    label.font = ELEVENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VMainTextColor);
    _label = label;
    [_headv addSubview:_label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30)/2+15, 0, (DR_SCREEN_WIDTH-30)/2, 40)];
    label1.font = ELEVENTEXTFONTSIZE;
    label1.textColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    label1.textAlignment = NSTextAlignmentRight;
    label1.userInteractionEnabled = YES;
    self.titL = label1;
    
    self.webVC = [[NoticeWebViewController alloc] init];
    self.webVC.specic = @"1";

    [self requestSpec];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webClick)];
    [label1 addGestureRecognizer:tap];
    [_headv addSubview:label1];
    self.tableView.tableHeaderView = self.isSend? nil: _headv;
    NSString *str = [NoticeTools isSimpleLau]?[NSString stringWithFormat:@"当前有%@位学友(列表仅自己可见)",_aboutM.friend_num]: [NSString stringWithFormat:@"當前有%@位学友(列表僅自己可見)",_aboutM.friend_num];
    _label.attributedText = [DDHAttributedMode setSizeAndColorString:str setColor:GetColorWithName(VDarkTextColor) setSize:9 setLengthString:@"(列表仅自己可见)" beginSize:str.length-9];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)requestSpec{

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"h5/html/declare/%@",@"1"] Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeWeb *web = [NoticeWeb mj_objectWithKeyValues:dict[@"data"]];
            self.titL.text = web.html_title;

        }
    } fail:^(NSError *error) {

    }];
}

- (NSString *)getNowTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSInteger x = arc4random() % 99999999999999999;
    return  [NSString stringWithFormat:@"%@//%ld",currentTimeString,(long)x];
}



- (void)setAboutM:(NoticeAbout *)aboutM{
    _aboutM = aboutM;
    if (aboutM.friend_num.integerValue) {
        NSString *str = [NSString stringWithFormat:@"当前有%@位学友(列表仅自己可见)",aboutM.friend_num];
        _label.attributedText = [DDHAttributedMode setSizeAndColorString:str setColor:GetColorWithName(VDarkTextColor) setSize:9 setLengthString:@"(列表仅自己可见)" beginSize:str.length-9];
    }else{
        _label.text = [NoticeTools isSimpleLau]? @"学友30天自动解除":@"学友30天自動解除";
    }
}




- (void)webClick{

    [self.navigationController pushViewController:self.webVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestAbout];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.callUserId = nil;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.isBusyForCalling = NO;
}

- (void)requestAbout{
    [[DRNetWorking shareInstance] requestNoTosat:[NSString stringWithFormat:@"users/%@/about",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v2.2+json" parmaer:nil success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeAbout *aboutM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            self.aboutM = aboutM;
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMyFriends *person = self.dataArr[indexPath.row];
    if (self.isCall) {
        for (NoticeMyFriends *allPerson in self.dataArr) {
            allPerson.isSelect = NO;
        }
        person.isSelect = !person.isSelect;
        [self.tableView reloadData];
        return;
    }
    if ([person.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        NoticeMineViewController *ctl = [[NoticeMineViewController alloc] init];
        ctl.isFromOther = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeOtherUserInfoViewController *ctl = [[NoticeOtherUserInfoViewController alloc] init];
        ctl.userId = person.user_id;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMyFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.isSend = self.isSend;
    cell.isCall = self.isCall;
    if (self.isSend) {
        cell.delegate = self;
        cell.sendImage = self.sendImage;
    }
    cell.friends = self.dataArr[indexPath.row];
    cell.isPipei = NO;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[self.dataArr[indexPath.row] renew_num] intValue] > 0?85:65;
}

- (void)createRefesh{
    
    __weak NoticeMyFriendViewController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
       url = [NSString stringWithFormat:@"users/%@/friends",[[NoticeSaveModel getUserInfo] user_id]];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"users/%@/friends?lastId=%@",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"users/%@/friends",[[NoticeSaveModel getUserInfo] user_id]];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMyFriends *model = [NoticeMyFriends mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeMyFriends *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.lastId;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)sendImageToFriend:(NoticeMyFriends *)user{

    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:user.user_id forKey:@"toUserId"];
    [parm setObject:self.resourceId forKey:@"artworkId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"artworkGifts" Accept:@"application/vnd.shengxi.v4.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [UIView animateWithDuration:1 animations:^{
                [self showToastWithText:[NSString stringWithFormat:@"%@{%@}",user.nick_name,[NoticeTools getLocalStrWith:@"group.hassenddraw"]]];
            } completion:^(BOOL finished) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

@end
