//
//  NoticePiPeiFriendListViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/5/28.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticePiPeiFriendListViewController.h"
#import "NoticeMyFriendCell.h"
#import "DDHAttributedMode.h"
#import "NoticeNoDataView.h"
#import "NoticeOtherUserInfoViewController.h"
#import "NoticeMineViewController.h"
#import "NoticeNearViewController.h"
#import "NoticeWebViewController.h"
#import "NoticeNowViewController.h"
#import "NoticeAbout.h"
@interface NoticePiPeiFriendListViewController ()<NoticePiPeiChoiceDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) NoticeAbout *aboutM;
@property (nonatomic, assign) BOOL isFirst;
@end

@implementation NoticePiPeiFriendListViewController
{
    UIView *_headv;
    UILabel *_label;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    
    self.view.backgroundColor =GetColorWithName(VBackColor);
    self.tableView.backgroundColor = GetColorWithName(VlistColor);
    self.navigationItem.title = [NoticeTools isSimpleLau]?@"选择优先匹配的学友":@"選擇優先匹配的学友";
    [self.tableView registerClass:[NoticeMyFriendCell class] forCellReuseIdentifier:@"cell1"];
    self.tableView.frame = CGRectMake(0, 1, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
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
    label1.textColor = GetColorWithName(VMainTextColor);
    label1.text = [NoticeTools isSimpleLau]? @"谁都不选":@"誰都不選";
    label1.textAlignment = NSTextAlignmentRight;
    label1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webClick)];
    [label1 addGestureRecognizer:tap];
    [_headv addSubview:label1];
    
    NSString *str = [NoticeTools isSimpleLau]?[NSString stringWithFormat:@"当前有%@位学友(列表仅自己可见)",_aboutM.friend_num]: [NSString stringWithFormat:@"當前有%@位学友(列表僅自己可見)",_aboutM.friend_num];
    _label.attributedText = [DDHAttributedMode setSizeAndColorString:str setColor:GetColorWithName(VDarkTextColor) setSize:12 setLengthString:@"(列表仅自己可见)" beginSize:str.length-9];
    self.isDown = YES;
    [self request];
}

- (void)setAboutM:(NoticeAbout *)aboutM{
    _aboutM = aboutM;
    if (aboutM.friend_num.integerValue) {
        NSString *str = [NSString stringWithFormat:@"当前有%@位学友(列表仅自己可见)",aboutM.friend_num];
        _label.attributedText = [DDHAttributedMode setSizeAndColorString:str setColor:GetColorWithName(VDarkTextColor) setSize:9 setLengthString:@"(列表仅自己可见)" beginSize:str.length-9];
    }
}

- (void)sendClick{
    if ([[[NoticeSaveModel getUserInfo] personality_no] length] == 4) {
        NoticeNowViewController *ctl = [[NoticeNowViewController alloc] init];
        ctl.hasTest = YES;
        [self.navigationController pushViewController:ctl animated:NO];
        return;
    }else{
        NoticeNowViewController *ctl = [[NoticeNowViewController alloc] init];
        ctl.hasTest = NO;
        [self.navigationController pushViewController:ctl animated:NO];
        return;
    }
}

- (void)webClick{

    //谁都不选
    if (self.pipeiBlock) {
        self.self.pipeiBlock([[NoticeMyFriends alloc] init]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)choicePipeiUserWithTag:(NSInteger)tag{
    NoticeMyFriends *person = self.dataArr[tag];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestAbout];
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
    
    for (NoticeMyFriends *friends in self.dataArr) {
        friends.isSelect = NO;
    }
    NoticeMyFriends *friend = self.dataArr[indexPath.row];
    if ([friend.user_id isEqualToString:self.hasUserId]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    friend.isSelect = YES;
    [self.tableView reloadData];
    if (self.pipeiBlock) {
        self.self.pipeiBlock(friend);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMyFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.isPipei = YES;
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.friends = self.dataArr[indexPath.row];
        if (indexPath.row == self.dataArr.count-1) {
            cell.line.hidden = YES;
        }else{
            cell.line.hidden = NO;
        }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticePiPeiFriendListViewController *ctl = self;
    
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
                if ([model.user_id isEqualToString:self.hasUserId]) {
                    if (self.isFirst) {
                        self.isFirst = NO;
                       model.isSelect = YES;
                    }
                }
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                NoticeMyFriends *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.lastId;
                self.tableView.tableHeaderView = self->_headv;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableHeaderView = nil;
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
